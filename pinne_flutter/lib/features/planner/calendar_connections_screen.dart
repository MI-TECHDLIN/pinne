import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import 'device_calendar_adapter.dart';
import 'planner_format.dart';
import 'planner_providers.dart';

/// Routes, permission state, freshness, and which calendars are checked for
/// conflicts and which one takes sessions.
class CalendarConnectionsScreen extends ConsumerWidget {
  const CalendarConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planner = ref.watch(plannerProvider);
    return PinnePage(
      leading: IconButton(
        tooltip: 'Back',
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back),
      ),
      headline: 'Calendar',
      headlineBold: 'connections',
      subtitle:
          'Pinne reads only busy times from the calendars you check, and '
          'writes only the review sessions it creates.',
      children: switch (planner) {
        AsyncData(:final value) => [
          if (value.notice case final notice?) ...[
            GlassCard(child: Semantics(liveRegion: true, child: Text(notice))),
            const SizedBox(height: PinneSpacing.md),
          ],
          _PhoneCard(state: value),
          const SizedBox(height: PinneSpacing.md),
          for (final route in value.routes)
            if (route.route != CalendarRoute.androidDevice) ...[
              _RouteCard(route: route),
              const SizedBox(height: PinneSpacing.md),
            ],
        ],
        AsyncError() => [
          const GlassCard(child: Text('Could not load your calendars.')),
        ],
        _ => [const Center(child: CircularProgressIndicator())],
      },
    );
  }
}

class _PhoneCard extends ConsumerWidget {
  const _PhoneCard({required this.state});

  final PlannerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.read(plannerProvider.notifier);
    final phone = state.phone;
    final access = state.access;
    final checked = phone?.connection.lastCheckedAt;

    final String status;
    if (!state.deviceSupported) {
      status = 'Not available on this device. Use the Android app.';
    } else {
      status = switch (access) {
        DeviceCalendarAccess.granted => 'Access allowed',
        DeviceCalendarAccess.writeOnly =>
          'Add-only access: Pinne cannot see when you are busy',
        DeviceCalendarAccess.denied => 'Access not given',
        DeviceCalendarAccess.restricted => 'Access blocked on this phone',
        DeviceCalendarAccess.notAsked => 'Not connected yet',
      };
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.phone_android, color: PinneColors.lilac),
              const SizedBox(width: PinneSpacing.sm),
              Expanded(
                child: Text(
                  'Calendars on this phone',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: PinneSpacing.xs),
          Text(status, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            checked == null
                ? 'Busy times have not been read yet.'
                : 'Calendars last read ${checkedAgo(checked, DateTime.now())}. '
                      'Busy times are only as fresh as the last read.',
            style: const TextStyle(color: PinneColors.muted, fontSize: 13),
          ),
          if (state.deviceSupported &&
              access != DeviceCalendarAccess.granted) ...[
            const SizedBox(height: PinneSpacing.md),
            FilledButton(
              onPressed: controller.connectPhone,
              child: const Text('Allow calendar access'),
            ),
          ],
          if (phone != null && access == DeviceCalendarAccess.granted) ...[
            const SizedBox(height: PinneSpacing.md),
            if (phone.selections.isEmpty)
              const Text('No calendars were found on this phone.'),
            for (final selection in phone.selections)
              _CalendarRow(
                selection: selection,
                onChanged: (conflicts, writes) => controller.setChoices(
                  phone.connection.id!,
                  [
                    for (final s in phone.selections)
                      CalendarSelectionChoice(
                        selectionId: s.id!,
                        useForConflicts: s.id == selection.id
                            ? conflicts
                            : s.useForConflicts,
                        useForWrites: s.id == selection.id
                            ? writes
                            : (writes ? false : s.useForWrites),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: PinneSpacing.xs),
            Text(
              state.writeCalendar == null
                  ? 'No calendar takes sessions yet. Accepted sessions stay '
                        'in Pinne until you choose one.'
                  : 'Sessions are added to ${state.writeCalendar!.name}.',
              style: const TextStyle(color: PinneColors.muted, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

class _CalendarRow extends StatelessWidget {
  const _CalendarRow({required this.selection, required this.onChanged});

  final CalendarSelection selection;
  final void Function(bool conflicts, bool writes) onChanged;

  @override
  Widget build(BuildContext context) {
    final account = selection.accountName;
    // The tiles paint their splashes on this Material, above the glass card.
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.only(bottom: PinneSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selection.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (account != null && account != selection.name)
              Text(
                account,
                style: const TextStyle(color: PinneColors.muted, fontSize: 12),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('Check for busy times'),
              value: selection.useForConflicts,
              onChanged: (on) => onChanged(on, selection.useForWrites),
            ),
            if (selection.readOnly)
              const Text(
                'Read-only: sessions cannot be added here.',
                style: TextStyle(color: PinneColors.muted, fontSize: 12),
              )
            else
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text('Add sessions here'),
                subtitle: const Text('Only one calendar takes sessions.'),
                value: selection.useForWrites,
                onChanged: (on) => onChanged(selection.useForConflicts, on),
              ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route});

  final CalendarRouteStatus route;

  @override
  Widget build(BuildContext context) {
    final exportOnly = route.route == CalendarRoute.icsExport;
    final tag = exportOnly
        ? 'Export only'
        : route.available
        ? 'Available'
        : 'Not configured';
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                exportOnly ? Icons.ios_share : Icons.cloud_outlined,
                color: PinneColors.lilac,
              ),
              const SizedBox(width: PinneSpacing.sm),
              Expanded(
                child: Text(
                  route.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: PinneColors.glass,
                  borderRadius: BorderRadius.circular(PinneRadii.chip),
                  border: Border.all(color: PinneColors.line),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: PinneColors.lilac,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (route.limitation case final limitation?) ...[
            const SizedBox(height: PinneSpacing.xs),
            Text(
              limitation,
              style: const TextStyle(color: PinneColors.muted, fontSize: 13),
            ),
          ],
          if (exportOnly)
            const Padding(
              padding: EdgeInsets.only(top: PinneSpacing.xs),
              child: Text(
                'Export from the Planner or a session card.',
                style: TextStyle(color: PinneColors.muted, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
