import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/app.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:pinne_flutter/features/today/today_providers.dart';
import 'package:pinne_flutter/features/today/today_greeting.dart';
import 'package:pinne_flutter/features/today/today_screen.dart';
import 'package:pinne_flutter/features/tour/tour_controller.dart';
import 'package:pinne_flutter/features/tour/tour_store.dart';
import 'package:pinne_flutter/router.dart';
import 'package:pinne_flutter/shell/app_shell.dart';
import 'package:pinne_flutter/ui/motion.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'capture/fake_capture_server.dart';
import 'support/golden_theme.dart';

class _SignedOut extends SignedInNotifier {
  @override
  bool build() => false;
}

class _AlwaysReduced extends MotionPreferenceNotifier {
  @override
  MotionPreference build() => MotionPreference.reduced;
}

Widget _app(TourStore store) => ProviderScope(
  overrides: [
    serverUrlProvider.overrideWithValue('http://localhost:8080/'),
    captureStoreProvider.overrideWithValue(
      CaptureStore(sqlite3.openInMemory()),
    ),
    captureApiProvider.overrideWithValue(FakeCaptureServer()),
    signedInProvider.overrideWith(_SignedOut.new),
    motionPreferenceProvider.overrideWith(_AlwaysReduced.new),
    tourStoreProvider.overrideWithValue(store),
    greetingClockProvider.overrideWithValue(
      () => DateTime(2026, 10, 7, 9),
    ),
    greetingIndexPickerProvider.overrideWithValue((_) => 0),
  ],
  child: const PinneApp(),
);

Finder get _overlay => find.byKey(const ValueKey('tour-callout'));

String _title(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const ValueKey('tour-title'))).data!;

