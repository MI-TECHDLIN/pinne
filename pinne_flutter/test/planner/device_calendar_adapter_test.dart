import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_calendar/pinne_calendar.dart';
import 'package:pinne_flutter/features/planner/device_calendar_adapter.dart';

import 'fake_device_calendar.dart';

void main() {
  late FakeDeviceCalendar phone;
  late AndroidDeviceCalendarAdapter adapter;
  final checkedAt = DateTime.utc(2026, 10, 20, 9);

  setUp(() {
    phone = FakeDeviceCalendar();
    adapter = AndroidDeviceCalendarAdapter(phone, clock: () => checkedAt);
  });

  DeviceEvent timed(
    String id,
    DateTime start,
    Duration length, {
    String calendar = '1',
    String? instance,
    bool free = false,
    bool cancelled = false,
    String? description,
  }) => DeviceEvent(
    eventId: id,
    instanceId: instance ?? id,
    calendarId: calendar,
    start: start,
    end: start.add(length),
    free: free,
    cancelled: cancelled,
    description: description,
  );

  final window = TimeInterval(
    DateTime.utc(2026, 10, 19),
    DateTime.utc(2026, 11, 2),
  );

  Future<List<BusyInterval>> read({String zone = 'Europe/London'}) async =>
      (await adapter.readBusyIntervals(
        calendarIds: ['1', '2'],
        window: window,
        timezone: zone,
      )).intervals;

  test('reports when and what it read', () async {
    final result = await adapter.readBusyIntervals(
      calendarIds: ['1'],
      window: window,
      timezone: 'UTC',
    );
    expect(result.checkedAt, checkedAt);
    expect(result.window, window);
    expect(result.calendarIds, ['1']);
  });

  test('skips cancelled and free events; tentative ones still block', () async {
    final at = DateTime.utc(2026, 10, 21, 9);
    phone.stored.addAll([
      timed('a', at, const Duration(hours: 1)),
      timed('b', at, const Duration(hours: 1), free: true),
      timed('c', at, const Duration(hours: 1), cancelled: true),
      timed('d', at, Duration.zero),
    ]);
    final busy = await read();
    expect(busy.map((b) => b.span), [
      TimeInterval(at, at.add(const Duration(hours: 1))),
    ]);
  });

  test(
    'expands recurrence: every occurrence, including a moved one, blocks',
    () async {
      // A weekly stand-up whose second occurrence was moved to the afternoon.
      final first = DateTime.utc(2026, 10, 19, 9);
      phone.stored.addAll([
        timed('s', first, const Duration(minutes: 30), instance: 's@1'),
        timed(
          's',
          DateTime.utc(2026, 10, 26, 15),
          const Duration(minutes: 30),
          instance: 's@2',
        ),
      ]);
      final busy = await read();
      expect(busy.map((b) => b.span.start), [
        first,
        DateTime.utc(2026, 10, 26, 15),
      ]);
    },
  );

  test(
    'an all-day event covers its local day, 25 hours when clocks go back',
    () async {
      // The phone reports all-day events as floating dates.
      phone.stored.add(
        DeviceEvent(
          eventId: 'h',
          instanceId: 'h',
          calendarId: '2',
          start: DateTime(2026, 10, 25),
          end: DateTime(2026, 10, 26),
          allDay: true,
        ),
      );
      final busy = (await read()).single;
      expect(busy.allDay, isTrue);
      expect(busy.timezone, 'Europe/London');
      expect(busy.span.start, DateTime.utc(2026, 10, 24, 23));
      expect(busy.span.end, DateTime.utc(2026, 10, 26));
      expect(busy.span.duration, const Duration(hours: 25));
    },
  );

  test('a one-day all-day event reporting its own date still spans a day', () {
    final busy = AndroidDeviceCalendarAdapter.normalizeEvent(
      DeviceEvent(
        eventId: 'x',
        instanceId: 'x',
        calendarId: '1',
        start: DateTime(2026, 10, 7),
        end: DateTime(2026, 10, 7),
        allDay: true,
      ),
      'Africa/Lagos',
    )!;
    expect(busy.span.start, DateTime.utc(2026, 10, 6, 23));
    expect(busy.span.duration, const Duration(hours: 24));
  });

  test(
    'marks its own session events so a move does not clash with itself',
    () async {
      final at = DateTime.utc(2026, 10, 21, 18);
      phone.stored.add(
        timed(
          'p',
          at,
          const Duration(minutes: 15),
          description: 'Review time\n\n${SessionMarker.line('pinne-abc')}',
        ),
      );
      expect((await read()).single.sessionUid, 'pinne-abc');
    },
  );

  group('capabilities', () {
    test(
      'without permission every operation is refused, with a reason',
      () async {
        phone.currentAccess = DeviceCalendarAccess.denied;
        final caps = await adapter.capabilities();
        expect(caps.blockedBy, CapabilityFailure.permissionDenied);
        await expectLater(
          read(),
          throwsA(
            isA<CalendarCapabilityException>().having(
              (e) => e.failure,
              'failure',
              CapabilityFailure.permissionDenied,
            ),
          ),
        );
      },
    );

    test('write-only access cannot read availability', () async {
      phone.currentAccess = DeviceCalendarAccess.writeOnly;
      final caps = await adapter.capabilities();
      expect(caps.can(CalendarCapability.readBusy), isFalse);
      await expectLater(
        read(),
        throwsA(
          isA<CalendarCapabilityException>().having(
            (e) => e.failure,
            'failure',
            CapabilityFailure.writeOnly,
          ),
        ),
      );
    });

    test('off Android the route says it is unsupported', () async {
      phone.supported = false;
      final caps = await adapter.capabilities();
      expect(caps.blockedBy, CapabilityFailure.unsupported);
      expect(caps.liveSync, isFalse);
    });
  });

  group('writing', () {
    final draft = SessionEventDraft(
      uid: 'pinne-1',
      calendarId: '2',
      title: 'Pinne review',
      notes: 'Review time planned by Pinne.',
      span: TimeInterval(
        DateTime.utc(2026, 10, 21, 18),
        DateTime.utc(2026, 10, 21, 18, 15),
      ),
      timezone: 'Europe/London',
    );

    test('stores the session marker in the event', () async {
      final ref = await adapter.createSessionEvent(draft);
      final event = await phone.event(ref.eventId);
      expect(event!.sessionUid, 'pinne-1');
    });

    test('never updates or deletes an event without its marker', () async {
      phone.stored.add(
        timed('9', DateTime.utc(2026, 10, 21, 18), const Duration(hours: 1)),
      );
      const ref = SessionEventRef(calendarId: '2', eventId: '9');
      await expectLater(
        adapter.updateSessionEvent(ref, draft),
        throwsA(isA<CalendarCapabilityException>()),
      );
      await expectLater(
        adapter.deleteSessionEvent(ref, uid: draft.uid),
        throwsA(isA<CalendarCapabilityException>()),
      );
      expect(phone.stored, hasLength(1));
      expect(phone.updates + phone.deletes, 0);
    });

    test(
      'reconcile finds the event by uid, or says the id is foreign',
      () async {
        final ref = await adapter.createSessionEvent(draft);
        final found = await adapter.reconcile(draft);
        expect(found.state, ReconcileState.matches);
        expect(found.ref!.eventId, ref.eventId);

        phone.stored.add(
          timed('9', DateTime.utc(2026, 10, 22, 18), const Duration(hours: 1)),
        );
        final other = SessionEventDraft(
          uid: 'pinne-2',
          calendarId: '2',
          title: 't',
          notes: 'n',
          span: draft.span,
          timezone: 'UTC',
        );
        final foreign = await adapter.reconcile(
          other,
          known: const SessionEventRef(calendarId: '2', eventId: '9'),
        );
        expect(foreign.state, ReconcileState.foreign);
        expect((await adapter.reconcile(other)).state, ReconcileState.missing);
      },
    );
  });
}
