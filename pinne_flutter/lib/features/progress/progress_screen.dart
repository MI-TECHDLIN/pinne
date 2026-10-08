import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import '../settings/profile_provider.dart';
import 'celebration.dart';
import 'progress_card_stack.dart';
import 'progress_providers.dart';
import 'progress_widgets.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(progressReportProvider, (_, next) {
      final report = next.asData?.value;
      if (report == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only the tab on screen celebrates; an offstage tab stays quiet.
        if (!mounted || !TickerMode.valuesOf(context).enabled) return;
        if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
        ref
            .read(celebrationControllerProvider.notifier)
            .celebrate(context, report.milestones);
      });
    }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    final period = ref.watch(progressPeriodProvider);
    final report = ref.watch(progressReportProvider);
    final value = report.value;
    final Widget body;
    if (report.hasError && !report.isLoading) {
      body = _ProgressError(
        onRetry: () => ref.invalidate(progressReportProvider),
      );
    } else if (!report.hasValue) {
      body = const GlassCard(
        child: SizedBox(
          height: 160,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    } else if (value == null) {
      body = const ProgressEmptyState(signedOut: true);
    } else if (value.savedCount == 0 && value.reviewedInPeriodCount == 0) {
      body = ProgressEmptyState(
        firstTime: value.totalReviewedCount == 0,
        period: value.period,
      );
    } else {
      body = AnimatedOpacity(
        opacity: value.period == period ? 1 : 0.5,
        duration: const Duration(milliseconds: 160),
        child: ProgressBody(
          report: value,
          onEditGoal: () => showGoalSettings(context),
        ),
      );
    }
    return PinnePage(
      headline: 'Honest',
      headlineBold: 'progress',
      subtitle: 'What you saved, and what you came back to.',
      children: [
        PeriodPicker(
          selected: period,
          onSelected: ref.read(progressPeriodProvider.notifier).select,
        ),
        SizedBox(
          height: PinneSpacing.lg,
          child: report.isLoading && report.hasValue
              ? const Center(child: LinearProgressIndicator(minHeight: 2))
              : null,
        ),
        body,
      ],
    );
  }
}

class PeriodPicker extends StatelessWidget {
  const PeriodPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final ProgressPeriod selected;
  final ValueChanged<ProgressPeriod> onSelected;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Progress period',
    child: Wrap(
      spacing: PinneSpacing.sm,
      runSpacing: PinneSpacing.sm,
      children: [
        for (final (period, label) in const [
          (ProgressPeriod.thisWeek, 'This week'),
          (ProgressPeriod.lastWeek, 'Last week'),
          (ProgressPeriod.thisMonth, 'This month'),
        ])
          ChoiceChip(
            key: ValueKey('period-${period.name}'),
            label: Text(label),
            selected: selected == period,
            onSelected: (_) => onSelected(period),
          ),
      ],
    ),
  );
}

/// The full report: card deck, stat pills, rate trend, goal, collections and
/// review days.
class ProgressBody extends ConsumerWidget {
  const ProgressBody({super.key, required this.report, this.onEditGoal});

  final ProgressReport report;
  final VoidCallback? onEditGoal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarRecipeProvider);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProgressCardStack(
          cards: progressCards(report),
          spiritCardId: 'reviewed',
          spirit: RibbonSpirit(
            seed: avatar.seed,
            palette: avatar.palette,
            size: 90,
            mood: report.reviewedInPeriodCount > 0
                ? RibbonMood.happy
                : RibbonMood.idle,
          ),
        ),
        const SizedBox(height: PinneSpacing.xl),
        Text(
          'Saved ${periodPhrase(report.period)}, and where they stand',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: PinneSpacing.md),
        ProgressStatPills(report: report),
        const SizedBox(height: PinneSpacing.md),
        ReviewRateCard(report: report),
        const SizedBox(height: PinneSpacing.md),
        WeeklyGoalCard(
          goal: report.weeklyGoal,
          streakDays: report.currentStreakDays,
          onEdit: onEditGoal,
        ),
        if (report.collections.isNotEmpty) ...[
          const SizedBox(height: PinneSpacing.xl),
          Text('By collection', style: theme.textTheme.titleMedium),
          const SizedBox(height: PinneSpacing.md),
          for (final collection in report.collections) ...[
            CollectionProgressBar(progress: collection),
            const SizedBox(height: PinneSpacing.sm),
          ],
        ],
        const SizedBox(height: PinneSpacing.md),
        ReviewDaysChart(report: report),
      ],
    );
  }
}

