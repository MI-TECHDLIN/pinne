import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/open_original.dart';
import '../../core/server_client.dart';
import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import '../../ui/item_preview.dart';
import '../../ui/pinne_loading.dart';
import 'ai_suggestions.dart';
import 'capture_labels.dart';
import 'capture_providers.dart';
import 'capture_store.dart';

/// Everything captured on this phone, newest first, with its source, sync
/// state and the user's note.
class SavedSection extends ConsumerWidget {
  const SavedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(captureStoreProvider) == null) return const SizedBox();
    final accountId = ref.watch(accountIdProvider);
    final capturesState = ref.watch(capturesProvider);
    final captures = capturesState.isLoading
        ? const <LocalCapture>[]
        : [
            for (final capture in capturesState.value ?? const <LocalCapture>[])
              if (capture.accountId == accountId) capture,
          ];
    final signedIn = ref.watch(signedInProvider);
    final serverItems = ref.watch(savedItemsProvider).value ?? const [];
    final byId = {
      for (final item in serverItems)
        if (item.id != null) item.id!.uuid: item,
    };
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Saved', style: theme.textTheme.titleLarge),
              const SizedBox(width: PinneSpacing.sm),
              if (captures.isNotEmpty)
                Text(
                  '${captures.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.pinne.muted,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: PinneSpacing.md),
        if (capturesState.isLoading)
          const _SavedListSkeleton()
        else if (captures.isEmpty)
          const ComingSoonCard(
            title: 'Nothing saved yet',
            body:
                'Share a link to Pinne from any app, or paste one on Today. '
                'It shows up here right away, even offline.',
          )
        else
          for (final (index, capture) in captures.indexed) ...[
            if (index > 0) const SizedBox(height: PinneSpacing.sm),
            _staggered(
              context,
              index,
              SavedCard(
                key: ValueKey('saved-${capture.clientItemId}'),
                capture: capture,
                signedIn: signedIn,
                item: capture.serverItemId == null
                    ? null
                    : byId[capture.serverItemId],
              ),
            ),
          ],
      ],
    );
  }

  static Widget _staggered(BuildContext context, int index, Widget card) {
    if (reduceMotionOf(context)) {
      return card.animate().fadeIn(duration: PinneMotionDurations.reducedFade);
    }
    return card
        .animate(delay: staggerDelayOf(context, index.clamp(0, 8)))
        .fadeIn(duration: PinneMotionDurations.standard)
        .slideY(
          begin: 0.12,
          end: 0,
          duration: PinneMotionDurations.standard,
          curve: PinneMotionCurves.enter,
        );
  }
}

class _SavedListSkeleton extends StatelessWidget {
  const _SavedListSkeleton();

  @override
  Widget build(BuildContext context) => const Column(
    key: ValueKey('saved-list-skeleton'),
    children: [
      PinneCardSkeleton(height: 132, label: 'Loading saved item'),
      SizedBox(height: PinneSpacing.sm),
      PinneCardSkeleton(height: 132, label: 'Loading saved item'),
      SizedBox(height: PinneSpacing.sm),
      PinneCardSkeleton(height: 132, label: 'Loading saved item'),
    ],
  );
}

class SavedCard extends ConsumerWidget {
  const SavedCard({
    super.key,
    required this.capture,
    required this.signedIn,
    this.item,
  });

  final LocalCapture capture;
  final bool signedIn;
  final Item? item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final url = capture.url;
    final note = capture.noteText;
    final intention = capture.intention;
    final preview = item;
    final openUrl = url ?? preview?.url;
    final canOpen =
        openUrl != null && Uri.tryParse(openUrl.trim())?.hasScheme == true;
    return GlassCard(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          key: const ValueKey('saved-card-open'),
          excludeFromSemantics: true,
          onTap: canOpen ? () => openOriginal(context, ref, openUrl) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SourceBadge(source: capture.source),
                  const SizedBox(width: PinneSpacing.sm),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SyncStatusLabel(
                        capture: capture,
                        signedIn: signedIn,
                      ),
                    ),
                  ),
                  if (canOpen)
                    IconButton(
                      key: const ValueKey('saved-open-original'),
                      tooltip: 'Open original',
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.open_in_new_rounded, size: 20),
                      onPressed: () => openOriginal(context, ref, openUrl),
                    ),
                ],
              ),
              const SizedBox(height: PinneSpacing.sm),
              if (preview != null) ...[
                PreviewThumbnail(item: preview),
                const SizedBox(height: PinneSpacing.sm),
              ],
              Text(
                preview?.title ?? capture.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              if (preview != null) ...[
                PreviewByline(item: preview),
                if (preview.durationSeconds case final seconds?)
                  Padding(
                    padding: const EdgeInsets.only(top: PinneSpacing.xs),
                    child: DurationChip(seconds: seconds),
                  ),
              ],
              if (url != null)
                Text(
                  readableUrl(url),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.pinne.muted,
                  ),
                )
              else if (note != null && note.trim() != capture.title)
                Text(
                  note,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.pinne.muted,
                  ),
                ),
              if (preview?.summary case final summary?) ...[
                const SizedBox(height: PinneSpacing.xs),
                Text(
                  summary,
                  key: const ValueKey('saved-summary'),
                  style: theme.textTheme.bodySmall,
                ),
              ],
              if (intention != null) ...[
                const SizedBox(height: PinneSpacing.sm),
                Text(
                  'Your note: “$intention”',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.pinne.lilac,
                  ),
                ),
              ],
              if (preview?.id case final itemId? when signedIn)
                SavedItemAiSuggestions(
                  itemId: itemId,
                  revision: preview?.revision,
                ),
              if (capture.syncState == CaptureSyncState.failed) ...[
                const SizedBox(height: PinneSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        capture.lastError ?? 'The server did not accept it.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.pinne.muted,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final accountId = ref.read(accountIdProvider);
                        if (accountId == null) return;
                        ref
                            .read(captureStoreProvider)
                            ?.retry(capture.clientItemId, accountId: accountId);
                        final sync = ref.read(outboxSyncProvider);
                        if (sync != null) unawaited(sync.drain());
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
