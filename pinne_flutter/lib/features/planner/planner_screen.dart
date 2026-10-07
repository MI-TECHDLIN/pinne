import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_calendar/pinne_calendar.dart' show LocalDate;
import 'package:pinne_client/pinne_client.dart';

import '../../core/server_client.dart';
import '../../router.dart';
import '../../shell/pinne_page.dart';
import '../../theme/pinne_theme.dart';
import '../../theme/pinne_tokens.dart';
import 'month_calendar.dart';
import 'planner_format.dart';
import 'planner_providers.dart';
import 'planner_settings_sheet.dart';
import 'session_card.dart';

/// Plans short review sessions in free time and shows what was checked.
class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final back = IconButton(
      tooltip: 'Back',
      onPressed: () => context.canPop() ? context.pop() : context.go('/'),
      icon: const Icon(Icons.arrow_back),
    );
    if (!ref.watch(signedInProvider)) {
      return PinnePage(
        leading: back,
        headline: 'Review',
        headlineBold: 'schedule',
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sign in to plan review time.'),
                const SizedBox(height: PinneSpacing.md),
                FilledButton(
                  onPressed: () => context.push(Routes.signIn),
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ),
        ],
      );
    }
    final planner = ref.watch(plannerProvider);
    return PinnePage(
      leading: back,
      headline: 'Review',
      headlineBold: 'schedule',
      subtitle: 'Short sessions placed in your free time.',
      children: switch (planner) {
        AsyncData(:final value) => [_PlannerBody(state: value)],
        AsyncError() => [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Could not load your planner.'),
                TextButton(
                  onPressed: () => ref.invalidate(plannerProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ],
        _ => [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(PinneSpacing.xl),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      },
    );
  }
}

class _PlannerBody extends ConsumerStatefulWidget {
  const _PlannerBody({required this.state});

  final PlannerState state;

  @override
  ConsumerState<_PlannerBody> createState() => _PlannerBodyState();
}

class _PlannerBodyState extends ConsumerState<_PlannerBody> {
  LocalDate? _selected;
  bool _working = false;

  PlannerController get _controller => ref.read(plannerProvider.notifier);

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _working = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final zone = state.timezone;
    final now = DateTime.now();
    final today = LocalDate.inZone(now, zone);
    final selected = _selected ?? today;
    final proposal = state.proposal;
    final proposed = proposal?.sessions ?? const <SessionView>[];
    final all = [...state.sessions, ...proposed];
    final onDay = [
      for (final view in all)
        if (LocalDate.inZone(view.session.startAt, zone) == selected) view,
    ];
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                onPressed: () => context.push(Routes.calendarConnections),
                icon: const Icon(Icons.event_available_outlined, size: 18),
                label: Text(
                  state.writeCalendar == null
                      ? 'Calendar connections'
                      : 'Sessions go to ${state.writeCalendar!.name}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Planner settings',
              onPressed: () => showPlannerSettings(context, state.preferences),
              icon: const Icon(Icons.tune),
            ),
          ],
        ),
        MonthCalendar(
          zone: zone,
          today: today,
          selected: selected,
          sessions: all,
          onSelect: (day) => setState(() => _selected = day),
        ),
        const SizedBox(height: PinneSpacing.sm),
        _CoverageLine(state: state),
        if (state.notice case final notice?) ...[
          const SizedBox(height: PinneSpacing.md),
          _Notice(text: notice, onClose: _controller.clearNotice),
        ],
        const SizedBox(height: PinneSpacing.lg),
        Text(longDate(selected), style: theme.textTheme.titleMedium),
        const SizedBox(height: PinneSpacing.sm),
        if (onDay.isEmpty)
          Text(
            'Nothing planned this day.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: PinneColors.muted,
            ),
          ),
        for (final (index, view) in onDay.indexed) ...[
          AnimatedEntry(
            index: index,
            child: SessionCard(
              view: view,
              zone: zone,
              onMove: view.session.status == SessionStatus.scheduled
                  ? () => _pickNewTime(view)
                  : null,
              onCancel: view.session.status == SessionStatus.scheduled
                  ? () => _run(() => _controller.cancel(view))
                  : null,
              onExport: () => _run(() => _controller.exportIcs([view])),
            ),
          ),
          const SizedBox(height: PinneSpacing.md),
        ],
        const SizedBox(height: PinneSpacing.md),
        if (proposal != null)
          _ProposalPanel(
            proposal: proposal,
            working: _working,
            onAccept: () => _run(_controller.accept),
            onKeepUnverified: () =>
                _run(() => _controller.accept(unverified: true)),
            onReplan: () => _run(_controller.propose),
            onExport: () => _run(() => _controller.exportIcs(proposed)),
          )
        else
          _PlanPanel(
            state: state,
            working: _working,
            onPlan: () => _run(_controller.propose),
            onExportAll: state.sessions.isEmpty
                ? null
                : () => _run(() => _controller.exportIcs(state.sessions)),
          ),
      ],
    );
  }

  Future<void> _pickNewTime(SessionView view) async {
    final zone = widget.state.timezone;
    final current = LocalDate.inZone(view.session.startAt, zone);
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(current.year, current.month, current.day),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 62)),
      helpText: 'Move session to',
    );
    if (date == null || !mounted) return;
    final [hour, minute] = clockTime(
      view.session.startAt,
      zone,
    ).split(':').map(int.parse).toList();
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );
    if (time == null) return;
    final start = LocalDate(
      date.year,
      date.month,
      date.day,
    ).at(zone, time.hour * 60 + time.minute);
    await _run(() => _controller.move(view, start));
  }
}

