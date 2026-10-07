import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../theme/pinne_tokens.dart';
import 'planner_providers.dart';

Future<void> showPlannerSettings(
  BuildContext context,
  PlannerPreferences preferences,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: PinneColors.card,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(PinneRadii.sheet)),
  ),
  builder: (context) => PlannerSettingsSheet(preferences: preferences),
);

/// When review sessions may go: horizon, days, daily window, length, how
/// many, buffers, lead time and whether plans need the user's acceptance.
class PlannerSettingsSheet extends ConsumerStatefulWidget {
  const PlannerSettingsSheet({super.key, required this.preferences});

  final PlannerPreferences preferences;

  @override
  ConsumerState<PlannerSettingsSheet> createState() =>
      _PlannerSettingsSheetState();
}

class _PlannerSettingsSheetState extends ConsumerState<PlannerSettingsSheet> {
  late PlannerPreferences _p = widget.preferences;

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String _clock(int minute) {
    if (minute >= 24 * 60) return '24:00';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(minute ~/ 60)}:${two(minute % 60)}';
  }

  Future<void> _pickMinute(bool start) async {
    final current = start ? _p.windowStartMinute : _p.windowEndMinute;
    final picked = await showTimePicker(
      context: context,
      helpText: start ? 'Earliest start' : 'Latest end',
      initialTime: TimeOfDay(hour: (current ~/ 60) % 24, minute: current % 60),
    );
    if (picked == null) return;
    final minute = picked.hour * 60 + picked.minute;
    setState(
      () => _p = start
          ? _p.copyWith(windowStartMinute: minute)
          : _p.copyWith(windowEndMinute: minute == 0 ? 24 * 60 : minute),
    );
  }

  Widget _choice<T>({
    required String label,
    required T value,
    required List<(T, String)> options,
    required ValueChanged<T> onChanged,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: PinneSpacing.sm),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        DropdownButton<T>(
          value: value,
          dropdownColor: PinneColors.cardRaised,
          underline: const SizedBox.shrink(),
          items: [
            for (final (v, text) in options)
              DropdownMenuItem(value: v, child: Text(text)),
          ],
          onChanged: (v) => v == null ? null : onChanged(v),
        ),
      ],
    ),
  );

  List<(int, String)> _withCurrent(List<(int, String)> options, int current) =>
      options.any((o) => o.$1 == current)
      ? options
      : [...options, (current, '$current')];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          PinneSpacing.gutter,
          PinneSpacing.lg,
          PinneSpacing.gutter,
          MediaQuery.viewInsetsOf(context).bottom + PinneSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Planner settings',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: PinneSpacing.md),
              SegmentedButton<PlanHorizon>(
                segments: const [
                  ButtonSegment(value: PlanHorizon.week, label: Text('Week')),
                  ButtonSegment(value: PlanHorizon.month, label: Text('Month')),
                ],
                selected: {_p.horizon},
                onSelectionChanged: (s) =>
                    setState(() => _p = _p.copyWith(horizon: s.single)),
              ),
              const SizedBox(height: PinneSpacing.md),
              const Text('Days'),
              const SizedBox(height: PinneSpacing.xs),
              Wrap(
                spacing: PinneSpacing.xs,
                runSpacing: PinneSpacing.xs,
                children: [
                  for (var d = 1; d <= 7; d++)
                    FilterChip(
                      label: Text(_days[d - 1].substring(0, 3)),
                      tooltip: _days[d - 1],
                      selected: _p.weekdays.contains(d),
                      onSelected: (on) => setState(() {
                        final days = {..._p.weekdays};
                        on ? days.add(d) : days.remove(d);
                        _p = _p.copyWith(weekdays: days.toList()..sort());
                      }),
                    ),
                ],
              ),
              const SizedBox(height: PinneSpacing.md),
              Row(
                children: [
                  const Expanded(child: Text('Between')),
                  TextButton(
                    onPressed: () => _pickMinute(true),
                    child: Text(_clock(_p.windowStartMinute)),
                  ),
                  const Text('and'),
                  TextButton(
                    onPressed: () => _pickMinute(false),
                    child: Text(_clock(_p.windowEndMinute)),
                  ),
                ],
              ),
              _choice(
                label: 'Session length',
                value: _p.sessionMinutes,
                options: _withCurrent([
                  for (final m in [10, 15, 20, 30, 45, 60]) (m, '$m min'),
                ], _p.sessionMinutes),
                onChanged: (v) =>
                    setState(() => _p = _p.copyWith(sessionMinutes: v)),
              ),
              _choice(
                label: 'Most sessions per plan',
                value: _p.maxSessions,
                options: _withCurrent([
                  for (final n in [1, 2, 3, 4, 5, 7, 10, 14]) (n, '$n'),
                ], _p.maxSessions),
                onChanged: (v) =>
                    setState(() => _p = _p.copyWith(maxSessions: v)),
              ),
              _choice(
                label: 'Free time around events',
                value: _p.bufferMinutes,
                options: _withCurrent([
                  for (final m in [0, 5, 10, 15, 30]) (m, '$m min'),
                ], _p.bufferMinutes),
                onChanged: (v) =>
                    setState(() => _p = _p.copyWith(bufferMinutes: v)),
              ),
              _choice(
                label: 'Earliest start from now',
                value: _p.minLeadMinutes,
                options: _withCurrent(const [
                  (0, 'Any time'),
                  (30, '30 min'),
                  (60, '1 hour'),
                  (180, '3 hours'),
                  (1440, '1 day'),
                ], _p.minLeadMinutes),
                onChanged: (v) =>
                    setState(() => _p = _p.copyWith(minLeadMinutes: v)),
              ),
              const SizedBox(height: PinneSpacing.sm),
              const Text('Plans'),
              RadioGroup<ApprovalMode>(
                groupValue: _p.approvalMode,
                onChanged: (v) => v == null
                    ? null
                    : setState(() => _p = _p.copyWith(approvalMode: v)),
                child: const Column(
                  children: [
                    RadioListTile(
                      value: ApprovalMode.confirm,
                      title: Text('Ask me to accept'),
                      subtitle: Text(
                        'Pinne checks your calendar again before adding.',
                      ),
                    ),
                    RadioListTile(
                      value: ApprovalMode.proposeOnly,
                      title: Text('Only suggest times'),
                      subtitle: Text('Nothing is scheduled or added.'),
                    ),
                  ],
                ),
              ),
              Text(
                'Times are in ${_p.timezone}.',
                style: const TextStyle(color: PinneColors.muted, fontSize: 13),
              ),
              const SizedBox(height: PinneSpacing.md),
              FilledButton(
                onPressed: () async {
                  await ref
                      .read(plannerProvider.notifier)
                      .savePreferences(
                        PlannerPreferencesDraft(
                          horizon: _p.horizon,
                          weekdays: _p.weekdays,
                          windowStartMinute: _p.windowStartMinute,
                          windowEndMinute: _p.windowEndMinute,
                          sessionMinutes: _p.sessionMinutes,
                          maxSessions: _p.maxSessions,
                          bufferMinutes: _p.bufferMinutes,
                          minLeadMinutes: _p.minLeadMinutes,
                          timezone: _p.timezone,
                          approvalMode: _p.approvalMode,
                        ),
                      );
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
