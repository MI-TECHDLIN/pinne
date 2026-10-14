import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/library_revision.dart';
import '../../core/server_client.dart';
import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/feedback/error_state.dart';
import '../../ui/feedback/toast.dart';
import '../../ui/item_preview.dart';
import '../../ui/motion.dart';
import '../../ui/pinne_loading.dart';
import '../capture/saved_section.dart';
import 'collection_cover.dart';
import 'collection_editor.dart';
import 'collections_providers.dart';

export 'collections_providers.dart'
    show CollectionTileData, collectionItemsProvider, collectionsProvider;

/// Opens the sheet for a new collection, coloured unlike its neighbours.
Future<Collection?> createCollection(BuildContext context, WidgetRef ref) =>
    showCollectionEditor(
      context,
      defaultPalette: defaultCollectionPalette(
        ref.read(collectionsProvider).asData?.value ?? const [],
      ),
    );

class CollectionsScreen extends ConsumerStatefulWidget {
  const CollectionsScreen({super.key});

  @override
  ConsumerState<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends ConsumerState<CollectionsScreen> {
  final _search = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collections = ref.watch(collectionsProvider);
    final signedIn = ref.watch(accountIdProvider) != null;
    return PinnePage(
      headline: 'Your',
      headlineBold: 'collections',
      subtitle: 'Group saves by what you want to do with them.',
      children: [
        collections.when(
          loading: () => const _LoadingGrid(),
          error: (error, stackTrace) => PinneErrorCard(
            error: error,
            subject: 'your collections',
            onRetry: () => ref.invalidate(collectionsProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return _EmptyCollections(
                onCreate: signedIn
                    ? () => createCollection(context, ref)
                    : null,
              );
            }
            final shown = [
              for (final item in items)
                if (item.matches(_query)) item,
            ];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Toolbar(
                  controller: _search,
                  onChanged: (value) => setState(() => _query = value),
                  onCreate: () => createCollection(context, ref),
                ),
                const SizedBox(height: PinneSpacing.md),
                if (shown.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: PinneSpacing.lg,
                    ),
                    child: Text(
                      'No collection matches “${_query.trim()}”.',
                      key: const ValueKey('collections-no-match'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.pinne.muted),
                    ),
                  )
                else
                  _CollectionGrid(items: shown),
              ],
            );
          },
        ),
        const SizedBox(height: PinneSpacing.xl),
        const SavedSection(),
      ],
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.controller,
    required this.onChanged,
    required this.onCreate,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            key: const ValueKey('collections-search-field'),
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search collections',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, _) => value.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          controller.clear();
                          onChanged('');
                        },
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(width: PinneSpacing.sm),
        Tooltip(
          message: 'New collection',
          child: FilledButton.icon(
            key: const ValueKey('new-collection'),
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('New'),
          ),
        ),
      ],
    );
  }
}

class _EmptyCollections extends StatelessWidget {
  const _EmptyCollections({required this.onCreate});

  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      key: const ValueKey('collections-empty'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No collections yet', style: theme.textTheme.titleMedium),
          const SizedBox(height: PinneSpacing.xs),
          Text(
            'Make one for anything you collect, such as UI inspiration or '
            'recipes. When you save something, Pinne suggests the collection '
            'it fits, or a new one when nothing does.',
            style: TextStyle(color: context.pinne.muted, height: 1.4),
          ),
          if (onCreate != null) ...[
            const SizedBox(height: PinneSpacing.md),
            FilledButton.icon(
              key: const ValueKey('create-first-collection'),
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create a collection'),
            ),
          ],
        ],
      ),
    );
  }
}

class _CollectionGrid extends StatelessWidget {
  const _CollectionGrid({required this.items});

  final List<CollectionTileData> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: PinneSpacing.md,
        mainAxisSpacing: PinneSpacing.md,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final tile = _CollectionTransition(
          key: ValueKey(('collection-tile', item.id)),
          item: item,
        );
        if (reduceMotionOf(context)) {
          return tile.animate().fadeIn(
            duration: PinneMotionDurations.reducedFade,
          );
        }
        return tile
            .animate(delay: staggerDelayOf(context, index))
            .fadeIn(duration: PinneMotionDurations.standard)
            .slideY(
              begin: 0.12,
              end: 0,
              duration: PinneMotionDurations.standard,
              curve: PinneMotionCurves.enter,
            );
      },
    );
  }
}

