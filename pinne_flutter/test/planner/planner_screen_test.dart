import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

class _Reduced extends MotionPreferenceNotifier {
  @override
  MotionPreference build() => MotionPreference.reduced;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

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

  testWidgets('calendar connections show routes honestly', (tester) async {
    await pump(tester, const CalendarConnectionsScreen());
    expect(find.text('Calendars on this phone'), findsOneWidget);
    expect(find.text('Access allowed'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
    expect(find.text('Check for busy times'), findsNWidgets(2));
    expect(find.text('Sessions are added to Family.'), findsOneWidget);
    expect(find.text('Not configured'), findsOneWidget);
    expect(find.text('Export only'), findsOneWidget);
    expect(find.textContaining('not proof of free time'), findsOneWidget);
  });
}
