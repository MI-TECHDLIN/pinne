import 'time_interval.dart';
import 'zones.dart';

/// The user's rules for when review sessions may go.
final class PlanningPolicy {
  const PlanningPolicy({
    required this.timezone,
    required this.weekdays,
    required this.windowStartMinute,
    required this.windowEndMinute,
    required this.sessionMinutes,
    required this.maxSessions,
    this.bufferMinutes = 0,
    this.minLeadMinutes = 0,
    this.gridMinutes = 15,
  });

  /// IANA zone the windows and days are read in.
  final String timezone;

  /// ISO weekdays (1 Monday to 7 Sunday) sessions may fall on.
  final Set<int> weekdays;

  /// Daily window, in minutes after local midnight. The end may be 1440.
  final int windowStartMinute;
  final int windowEndMinute;

  final int sessionMinutes;

  /// Most sessions in one plan.
  final int maxSessions;

  /// Free time kept on both sides of every busy interval.
  final int bufferMinutes;

  /// Earliest start, counted from now.
  final int minLeadMinutes;

  /// Sessions start on this local-minute grid, so times read as 18:00 or
  /// 18:15 rather than 18:07.
  final int gridMinutes;

  /// Limits shared by the server and app.
  static const maxSessionMinutes = 180;
  static const maxSessionsPerPlan = 31;
  static const maxBufferMinutes = 120;
  static const maxLeadMinutes = 7 * 24 * 60;

  /// The first broken rule in plain language, or null when valid.
  String? problem() {
    if (!isKnownTimeZone(timezone)) return 'Unknown time zone "$timezone".';
    if (weekdays.isEmpty) return 'Choose at least one day.';
    if (weekdays.any((d) => d < 1 || d > 7)) return 'Days must be 1 to 7.';
    if (windowStartMinute < 0 || windowEndMinute > 24 * 60) {
      return 'The daily window must fall within one day.';
    }
    if (windowEndMinute <= windowStartMinute) {
      return 'The daily window must end after it starts.';
    }
    if (sessionMinutes < 5 || sessionMinutes > maxSessionMinutes) {
      return 'Sessions must be 5 to $maxSessionMinutes minutes long.';
    }
    if (sessionMinutes > windowEndMinute - windowStartMinute) {
      return 'A session does not fit in the daily window.';
    }
    if (maxSessions < 1 || maxSessions > maxSessionsPerPlan) {
      return 'Plan 1 to $maxSessionsPerPlan sessions.';
    }
    if (bufferMinutes < 0 || bufferMinutes > maxBufferMinutes) {
      return 'Buffers must be 0 to $maxBufferMinutes minutes.';
    }
    if (minLeadMinutes < 0 || minLeadMinutes > maxLeadMinutes) {
      return 'Lead time must be 0 to 7 days.';
    }
    if (gridMinutes < 1 || gridMinutes > 60) return 'Invalid grid.';
    return null;
  }
}

/// Why a plan has fewer sessions than asked, when it does.
enum ShortfallReason {
  /// None of the chosen weekdays fall inside the horizon after lead time.
  noEligibleDays,

  /// Every eligible window is busy, including buffers.
  noFreeWindow,
}

final class SlotPlan {
  const SlotPlan({
    required this.slots,
    required this.eligibleDays,
    required this.daysWithRoom,
    this.shortfall,
  });

  /// Chosen sessions in time order, at most one per local day.
  final List<TimeInterval> slots;

  /// Local days in the horizon that match the chosen weekdays.
  final int eligibleDays;

  /// Of those, the days with a free window long enough.
  final int daysWithRoom;

  /// Set when no slot could be placed.
  final ShortfallReason? shortfall;
}

/// Places review sessions in free time. Deterministic: the same inputs
/// always give the same slots.
///
/// 1. Pad every busy interval by the buffer and merge overlaps.
/// 2. For each local day in [horizon] on an allowed weekday, take the daily
///    window in [PlanningPolicy.timezone], clipped to the horizon and the
///    lead time.
/// 3. Take the earliest grid-aligned start whose whole session is free.
/// 4. When more days have room than [PlanningPolicy.maxSessions], spread the
///    sessions evenly across them.
SlotPlan planSlots({
  required PlanningPolicy policy,
  required TimeInterval horizon,
  required DateTime now,
  required Iterable<TimeInterval> busy,
}) {
  final problem = policy.problem();
  if (problem != null) throw ArgumentError(problem);

  final zone = policy.timezone;
  final buffer = Duration(minutes: policy.bufferMinutes);
  final blocked = mergeIntervals([
    for (final block in busy) block.padded(before: buffer, after: buffer),
  ]);
  final earliest = now.toUtc().add(Duration(minutes: policy.minLeadMinutes));
  final length = Duration(minutes: policy.sessionMinutes);

  final candidates = <TimeInterval>[];
  var eligibleDays = 0;
  final lastDay = LocalDate.inZone(
    horizon.end.subtract(const Duration(microseconds: 1)),
    zone,
  );
  for (
    var day = LocalDate.inZone(horizon.start, zone);
    day.compareTo(lastDay) <= 0;
    day = day.addDays(1)
  ) {
    if (!policy.weekdays.contains(day.weekday)) continue;
    final dayWindow = TimeInterval.tryCreate(
      day.at(zone, policy.windowStartMinute),
      day.at(zone, policy.windowEndMinute),
    );
    final inHorizon = dayWindow?.intersect(horizon);
    if (inHorizon == null) continue;
    final open = TimeInterval.tryCreate(
      inHorizon.start.isAfter(earliest) ? inHorizon.start : earliest,
      inHorizon.end,
    );
    if (open == null) continue;
    eligibleDays++;
    final slot = _firstFit(freeWithin(open, blocked), length, policy, zone);
    if (slot != null) candidates.add(slot);
  }

  final chosen = _spread(candidates, policy.maxSessions);
  return SlotPlan(
    slots: chosen,
    eligibleDays: eligibleDays,
    daysWithRoom: candidates.length,
    shortfall: chosen.isNotEmpty
        ? null
        : eligibleDays == 0
        ? ShortfallReason.noEligibleDays
        : ShortfallReason.noFreeWindow,
  );
}

TimeInterval? _firstFit(
  List<TimeInterval> free,
  Duration length,
  PlanningPolicy policy,
  String zone,
) {
  for (final gap in free) {
    final start = _alignUp(gap.start, policy.gridMinutes, zone);
    final end = start.add(length);
    if (!end.isAfter(gap.end)) return TimeInterval(start, end);
  }
  return null;
}

/// Rounds [instant] up to the next local wall-clock grid line.
DateTime _alignUp(DateTime instant, int grid, String zone) {
  final local = wallClock(instant, zone);
  final subMinute = Duration(
    seconds: local.second,
    milliseconds: local.millisecond,
    microseconds: local.microsecond,
  );
  var aligned = instant.subtract(subMinute);
  if (subMinute > Duration.zero) {
    aligned = aligned.add(const Duration(minutes: 1));
  }
  final minute = wallClock(aligned, zone).minute;
  final pad = (grid - minute % grid) % grid;
  return aligned.add(Duration(minutes: pad));
}

/// Picks [max] of [candidates] evenly spaced, always keeping the first.
List<TimeInterval> _spread(List<TimeInterval> candidates, int max) {
  final n = candidates.length;
  if (n <= max) return candidates;
  return [for (var i = 0; i < max; i++) candidates[(i * n) ~/ max]];
}
