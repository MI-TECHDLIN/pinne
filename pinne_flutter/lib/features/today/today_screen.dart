import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../router.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/feedback/error_state.dart';
import '../../ui/feedback/toast.dart';
import '../../ui/item_preview.dart';
import '../../ui/motion.dart';
import '../../ui/pinne_loading.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import '../capture/paste_capture_card.dart';
import '../examples/example_saves.dart';
import '../progress/celebration.dart';
import '../settings/profile_provider.dart';
import '../tour/tour_controller.dart';
import 'today_providers.dart';
import 'today_greeting.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(todayQueueProvider);
    final avatar = ref.watch(avatarRecipeProvider);
    final profile = ref.watch(profileProvider).asData?.value;
    final budget = ref.watch(reviewBudgetProvider);
    final overviewState = ref.watch(todayOverviewProvider);
    final overview = overviewState.asData?.value;
    final now = ref.watch(todayClockProvider);
    final data = queue.asData?.value;
    final dueCount = data?.entries.length ?? 0;
    final rotatingLine = ref.watch(todayGreetingProvider);
    final top = data?.entries.firstOrNull;
    final displayName = profile?.displayName.trim();

    return TourAutoStart(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.6, -1.2),
            radius: 1.2,
            colors: [context.pinne.glowViolet, context.pinne.midnight],
          ),
        ),
        child: SafeArea(
          bottom: false,
          // Not lazy: the tour must reach every part of Today on any screen.
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              PinneSpacing.gutter,
              PinneSpacing.lg,
              PinneSpacing.gutter,
              PinneSpacing.navClearance,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TodayHeader(
                  seed: avatar.seed,
                  palette: avatar.palette,
                  greeting: dueCount == 0 ? _greeting(now.hour) : rotatingLine,
                  name: displayName == null || displayName.isEmpty
                      ? 'Guest'
                      : displayName,
                  onProfile: () => context.push(Routes.profile),
                  onSearch: () => context.go(Routes.search),
                ),
                const SizedBox(height: PinneSpacing.lg),
                TodayHeadline(count: dueCount, calmLine: rotatingLine),
                const SizedBox(height: PinneSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TourAnchor(
                    target: TourTarget.timeChips,
                    child: _BudgetChoice(selected: budget),
                  ),
                ),
                const SizedBox(height: PinneSpacing.md),
                TourAnchor(
                  target: TourTarget.reviewCard,
                  child: queue.isLoading
                      ? const _HeroLoading()
                      : queue.hasError
                      ? PinneErrorCard(
                          error: queue.error,
                          subject: 'your queue',
                          onRetry: () => ref.invalidate(todayQueueProvider),
                        )
                      : TodaySpiritCard(
                          due: top != null,
                          seed: avatar.seed,
                          palette: avatar.palette,
                          entry: top,
                          digestText: data?.digestText,
                          timeBudgetMinutes: budget,
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
                                  'Could not snooze it',
                                ),
                          onArchive: top == null
                              ? null
                              : () => _run(
                                  context,
                                  () => ref
                                      .read(todayActionGatewayProvider)
                                      .archive(top.item),
                                  'Archived without counting it as reviewed.',
                                  'Could not archive it',
                                ),
                          onOpen: top?.item.url == null
                              ? null
                              : () => _run(
                                  context,
                                  () => ref
                                      .read(todayActionGatewayProvider)
                                      .open(top!.item),
                                  'Opened. It still waits for your review.',
                                  'Could not open it',
                                ),
                        ),
                ),
                const SizedBox(height: PinneSpacing.md),
                TourAnchor(
                  target: TourTarget.weekStrip,
                  child: _WeekStrip(
                    now: now,
                    reviewedDates: {
                      for (final day
                          in overview?.progress?.days ?? <ProgressDay>[])
                        if (day.reviewedCount > 0) day.date,
                    },
                  ),
                ),
                const SizedBox(height: PinneSpacing.md),
                TourAnchor(
                  target: TourTarget.planTiles,
                  child: overviewState.isLoading
                      ? const Row(
                          children: [
                            Expanded(child: PinneTileSkeleton(height: 126)),
                            SizedBox(width: PinneSpacing.sm),
                            Expanded(child: PinneTileSkeleton(height: 126)),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: _PastelActionTile(
                                color: context.pinne.peach,
                                tag: 'NEXT UP',
                                title: overview?.nextSession == null
                                    ? 'Plan a review session'
                                    : 'Review session',
                                body: _sessionLabel(overview?.nextSession, now),
                                icon: Icons.calendar_month_rounded,
                                onTap: () => context.push(Routes.planner),
                              ),
                            ),
                            const SizedBox(width: PinneSpacing.sm),
                            Expanded(
                              child: _PastelActionTile(
                                color: context.pinne.mint,
                                tag: 'THIS WEEK',
                                title:
                                    '${overview?.progress?.savedCount ?? 0} saved this week',
                                body:
                                    '${overview?.progress?.reviewedInPeriodCount ?? 0} reviewed',
                                icon: Icons.insights_rounded,
                                onTap: () => context.go(Routes.progress),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: PinneSpacing.sm),
                const TourAnchor(
                  target: TourTarget.saveLink,
                  child: CaptureEntryTile(),
                ),
                const SizedBox(height: PinneSpacing.md),
                const ExampleSavesCard(),
                if ((data?.entries.length ?? 0) > 1) ...[
                  const SizedBox(height: PinneSpacing.md),
                  Text(
                    '${data!.entries.length - 1} more fit this session. '
                    'Durations are estimates.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: context.pinne.muted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _review(BuildContext context, WidgetRef ref, Item item) async {
    try {
      final receipt = await ref.read(todayActionGatewayProvider).reviewed(item);
      if (!context.mounted) return;
      showPinneToast(
        context,
        'Counted as reviewed.',
        kind: ToastKind.success,
        actionLabel: 'Undo',
        onAction: () => unawaited(
          ref.read(todayActionGatewayProvider).undo(item, receipt.event.id!),
        ),
      );
      await ref
          .read(celebrationControllerProvider.notifier)
          .checkAfterReview(context);
    } on Object catch (error) {
      if (context.mounted) {
        showErrorToast(context, error, 'Could not count your review');
      }
    }
  }

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
    String success,
    String failure,
  ) async {
    try {
      await action();
      if (context.mounted) {
        showPinneToast(context, success, kind: ToastKind.success);
      }
    } on Object catch (error) {
      if (context.mounted) showErrorToast(context, error, failure);
    }
  }

  static String _greeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  static String _sessionLabel(SessionView? view, DateTime now) {
    if (view == null) return 'Find a calm pocket of time';
    final local = view.session.startAt.toLocal();
    final day = _sameDate(local, now)
        ? 'Today'
        : _weekdayNames[local.weekday - 1];
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day · ${local.hour}:$minute';
  }
}

class _TodayHeader extends StatelessWidget {
  const _TodayHeader({
    required this.seed,
    required this.palette,
    required this.greeting,
    required this.name,
    required this.onProfile,
    required this.onSearch,
  });

  final int seed;
  final int palette;
  final String greeting;
  final String name;
  final VoidCallback onProfile;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Semantics(
          button: true,
          label: 'Open profile',
          child: InkWell(
            key: const ValueKey('today-profile'),
            onTap: onProfile,
            customBorder: const CircleBorder(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.pinne.glass,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: RibbonSpirit(
                  seed: seed,
                  palette: palette,
                  size: 48,
                  animate: false,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: PinneSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: context.pinne.muted),
              ),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        IconButton.filled(
          key: const ValueKey('today-search'),
          tooltip: 'Search saved items',
          style: IconButton.styleFrom(
            backgroundColor: context.pinne.glass,
            foregroundColor: context.pinne.text,
            side: BorderSide(color: context.pinne.line),
          ),
          onPressed: onSearch,
          icon: const Icon(Icons.search_rounded),
        ),
      ],
    );
  }
}

class TodayHeadline extends StatelessWidget {
  const TodayHeadline({super.key, required this.count, required this.calmLine});

  final int count;
  final String calmLine;

  @override
  Widget build(BuildContext context) {
    final display = Theme.of(context).textTheme.displaySmall;
    final prefix =
        '${_countWord(count)} ${count == 1 ? 'thing' : 'things'} worth';
    return Semantics(
      header: true,
      child: count == 0
          ? Text(
              calmLine,
              key: const ValueKey('today-calm-headline'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: display,
            )
          : Text.rich(
              TextSpan(
                text: '$prefix\n',
                children: const [
                  TextSpan(
                    text: 'revisiting',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              key: const ValueKey('today-due-headline'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: display,
            ),
    );
  }

  static String _countWord(int count) => switch (count) {
    1 => 'One',
    2 => 'Two',
    3 => 'Three',
    4 => 'Four',
    5 => 'Five',
    _ => '$count',
  };
}

class _BudgetChoice extends ConsumerWidget {
  const _BudgetChoice({required this.selected});

  final int selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final light = Theme.of(context).brightness == Brightness.light;
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
              selectedColor: light ? context.pinne.selectionFill : null,
              labelStyle: light
                  ? TextStyle(
                      color: selected == minutes
                          ? context.pinne.selectionText
                          : context.pinne.text,
                    )
                  : null,
              onSelected: (_) =>
                  ref.read(reviewBudgetProvider.notifier).select(minutes),
              visualDensity: VisualDensity.compact,
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
    this.timeBudgetMinutes = 10,
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
  final int timeBudgetMinutes;
  final VoidCallback? onReviewed;
  final VoidCallback? onRemindLater;
  final VoidCallback? onArchive;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    if (!due || entry == null) {
      return _EmptyQueueCard(
        seed: seed,
        palette: palette,
        digestText: digestText,
      );
    }
    final item = entry!.item;
    final note = item.intention ?? item.noteText;
    final estimate = entry!.estimatedMinutes;
    final progress = (estimate / timeBudgetMinutes).clamp(0.08, 1.0);
    final card = Container(
      key: const ValueKey('today-due-hero'),
      width: double.infinity,
      padding: const EdgeInsets.all(PinneSpacing.lg),
      decoration: BoxDecoration(
        color: context.pinne.accentDue,
        borderRadius: BorderRadius.circular(PinneRadii.card),
        border: Theme.of(context).brightness == Brightness.light
            ? Border.all(color: context.pinne.dueEdge, width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'DUE NOW · $estimate MIN EST.',
                  style: TextStyle(
                    color: context.pinne.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              IconButton.filled(
                key: const ValueKey('review-open'),
                tooltip: 'Open saved item',
                style: IconButton.styleFrom(
                  backgroundColor: context.pinne.ink,
                  foregroundColor: context.pinne.accentDue,
                ),
                onPressed: onOpen,
                icon: const Icon(Icons.north_east_rounded),
              ),
            ],
          ),
          Wrap(
            spacing: PinneSpacing.xs,
            runSpacing: PinneSpacing.xs,
            children: [
              PreviewSourceChip(
                source: item.sourcePlatform,
                surface: PreviewChipSurface.due,
              ),
              if (item.durationSeconds case final seconds?)
                DurationChip(seconds: seconds, surface: PreviewChipSurface.due),
            ],
          ),
          if (item.isExample) ...[
            const SizedBox(height: PinneSpacing.xs),
            const ExampleChip(dark: true),
          ],
          const SizedBox(height: PinneSpacing.sm),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: context.pinne.ink,
              fontWeight: FontWeight.w600,
              height: 1.08,
            ),
          ),
          if (note?.trim().isNotEmpty == true) ...[
            const SizedBox(height: PinneSpacing.sm),
            Text(
              note!.trim(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.pinne.ink, height: 1.35),
            ),
          ],
          const SizedBox(height: PinneSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(PinneRadii.chip),
            child: LinearProgressIndicator(
              key: const ValueKey('today-budget-progress'),
              value: progress,
              minHeight: 6,
              color: context.pinne.ink,
              backgroundColor: context.pinne.ink.withValues(alpha: 0.16),
            ),
          ),
          const SizedBox(height: PinneSpacing.md),
          Wrap(
            spacing: PinneSpacing.sm,
            runSpacing: PinneSpacing.xs,
            children: [
              FilledButton.icon(
                key: const ValueKey('review-reviewed'),
                style: FilledButton.styleFrom(
                  backgroundColor: context.pinne.ink,
                  foregroundColor: context.pinne.onViolet,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: onReviewed,
                icon: const Icon(Icons.check_rounded, size: 17),
                label: const Text('Reviewed'),
              ),
              OutlinedButton(
                key: const ValueKey('review-remind'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.pinne.ink,
                  side: BorderSide(color: context.pinne.ink),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: onRemindLater,
                child: const Text('Remind me later'),
              ),
              TextButton(
                key: const ValueKey('review-archive'),
                style: TextButton.styleFrom(
                  foregroundColor: context.pinne.ink,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: onArchive,
                child: const Text('Archive'),
              ),
            ],
          ),
        ],
      ),
    );

    if (!animate || reduceMotionOf(context)) return card;
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

class _EmptyQueueCard extends StatelessWidget {
  const _EmptyQueueCard({
    required this.seed,
    required this.palette,
    this.digestText,
  });

  final int seed;
  final int palette;
  final String? digestText;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('today-empty-hero'),
      padding: const EdgeInsets.fromLTRB(20, 18, 112, 20),
      constraints: const BoxConstraints(minHeight: 154),
      decoration: BoxDecoration(
        color: context.pinne.lilacTile,
        borderRadius: BorderRadius.circular(PinneRadii.card),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ALL QUIET',
                style: TextStyle(
                  color: context.pinne.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: PinneSpacing.sm),
              Text(
                'Room for a new thought',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: context.pinne.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: PinneSpacing.xs),
              Text(
                digestText?.trim().isNotEmpty == true
                    ? digestText!
                    : 'Nothing is due. Your spirit is resting.',
                style: TextStyle(
                  color: context.pinne.ink.withValues(alpha: 0.76),
                  height: 1.35,
                ),
              ),
            ],
          ),
          Positioned(
            right: -104,
            top: 2,
            child: RibbonSpirit(
              seed: seed,
              palette: palette,
              size: 108,
              animate: false,
              mood: RibbonMood.sleepy,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.now, required this.reviewedDates});

  final DateTime now;
  final Set<String> reviewedDates;

  @override
  Widget build(BuildContext context) {
    final local = DateTime(now.year, now.month, now.day);
    final monday = local.subtract(Duration(days: local.weekday - 1));
    return Semantics(
      label: 'This week. Dots mark days with reviews.',
      child: Row(
        children: [
          for (var i = 0; i < 7; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: _DayChip(
                day: monday.add(Duration(days: i)),
                today: _sameDate(monday.add(Duration(days: i)), local),
                reviewed: reviewedDates.contains(
                  _dateKey(monday.add(Duration(days: i))),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.today,
    required this.reviewed,
  });

  final DateTime day;
  final bool today;
  final bool reviewed;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final foreground = today
        ? light
              ? context.pinne.onViolet
              : context.pinne.ink
        : context.pinne.text;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: today
            ? light
                  ? context.pinne.ink
                  : Colors.white
            : context.pinne.glass,
        borderRadius: BorderRadius.circular(PinneRadii.chip),
        border: Border.all(color: context.pinne.line),
      ),
      child: Column(
        children: [
          Text(
            _weekdayNames[day.weekday - 1].substring(0, 1),
            style: TextStyle(color: foreground, fontSize: 10),
          ),
          Text(
            '${day.day}',
            style: TextStyle(
              color: foreground,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 4,
            child: reviewed
                ? Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: foreground,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class _PastelActionTile extends StatelessWidget {
  const _PastelActionTile({
    required this.color,
    required this.tag,
    required this.title,
    required this.body,
    required this.icon,
    required this.onTap,
  });

  final Color color;
  final String tag;
  final String title;
  final String body;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(PinneRadii.tile),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          // Grows with large text so the title and body never clip.
          height: 126 * MediaQuery.textScalerOf(context).scale(1).clamp(1, 1.6),
          child: Padding(
            padding: const EdgeInsets.all(PinneSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: context.pinne.ink.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(PinneRadii.chip),
                        ),
                        child: Text(
                          tag,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: context.pinne.ink,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: PinneSpacing.xs),
                    Icon(icon, color: context.pinne.ink, size: 18),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: context.pinne.ink,
                    fontWeight: FontWeight.w700,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.pinne.ink,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroLoading extends StatelessWidget {
  const _HeroLoading();

  @override
  Widget build(BuildContext context) =>
      const PinneCardSkeleton(height: 148, label: 'Loading your next review');
}

const _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

bool _sameDate(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
