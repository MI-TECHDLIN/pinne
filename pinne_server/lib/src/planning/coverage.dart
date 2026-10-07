import 'package:pinne_calendar/pinne_calendar.dart' as cal;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// How much of the owner's availability is known for a time window.
class CoverageAssessment {
  CoverageAssessment({
    required this.coverage,
    required this.busy,
    required this.verified,
  });

  /// One entry per conflict calendar, in name order.
  final List<CalendarCoverage> coverage;

  /// Busy intervals from every readable reading, stale or not: an old busy
  /// time still blocks, while an old free time proves nothing.
  final List<({cal.TimeInterval span, String? sessionUid})> busy;

  /// True only when at least one conflict calendar exists and every one was
  /// read recently over the whole window. Unknown is never free (BR04).
  final bool verified;

  /// Plain-language reason when not [verified].
  String? get gap {
    if (verified) return null;
    if (coverage.isEmpty) {
      return 'No calendar is chosen for checking busy times, so these times '
          'are not checked against anything.';
    }
    final problems = [
      for (final c in coverage)
        if (c.state != CoverageState.checked)
          '${c.calendarName} (${_describe(c.state)})',
    ];
    return 'Busy times could not be confirmed for ${problems.join(', ')}.';
  }

  static String _describe(CoverageState state) => switch (state) {
    CoverageState.checked => 'checked',
    CoverageState.stale => 'last read too long ago',
    CoverageState.partial => 'not read for the whole period',
    CoverageState.unreadable => 'could not be read',
    CoverageState.notChecked => 'not read',
  };
}

/// Readings older than this cannot verify a plan.
const availabilityFreshFor = Duration(minutes: 15);

/// A device clock may run this far ahead before its reading is distrusted.
const _clockTolerance = Duration(minutes: 2);

/// Most busy intervals accepted in one reading.
const maxIntervalsPerSnapshot = 5000;

/// Rates each conflict calendar's reading for [window]. Readings for
/// calendars that are not the owner's conflict calendars are ignored, so a
/// foreign selection id behaves like a missing one.
CoverageAssessment assessCoverage({
  required List<CalendarSelection> conflictCalendars,
  required Map<UuidValue, CalendarConnection> connections,
  required List<AvailabilitySnapshot> snapshots,
  required cal.TimeInterval window,
  required DateTime now,
}) {
  final latest = <UuidValue, AvailabilitySnapshot>{};
  for (final snapshot in snapshots) {
    if (snapshot.intervals.length > maxIntervalsPerSnapshot) {
      throw ValidationException(message: 'Too many busy times in one reading.');
    }
    final known = latest[snapshot.selectionId];
    if (known == null || snapshot.checkedAt.isAfter(known.checkedAt)) {
      latest[snapshot.selectionId] = snapshot;
    }
  }

  final coverage = <CalendarCoverage>[];
  final busy = <({cal.TimeInterval span, String? sessionUid})>[];
  for (final selection in conflictCalendars) {
    final connection = connections[selection.connectionId];
    final snapshot = latest[selection.id];
    final state = _rate(snapshot, connection, window, now);
    coverage.add(
      CalendarCoverage(
        selectionId: selection.id!,
        calendarName: selection.name,
        route: connection?.route ?? CalendarRoute.androidDevice,
        state: state,
        checkedAt: snapshot?.checkedAt.toUtc(),
      ),
    );
    if (snapshot == null || !snapshot.readable) continue;
    for (final interval in snapshot.intervals) {
      final span = cal.TimeInterval.tryCreate(
        interval.startAt.toUtc(),
        interval.endAt.toUtc(),
      );
      if (span != null) {
        busy.add((span: span, sessionUid: interval.sessionUid));
      }
    }
  }
  return CoverageAssessment(
    coverage: coverage,
    busy: busy,
    verified:
        coverage.isNotEmpty &&
        coverage.every((c) => c.state == CoverageState.checked),
  );
}

CoverageState _rate(
  AvailabilitySnapshot? snapshot,
  CalendarConnection? connection,
  cal.TimeInterval window,
  DateTime now,
) {
  if (snapshot == null) return CoverageState.notChecked;
  if (!snapshot.readable ||
      connection == null ||
      connection.permission != CalendarPermission.granted) {
    return CoverageState.unreadable;
  }
  final read = cal.TimeInterval.tryCreate(
    snapshot.windowStart.toUtc(),
    snapshot.windowEnd.toUtc(),
  );
  if (read == null || !read.contains(window)) return CoverageState.partial;
  final checkedAt = snapshot.checkedAt.toUtc();
  if (checkedAt.isAfter(now.add(_clockTolerance)) ||
      now.difference(checkedAt) > availabilityFreshFor) {
    return CoverageState.stale;
  }
  return CoverageState.checked;
}