/// Opens [item]'s detail screen from anywhere, such as Search results.
Future<void> openCollection(BuildContext context, CollectionTileData item) =>
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: motionDurationOf(
          context,
          PinneMotionDurations.standard,
        ),
        reverseTransitionDuration: motionDurationOf(
          context,
          PinneMotionDurations.standard,
        ),
        pageBuilder: (context, animation, secondaryAnimation) =>
            CollectionDetailScreen(item: item),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );

class _CollectionTransition extends StatelessWidget {
  const _CollectionTransition({super.key, required this.item});

  final CollectionTileData item;

  @override
  Widget build(BuildContext context) {
    if (reduceMotionOf(context)) {
      return _CollectionTile(
        item: item,
        onTap: () => openCollection(context, item),
      );
    }

    return OpenContainer<void>(
      transitionDuration: PinneMotionDurations.slow,
      transitionType: ContainerTransitionType.fadeThrough,
      closedColor: Colors.transparent,
      openColor: context.pinne.midnight,
      middleColor: context.pinne.midnightRaised,
      closedElevation: 0,
      openElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PinneRadii.tile),
      ),
      openShape: const RoundedRectangleBorder(),
      closedBuilder: (context, openContainer) =>
          _CollectionTile(item: item, onTap: openContainer),
      openBuilder: (context, closeContainer) =>
          CollectionDetailScreen(item: item),
    );
  }
}

class _CollectionTile extends StatelessWidget {
  const _CollectionTile({required this.item, required this.onTap});

  final CollectionTileData item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${item.name}. ${item.cardLine}',
      child: Material(
        color: context
            .pinne
            .tilePalette[item.paletteIndex % context.pinne.tilePalette.length],
        borderRadius: BorderRadius.circular(PinneRadii.tile),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('collection-${item.id.uuid}'),
          onTap: onTap,
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 6,
                  child: CollectionCover(
                    seed: item.coverSeed,
                    paletteIndex: item.paletteIndex,
                    borderRadius: 0,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(PinneSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: context.pinne.ink.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                              PinneRadii.chip,
                            ),
                          ),
                          child: Text(
                            item.isExample ? 'EXAMPLE' : 'COLLECTION',
                            style: TextStyle(
                              color: context.pinne.ink,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: PinneSpacing.xs),
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: context.pinne.ink,
                                height: 1.05,
                              ),
                        ),
                        const SizedBox(height: PinneSpacing.xs),
                        Text(
                          item.cardLine,
                          key: ValueKey('collection-line-${item.id.uuid}'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: context.pinne.ink.withValues(
                                  alpha: 0.72,
                                ),
                              ),
                        ),
                      ],
                    ),
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

/// A compact row for a collection, used in Search results.
class CollectionResultTile extends StatelessWidget {
  const CollectionResultTile({super.key, required this.item});

