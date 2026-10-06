import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_calendar/pinne_calendar.dart' show SessionMarker;
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/features/planner/calendar_write_runner.dart';
import 'package:pinne_flutter/features/planner/device_calendar_adapter.dart';

import 'fake_device_calendar.dart';

void main() {
  late FakeDeviceCalendar phone;
  late CalendarWriteRunner runner;

  setUp(() {
    phone = FakeDeviceCalendar();
    runner = CalendarWriteRunner(AndroidDeviceCalendarAdapter(phone));
  });

  final linkId = const Uuid().v4obj();
  final start = DateTime.utc(2026, 10, 21, 18);

  CalendarWrite write(
    CalendarWriteAction action, {
    String? eventId,
    DateTime? at,
    int revision = 1,
  }) => CalendarWrite(
    linkId: linkId,
    action: action,
    sessionId: const Uuid().v4obj(),
    eventUid: 'pinne-s1',
    externalCalendarId: '2',
    externalEventId: eventId,
    startAt: at ?? start,
    endAt: (at ?? start).add(const Duration(minutes: 15)),
    timezone: 'UTC',
    title: 'Pinne review',
    notes: 'Review time.\n\n${SessionMarker.line('pinne-s1')}',
    sessionRevision: revision,
  );

  test(
    'a create that timed out after the provider saved it is not repeated',
    () async {
      phone.timeoutAfterNextCreate = true;
      final first = await runner.run([write(CalendarWriteAction.create)]);
      expect(first.single.outcome, CalendarWriteOutcome.failed);
      expect(phone.stored, hasLength(1));

      // The server still has the create pending; the next run finds the event
      // by its uid and confirms it instead of creating a second one.
      final retry = await runner.run([write(CalendarWriteAction.create)]);
      expect(retry.single.outcome, CalendarWriteOutcome.done);
      expect(retry.single.externalEventId, phone.stored.single.eventId);
      expect(phone.creates, 1);
      expect(phone.stored, hasLength(1));
    },
  );

  test(
    'an event moved in the calendar app is reported, not overwritten',
    () async {
      final created = await runner.run([write(CalendarWriteAction.create)]);
      final id = created.single.externalEventId!;
      final moved = DateTime.utc(2026, 10, 22, 7);
      await phone.update(
        id,
        title: 'Pinne review',
        notes: phone.stored.single.description!,
        start: moved,
        end: moved.add(const Duration(minutes: 15)),
      );
      phone.updates = 0;

      final check = await runner.run([
        write(CalendarWriteAction.check, eventId: id),
      ]);
      expect(check.single.outcome, CalendarWriteOutcome.moved);
      expect(check.single.startAt, moved);
      expect(phone.updates, 0);
    },
  );

  test('an unchanged event reports nothing on a check', () async {
    final created = await runner.run([write(CalendarWriteAction.create)]);
    final check = await runner.run([
      write(
        CalendarWriteAction.check,
        eventId: created.single.externalEventId,
      ),
    ]);
    expect(check, isEmpty);
  });

  test('a move updates the session event in place', () async {
    final created = await runner.run([write(CalendarWriteAction.create)]);
    final later = start.add(const Duration(hours: 2));
    final moved = await runner.run([
      write(
        CalendarWriteAction.update,
        eventId: created.single.externalEventId,
        at: later,
        revision: 2,
      ),
    ]);
    expect(moved.single.outcome, CalendarWriteOutcome.done);
    expect(moved.single.sessionRevision, 2);
    expect(phone.stored.single.start, later);
  });

  test('an id that now names someone else\'s event is never touched', () async {
    phone.stored.add(
      DeviceEvent(
        eventId: '7',
        instanceId: '7',
        calendarId: '2',
        start: start,
        end: start.add(const Duration(hours: 1)),
        description: 'Dentist',
      ),
    );
    final results = await runner.run([
      write(CalendarWriteAction.delete, eventId: '7'),
      write(CalendarWriteAction.update, eventId: '7'),
    ]);
    expect(results.map((r) => r.outcome), [
      CalendarWriteOutcome.notOurs,
      CalendarWriteOutcome.notOurs,
    ]);
    expect(phone.stored.single.description, 'Dentist');
    expect(phone.deletes + phone.updates, 0);
  });

  test('deleting an event that is already gone is fine', () async {
    final results = await runner.run([
      write(CalendarWriteAction.delete, eventId: '404'),
    ]);
    expect(results.single.outcome, CalendarWriteOutcome.alreadyGone);
  });

  test('without permission the work fails and stays queued', () async {
    phone.currentAccess = DeviceCalendarAccess.denied;
    final results = await runner.run([write(CalendarWriteAction.create)]);
    expect(results.single.outcome, CalendarWriteOutcome.failed);
    expect(results.single.message, contains('Calendar access'));
    expect(phone.stored, isEmpty);
  });
}
