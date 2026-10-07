import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../router.dart';
import '../../shell/pinne_page.dart';
import '../capture/paste_capture_card.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import '../settings/profile_provider.dart';

/// Local placeholder until the review queue supplies this state. Empty by
/// default; the debug gallery and tests override it to preview due-now.
final todayHasDueProvider = Provider<bool>((ref) => false);

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final due = ref.watch(todayHasDueProvider);
    final avatar = ref.watch(avatarRecipeProvider);
    return PinnePage(
      headline: 'Today,',
      headlineBold: 'a few good saves',
      subtitle: 'A small queue of what is worth revisiting now.',
      children: [
        TodaySpiritCard(due: due, seed: avatar.seed, palette: avatar.palette),
        const SizedBox(height: PinneSpacing.md),
        const PasteCaptureCard(),
        const SizedBox(height: PinneSpacing.md),
        const PlanReviewCard(),
        const SizedBox(height: PinneSpacing.md),
        const ComingSoonCard(
          title: 'Your queue stays small',
          body:
              'Items you save show up here about a day later, '
              'with the note you left on why you saved them.',
        ),
      ],
    );
  }
}

/// The way into the Planner from Today.
class PlanReviewCard extends StatelessWidget {
  const PlanReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Make time to review', style: theme.textTheme.titleMedium),
                const SizedBox(height: PinneSpacing.xs),
                Text(
                  'Plan short sessions in your free time.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: PinneColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: PinneSpacing.sm),
          FilledButton(
            onPressed: () => context.push(Routes.planner),
            child: const Text('Plan'),
          ),
        ],
      ),
    );
  }
}

class TodaySpiritCard extends StatelessWidget {
  const TodaySpiritCard({
    super.key,
    required this.due,
    required this.seed,
    required this.palette,
    this.animate = true,
  });
  final bool due;
  final int seed;
  final int palette;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final ink = due ? PinneColors.ink : PinneColors.text;
    final card = Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: due ? PinneColors.accentDue : PinneColors.card,
              borderRadius: BorderRadius.circular(PinneRadii.card),
              border: due ? null : Border.all(color: PinneColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  due ? 'DUE NOW' : 'ALL QUIET',
                  style: TextStyle(
                    color: ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  due ? 'A little rediscovery' : 'Room for a new thought',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: ink),
                ),
                const SizedBox(height: 8),
                Text(
                  due
                      ? 'Something you saved is ready for another look.'
                      : 'Nothing due yet. Your spirit is resting.\nSave something good; we’ll bring it back tomorrow.',
                  style: TextStyle(
                    color: due ? ink : PinneColors.muted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 12,
          top: 0,
          child: RibbonSpirit(
            seed: seed,
            palette: palette,
            size: 126,
            animate: animate,
            mood: due ? RibbonMood.excited : RibbonMood.sleepy,
          ),
        ),
      ],
    );

    // The due-now card floats gently, carrying the spirit with it.
    if (!due || !animate || reduceMotionOf(context)) return card;
    return RepaintBoundary(
      child: card
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(
            begin: 0,
            end: -4,
            duration: PinneMotionDurations.float,
            curve: PinneMotionCurves.float,
          ),
    );
  }
}
