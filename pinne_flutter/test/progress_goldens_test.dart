import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/progress/celebration.dart';
import 'package:pinne_flutter/features/progress/progress_providers.dart';
import 'package:pinne_flutter/features/progress/progress_screen.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'progress/fake_progress_api.dart';
import 'support/golden_theme.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

/// Renders the Progress tab and the celebration for docs/progress/.
void main() {
  setUpAll(loadGoldenFonts);
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  Widget app(
    Widget home, {
    required FakeProgressApi api,
    MotionPreference motion = MotionPreference.full,
  }) => ProviderScope(
    overrides: [
      signedInProvider.overrideWith(_SignedIn.new),
      avatarRecipeProvider.overrideWithValue((seed: 2026, palette: 0)),
      progressApiProvider.overrideWithValue(api),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: goldenTheme(),
      builder: (context, child) =>
          MotionPreferenceScope(preference: motion, child: child!),
      home: Scaffold(body: home),
    ),
  );

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('Progress tab', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 2020));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        const ProgressScreen(),
        api: FakeProgressApi({ProgressPeriod.thisWeek: sampleReport()}),
      ),
    );
    await settle(tester);
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../docs/progress/progress-tab.png'),
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('card deck mid-swipe', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 560));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        const ProgressScreen(),
        api: FakeProgressApi({ProgressPeriod.thisWeek: sampleReport()}),
      ),
    );
    await settle(tester);
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const ValueKey('progress-stack-top'))),
    );
    for (var i = 0; i < 6; i++) {
      await gesture.moveBy(const Offset(-24, -2));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../docs/progress/card-deck-swipe.png'),
    );
    await gesture.up();
    await settle(tester);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('empty state', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        const ProgressScreen(),
        api: FakeProgressApi({ProgressPeriod.thisWeek: emptyReport()}),
        motion: MotionPreference.reduced,
      ),
    );
    await settle(tester);
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../docs/progress/empty.png'),
    );
    await tester.pumpWidget(const SizedBox());
  });

  for (final reduced in [false, true]) {
    testWidgets('celebration${reduced ? ' (reduced motion)' : ''}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(412, 860));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = FakeProgressApi({
        ProgressPeriod.thisWeek: sampleReport(
          milestones: [
            ProgressMilestone(
              key: 'weekly-goal-2026-10-05',
              kind: MilestoneKind.weeklyGoal,
              value: 5,
              celebrated: false,
            ),
            ProgressMilestone(
              key: 'reviews-25',
              kind: MilestoneKind.reviewCount,
              value: 25,
              celebrated: true,
            ),
            ProgressMilestone(
              key: 'queue-cleared-2026-10-07',
              kind: MilestoneKind.queueCleared,
              value: 2,
              celebrated: false,
            ),
          ],
        ),
      });
      await tester.pumpWidget(
        app(
          const ProgressScreen(),
          api: api,
          motion: reduced ? MotionPreference.reduced : MotionPreference.full,
        ),
      );
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byKey(const ValueKey('celebration-card')), findsOneWidget);
      expect(find.byType(RibbonConfetti), reduced ? findsNothing : findsOne);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          '../../docs/progress/celebration${reduced ? '-reduced' : ''}.png',
        ),
      );
      await tester.tap(find.byKey(const ValueKey('celebration-continue')));
      await settle(tester);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
