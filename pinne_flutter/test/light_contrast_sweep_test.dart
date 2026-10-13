import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/app.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/onboarding/onboarding_store.dart';
import 'package:pinne_flutter/features/search/search_history.dart';
import 'package:pinne_flutter/features/today/today_greeting.dart';
import 'package:pinne_flutter/features/tour/tour_store.dart';
import 'package:pinne_flutter/theme/theme_mode.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'capture/fake_capture_server.dart';
import 'support/contrast.dart';
import 'support/golden_theme.dart';

class _SignedOut extends SignedInNotifier {
  @override
  bool build() => false;
}

class _AlwaysReduced extends MotionPreferenceNotifier {
  @override
  MotionPreference build() => MotionPreference.reduced;
}

class _Light extends ThemePreferenceNotifier {
  @override
  PinneThemePreference build() => PinneThemePreference.light;
}

void main() {
  setUpAll(loadGoldenFonts);
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  Widget app({
    bool onboarded = true,
    bool toured = true,
    List overrides = const [],
  }) => ProviderScope(
    overrides: [
      ...overrides,
      serverUrlProvider.overrideWithValue('http://localhost:8080/'),
      emailDeliveryAvailableProvider.overrideWith((ref) async => false),
      captureStoreProvider.overrideWithValue(
        CaptureStore(sqlite3.openInMemory()),
      ),
      captureApiProvider.overrideWithValue(FakeCaptureServer()),
      signedInProvider.overrideWith(_SignedOut.new),
      motionPreferenceProvider.overrideWith(_AlwaysReduced.new),
      themePreferenceProvider.overrideWith(_Light.new),
      onboardingStoreProvider.overrideWithValue(
        MemoryOnboardingStore(completed: onboarded),
      ),
      tourStoreProvider.overrideWithValue(MemoryTourStore(seen: toured)),
      greetingClockProvider.overrideWithValue(() => DateTime(2026, 10, 7, 9)),
      greetingIndexPickerProvider.overrideWithValue((_) => 0),
    ],
    child: const PinneApp(),
  );

  Future<void> tall(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  Future<void> phone(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  Future<void> check(
    WidgetTester tester,
    String where, {
    Finder? within,
  }) async {
    await expectReadableText(tester, within: within, reason: where);
  }

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder.first);
    await tester.pumpAndSettle();
    await tester.tap(finder.first);
    await tester.pumpAndSettle();
  }

  testWidgets('every tab', (tester) async {
    await tall(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    for (final tab in [
      'today',
      'collections',
      'search',
      'progress',
      'settings',
    ]) {
      await tapAndSettle(tester, find.byKey(ValueKey('nav-$tab')));
      await check(tester, tab);
    }
  });

  testWidgets('collection detail', (tester) async {
    await tall(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-collections')));
    await tapAndSettle(
      tester,
      find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey<String> &&
            (w.key! as ValueKey<String>).value.startsWith('collection-'),
      ),
    );
    expect(find.byTooltip('Back'), findsOneWidget);
    await check(tester, 'collection detail');
  });

  testWidgets('search: recent searches and clear dialog', (tester) async {
    await tall(tester);
    await tester.pumpWidget(
      app(
        overrides: [
          searchHistoryStoreProvider.overrideWithValue(
            MemorySearchHistoryStore(['Newest search', 'Older search']),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-search')));
    await check(tester, 'recent searches');
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('clear-search-history')),
    );
    await check(tester, 'clear recent searches dialog');
  });

  testWidgets('app tour coach marks', (tester) async {
    await tall(tester);
    await tester.pumpWidget(app(toured: false));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('tour-callout')), findsOneWidget);
    var steps = 0;
    for (var step = 0; step < 12; step++, steps++) {
      if (find.byKey(const ValueKey('tour-callout')).evaluate().isEmpty) break;
      await check(
        tester,
        'tour step $step',
        within: find.byKey(const ValueKey('tour-callout')),
      );
      final next = find.byKey(const ValueKey('tour-next'));
      if (next.evaluate().isEmpty) break;
      await tester.tap(next);
      await tester.pumpAndSettle();
    }
    expect(steps, greaterThan(1));
  });

  testWidgets('onboarding pages', (tester) async {
    await phone(tester);
    await tester.pumpWidget(app(onboarded: false));
    await tester.pumpAndSettle();
    for (var page = 0; page < 3; page++) {
      await check(tester, 'onboarding page $page');
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('guest profile', (tester) async {
    await tall(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-settings')));
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('settings-profile-link')),
    );
    await check(tester, 'guest profile');
  });
}