Future<void> _setSize(WidgetTester tester, Size size, {double text = 1}) async {
  await tester.binding.setSurfaceSize(size);
  tester.platformDispatcher.textScaleFactorTestValue = text;
  addTearDown(() {
    tester.binding.setSurfaceSize(null);
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

void main() {
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  testWidgets('the tour opens once on the first Today visit', (tester) async {
    final store = MemoryTourStore();
    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();

    expect(_overlay, findsOneWidget);
    expect(_title(tester), 'Welcome to Pinne');
    expect(find.bySemanticsLabel('App tour'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tour-skip')));
    await tester.pumpAndSettle();
    expect(_overlay, findsNothing);
    expect(store.seen, isTrue);

    // A fresh app on the same phone does not show it again.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();
    expect(_overlay, findsNothing);
  });

  testWidgets('a returning user who has seen it is not interrupted', (
    tester,
  ) async {
    await tester.pumpWidget(_app(MemoryTourStore(seen: true)));
    await tester.pumpAndSettle();
    expect(_overlay, findsNothing);
  });

  testWidgets('Next and Back walk every step, and Done closes it', (
    tester,
  ) async {
    final store = MemoryTourStore();
    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('tour-back')), findsNothing);
    for (var i = 0; i < tourSteps.length; i++) {
      expect(_title(tester), tourSteps[i].title, reason: 'step $i');
      expect(find.text('STEP ${i + 1} OF ${tourSteps.length}'), findsOneWidget);
      if (i == 2) {
        await tester.tap(find.byKey(const ValueKey('tour-back')));
        await tester.pumpAndSettle();
        expect(_title(tester), tourSteps[1].title);
        await tester.tap(find.byKey(const ValueKey('tour-next')));
        await tester.pumpAndSettle();
      }
      if (i < tourSteps.length - 1) {
        await tester.tap(find.byKey(const ValueKey('tour-next')));
        await tester.pumpAndSettle();
      }
    }
    // The last step names every tab of the pill nav.
    for (final tab in shellDestinations) {
      expect(
        find.descendant(of: _overlay, matching: find.text(tab.label)),
        findsOneWidget,
      );
    }
    expect(find.byKey(const ValueKey('tour-skip')), findsNothing);
    expect(find.text('Done'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('tour-next')));
    await tester.pumpAndSettle();
    expect(_overlay, findsNothing);
    expect(store.seen, isTrue);
  });

  testWidgets('system back closes the tour instead of leaving the app', (
    tester,
  ) async {
    final store = MemoryTourStore();
    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();
    expect(_overlay, findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(_overlay, findsNothing);
    expect(store.seen, isTrue);
    expect(
      find.byKey(const ValueKey('today-calm-headline')),
      findsOneWidget,
    );
  });

  testWidgets('Settings can show the tour again', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_app(MemoryTourStore(seen: true)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-settings')));
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('show-app-tour')),
      find.byType(ListView).last,
      const Offset(0, -300),
    );
    await tester.tap(find.byKey(const ValueKey('show-app-tour')));
    await tester.pumpAndSettle();
    expect(_overlay, findsOneWidget);
    expect(_title(tester), 'Welcome to Pinne');
    expect(
      find.byKey(const ValueKey('today-calm-headline')),
      findsOneWidget,
    );
  });

  const screens = {
    'small phone, large text': (Size(360, 640), 1.3),
    'tiny phone': (Size(320, 568), 1.0),
    'landscape phone': (Size(780, 360), 1.0),
    'tablet': (Size(1024, 1366), 1.0),
  };
  for (final MapEntry(key: name, value: (size, text)) in screens.entries) {
    testWidgets('on a $name every callout stays on screen and beside its '
        'target', (tester) async {
      await _setSize(tester, size, text: text);
      await tester.pumpWidget(_app(MemoryTourStore()));
      await tester.pumpAndSettle();

      final screen = Offset.zero & size;
      for (var i = 0; i < tourSteps.length; i++) {
        expect(tester.takeException(), isNull, reason: 'step $i');
        final callout = tester.getRect(_overlay);
        expect(
          screen.inflate(.5).contains(callout.topLeft) &&
              screen.inflate(.5).contains(callout.bottomRight),
          isTrue,
          reason: 'step $i callout $callout',
        );
        final target = tourSteps[i].target;
        if (target != null) {
          final anchor = find.byWidgetPredicate(
            (widget) => widget is TourAnchor && widget.target == target,
          );
          final hole = tester.getRect(anchor);
          final fitsBesides =
              hole.top - callout.height > 40 ||
              size.height - hole.bottom - callout.height > 40;
          if (fitsBesides) {
            expect(
              callout.overlaps(hole.deflate(1)),
              isFalse,
              reason: 'step $i covers its target',
            );
          }
          expect(hole.top, greaterThanOrEqualTo(-1), reason: 'step $i');
          expect(hole.bottom, lessThanOrEqualTo(size.height + 1));
        }
        if (i < tourSteps.length - 1) {
          await tester.tap(find.byKey(const ValueKey('tour-next')));
          await tester.pumpAndSettle();
        }
      }
    });
  }

  group('renders for review', () {
    setUpAll(loadGoldenFonts);

    final owner = UuidValue.fromString('00000000-0000-4000-8000-000000000001');
    final item = Item(
      id: UuidValue.fromString('00000000-0000-4000-8000-000000000002'),
      ownerId: owner,
      url: 'https://example.com/fake-flutter-sidebar',
      sourcePlatform: SourcePlatform.x,
      title: 'Flutter desktop sidebar patterns',
      contentType: ContentType.post,
      intention: 'Try this navigation pattern in the demo dashboard',
      savedAt: DateTime.utc(2026, 10, 5),
      durationSeconds: 420,
    );

    Widget shell() {
      Widget placeholder(String name) => Center(child: Text(name));
      StatefulShellBranch branch(String path, Widget child) =>
          StatefulShellBranch(
            routes: [GoRoute(path: path, builder: (_, _) => child)],
          );
      final router = GoRouter(
        initialLocation: Routes.today,
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, shell) =>
                AppShell(navigationShell: shell),
            branches: [
              branch(Routes.today, const TodayScreen()),
              branch(Routes.collections, placeholder('Collections')),
              branch(Routes.search, placeholder('Search')),
              branch(Routes.progress, placeholder('Progress')),
              branch(Routes.settings, placeholder('Settings')),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      return ProviderScope(
        overrides: [
          signedInProvider.overrideWith(_SignedOut.new),
          captureStoreProvider.overrideWithValue(
            CaptureStore(sqlite3.openInMemory()),
          ),
          tourStoreProvider.overrideWithValue(MemoryTourStore()),
          greetingClockProvider.overrideWithValue(
            () => DateTime(2026, 10, 7, 9),
          ),
          greetingIndexPickerProvider.overrideWithValue((_) => 0),
          todayClockProvider.overrideWithValue(DateTime(2026, 10, 7, 17, 30)),
          profileProvider.overrideWith(
            (_) async => PinneProfile(
              ownerId: owner,
              displayName: 'Demo Friend',
              avatarSeed: 42,
              avatarPalette: 0,
            ),
          ),
          todayQueueProvider.overrideWith(
            (_) async => ReviewQueueResult(
              entries: [
                ReviewQueueEntry(
                  item: item,
                  dueAt: DateTime.utc(2026, 10, 7, 16),
                  overdueMinutes: 90,
                  estimatedMinutes: 7,
                  selectionReason: 'Due for review',
                ),
              ],
              timeBudgetMinutes: 10,
              eligibleCount: 1,
            ),
          ),
          todayOverviewProvider.overrideWith(
            (_) async => const TodayOverview(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: goldenTheme(),
          routerConfig: router,
          builder: (context, child) => MotionPreferenceScope(
            preference: MotionPreference.reduced,
            child: child!,
          ),
        ),
      );
    }

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    testWidgets('Today tour steps', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(shell());
      await settle(tester);

      const shots = {
        0: '01-welcome',
        1: '02-save',
        2: '03-due-now',
        3: '04-time',
        5: '05-plan-and-track',
        6: '06-tabs',
      };
      for (var i = 0; i < tourSteps.length; i++) {
        if (shots[i] case final name?) {
          await expectLater(
            find.byType(AppShell),
            matchesGoldenFile('../../docs/tour/$name.png'),
          );
        }
        if (i < tourSteps.length - 1) {
          await tester.tap(find.byKey(const ValueKey('tour-next')));
          await settle(tester);
        }
      }
    });

    testWidgets('small phone with large text', (tester) async {
      await _setSize(tester, const Size(360, 640), text: 1.3);
      await tester.pumpWidget(shell());
      await settle(tester);
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byKey(const ValueKey('tour-next')));
        await settle(tester);
      }
      await expectLater(
        find.byType(AppShell),
        matchesGoldenFile('../../docs/tour/small-large-text-due-now.png'),
      );
    });
  });
}
