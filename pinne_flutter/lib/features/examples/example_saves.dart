import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/server_client.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/glass_card.dart';
import '../../ui/pinne_loading.dart';
import '../collections/collections_screen.dart';
import '../progress/progress_providers.dart';
import '../search/search_providers.dart';
import '../today/today_providers.dart';
import '../../ui/feedback/toast.dart';

final exampleSavesStatusProvider =
    FutureProvider.autoDispose<ExampleSavesStatus?>((ref) async {
      if (!ref.watch(signedInProvider)) return null;
      return ref.watch(clientProvider).exampleSaves.status();
    });

class ExampleSavesCard extends ConsumerStatefulWidget {
  const ExampleSavesCard({super.key});

  @override
  ConsumerState<ExampleSavesCard> createState() => _ExampleSavesCardState();
}

class _ExampleSavesCardState extends ConsumerState<ExampleSavesCard> {
  var _dismissed = false;
  var _busy = false;

  Future<void> _change({required bool remove}) async {
    setState(() => _busy = true);
    try {
      final endpoint = ref.read(clientProvider).exampleSaves;
      if (remove) {
        await endpoint.remove();
      } else {
        await endpoint.seed();
      }
      ref
        ..invalidate(exampleSavesStatusProvider)
        ..invalidate(todayQueueProvider)
        ..invalidate(collectionsProvider)
        ..invalidate(searchPageProvider)
        ..invalidate(progressReportProvider);
      if (mounted) {
        showPinneToast(
          context,
          remove ? 'Example saves removed.' : 'Six example saves added.',
          kind: ToastKind.success,
        );
      }
    } on Object catch (error) {
      if (mounted) {
        showErrorToast(context, error, 'Could not update example saves');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    final status = ref.watch(exampleSavesStatusProvider);
    final value = status.asData?.value;
    if (value == null ||
        (value.totalItemCount > 0 && value.exampleItemCount == 0)) {
      return const SizedBox.shrink();
    }
    final loaded = value.exampleItemCount > 0;
    return GlassCard(
      key: const ValueKey('example-saves-card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: context.pinne.violet,
                  borderRadius: BorderRadius.circular(PinneRadii.chip),
                ),
                child: Text(
                  'EXAMPLE',
                  style: TextStyle(
                    color: context.pinne.onViolet,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                key: const ValueKey('dismiss-example-saves'),
                tooltip: 'Dismiss',
                onPressed: () => setState(() => _dismissed = true),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          Text(
            loaded
                ? 'Explore with example saves'
                : 'Load a few example saves to explore',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: PinneSpacing.xs),
          Text(
            loaded
                ? '${value.exampleItemCount} clearly labelled examples are in your account.'
                : 'Add six labelled examples across two collections, three of them ready to review now. Nothing is added unless you choose it.',
            style: TextStyle(color: context.pinne.muted, height: 1.4),
          ),
          const SizedBox(height: PinneSpacing.md),
          if (loaded)
            TextButton.icon(
              key: const ValueKey('remove-example-saves'),
              onPressed: _busy ? null : () => _change(remove: true),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Remove examples'),
            )
          else
            FilledButton.icon(
              key: const ValueKey('load-example-saves'),
              onPressed: _busy ? null : () => _change(remove: false),
              icon: _busy
                  ? const PinneBrandedLoader(
                      size: 18,
                      label: 'Adding example saves',
                    )
                  : const Icon(Icons.auto_awesome_rounded),
              label: Text(_busy ? 'Adding…' : 'Load examples'),
            ),
        ],
      ),
    );
  }
}

class ExampleChip extends StatelessWidget {
  const ExampleChip({super.key, this.dark = false});
  final bool dark;

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('example-chip'),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: dark
          ? context.pinne.ink.withValues(alpha: .12)
          : context.pinne.violet,
      borderRadius: BorderRadius.circular(PinneRadii.chip),
      border: dark
          ? Border.all(color: context.pinne.ink.withValues(alpha: .24))
          : null,
    ),
    child: Text(
      'EXAMPLE',
      style: TextStyle(
        color: dark ? context.pinne.ink : context.pinne.text,
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: .8,
      ),
    ),
  );
}