/// The hero cards for a report, only with numbers the report really has.
List<ProgressCardData> progressCards(ProgressReport report) {
  final phrase = periodPhrase(report.period);
  final goal = report.weeklyGoal;
  String saves(int n) => n == 1 ? 'save' : 'saves';
  return [
    ProgressCardData(
      id: 'reviewed',
      label: 'Reviewed $phrase',
      icon: Icons.check_circle_rounded,
      value: report.reviewedInPeriodCount,
      unit: saves(report.reviewedInPeriodCount),
      caption: report.firstReviewedTodayCount > 0
          ? '${report.firstReviewedTodayCount} first looked at today. '
                'Each save counts once.'
          : 'Each save counts once, however often you return.',
      background: PinneColors.violet,
      foreground: PinneColors.text,
    ),
    ProgressCardData(
      id: 'saved',
      label: 'Saved $phrase',
      icon: Icons.bookmark_rounded,
      value: report.savedCount,
      unit: saves(report.savedCount),
      caption: report.reviewRate == null
          ? 'Nothing saved $phrase yet. Share a link to Pinne any time.'
          : '${percentLabel(report.reviewRate)} of them revisited so far.',
      background: PinneColors.peach,
      foreground: PinneColors.ink,
    ),
    ProgressCardData(
      id: 'remaining',
      label: 'Still to revisit',
      icon: Icons.auto_stories_rounded,
      value: report.remainingCount,
      unit: saves(report.remainingCount),
      caption: report.remainingCount == 0
          ? (report.savedCount == 0
                ? 'Nothing waiting from $phrase.'
                : 'Every save from $phrase has had a look.')
          : 'Ready whenever you are.',
      background: PinneColors.mint,
      foreground: PinneColors.ink,
    ),
    ProgressCardData(
      id: 'days',
      label: 'Review days this week',
      icon: Icons.calendar_today_rounded,
      value: goal.reviewDayCount,
      unit: 'of ${goal.goalDays}',
      caption: goal.reached
          ? 'Weekly goal reached.'
          : 'Any day with a review counts.',
      background: PinneColors.cardRaised,
      foreground: PinneColors.text,
      dayBars: [
        for (final day in goal.days)
          day.isFuture ? null : day.reviewedCount > 0,
      ],
      dayLetters: [for (final day in goal.days) weekdayLetter(day.date)],
    ),
    if (report.appliedCount > 0)
      ProgressCardData(
        id: 'applied',
        label: 'Put to use',
        icon: Icons.bolt_rounded,
        value: report.appliedCount,
        unit: saves(report.appliedCount),
        caption: 'Saves from $phrase you applied.',
        background: PinneColors.pink,
        foreground: PinneColors.ink,
      ),
    if (report.currentStreakDays case final streak? when streak > 0)
      ProgressCardData(
        id: 'streak',
        label: 'Daily streak',
        icon: Icons.local_fire_department_rounded,
        value: streak,
        unit: streak == 1 ? 'day' : 'days',
        caption: 'In a row, counting today once you review.',
        background: PinneColors.sky,
        foreground: PinneColors.ink,
      ),
  ];
}

/// Early and empty states: honest, encouraging and number-free.
class ProgressEmptyState extends ConsumerWidget {
  const ProgressEmptyState({
    super.key,
    this.signedOut = false,
    this.firstTime = true,
    this.period = ProgressPeriod.thisWeek,
  });

