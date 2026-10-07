/// A span of time with an inclusive start and an exclusive end, in UTC.
///
/// Two intervals that only touch (`a.end == b.start`) do not overlap, so a
/// session may start the instant a meeting ends.
final class TimeInterval implements Comparable<TimeInterval> {
  TimeInterval(DateTime start, DateTime end)
    : start = _plainUtc(start),
      end = _plainUtc(end) {
    if (!this.end.isAfter(this.start)) {
      throw ArgumentError('An interval must end after it starts.');
    }
  }

  /// Returns null instead of throwing when [end] is not after [start], for
  /// provider data that can contain zero-length events.
  static TimeInterval? tryCreate(DateTime start, DateTime end) =>
      end.isAfter(start) ? TimeInterval(start, end) : null;

  final DateTime start;
  final DateTime end;

  /// A plain UTC [DateTime], so zone-aware subclasses compare equal too.
  static DateTime _plainUtc(DateTime time) =>
      DateTime.fromMicrosecondsSinceEpoch(
        time.microsecondsSinceEpoch,
        isUtc: true,
      );

  Duration get duration => end.difference(start);

  bool overlaps(TimeInterval other) =>
      start.isBefore(other.end) && other.start.isBefore(end);

  bool contains(TimeInterval other) =>
      !other.start.isBefore(start) && !other.end.isAfter(end);

  /// This interval widened by [before] and [after], such as buffers around a
  /// busy event.
  TimeInterval padded({
    Duration before = Duration.zero,
    Duration after = Duration.zero,
  }) => TimeInterval(start.subtract(before), end.add(after));

  /// The overlap with [other], or null when they do not overlap.
  TimeInterval? intersect(TimeInterval other) {
    if (!overlaps(other)) return null;
    return TimeInterval(
      start.isAfter(other.start) ? start : other.start,
      end.isBefore(other.end) ? end : other.end,
    );
  }

  @override
  int compareTo(TimeInterval other) {
    final byStart = start.compareTo(other.start);
    return byStart != 0 ? byStart : end.compareTo(other.end);
  }

  @override
  bool operator ==(Object other) =>
      other is TimeInterval && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '[${start.toIso8601String()}, ${end.toIso8601String()})';
}

/// Sorts [intervals] and joins every overlapping or touching pair, so the
/// result is disjoint and ordered.
List<TimeInterval> mergeIntervals(Iterable<TimeInterval> intervals) {
  final sorted = [...intervals]..sort();
  final merged = <TimeInterval>[];
  for (final next in sorted) {
    if (merged.isEmpty || next.start.isAfter(merged.last.end)) {
      merged.add(next);
    } else if (next.end.isAfter(merged.last.end)) {
      merged.last = TimeInterval(merged.last.start, next.end);
    }
  }
  return merged;
}

/// The parts of [window] not covered by [busy]. [busy] need not be merged.
List<TimeInterval> freeWithin(
  TimeInterval window,
  Iterable<TimeInterval> busy,
) {
  final free = <TimeInterval>[];
  var cursor = window.start;
  for (final block in mergeIntervals(busy)) {
    if (!block.end.isAfter(cursor)) continue;
    if (!block.start.isBefore(window.end)) break;
    final gap = TimeInterval.tryCreate(cursor, block.start);
    if (gap != null) free.add(gap);
    if (block.end.isAfter(cursor)) cursor = block.end;
  }
  final tail = TimeInterval.tryCreate(cursor, window.end);
  if (tail != null) free.add(tail);
  return free;
}
