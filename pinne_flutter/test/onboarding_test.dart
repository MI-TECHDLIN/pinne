import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_flutter/features/onboarding/onboarding_screen.dart';
import 'package:pinne_flutter/features/onboarding/onboarding_store.dart';
import 'package:pinne_flutter/router.dart';
import 'package:pinne_flutter/ui/motion.dart';
import 'package:pinne_flutter/ui/ribbon_spirit/ribbon_cutout.dart';

import 'support/contrast.dart';
import 'support/golden_theme.dart';

void main() {
  setUpAll(loadGoldenFonts);

  Widget testApp(
    MemoryOnboardingStore store, {
    String initialLocation = Routes.onboarding,
    MotionPreference motion = MotionPreference.reduced,
    bool light = false,
  }) {
    final router = GoRouter(
      initialLocation: initialLocation,
      redirect: (context, state) => onboardingRedirect(store, state),
      routes: [
        GoRoute(
          path: Routes.onboarding,
          builder: (context, state) => OnboardingScreen(
            replay: state.uri.queryParameters['replay'] == '1',
          ),
        ),
        GoRoute(
          path: Routes.signIn,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Sign in destination')),
          ),
        ),
        GoRoute(
          path: Routes.today,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Today destination'))),
        ),
        GoRoute(
          path: Routes.settings,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Settings destination')),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    return ProviderScope(
      overrides: [onboardingStoreProvider.overrideWithValue(store)],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: goldenTheme(
          brightness: light ? Brightness.light : Brightness.dark,
        ),
        routerConfig: router,
        builder: (context, child) => MotionPreferenceScope(
          preference: motion,
          child: child!,
        ),
      ),
    );
  }

  testWidgets('first launch shows once and skip persists completion', (
    tester,
  ) async {
    final store = MemoryOnboardingStore();
    await tester.pumpWidget(testApp(store));
    await tester.pumpAndSettle();
    expect(find.textContaining('Save it once.'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('onboarding-skip')));
    await tester.pumpAndSettle();
    expect(store.completed, isTrue);
    expect(find.text('Sign in destination'), findsOneWidget);

    await tester.pumpWidget(testApp(store));
    await tester.pumpAndSettle();
    expect(find.text('Today destination'), findsOneWidget);
  });

  testWidgets('swipe and next button move through all three pages', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(testApp(MemoryOnboardingStore()));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const ValueKey('onboarding-pages')),
      const Offset(-360, 0),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('right on time'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Turn saved into'), findsOneWidget);
  });

  testWidgets('completed users can explicitly replay onboarding', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        MemoryOnboardingStore(completed: true),
        initialLocation: '${Routes.onboarding}?replay=1',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Save it once.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('onboarding-skip')));
    await tester.pumpAndSettle();
    expect(find.text('Settings destination'), findsOneWidget);
  });

  testWidgets('reduced motion uses calm static compositions', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      testApp(
        MemoryOnboardingStore(),
        motion: MotionPreference.reduced,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('onboarding-static-scene')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('flight-animation')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('onboarding-static-scene')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('reminder-animation')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('onboarding-static-scene')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('progress-animation')), findsNothing);
  });

  testWidgets('full motion enables the content flight scene', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      testApp(MemoryOnboardingStore(), motion: MotionPreference.full),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(const ValueKey('flight-animation')), findsOneWidget);
    expect(find.byKey(const ValueKey('onboarding-static-scene')), findsNothing);
  });

  testWidgets('reminder cards clear the spirit on narrow phones', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(testApp(MemoryOnboardingStore()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();

    final spirit = tester.getRect(
      find.byKey(const ValueKey('reminder-spirit')),
    );
    final article = tester.getRect(
      find.byKey(const ValueKey('reminder-article')),
    );
    final video = tester.getRect(find.byKey(const ValueKey('reminder-video')));
    final due = tester.getRect(find.byKey(const ValueKey('reminder-due')));
    expect(spirit.bottom, lessThan(article.top));
    expect(article.bottom, lessThan(video.top));
    expect(video.bottom, lessThan(due.top));
    expect(tester.takeException(), isNull);
  });

  testWidgets('three onboarding screens render for review', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      testApp(
        MemoryOnboardingStore(),
        motion: MotionPreference.reduced,
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../docs/onboarding/01-everything-one-home.png'),
    );
    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../docs/onboarding/02-we-bring-it-back.png'),
    );
    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../docs/onboarding/03-make-time-progress.png'),
    );
  });

  testWidgets('first onboarding page renders in Lavender Mist', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      testApp(
        MemoryOnboardingStore(),
        motion: MotionPreference.reduced,
        light: true,
      ),
    );
    await tester.pumpAndSettle();

    final cutout = find.byType(RibbonSpiritCutout);
    await tester.runAsync(
      () => precacheImage(
        const AssetImage(
          'assets/art/cutout/ribbon_spirit_empty_collection.webp',
        ),
        tester.element(cutout),
      ),
    );
    await tester.pump();
    final image = find.descendant(of: cutout, matching: find.byType(RawImage));
    expect(cutout, findsOneWidget);
    expect(tester.renderObject<RenderImage>(image).image, isNotNull);

    await expectReadableText(tester);
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../docs/light-theme/onboarding.png'),
    );
  });

  const phones = {
    'small': Size(360, 640),
    'medium': Size(390, 844),
    'large': Size(430, 932),
  };

  for (final MapEntry(key: name, value: size) in phones.entries) {
    for (final scale in const [1.0, 1.3]) {
      testWidgets('$name phone at ${scale}x text keeps copy clear of the '
          'footer on every page', (tester) async {
        await tester.binding.setSurfaceSize(size);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(() {
          tester.binding.setSurfaceSize(null);
          tester.platformDispatcher.clearTextScaleFactorTestValue();
        });
        await tester.pumpWidget(testApp(MemoryOnboardingStore()));
        await tester.pumpAndSettle();

        for (var page = 0; page < 3; page++) {
          expect(tester.takeException(), isNull, reason: 'page $page');
          final next = tester.getRect(
            find.byKey(const ValueKey('onboarding-next')),
          );
          final copy = find.byKey(const ValueKey('onboarding-copy'));
          final scrollable = find.descendant(
            of: find.byKey(const ValueKey('onboarding-pages')),
            matching: find.byType(Scrollable),
          );
          // Scroll the copy fully into view; it must then sit above the
          // footer and inside the screen, never under it.
          await tester.ensureVisible(copy);
          await tester.pumpAndSettle();
          final copyRect = tester.getRect(copy);
          expect(copyRect.bottom, lessThanOrEqualTo(next.top), reason: '$page');
          expect(copyRect.left, greaterThanOrEqualTo(0));
          expect(copyRect.right, lessThanOrEqualTo(size.width));
          expect(scrollable, findsWidgets);
          if (page < 2) {
            await tester.tap(find.byKey(const ValueKey('onboarding-next')));
            await tester.pumpAndSettle();
          }
        }
        expect(find.text('Get started'), findsOneWidget);
      });
    }
  }

  testWidgets('scene gets the room left by the copy on tall phones', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(testApp(MemoryOnboardingStore()));
    await tester.pumpAndSettle();

    final scene = tester.getRect(
      find.byKey(const ValueKey('onboarding-static-scene')),
    );
    final copy = tester.getRect(find.byKey(const ValueKey('onboarding-copy')));
    expect(scene.bottom, lessThanOrEqualTo(copy.top));
    expect(scene.height, greaterThan(300));
  });

  testWidgets('landscape and tablets put the scene beside the copy', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 420));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(testApp(MemoryOnboardingStore()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final scene = tester.getRect(
      find.byKey(const ValueKey('onboarding-static-scene')),
    );
    final copy = tester.getRect(find.byKey(const ValueKey('onboarding-copy')));
    expect(scene.right, lessThanOrEqualTo(copy.left));
  });

  testWidgets('small phone with large text renders for review', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(() {
      tester.binding.setSurfaceSize(null);
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    await tester.pumpWidget(testApp(MemoryOnboardingStore()));
    await tester.pumpAndSettle();

    for (var page = 1; page <= 3; page++) {
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('../../docs/onboarding/small-large-text-0$page.png'),
      );
      if (page < 3) {
        await tester.tap(find.byKey(const ValueKey('onboarding-next')));
        await tester.pumpAndSettle();
      }
    }
  });
}
