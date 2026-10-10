import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/server_client.dart';
import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/motion.dart';
import '../capture/saved_section.dart';
import 'collection_cover.dart';

@immutable
class CollectionTileData {
  const CollectionTileData({
    required this.name,
    required this.description,
    required this.coverSeed,
    required this.paletteIndex,
    this.isSample = false,
  });

  factory CollectionTileData.fromCollection(Collection collection) {
    return CollectionTileData(
      name: collection.name,
      description: collection.description ?? 'A place for good finds.',
      coverSeed: collection.coverSeed,
      paletteIndex: collection.paletteIndex,
      isSample: collection.isExample,
    );
  }

  final String name;
  final String description;
  final int coverSeed;
  final int paletteIndex;
  final bool isSample;
}

// Intentionally local preview data for signed-out and genuinely empty states.
// It is not uploaded or confused with a user's collections.
const _sampleCollections = <CollectionTileData>[
  CollectionTileData(
    name: 'Flutter UI',
    description: '24 saved · 18 reviewed',
    coverSeed: 1847,
    paletteIndex: 0,
    isSample: true,
  ),
  CollectionTileData(
    name: 'Motion ideas',
    description: '11 saved · 4 reviewed',
    coverSeed: 90210,
    paletteIndex: 1,
    isSample: true,
  ),
  CollectionTileData(
    name: 'Backend notes',
    description: '9 saved · 9 reviewed',
    coverSeed: 7331,
    paletteIndex: 2,
    isSample: true,
  ),
  CollectionTileData(
    name: 'Not sorted yet',
    description: '6 waiting',
    coverSeed: 24680,
    paletteIndex: 3,
    isSample: true,
  ),
];

final collectionsProvider =
    FutureProvider.autoDispose<List<CollectionTileData>>(
      (ref) async {
        if (!ref.watch(signedInProvider)) return _sampleCollections;
        final collections = await ref.watch(clientProvider).collection.list();
        if (collections.isEmpty) return _sampleCollections;
        return collections.map(CollectionTileData.fromCollection).toList();
      },
    );

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);
    return PinnePage(
      headline: 'Your',
      headlineBold: 'collections',
      subtitle: 'Group saves by what you want to do with them.',
      children: [
        collections.when(
          loading: () => const _LoadingGrid(),
          error: (error, stackTrace) => GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Collections could not load',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: PinneSpacing.xs),
                const Text(
                  'Try again when the server is reachable.',
                  style: TextStyle(color: PinneColors.muted),
                ),
                const SizedBox(height: PinneSpacing.sm),
                TextButton(
                  onPressed: () => ref.invalidate(collectionsProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
          data: (items) => _CollectionGrid(items: items),
        ),
        const SizedBox(height: PinneSpacing.xl),
        const SavedSection(),
      ],
    );
  }
}

class _CollectionGrid extends StatelessWidget {
  const _CollectionGrid({required this.items});

  final List<CollectionTileData> items;

  @override
  Widget build(BuildContext context) {
    final showsSamples = items.any((item) => item.isSample);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showsSamples) ...[
          const _SampleNotice(),
          const SizedBox(height: PinneSpacing.md),
        ],
        GridView.builder(
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
            final tile = _CollectionTransition(item: item);
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
        ),
      ],
    );
  }
}

class _SampleNotice extends StatelessWidget {
  const _SampleNotice();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Showing sample collections',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PinneSpacing.md,
          vertical: PinneSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: PinneColors.glass,
          borderRadius: BorderRadius.circular(PinneRadii.chip),
          border: Border.all(color: PinneColors.line),
        ),
        child: const Text(
          'SAMPLE COLLECTIONS',
          style: TextStyle(
            color: PinneColors.lilac,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
      ),
    );
  }
}

class _CollectionTransition extends StatelessWidget {
  const _CollectionTransition({required this.item});

  final CollectionTileData item;

  @override
  Widget build(BuildContext context) {
    if (reduceMotionOf(context)) {
      return _CollectionTile(
        item: item,
        onTap: () => Navigator.of(context).push(
          PageRouteBuilder<void>(
            transitionDuration: PinneMotionDurations.reducedFade,
            reverseTransitionDuration: PinneMotionDurations.reducedFade,
            pageBuilder: (context, animation, secondaryAnimation) =>
                CollectionDetailScreen(item: item),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
      );
    }

    return OpenContainer<void>(
      transitionDuration: PinneMotionDurations.slow,
      transitionType: ContainerTransitionType.fadeThrough,
      closedColor: Colors.transparent,
      openColor: PinneColors.midnight,
      middleColor: PinneColors.midnightRaised,
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
      label: '${item.name}. ${item.description}',
      child: Material(
        color: PinneColors.tilePalette[item.paletteIndex],
        borderRadius: BorderRadius.circular(PinneRadii.tile),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('collection-${item.coverSeed}'),
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
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: PinneColors.ink,
                                height: 1.05,
                              ),
                        ),
                        const SizedBox(height: PinneSpacing.xs),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: PinneColors.ink.withValues(alpha: 0.68),
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

class CollectionDetailScreen extends StatelessWidget {
  const CollectionDetailScreen({super.key, required this.item});

  final CollectionTileData item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PinneColors.midnight,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PinneSpacing.gutter),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: PinneColors.ink,
                ),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Back',
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            const SizedBox(height: PinneSpacing.md),
            SizedBox(
              height: 220,
              child: CollectionCover(
                seed: item.coverSeed,
                paletteIndex: item.paletteIndex,
                borderRadius: PinneRadii.card,
              ),
            ),
            const SizedBox(height: PinneSpacing.xl),
            Semantics(
              header: true,
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: PinneSpacing.sm),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: PinneColors.muted,
              ),
            ),
            const SizedBox(height: PinneSpacing.xl),
            const GlassCard(
              child: Text(
                'Saved items will appear here.',
                style: TextStyle(color: PinneColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 220,
      child: Center(
        child: CircularProgressIndicator(color: PinneColors.violet),
      ),
    );
  }
}