  final CollectionTileData item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: 'Collection ${item.name}. ${item.cardLine}',
      child: Material(
        color: context.pinne.card,
        borderRadius: BorderRadius.circular(PinneRadii.card),
        child: InkWell(
          key: ValueKey('collection-result-${item.id.uuid}'),
          borderRadius: BorderRadius.circular(PinneRadii.card),
          onTap: () => openCollection(context, item),
          child: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.all(PinneSpacing.sm),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 48,
                    child: CollectionCover(
                      seed: item.coverSeed,
                      paletteIndex: item.paletteIndex,
                      borderRadius: PinneRadii.chip,
                    ),
                  ),
                  const SizedBox(width: PinneSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          item.cardLine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: context.pinne.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: context.pinne.muted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One collection and its saves. It follows the server, so a suggestion
/// accepted elsewhere, an edit or a removal shows here at once.
class CollectionDetailScreen extends ConsumerWidget {
  const CollectionDetailScreen({super.key, required this.item});

  /// The collection as it was when opened; newer data replaces it.
  final CollectionTileData item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref
        .watch(collectionsProvider)
        .asData
        ?.value
        .where((other) => other.id == item.id)
        .firstOrNull;
    final current = latest ?? item;
    final items = ref.watch(collectionItemsProvider(item.id));
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: context.pinne.midnight,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PinneSpacing.gutter),
          children: [
            Row(
              children: [
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: context.pinne.ink,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const Spacer(),
                if (current.collection != null) ...[
                  IconButton(
                    key: const ValueKey('edit-collection'),
                    tooltip: 'Edit name, colour and description',
                    onPressed: () =>
                        showCollectionEditor(context, editing: current),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    key: const ValueKey('delete-collection'),
                    tooltip: 'Delete collection',
                    onPressed: () => _delete(context, ref, current),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ],
            ),
            const SizedBox(height: PinneSpacing.md),
            SizedBox(
              height: 220,
              child: CollectionCover(
                seed: current.coverSeed,
                paletteIndex: current.paletteIndex,
                borderRadius: PinneRadii.card,
              ),
            ),
            const SizedBox(height: PinneSpacing.xl),
            Semantics(
              header: true,
              child: Text(current.name, style: theme.textTheme.displaySmall),
            ),
            if (current.description case final description?) ...[
              const SizedBox(height: PinneSpacing.sm),
              Text(
                description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: context.pinne.muted,
                ),
              ),
            ],
            const SizedBox(height: PinneSpacing.sm),
            Text(
              current.cardLine,
              key: const ValueKey('collection-detail-line'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.pinne.lilac,
              ),
            ),
            const SizedBox(height: PinneSpacing.xl),
            items.when(
              loading: () => const PinneCardSkeleton(
                height: 96,
                label: 'Loading this collection',
              ),
              error: (error, stackTrace) => PinneErrorCard(
                error: error,
                subject: 'this collection',
                onRetry: () => ref.invalidate(collectionItemsProvider(item.id)),
              ),
              data: (saves) => saves.isEmpty
                  ? GlassCard(
                      child: Text(
                        'Nothing here yet. Accept a collection suggestion on '
                        'a save and it lands here.',
                        style: TextStyle(color: context.pinne.muted),
                      ),
                    )
                  : Column(
                      children: [
                        for (final save in saves) ...[
                          _CollectionItemRow(collection: current, item: save),
                          const SizedBox(height: PinneSpacing.sm),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    CollectionTileData current,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete “${current.name}”?'),
        content: Text(switch (current.itemCount) {
          0 => 'The collection is empty.',
          1 => 'Its save stays in Pinne. It just leaves this collection.',
          final count =>
            'Its $count saves stay in Pinne. They just leave this collection.',
        }),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const ValueKey('confirm-delete-collection'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(collectionsApiProvider).delete(current.id);
      ref.read(libraryRevisionProvider.notifier).bump();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      showPinneToast(
        context,
        'Collection deleted. Its saves are still in Pinne.',
        kind: ToastKind.success,
      );
    } on Object catch (error) {
      if (context.mounted) {
        showErrorToast(context, error, 'Could not delete the collection');
      }
    }
  }
}

class _CollectionItemRow extends ConsumerWidget {
  const _CollectionItemRow({required this.collection, required this.item});

  final CollectionTileData collection;
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final uri = item.url == null ? null : Uri.tryParse(item.url!);
    return GlassCard(
      key: ValueKey('collection-item-${item.id?.uuid}'),
      padding: const EdgeInsets.only(
        left: PinneSpacing.md,
        top: PinneSpacing.sm,
        bottom: PinneSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: uri == null
                  ? null
                  : () => launchUrl(uri, mode: LaunchMode.externalApplication),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  PreviewByline(item: item),
                  if (item.summary case final summary?)
                    Text(
                      summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Remove from ${collection.name}',
            onPressed: () => _remove(context, ref),
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
        ],
      ),
    );
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(collectionsApiProvider)
          .removeItem(collection.id, item.id!);
      ref.read(libraryRevisionProvider.notifier).bump();
      if (context.mounted) {
        showPinneToast(
          context,
          'Removed from ${collection.name}. It is still in Pinne.',
        );
      }
    } on Object catch (error) {
      if (context.mounted) {
        showErrorToast(context, error, 'Could not remove it');
      }
    }
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) => GridView.count(
    key: const ValueKey('collections-skeleton'),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    crossAxisSpacing: PinneSpacing.md,
    mainAxisSpacing: PinneSpacing.md,
    childAspectRatio: 0.82,
    children: const [
      PinneTileSkeleton(),
      PinneTileSkeleton(),
      PinneTileSkeleton(),
      PinneTileSkeleton(),
    ],
  );
}