  final bool signedOut;
  final bool firstTime;
  final ProgressPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarRecipeProvider);
    final theme = Theme.of(context);
    final (title, body) = signedOut
        ? (
            'Your progress lives with your account',
            'Sign in from Settings and your reviews will gather here.',
          )
        : firstTime
        ? (
            'Save something, then come back to it here',
            'Each save you revisit shows up as a real number. '
                'Opens never count, so every number here is honest.',
          )
        : (
            'Quiet ${periodPhrase(period)}',
            'Nothing saved or reviewed ${periodPhrase(period)}. '
                'Try another period, or save something new.',
          );
    return Stack(
      key: const ValueKey('progress-empty'),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 64),
          child: GlassCard(
            padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: PinneSpacing.sm),
                Text(
                  body,
                  style: const TextStyle(color: PinneColors.muted, height: 1.5),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: 0,
          child: RibbonSpirit(
            seed: avatar.seed,
            palette: avatar.palette,
            size: 128,
            mood: RibbonMood.sleepy,
          ),
        ),
      ],
    );
  }
}

class _ProgressError extends StatelessWidget {
  const _ProgressError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your progress is taking a moment.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: PinneSpacing.sm),
        const Text('Nothing is lost. Try again when you’re ready.'),
        const SizedBox(height: PinneSpacing.md),
        FilledButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    ),
  );
}

Future<void> showGoalSettings(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: PinneColors.midnightRaised,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(PinneRadii.sheet),
        ),
      ),
      builder: (context) => const GoalSettingsSheet(),
    );

/// The weekly goal and the opt-in daily streak.
class GoalSettingsSheet extends ConsumerStatefulWidget {
  const GoalSettingsSheet({super.key});

  @override
  ConsumerState<GoalSettingsSheet> createState() => _GoalSettingsSheetState();
}

class _GoalSettingsSheetState extends ConsumerState<GoalSettingsSheet> {
  int? _goal;
  bool? _streak;
  bool _saving = false;
  String? _error;

  Future<void> _save(ProgressSettings current) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(progressApiProvider)
          .updateSettings(
            ProgressSettingsDraft(
              streakEnabled: _streak ?? current.streakEnabled,
              weeklyGoalDays: _goal ?? current.weeklyGoalDays,
            ),
          );
      ref
        ..invalidate(progressSettingsProvider)
        ..invalidate(progressReportProvider);
      if (mounted) Navigator.of(context).pop();
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not save. Your goal is unchanged.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = ref.watch(progressSettingsProvider);
    final current = settings.value;
    if (current == null) {
      return SizedBox(
        height: 180,
        child: Center(
          child: settings.hasError || !settings.isLoading
              ? const Text('Sign in to set a weekly goal.')
              : const CircularProgressIndicator(),
        ),
      );
    }
    final goal = _goal ?? current.weeklyGoalDays;
    final streak = _streak ?? current.streakEnabled;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weekly goal', style: theme.textTheme.titleLarge),
            const SizedBox(height: PinneSpacing.xs),
            const Text(
              'Days a week with at least one review. Missing a day never '
              'takes anything away.',
              style: TextStyle(color: PinneColors.muted),
            ),
            const SizedBox(height: PinneSpacing.md),
            Row(
              children: [
                IconButton.filledTonal(
                  key: const ValueKey('goal-minus'),
                  tooltip: 'Fewer days',
                  onPressed: goal > 1
                      ? () => setState(() => _goal = goal - 1)
                      : null,
                  icon: const Icon(Icons.remove_rounded),
                ),
                Expanded(
                  child: Text(
                    goal == 1 ? '1 day' : '$goal days',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                IconButton.filledTonal(
                  key: const ValueKey('goal-plus'),
                  tooltip: 'More days',
                  onPressed: goal < 7
                      ? () => setState(() => _goal = goal + 1)
                      : null,
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            const SizedBox(height: PinneSpacing.md),
            SwitchListTile(
              key: const ValueKey('streak-switch'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Show a daily streak'),
              subtitle: const Text('Off unless you want it.'),
              value: streak,
              onChanged: (value) => setState(() => _streak = value),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: PinneSpacing.sm),
                child: Text(
                  _error!,
                  style: const TextStyle(color: PinneColors.pink),
                ),
              ),
            const SizedBox(height: PinneSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const ValueKey('goal-save'),
                onPressed: _saving ? null : () => _save(current),
                child: Text(_saving ? 'Saving…' : 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
