import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_flutter/features/onboarding/onboarding_screen.dart';
import 'package:pinne_flutter/features/onboarding/onboarding_store.dart';
import 'package:pinne_flutter/router.dart';
import 'package:pinne_flutter/ui/motion.dart';

import 'support/golden_theme.dart';

void main() {
  setUpAll(loadGoldenFonts);

  Widget testApp(
    MemoryOnboardingStore store, {
    String initialLocation = Routes.onboarding,
    MotionPreference motion = MotionPreference.reduced,
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
        theme: goldenTheme(),
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
}
