import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'time_interval.dart';

var _loaded = false;

/// Loads the IANA time zone database once.
void ensureTimeZones() {
  if (_loaded) return;
  tzdata.initializeTimeZones();
  _loaded = true;
}

/// Whether [name] is a known IANA time zone such as `Europe/London`.
bool isKnownTimeZone(String name) {
  ensureTimeZones();
  return tz.timeZoneDatabase.locations.containsKey(name);
}

tz.Location _zone(String name) {
  ensureTimeZones();
  return tz.getLocation(name);
}

/// A calendar date with no time or zone, such as the date of an all-day
/// event or the local day of a review.
final class LocalDate implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day);

  /// Normalises overflowing parts, so `LocalDate.of(2026, 10, 32)` is
  /// November 1st.
  factory LocalDate.of(int year, int month, int day) {
    final date = DateTime.utc(year, month, day);
    return LocalDate(date.year, date.month, date.day);
  }

  /// The date [instant] falls on in [zone].
  factory LocalDate.inZone(DateTime instant, String zone) {
    final local = tz.TZDateTime.from(instant.toUtc(), _zone(zone));
    return LocalDate(local.year, local.month, local.day);
  }

  /// Parses `yyyy-MM-dd`.
  factory LocalDate.parse(String text) {
    final parts = text.split('-');
    if (parts.length != 3) throw FormatException('Not a date: $text');
    return LocalDate(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  final int year;
  final int month;
  final int day;

  /// ISO weekday, 1 for Monday to 7 for Sunday.
  int get weekday => DateTime.utc(year, month, day).weekday;

  LocalDate addDays(int days) => LocalDate.of(year, month, day + days);

  /// Whole days from this date to [other].
  int daysUntil(LocalDate other) => DateTime.utc(
    other.year,
    other.month,
    other.day,
  ).difference(DateTime.utc(year, month, day)).inDays;

  /// The instant the wall clock in [zone] shows [minuteOfDay] minutes past
  /// midnight on this date. A wall time skipped by a daylight-saving jump
  /// resolves to the instant just after the jump.
  DateTime at(String zone, int minuteOfDay) =>
      DateTime.fromMicrosecondsSinceEpoch(
        tz.TZDateTime(
          _zone(zone),
          year,
          month,
          day,
          0,
          minuteOfDay,
        ).microsecondsSinceEpoch,
        isUtc: true,
      );

  /// The whole local day in [zone]: 23 or 25 hours long on a daylight-saving
  /// change.
  TimeInterval wholeDay(String zone) =>
      TimeInterval(at(zone, 0), addDays(1).at(zone, 0));

  @override
  int compareTo(LocalDate other) =>
      daysUntil(other) == 0 ? 0 : (daysUntil(other) > 0 ? -1 : 1);

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';
}

/// [instant] as a wall-clock time in [zone]. The result's fields are the
/// local values; do not compare it with UTC instants.
DateTime wallClock(DateTime instant, String zone) =>
    tz.TZDateTime.from(instant.toUtc(), _zone(zone));
