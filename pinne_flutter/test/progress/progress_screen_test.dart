import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/progress/celebration.dart';
import 'package:pinne_flutter/features/progress/progress_card_stack.dart';
import 'package:pinne_flutter/features/progress/progress_providers.dart';
import 'package:pinne_flutter/features/progress/progress_screen.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../support/golden_theme.dart';
import 'fake_progress_api.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

void main() {
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  Widget app(
    Widget home, {
    MotionPreference motion = MotionPreference.reduced,
    FakeProgressApi? api,
  }) => ProviderScope(
    overrides: [
      signedInProvider.overrideWith(_SignedIn.new),
      avatarRecipeProvider.overrideWithValue((seed: 2026, palette: 0)),
      if (api != null) progressApiProvider.overrideWithValue(api),
    ],
    child: MaterialApp(
      theme: goldenTheme(),
      builder: (context, child) =>
          MotionPreferenceScope(preference: motion, child: child!),
      home: Scaffold(body: home),
    ),
  );

  List<ProgressCardData> cards() => [
    for (final (id, label, value) in [
      ('a', 'Reviewed this week', 7),
      ('b', 'Saved this week', 12),
      ('c', 'Still to revisit', 5),
    ])
      ProgressCardData(
        id: id,
        label: label,
        icon: Icons.check_rounded,
        value: value,
        caption: 'Caption $id',
        background: PinneColors.violet,
        foreground: PinneColors.text,
      ),
  ];

  Finder topCardText(String text) => find.descendant(
    of: find.byKey(const ValueKey('progress-stack-top')),
    matching: find.text(text),
  );

  group('card stack', () {
    testWidgets('a swipe sends the top card to the back', (tester) async {
      await tester.pumpWidget(
        app(
          Padding(
            padding: const EdgeInsets.all(16),
            child: ProgressCardStack(cards: cards()),
          ),
          motion: MotionPreference.full,
        ),
      );
      expect(topCardText('Reviewed this week'), findsOneWidget);
      expect(find.byKey(const ValueKey('progress-pager')), findsNothing);
      // The resting deck is tilted.
      final transforms = tester.widgetList<Transform>(
        find.ancestor(
          of: topCardText('Reviewed this week'),
          matching: find.byType(Transform),
        ),
      );
      expect(
        transforms.any((t) => t.transform.storage[1].abs() > 0.01),
        isTrue,
      );

      await tester.drag(
        find.byKey(const ValueKey('progress-stack-top')),
        const Offset(-260, 0),
      );
      await tester.pumpAndSettle();
      expect(topCardText('Saved this week'), findsOneWidget);
      expect(topCardText('Reviewed this week'), findsNothing);

      // A tap moves on too, and the deck cycles back to the start.
      await tester.tap(find.byKey(const ValueKey('progress-stack-top')));
      await tester.pumpAndSettle();
      expect(topCardText('Still to revisit'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('progress-stack-top')));
      await tester.pumpAndSettle();
      expect(topCardText('Reviewed this week'), findsOneWidget);
    });

    testWidgets('a short drag springs back without moving on', (tester) async {
      await tester.pumpWidget(
        app(
          Padding(
            padding: const EdgeInsets.all(16),
            child: ProgressCardStack(cards: cards()),
          ),
          motion: MotionPreference.full,
        ),
      );
      await tester.timedDrag(
        find.byKey(const ValueKey('progress-stack-top')),
        const Offset(-30, 0),
        const Duration(milliseconds: 600),
      );
      await tester.pumpAndSettle();
      expect(topCardText('Reviewed this week'), findsOneWidget);
    });

    testWidgets('reduced motion shows a plain pager', (tester) async {
      await tester.pumpWidget(
        app(
          Padding(
            padding: const EdgeInsets.all(16),
            child: ProgressCardStack(cards: cards()),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('progress-pager')), findsOneWidget);
      expect(find.byKey(const ValueKey('progress-stack-top')), findsNothing);
      final transforms = tester.widgetList<Transform>(
        find.ancestor(
          of: find.text('Reviewed this week'),
          matching: find.byType(Transform),
        ),
      );
      expect(transforms.every((t) => t.transform.storage[1] == 0), isTrue);
      await tester.drag(
        find.byKey(const ValueKey('progress-pager')),
        const Offset(-400, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text('Saved this week'), findsOneWidget);
    });
  });

  group('Progress tab', () {
    testWidgets('shows the report with honest labels', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.binding.setSurfaceSize(const Size(430, 2600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = FakeProgressApi({ProgressPeriod.thisWeek: sampleReport()});
      await tester.pumpWidget(app(const ProgressScreen(), api: api));
      await tester.pumpAndSettle();

      expect(find.text('Reviewed this week'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Reviewed'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('58%'), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          RegExp('Design inspiration: 75% revisited, 3 of 4'),
        ),
        findsOneWidget,
      );
      expect(find.text('best day\nso far'), findsOneWidget);
      expect(find.text('3-day streak'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('Wednesday, today: reviewed')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp('Thursday: still to come')),
        findsOneWidget,
      );
      expect(api.queries.single.period, ProgressPeriod.thisWeek);
      semantics.dispose();
    });

    testWidgets('switching period asks for that cohort', (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = FakeProgressApi({
        ProgressPeriod.thisWeek: sampleReport(),
        ProgressPeriod.lastWeek: sampleReport(period: ProgressPeriod.lastWeek),
      });
      await tester.pumpWidget(app(const ProgressScreen(), api: api));
      await tester.pumpAndSettle();
      expect(
        find.text('Saved this week, and where they stand'),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('period-lastWeek')));
      await tester.pumpAndSettle();
      expect(api.queries.last.period, ProgressPeriod.lastWeek);
      expect(api.queries.last.timezoneOffsetMinutes, isA<int>());
      expect(
        find.text('Saved last week, and where they stand'),
        findsOneWidget,
      );
      expect(find.text('Reviewed last week'), findsOneWidget);
      expect(find.text('67%'), findsWidgets);
    });

    testWidgets('an empty account gets an encouraging, number-free state', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final api = FakeProgressApi({ProgressPeriod.thisWeek: emptyReport()});
      await tester.pumpWidget(app(const ProgressScreen(), api: api));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('progress-empty')), findsOneWidget);
      expect(
        find.text('Save something, then come back to it here'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp('sleepy ribbon spirit')),
        findsOneWidget,
      );
      expect(find.textContaining('%'), findsNothing);
      expect(find.byType(ProgressCardStack), findsNothing);
      semantics.dispose();
    });

    testWidgets('the weekly goal sheet saves goal and streak', (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 2600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = FakeProgressApi({ProgressPeriod.thisWeek: sampleReport()});
      await tester.pumpWidget(app(const ProgressScreen(), api: api));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('progress-goal-edit')));
      await tester.pumpAndSettle();
      expect(find.text('3 days'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('goal-plus')));
      await tester.tap(find.byKey(const ValueKey('streak-switch')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('goal-save')));
      await tester.pumpAndSettle();
      expect(api.settingsValue.weeklyGoalDays, 4);
      expect(api.settingsValue.streakEnabled, isTrue);
      expect(find.byType(GoalSettingsSheet), findsNothing);
    });
  });

  group('celebration', () {
    final weeklyGoal = ProgressMilestone(
      key: 'weekly-goal-2026-10-05',
      kind: MilestoneKind.weeklyGoal,
      value: 5,
      celebrated: false,
    );
    final queue = ProgressMilestone(
      key: 'queue-cleared-2026-10-07',
      kind: MilestoneKind.queueCleared,
      value: 2,
      celebrated: false,
    );

    testWidgets('a new milestone celebrates exactly once', (tester) async {
      final announcements = <String>[];
      tester.binding.defaultBinaryMessenger
          .setMockDecodedMessageHandler<dynamic>(SystemChannels.accessibility, (
            message,
          ) async {
            final data = (message as Map)['data'] as Map;
            if (data['message'] case final String text) announcements.add(text);
            return null;
          });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger
            .setMockDecodedMessageHandler<dynamic>(
              SystemChannels.accessibility,
              null,
            ),
      );
      final api = FakeProgressApi({
        ProgressPeriod.thisWeek: sampleReport(milestones: [queue, weeklyGoal]),
        ProgressPeriod.lastWeek: sampleReport(
          period: ProgressPeriod.lastWeek,
          milestones: [queue, weeklyGoal],
        ),
      });
      await tester.pumpWidget(app(const ProgressScreen(), api: api));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('celebration-card')), findsOneWidget);
      expect(find.text('Weekly goal reached'), findsOneWidget);
      expect(find.text('5'), findsWidgets);
      expect(find.text('review days'), findsOneWidget);
      expect(find.text('Also: Queue cleared'), findsOneWidget);
      // Reduced motion: a calm card, no confetti.
      expect(find.byType(RibbonConfetti), findsNothing);
      expect(
        announcements,
        contains(startsWith('Weekly goal reached: 5 review days.')),
      );
      expect(api.celebrated.expand((keys) => keys).toSet(), {
        weeklyGoal.key,
        queue.key,
      });

      await tester.tap(find.byKey(const ValueKey('celebration-continue')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('celebration-card')), findsNothing);

      // Even if a stale report still says "not celebrated", it never repeats.
      await tester.tap(find.byKey(const ValueKey('period-lastWeek')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('period-thisWeek')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('celebration-card')), findsNothing);
    });

    testWidgets('a celebrated milestone stays quiet', (tester) async {
      final api = FakeProgressApi({
        ProgressPeriod.thisWeek: sampleReport(
          milestones: [weeklyGoal.copyWith(celebrated: true)],
        ),
      });
      await tester.pumpWidget(app(const ProgressScreen(), api: api));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('celebration-card')), findsNothing);
      expect(api.celebrated, isEmpty);
    });

    testWidgets('full motion adds pastel ribbon confetti', (tester) async {
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showCelebration(
                context,
                milestone: weeklyGoal,
                seed: 2026,
                palette: 0,
              ),
              child: const Text('go'),
            ),
          ),
          motion: MotionPreference.full,
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(RibbonConfetti), findsOneWidget);
      expect(RibbonConfetti.colours, isNot(contains(PinneColors.accentDue)));
      await tester.tap(find.byKey(const ValueKey('celebration-continue')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(RibbonConfetti), findsNothing);
    });
  });
}
