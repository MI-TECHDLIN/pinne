import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_calendar/pinne_calendar.dart' show AdapterCalendar;
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/planner/calendar_connections_screen.dart';
import 'package:pinne_flutter/features/planner/device_calendar_adapter.dart';
import 'package:pinne_flutter/features/planner/planner_providers.dart';
import 'package:pinne_flutter/features/planner/planner_screen.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';
import 'package:pinne_flutter/ui/motion.dart';

import 'fake_device_calendar.dart';
import 'fake_planner_api.dart';
import '../support/test_account.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

class _Reduced extends MotionPreferenceNotifier {
  @override
  MotionPreference build() => MotionPreference.reduced;
}

class _SwitchingAccount extends AccountIdNotifier {
  @override
  String? build() => 'account-a';

  void switchTo(String accountId) => state = accountId;
}

void main() {
  late FakePlannerApi server;
  late FakeDeviceCalendar phone;
  late List<String> shared;

  setUp(() {
    server = FakePlannerApi();
    phone = FakeDeviceCalendar();
    shared = [];
  });

  Future<void> pump(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signedInProvider.overrideWith(_SignedIn.new),
          accountIdProvider.overrideWith(TestAccountId.new),
          motionPreferenceProvider.overrideWith(_Reduced.new),
          plannerApiProvider.overrideWithValue(server),
          deviceCalendarApiProvider.overrideWithValue(phone),
          deviceIdProvider.overrideWith((ref) async => const Uuid().v4obj()),
          deviceTimezoneProvider.overrideWith((ref) async => 'UTC'),
          icsSharerProvider.overrideWithValue((ics) async => shared.add(ics)),
        ],
        child: MaterialApp(
          theme: pinneDarkTheme(),
          home: Scaffold(body: screen),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Iterable<FilledButton> limeButtons(WidgetTester tester) => tester
      .widgetList<FilledButton>(find.byType(FilledButton))
      .where(
        (b) =>
            b.style?.backgroundColor?.resolve({}) ==
            PinneColors.accentPrimaryAction,
      );

  testWidgets('propose then accept a checked plan', (tester) async {
    await pump(tester, const PlannerScreen());
    expect(find.text('Plan my week'), findsOneWidget);
    expect(limeButtons(tester), hasLength(1));

    await tester.tap(find.text('Plan my week'));
    await tester.pumpAndSettle();

    // Busy times were read on the phone for both conflict calendars.
    expect(server.proposeRequests.single.availability, hasLength(2));
    expect(
      server.proposeRequests.single.availability.every((a) => a.readable),
      isTrue,
    );
    expect(
      find.textContaining('Checked your busy times just now'),
      findsOneWidget,
    );
    expect(find.text('Proposed'), findsWidgets);
    expect(find.text('Flutter sidebar thread'), findsOneWidget);
    expect(find.textContaining('adds them to Family'), findsOneWidget);
    expect(limeButtons(tester), hasLength(1));

    await tester.tap(find.text('Accept plan'));
    await tester.pumpAndSettle();

    final commit = server.commits.single;
    expect(commit.acceptUnverified, isFalse);
    expect(commit.availability, hasLength(2));
    expect(find.text('Accept plan'), findsNothing);
    expect(find.textContaining('Adding to Family'), findsOneWidget);
  });

  test(
    'Planner reloads its server state when the active account changes',
    () async {
      final deviceId = const Uuid().v4obj();
      final container = ProviderContainer(
        overrides: [
          accountIdProvider.overrideWith(_SwitchingAccount.new),
          plannerApiProvider.overrideWithValue(server),
          deviceCalendarApiProvider.overrideWithValue(phone),
          deviceIdProvider.overrideWith((ref) async => deviceId),
          deviceTimezoneProvider.overrideWith((ref) async => 'UTC'),
        ],
      );
      addTearDown(container.dispose);

      await container.read(plannerProvider.future);
      final accountB = const Uuid().v4obj();
      server.prefs = server.prefs.copyWith(ownerId: accountB);
      (container.read(accountIdProvider.notifier) as _SwitchingAccount)
          .switchTo(
            'account-b',
          );

      final reloaded = await container.read(plannerProvider.future);
      expect(reloaded.preferences.ownerId, accountB);
      expect(server.preferencesRequests, 2);
    },
  );

  testWidgets('unknown availability cannot be accepted as checked', (
    tester,
  ) async {
    server.conflictCalendars = false;
    await pump(tester, const PlannerScreen());
    await tester.tap(find.text('Plan my week'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Not checked: no calendar is chosen'),
      findsOneWidget,
    );
    expect(find.text('Accept plan'), findsNothing);
    expect(limeButtons(tester), isEmpty);
    expect(
      find.text('Proposed, not checked against your calendar'),
      findsOneWidget,
    );

    await tester.tap(find.text('Keep in Pinne without checking'));
    await tester.pumpAndSettle();
    expect(server.commits.single.acceptUnverified, isTrue);
    expect(
      find.text('Kept in Pinne only; not checked against your calendar'),
      findsOneWidget,
    );
  });

  testWidgets('revoked permission is sent as unreadable, never as free', (
    tester,
  ) async {
    await pump(tester, const PlannerScreen());
    phone.currentAccess = DeviceCalendarAccess.denied;
    await tester.tap(find.text('Plan my week'));
    await tester.pumpAndSettle();

    final readings = server.proposeRequests.single.availability;
    expect(readings, hasLength(2));
    expect(readings.every((a) => !a.readable && a.intervals.isEmpty), isTrue);
    expect(find.text('Accept plan'), findsNothing);
  });

  testWidgets('calendar provider failure stays local and explains the fix', (
    tester,
  ) async {
    await pump(tester, const PlannerScreen());
    phone.eventsError = StateError('calendar provider stopped');

    await tester.tap(find.text('Plan my week'));
    await tester.pumpAndSettle();

    expect(server.proposeRequests, hasLength(1));
    expect(
      server.proposeRequests.single.availability.every((a) => !a.readable),
      isTrue,
    );
    expect(
      find.textContaining('Open your phone\'s Calendar app'),
      findsOneWidget,
    );
    expect(find.textContaining('Could not reach Pinne'), findsNothing);
  });

  testWidgets('calendar list failure does not take down Planner', (
    tester,
  ) async {
    phone.calendarsError = StateError('calendar provider stopped');

    await pump(tester, const PlannerScreen());

    expect(find.text('Plan my week'), findsOneWidget);
    expect(
      find.textContaining('Open your phone\'s Calendar app'),
      findsOneWidget,
    );
    expect(find.textContaining('Could not load your planner'), findsNothing);
  });

  testWidgets('a calendar that became read-only explains how to recover', (
    tester,
  ) async {
    phone = FakeDeviceCalendar(
      calendars: const [
        AdapterCalendar(id: '1', name: 'Work', readOnly: false),
        AdapterCalendar(id: '2', name: 'Family', readOnly: true),
      ],
    );
    final start = DateTime.now().toUtc().add(const Duration(hours: 2));
    server.commitWrites = [
      CalendarWrite(
        linkId: const Uuid().v4obj(),
        action: CalendarWriteAction.create,
        sessionId: const Uuid().v4obj(),
        eventUid: 'pinne-read-only',
        externalCalendarId: '2',
        startAt: start,
        endAt: start.add(const Duration(minutes: 15)),
        timezone: 'UTC',
        title: 'Pinne review',
        notes: 'Review time.',
        sessionRevision: 1,
      ),
    ];

    await pump(tester, const PlannerScreen());
    await tester.tap(find.text('Plan my week'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Accept plan'));
    await tester.pumpAndSettle();

    expect(server.reported.single.outcome, CalendarWriteOutcome.failed);
    expect(find.textContaining('is read-only'), findsOneWidget);
    expect(find.textContaining('writable calendar'), findsOneWidget);
    expect(phone.creates, 0);
  });

  testWidgets('a proposal exports as an .ics file through the share sheet', (
    tester,
  ) async {
    await pump(tester, const PlannerScreen());
    await tester.tap(find.text('Plan my week'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Export .ics (export only)'));
    await tester.pumpAndSettle();
    expect(shared.single, startsWith('BEGIN:VCALENDAR'));
    expect(server.exported.single, hasLength(1));
  });

  testWidgets('calendar connections show only phone calendars', (tester) async {
    await pump(tester, const CalendarConnectionsScreen());
    expect(find.text('Calendars on this phone'), findsOneWidget);
    expect(find.text('Access allowed'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
    expect(find.text('Check for busy times'), findsNWidgets(2));
    expect(find.text('Sessions are added to Family.'), findsOneWidget);
    expect(find.text('Google Calendar'), findsNothing);
    expect(find.text('Apple Calendar'), findsNothing);
    expect(find.text('Calendar file (.ics)'), findsNothing);
    expect(find.text('Not configured'), findsNothing);
    expect(server.routeRequests, 0);
  });

  testWidgets('permanently denied access opens Android settings', (
    tester,
  ) async {
    phone.currentAccess = DeviceCalendarAccess.denied;
    await pump(tester, const CalendarConnectionsScreen());

    expect(find.text('Open Android settings'), findsOneWidget);
    expect(
      find.textContaining('turn on Calendar permission'),
      findsOneWidget,
    );
    await tester.tap(find.text('Open Android settings'));
    await tester.pumpAndSettle();

    expect(phone.settingsOpens, 1);
    expect(phone.permissionRequests, 0);
  });

  testWidgets('empty phone calendar list gives a recovery action', (
    tester,
  ) async {
    phone = FakeDeviceCalendar(calendars: const []);
    await pump(tester, const CalendarConnectionsScreen());

    expect(
      find.textContaining('Add or sync a calendar in your phone'),
      findsOneWidget,
    );
    expect(find.text('Refresh calendars'), findsOneWidget);
  });
}
