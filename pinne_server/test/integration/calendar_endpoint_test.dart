import 'package:pinne_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'calendar_fixtures.dart';
import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the calendar endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;

    setUp(() async {
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
    });

    test('when listing routes then Google says it is not configured', () async {
      final routes = await endpoints.calendar.routes(alice);
      final google = routes.firstWhere(
        (r) => r.route == CalendarRoute.googleCloud,
      );
      expect(google.available, isFalse);
      expect(google.canReadBusy, isFalse);
      expect(google.limitation, contains('not configured'));

      final ics = routes.firstWhere((r) => r.route == CalendarRoute.icsExport);
      expect(ics.liveSync, isFalse);
      expect(ics.canReadBusy, isFalse);
      expect(ics.limitation, contains('Export only'));
      expect(ics.limitation, contains('not proof of free time'));
    });

    test('when authorizing Google then a structured error says why', () async {
      await expectLater(
        endpoints.calendar.authorizeGoogle(alice),
        throwsA(
          isA<CalendarRouteException>()
              .having((e) => e.route, 'route', CalendarRoute.googleCloud)
              .having((e) => e.failure, 'failure', 'notConfigured'),
        ),
      );
    });

    test(
      'when a phone reports calendars then all are checked and none written',
      () async {
        final phone = await PhoneCalendars.connect(
          endpoints,
          alice,
          writeToFamily: false,
        );
        final views = await endpoints.calendar.connections(alice);
        final selections = views.single.selections;
        expect(selections, hasLength(3));
        expect(selections.where((s) => s.useForWrites), isEmpty);
        expect(views.single.connection.deviceId, phone.deviceId);
        expect(views.single.connection.lastCheckedAt, isNotNull);
      },
    );

    test(
      'when choosing a read-only calendar for sessions then it is refused',
      () async {
        final phone = await PhoneCalendars.connect(endpoints, alice);
        final holidays = (await endpoints.calendar.connections(
          alice,
        )).single.selections.firstWhere((s) => s.readOnly);
        await expectLater(
          endpoints.calendar.setSelections(alice, phone.connection.id!, [
            CalendarSelectionChoice(
              selectionId: holidays.id!,
              useForConflicts: true,
              useForWrites: true,
            ),
          ]),
          throwsA(
            isA<CalendarRouteException>().having(
              (e) => e.failure,
              'failure',
              'readOnlyCalendar',
            ),
          ),
        );
      },
    );

    test(
      'when choosing a new write calendar then the old one is cleared',
      () async {
        final phone = await PhoneCalendars.connect(endpoints, alice);
        await expectLater(
          endpoints.calendar.setSelections(alice, phone.connection.id!, [
            for (final s in [phone.work, phone.family])
              CalendarSelectionChoice(
                selectionId: s.id!,
                useForConflicts: true,
                useForWrites: true,
              ),
          ]),
          throwsA(isA<ValidationException>()),
        );
        final views = await endpoints.calendar.setSelections(
          alice,
          phone.connection.id!,
          [
            CalendarSelectionChoice(
              selectionId: phone.work.id!,
              useForConflicts: true,
              useForWrites: true,
            ),
          ],
        );
        final writers = views.single.selections.where((s) => s.useForWrites);
        expect(writers.map((s) => s.name), ['Work']);
      },
    );

    test(
      'when permission is revoked then choices stay and state says so',
      () async {
        final phone = await PhoneCalendars.connect(endpoints, alice);
        final view = await endpoints.calendar.syncDeviceCalendars(
          alice,
          PhoneCalendars.report(
            phone.deviceId,
            permission: CalendarPermission.denied,
          ),
        );
        expect(view.connection.permission, CalendarPermission.denied);
        expect(view.selections, hasLength(3));
        expect(
          view.selections.firstWhere((s) => s.name == 'Family').useForWrites,
          isTrue,
        );
      },
    );

    test(
      'when a calendar disappears from the phone then it is dropped',
      () async {
        final phone = await PhoneCalendars.connect(endpoints, alice);
        final view = await endpoints.calendar.syncDeviceCalendars(
          alice,
          PhoneCalendars.report(phone.deviceId, withHolidays: false),
        );
        expect(
          view.selections.map((s) => s.name),
          unorderedEquals(['Work', 'Family']),
        );
      },
    );

    test('when another user uses the ids then they are missing', () async {
      final phone = await PhoneCalendars.connect(endpoints, alice);
      expect(await endpoints.calendar.connections(bob), isEmpty);
      await expectLater(
        endpoints.calendar.setSelections(bob, phone.connection.id!, [
          CalendarSelectionChoice(
            selectionId: phone.work.id!,
            useForConflicts: false,
            useForWrites: true,
          ),
        ]),
        throwsA(isA<RecordNotFoundException>()),
      );
      expect(
        await endpoints.calendar.disconnect(bob, phone.connection.id!),
        isFalse,
      );
      // The same phone signed in as Bob is a separate connection.
      final bobs = await endpoints.calendar.syncDeviceCalendars(
        bob,
        PhoneCalendars.report(phone.deviceId),
      );
      expect(bobs.connection.id, isNot(phone.connection.id));
      expect(
        (await endpoints.calendar.connections(alice)).single.selections,
        hasLength(3),
      );
    });

    test('when disconnecting then scheduled sessions stay in Pinne', () async {
      final phone = await PhoneCalendars.connect(endpoints, alice);
      await endpoints.planner.savePreferences(alice, anyTimePreferences());
      final proposal = await endpoints.planner.propose(
        alice,
        PlanRequest(availability: phone.readings()),
      );
      await endpoints.planner.commit(
        alice,
        PlanCommitRequest(
          planId: proposal.plan.id!,
          operationId: proposal.plan.id!,
          availability: phone.readings(),
          acceptUnverified: false,
          deviceId: phone.deviceId,
        ),
      );
      expect(
        await endpoints.calendar.disconnect(alice, phone.connection.id!),
        isTrue,
      );
      final sessions = await endpoints.planner.sessions(
        alice,
        DateTime.now(),
        DateTime.now().add(const Duration(days: 40)),
      );
      expect(sessions, hasLength(3));
      expect(sessions.map((v) => v.calendarName), everyElement(isNull));
    });
  });
}
