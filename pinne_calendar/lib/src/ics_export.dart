import 'dart:convert';

import 'calendar_adapter.dart';
import 'time_interval.dart';

/// One session in an iCalendar export.
final class IcsEvent {
  const IcsEvent({
    required this.uid,
    required this.span,
    required this.summary,
    required this.description,
    this.tentative = false,
  });

  final String uid;
  final TimeInterval span;
  final String summary;
  final String description;

  /// A proposal the user has not accepted yet.
  final bool tentative;
}

/// The note every exported event carries: an export is a copy, not a link.
const icsExportNotice =
    'Exported from Pinne. This file is a one-time copy: it does not sync, '
    'and Pinne did not check this calendar for free time.';

/// Encodes [events] as an RFC 5545 iCalendar file: CRLF line endings, lines
/// folded at 75 octets, text escaped, times in UTC.
String encodeIcs(
  List<IcsEvent> events, {
  required DateTime stamp,
  String calendarName = 'Pinne review sessions',
}) {
  final lines = <String>[
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//Pinne//Review sessions//EN',
    'CALSCALE:GREGORIAN',
    'METHOD:PUBLISH',
    'X-WR-CALNAME:${_escape(calendarName)}',
    for (final event in events) ...[
      'BEGIN:VEVENT',
      'UID:${_escape(event.uid)}',
      'DTSTAMP:${_utc(stamp)}',
      'DTSTART:${_utc(event.span.start)}',
      'DTEND:${_utc(event.span.end)}',
      'SUMMARY:${_escape(event.summary)}',
      'DESCRIPTION:${_escape('${event.description}\n\n$icsExportNotice')}',
      'STATUS:${event.tentative ? 'TENTATIVE' : 'CONFIRMED'}',
      'TRANSP:OPAQUE',
      'END:VEVENT',
    ],
    'END:VCALENDAR',
  ];
  return '${lines.map(_fold).join('\r\n')}\r\n';
}

String _utc(DateTime time) {
  final t = time.toUtc();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${t.year.toString().padLeft(4, '0')}${two(t.month)}${two(t.day)}'
      'T${two(t.hour)}${two(t.minute)}${two(t.second)}Z';
}

String _escape(String text) => text
    .replaceAll(r'\', r'\\')
    .replaceAll(';', r'\;')
    .replaceAll(',', r'\,')
    .replaceAll('\r\n', r'\n')
    .replaceAll('\n', r'\n');

/// Splits a content line into 75-octet pieces without breaking a UTF-8
/// sequence; continuation lines start with one space.
String _fold(String line) {
  const limit = 75;
  if (utf8.encode(line).length <= limit) return line;
  final pieces = <String>[];
  final buffer = StringBuffer();
  var octets = 0;
  var budget = limit;
  for (final rune in line.runes) {
    final char = String.fromCharCode(rune);
    final size = utf8.encode(char).length;
    if (octets + size > budget) {
      pieces.add(buffer.toString());
      buffer.clear();
      octets = 0;
      budget = limit - 1;
    }
    buffer.write(char);
    octets += size;
  }
  pieces.add(buffer.toString());
  return pieces.join('\r\n ');
}

/// The export-only route: it writes files, never reads availability or
/// touches a live calendar.
final class IcsExportAdapter implements CalendarAdapter {
  const IcsExportAdapter();

  @override
  CalendarRouteKind get route => CalendarRouteKind.icsExport;

  @override
  Future<AdapterCapabilities> capabilities() async => const AdapterCapabilities(
    route: CalendarRouteKind.icsExport,
    supported: {CalendarCapability.exportFile},
    liveSync: false,
    limitation:
        'Export only: a file you import yourself. It does not sync and is not '
        'proof of free time.',
  );

  Never _refuse(CalendarCapability capability) =>
      throw CalendarCapabilityException(
        route: route,
        capability: capability,
        failure: CapabilityFailure.unsupported,
        message: 'A calendar file export cannot ${_verb(capability)}.',
      );

  static String _verb(CalendarCapability capability) => switch (capability) {
    CalendarCapability.listCalendars => 'list calendars',
    CalendarCapability.readBusy => 'read busy times',
    CalendarCapability.createEvent => 'add events to a calendar',
    CalendarCapability.updateEvent => 'move calendar events',
    CalendarCapability.deleteEvent => 'remove calendar events',
    CalendarCapability.reconcile => 'see changes made in a calendar',
    CalendarCapability.exportFile => 'export',
  };

  @override
  Future<List<AdapterCalendar>> listCalendars() async =>
      _refuse(CalendarCapability.listCalendars);

  @override
  Future<BusyRead> readBusyIntervals({
    required List<String> calendarIds,
    required TimeInterval window,
    required String timezone,
  }) async => _refuse(CalendarCapability.readBusy);

  @override
  Future<SessionEventRef> createSessionEvent(SessionEventDraft draft) async =>
      _refuse(CalendarCapability.createEvent);

  @override
  Future<SessionEventRef> updateSessionEvent(
    SessionEventRef ref,
    SessionEventDraft draft,
  ) async => _refuse(CalendarCapability.updateEvent);

  @override
  Future<void> deleteSessionEvent(
    SessionEventRef ref, {
    required String uid,
  }) async => _refuse(CalendarCapability.deleteEvent);

  @override
  Future<ReconcileResult> reconcile(
    SessionEventDraft draft, {
    SessionEventRef? known,
  }) async => _refuse(CalendarCapability.reconcile);
}