class _CoverageLine extends StatelessWidget {
  const _CoverageLine({required this.state});

  final PlannerState state;

  @override
  Widget build(BuildContext context) {
    final proposal = state.proposal;
    final now = DateTime.now().toUtc();
    final String text;
    final bool ok;
    if (proposal != null) {
      ok = proposal.plan.availabilityVerified;
      text = coverageLine(
        coverage: proposal.plan.coverage,
        verified: ok,
        now: now,
      );
    } else if (state.conflictCalendars.isEmpty) {
      ok = false;
      text = 'Not checked: no calendar is chosen for busy times.';
    } else if (state.lastCheckedAt case final checked?) {
      ok = true;
      text = 'Last read your calendars ${checkedAgo(checked, now)}.';
    } else {
      ok = false;
      text = 'Your calendars have not been read yet.';
    }
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            ok ? Icons.verified_outlined : Icons.help_outline,
            size: 16,
            color: PinneColors.muted,
          ),
          const SizedBox(width: PinneSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: PinneColors.muted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text, required this.onClose});

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18, color: PinneColors.lilac),
          const SizedBox(width: PinneSpacing.sm),
          Expanded(child: Semantics(liveRegion: true, child: Text(text))),
          IconButton(
            tooltip: 'Dismiss',
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
    );
  }
}

/// No proposal yet: the one primary action is to plan.
class _PlanPanel extends StatelessWidget {
  const _PlanPanel({
    required this.state,
    required this.working,
    required this.onPlan,
    required this.onExportAll,
  });

  final PlannerState state;
  final bool working;
  final VoidCallback onPlan;
  final VoidCallback? onExportAll;

  @override
  Widget build(BuildContext context) {
    final month = state.preferences.horizon == PlanHorizon.month;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          style: pinnePrimaryActionStyle(),
          onPressed: working ? null : onPlan,
          child: Text(month ? 'Plan my month' : 'Plan my week'),
        ),
        if (onExportAll != null)
          TextButton.icon(
            onPressed: working ? null : onExportAll,
            icon: const Icon(Icons.ios_share, size: 18),
            label: const Text('Export sessions as .ics (export only)'),
          ),
      ],
    );
  }
}

/// A proposal: accept is the one primary action when it is allowed.
class _ProposalPanel extends StatelessWidget {
  const _ProposalPanel({
    required this.proposal,
    required this.working,
    required this.onAccept,
    required this.onKeepUnverified,
    required this.onReplan,
    required this.onExport,
  });

  final PlanProposal proposal;
  final bool working;
  final VoidCallback onAccept;
  final VoidCallback onKeepUnverified;
  final VoidCallback onReplan;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = proposal.sessions.length;
    final destination = proposal.writeCalendarName;
    final suggestOnly = proposal.approvalMode == ApprovalMode.proposeOnly;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            count == 0
                ? 'No sessions fit'
                : count == 1
                ? '1 session proposed'
                : '$count sessions proposed',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: PinneSpacing.xs),
          Text(
            [
              ?proposal.shortfall,
              if (count > 0 && proposal.canCommit)
                destination == null
                    ? 'Accepting keeps them in Pinne. Choose a calendar in '
                          'Calendar connections to add them there too.'
                    : 'Accepting checks your calendar again, then adds them '
                          'to $destination.',
              if (!proposal.canCommit && count > 0)
                ?proposal.commitBlockedReason,
            ].join(' '),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: PinneColors.muted,
            ),
          ),
          const SizedBox(height: PinneSpacing.md),
          if (proposal.canCommit)
            FilledButton(
              style: pinnePrimaryActionStyle(),
              onPressed: working ? null : onAccept,
              child: const Text('Accept plan'),
            )
          else if (count > 0 && !suggestOnly)
            OutlinedButton(
              onPressed: working ? null : onKeepUnverified,
              child: const Text('Keep in Pinne without checking'),
            ),
          const SizedBox(height: PinneSpacing.xs),
          Wrap(
            spacing: PinneSpacing.sm,
            children: [
              TextButton(
                onPressed: working ? null : onReplan,
                child: const Text('Plan again'),
              ),
              if (count > 0)
                TextButton(
                  onPressed: working ? null : onExport,
                  child: const Text('Export .ics (export only)'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
