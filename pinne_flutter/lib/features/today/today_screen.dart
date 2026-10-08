import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../router.dart';
import '../../shell/pinne_page.dart';
import '../../theme/pinne_theme.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import '../capture/paste_capture_card.dart';
import '../progress/celebration.dart';
import '../settings/profile_provider.dart';
import 'today_providers.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(todayQueueProvider);
    final avatar = ref.watch(avatarRecipeProvider);
    final budget = ref.watch(reviewBudgetProvider);
    final data = queue.asData?.value;
    final top = data?.entries.firstOrNull;
    return PinnePage(
      headline: 'Today,',
      headlineBold: top == null ? 'a few good saves' : 'worth revisiting',
      subtitle: 'A small queue of what is worth revisiting now.',
      children: [
        _BudgetChoice(selected: budget),
        const SizedBox(height: PinneSpacing.md),
        if (top != null && (data?.digestText?.trim().isNotEmpty ?? false)) ...[
          GlassCard(
            child: Text(
              data!.digestText!,
              style: const TextStyle(height: 1.45),
            ),
          ),
          const SizedBox(height: PinneSpacing.md),
        ],
        if (queue.isLoading)
          const GlassCard(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (queue.hasError)
          _QueueError(onRetry: () => ref.invalidate(todayQueueProvider))
        else
          TodaySpiritCard(
            due: top != null,
            seed: avatar.seed,
            palette: avatar.palette,
            entry: top,
            digestText: data?.digestText,
            onReviewed: top == null
                ? null
                : () => _review(context, ref, top.item),
            onRemindLater: top == null
                ? null
                : () => _run(
                    context,
                    () => ref
                        .read(todayActionGatewayProvider)
                        .remindLater(top.item),
                    'We’ll bring it back tomorrow.',
                  ),
            onArchive: top == null
                ? null
                : () => _run(
                    context,
                    () =>
                        ref.read(todayActionGatewayProvider).archive(top.item),
                    'Archived without counting it as reviewed.',
                  ),
            onOpen: top?.item.url == null
                ? null
                : () => _run(
                    context,
                    () => ref.read(todayActionGatewayProvider).open(top!.item),
                    'Opened. It still waits for your review.',
                  ),
          ),
        const SizedBox(height: PinneSpacing.md),
        const PasteCaptureCard(),
        const SizedBox(height: PinneSpacing.md),
        const PlanReviewCard(),
        if ((data?.entries.length ?? 0) > 1) ...[
          const SizedBox(height: PinneSpacing.md),
          GlassCard(
            child: Text(
              '${data!.entries.length - 1} more fit this session. '
              'Durations are estimates.',
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _review(BuildContext context, WidgetRef ref, Item item) async {
    try {
      final receipt = await ref.read(todayActionGatewayProvider).reviewed(item);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Counted as reviewed.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => unawaited(
              ref
                  .read(todayActionGatewayProvider)
                  .undo(item, receipt.event.id!),
            ),
          ),
        ),
      );
      await ref
          .read(celebrationControllerProvider.notifier)
          .checkAfterReview(context);
    } on Object {
      if (context.mounted) _message(context, 'Could not update your review.');
    }
  }

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
    String success,
  ) async {
    try {
      await action();
      if (context.mounted) _message(context, success);
    } on Object {
      if (context.mounted) _message(context, 'Could not update the queue.');
    }
  }

  void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _BudgetChoice extends ConsumerWidget {
  const _BudgetChoice({required this.selected});

  final int selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: 'Review time budget. Durations are estimates.',
      child: Wrap(
        spacing: PinneSpacing.sm,
        runSpacing: PinneSpacing.sm,
        children: [
          for (final minutes in const [5, 10, 20])
            ChoiceChip(
              key: ValueKey('budget-$minutes'),
              label: Text('$minutes min'),
              selected: selected == minutes,
              onSelected: (_) =>
                  ref.read(reviewBudgetProvider.notifier).select(minutes),
            ),
        ],
      ),
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
    this.entry,
    this.digestText,
    this.onReviewed,
    this.onRemindLater,
    this.onArchive,
    this.onOpen,
  });

  final bool due;
  final int seed;
  final int palette;
  final bool animate;
  final ReviewQueueEntry? entry;
  final String? digestText;
  final VoidCallback? onReviewed;
  final VoidCallback? onRemindLater;
  final VoidCallback? onArchive;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final ink = due ? PinneColors.ink : PinneColors.text;
    final item = entry?.item;
    final note = item?.intention ?? item?.noteText;
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
                  due
                      ? 'DUE NOW · ${entry?.estimatedMinutes ?? 10} MIN EST.'
                      : 'ALL QUIET',
                  style: TextStyle(
                    color: ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  item?.title ??
                      (due ? 'A little rediscovery' : 'Room for a new thought'),
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: ink),
                ),
                const SizedBox(height: 8),
                Text(
                  item == null
                      ? (due
                            ? 'Something you saved is ready for another look.'
                            : digestText ??
                                  'Nothing due yet. Your spirit is resting.\n'
                                      'Save something good; we’ll bring it back tomorrow.')
                      : '${item.sourcePlatform.name.toUpperCase()} · '
                            '${note?.trim().isNotEmpty == true ? note : 'No saved note'}',
                  style: TextStyle(
                    color: due ? ink : PinneColors.muted,
                    height: 1.5,
                  ),
                ),
                if (item != null) ...[
                  const SizedBox(height: PinneSpacing.lg),
                  Wrap(
                    spacing: PinneSpacing.sm,
                    runSpacing: PinneSpacing.sm,
                    children: [
                      FilledButton(
                        key: const ValueKey('review-reviewed'),
                        style: pinnePrimaryActionStyle(),
                        onPressed: onReviewed,
                        child: const Text('Reviewed'),
                      ),
                      FilledButton(
                        key: const ValueKey('review-remind'),
                        onPressed: onRemindLater,
                        child: const Text('Remind me later'),
                      ),
                      OutlinedButton(
                        key: const ValueKey('review-archive'),
                        onPressed: onArchive,
                        child: const Text('Archive'),
                      ),
                      TextButton.icon(
                        key: const ValueKey('review-open'),
                        onPressed: onOpen,
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: const Text('Open'),
                      ),
                    ],
                  ),
                ],
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

class _QueueError extends StatelessWidget {
  const _QueueError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your queue is taking a moment.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: PinneSpacing.sm),
        const Text('Your saves are safe. Try again when you’re ready.'),
        const SizedBox(height: PinneSpacing.md),
        FilledButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    ),
  );
}
