import 'package:pinne_calendar/pinne_calendar.dart';
import 'package:pinne_client/pinne_client.dart';

/// `18:00` for [instant] on the wall clock of [zone].
String clockTime(DateTime instant, String zone) {
  final local = wallClock(instant, zone);
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(local.hour)}:${two(local.minute)}';
}

/// `18:00 – 18:15` in [zone].
String timeRange(DateTime start, DateTime end, String zone) =>
    '${clockTime(start, zone)} – ${clockTime(end, zone)}';

const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String monthName(int month) => _months[month - 1];

/// `Wednesday 7 October`.
String longDate(LocalDate date) =>
    '${_weekdays[date.weekday - 1]} ${date.day} ${monthName(date.month)}';

/// How long ago busy times were read, as the Planner says it.
String checkedAgo(DateTime checkedAt, DateTime now) {
  final minutes = now.difference(checkedAt).inMinutes;
  if (minutes < 1) return 'just now';
  if (minutes == 1) return '1 minute ago';
  if (minutes < 60) return '$minutes minutes ago';
  final hours = minutes ~/ 60;
  if (hours == 1) return '1 hour ago';
  if (hours < 48) return '$hours hours ago';
  return '${hours ~/ 24} days ago';
}

/// The coverage line under the calendar. It never claims a check that did
/// not happen.
String coverageLine({
  required List<CalendarCoverage> coverage,
  required bool verified,
  required DateTime now,
}) {
  if (coverage.isEmpty) {
    return 'Not checked: no calendar is chosen for busy times.';
  }
  final times = [for (final c in coverage) c.checkedAt].nonNulls.toList()
    ..sort();
  if (verified && times.isNotEmpty) {
    return 'Checked your busy times ${checkedAgo(times.first, now)}.';
  }
  final unchecked = [
    for (final c in coverage)
      if (c.state != CoverageState.checked) c.calendarName,
  ];
  return 'Not fully checked: ${unchecked.join(', ')} could not be confirmed.';
}

/// What the user should know about a session's calendar event, in words.
String sessionStatusLine(SessionView view) {
  final session = view.session;
  if (session.status == SessionStatus.proposed) {
    return session.availabilityVerified
        ? 'Proposed in free time'
        : 'Proposed, not checked against your calendar';
  }
  if (!session.availabilityVerified) {
    return 'Kept in Pinne only; not checked against your calendar';
  }
  final calendar = view.calendarName;
  return switch (view.syncState) {
    null => 'Scheduled in Pinne',
    EventSyncState.pendingCreate => 'Adding to ${calendar ?? 'your calendar'}…',
    EventSyncState.pendingUpdate => 'Moving in ${calendar ?? 'your calendar'}…',
    EventSyncState.pendingDelete => 'Removing from your calendar…',
    EventSyncState.synced =>
      calendar == null ? 'In your calendar' : 'In your $calendar calendar',
    EventSyncState.deleted => 'Removed from your calendar',
    EventSyncState.missing => 'Removed in your calendar app',
    EventSyncState.foreign =>
      'Calendar event changed outside Pinne; left as is',
  };
}

/// `3 saved items` or `1 saved item`.
String itemCount(int count) =>
    count == 1 ? '1 saved item' : '$count saved items';
