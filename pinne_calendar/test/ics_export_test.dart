import 'dart:convert';

import 'package:pinne_calendar/pinne_calendar.dart';
import 'package:test/test.dart';

void main() {
  final event = IcsEvent(
    uid: '0199b1c2-0000-7000-8000-000000000001@pinne',
    span: TimeInterval(
      DateTime.utc(2026, 10, 7, 17),
      DateTime.utc(2026, 10, 7, 17, 15),
    ),
    summary: 'Pinne review',
    description:
        'Three saved items, about 5 minutes each; that is an estimate, '
        'not a promise. Héllo ✨ with a long line that must fold safely.',
  );

  final ics = encodeIcs([event], stamp: DateTime.utc(2026, 10, 6, 9, 30));

  List<String> unfolded() => ics
      .split('\r\n')
      .fold<List<String>>([], (lines, line) {
        if (line.startsWith(' ')) {
          lines.last += line.substring(1);
        } else {
          lines.add(line);
        }
        return lines;
      })
      .where((line) => line.isNotEmpty)
      .toList();

  test('uses CRLF and folds every line within 75 octets', () {
    expect(ics.endsWith('\r\n'), isTrue);
    expect(ics.replaceAll('\r\n', '').contains('\n'), isFalse);
    for (final line in ics.split('\r\n')) {
      expect(utf8.encode(line).length, lessThanOrEqualTo(75), reason: line);
    }
  });

  test('has the required calendar and event properties', () {
    final lines = unfolded();
    expect(lines.first, 'BEGIN:VCALENDAR');
    expect(lines.last, 'END:VCALENDAR');
    expect(lines, contains('VERSION:2.0'));
    expect(lines.where((l) => l.startsWith('PRODID:')), hasLength(1));
    expect(lines, contains('BEGIN:VEVENT'));
    expect(lines, contains('UID:${event.uid}'));
    expect(lines, contains('DTSTAMP:20261006T093000Z'));
    expect(lines, contains('DTSTART:20261007T170000Z'));
    expect(lines, contains('DTEND:20261007T171500Z'));
    expect(lines, contains('SUMMARY:Pinne review'));
    expect(lines, contains('STATUS:CONFIRMED'));
  });

  test('escapes text and says it is export only', () {
    final description = unfolded().firstWhere(
      (l) => l.startsWith('DESCRIPTION:'),
    );
    expect(description, contains(r'each\; that is an estimate\,'));
    expect(description, contains(r'\n\nExported from Pinne'));
    expect(description, contains('does not sync'));
    expect(description, contains('Héllo ✨'));
  });

  test('marks proposals tentative', () {
    final tentative = encodeIcs([
      IcsEvent(
        uid: 'x',
        span: event.span,
        summary: 's',
        description: 'd',
        tentative: true,
      ),
    ], stamp: DateTime.utc(2026));
    expect(tentative, contains('STATUS:TENTATIVE'));
  });

  test(
    'the export adapter refuses live operations with structured errors',
    () async {
      const adapter = IcsExportAdapter();
      final capabilities = await adapter.capabilities();
      expect(capabilities.liveSync, isFalse);
      expect(capabilities.can(CalendarCapability.exportFile), isTrue);
      expect(capabilities.can(CalendarCapability.readBusy), isFalse);
      await expectLater(
        adapter.readBusyIntervals(
          calendarIds: const [],
          window: event.span,
          timezone: 'UTC',
        ),
        throwsA(
          isA<CalendarCapabilityException>()
              .having(
                (e) => e.failure,
                'failure',
                CapabilityFailure.unsupported,
              )
              .having(
                (e) => e.capability,
                'capability',
                CalendarCapability.readBusy,
              ),
        ),
      );
    },
  );
}
