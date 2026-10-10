import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import '../../ui/item_preview.dart';
import '../settings/profile_provider.dart';
import '../examples/example_saves.dart';
import 'search_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _queryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(searchQueryProvider.notifier).set(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final page = ref.watch(searchPageProvider);
    final avatar = ref.watch(avatarRecipeProvider);
    return PinnePage(
      headline: 'Remember it',
      headlineBold: 'your way',
      subtitle: 'Describe it the way you would to a friend.',
      children: [
        TextField(
          key: const ValueKey('search-field'),
          controller: _controller,
          onChanged: _queryChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'desktop sidebar from X',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      _debounce?.cancel();
                      _controller.clear();
                      ref.read(searchQueryProvider.notifier).set('');
                      setState(() {});
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
            filled: true,
            fillColor: PinneColors.glass,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(PinneRadii.chip),
              ),
              borderSide: BorderSide(color: PinneColors.line),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(PinneRadii.chip),
              ),
              borderSide: BorderSide(color: PinneColors.line),
            ),
          ),
        ),
        const SizedBox(height: PinneSpacing.md),
        const _FilterChips(),
        const SizedBox(height: PinneSpacing.lg),
        page.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _SearchMessage(
            title: 'Search is taking a moment.',
            body: 'Your saves are safe. Try again when you’re ready.',
            action: () => ref.invalidate(searchPageProvider),
          ),
          data: (data) {
            if (query.isEmpty) {
              return SearchEmptyState(
                seed: avatar.seed,
                palette: avatar.palette,
                title: 'What do you remember?',
                body: 'A phrase, source or note is enough to begin.',
              );
            }
            if (data.results.isEmpty) {
              return SearchEmptyState(
                seed: avatar.seed,
                palette: avatar.palette,
                title: 'Nothing matched yet.',
                body:
                    'Try fewer words or clear a filter. Your saves are still here.',
              );
            }
            return Column(
              children: [
                for (var i = 0; i < data.results.length; i++) ...[
                  SearchResultCard(
                    key: ValueKey('search-result-${data.results[i].item.id}'),
                    result: data.results[i],
                    color: PinneColors
                        .tilePalette[i % PinneColors.tilePalette.length],
                    onOpen: () => _open(data.results[i].item),
                  ),
                  if (i != data.results.length - 1)
                    const SizedBox(height: PinneSpacing.sm),
                ],
                if (data.nextCursor != null) ...[
                  const SizedBox(height: PinneSpacing.md),
                  FilledButton(
                    key: const ValueKey('search-more'),
                    onPressed: page.isLoading
                        ? null
                        : () =>
                              ref.read(searchPageProvider.notifier).loadMore(),
                    child: const Text('More results'),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _open(Item item) async {
    final uri = item.url == null ? null : Uri.tryParse(item.url!);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _FilterChips extends ConsumerWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final collections = ref.watch(searchCollectionsProvider).value ?? const [];
    final controller = ref.read(searchFiltersProvider.notifier);
    final clear =
        filters.source == null &&
        filters.contentType == null &&
        filters.collectionId == null &&
        filters.reviewStatus == null;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            key: const ValueKey('filter-all'),
            label: const Text('All'),
            selected: clear,
            onSelected: (_) => controller.clear(),
          ),
          const SizedBox(width: PinneSpacing.sm),
          _MenuFilter<SourcePlatform>(
            label: filters.source == null ? 'Source' : _source(filters.source!),
            selected: filters.source,
            values: SourcePlatform.values,
            display: _source,
            onSelected: controller.source,
          ),
          const SizedBox(width: PinneSpacing.sm),
          _MenuFilter<ContentType>(
            label: filters.contentType == null
                ? 'Type'
                : _words(filters.contentType!.name),
            selected: filters.contentType,
            values: ContentType.values,
            display: (value) => _words(value.name),
            onSelected: controller.contentType,
          ),
          const SizedBox(width: PinneSpacing.sm),
          _MenuFilter<Collection>(
            label: filters.collectionName ?? 'Collection',
            selected: collections
                .where((value) => value.id == filters.collectionId)
                .firstOrNull,
            values: collections,
            display: (value) => value.name,
            onSelected: controller.collection,
          ),
          const SizedBox(width: PinneSpacing.sm),
          _MenuFilter<ReviewStatusFilter>(
            label: filters.reviewStatus == null
                ? 'Review status'
                : _words(filters.reviewStatus!.name),
            selected: filters.reviewStatus,
            values: ReviewStatusFilter.values,
            display: (value) => _words(value.name),
            onSelected: controller.reviewStatus,
          ),
        ],
      ),
    );
  }
}

class _MenuFilter<T> extends StatelessWidget {
  const _MenuFilter({
    required this.label,
    required this.selected,
    required this.values,
    required this.display,
    required this.onSelected,
  });

  final String label;
  final T? selected;
  final List<T> values;
  final String Function(T value) display;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton<T?>(
    onSelected: onSelected,
    itemBuilder: (context) => [
      PopupMenuItem<T?>(value: null, child: const Text('Any')),
      for (final value in values)
        PopupMenuItem<T?>(value: value, child: Text(display(value))),
    ],
    child: Chip(
      side: BorderSide(
        color: selected == null ? PinneColors.line : PinneColors.violet,
      ),
      backgroundColor: selected == null
          ? PinneColors.glass
          : PinneColors.violet,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: PinneSpacing.xs),
          const Icon(Icons.expand_more_rounded, size: 16),
        ],
      ),
    ),
  );
}

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.result,
    required this.color,
    required this.onOpen,
  });

  final SearchResult result;
  final Color color;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final item = result.item;
    final note = item.intention ?? item.noteText;
    final evidence = result.evidence.firstOrNull;
    return Semantics(
      button: item.url != null,
      label: '${_source(item.sourcePlatform)}, ${item.title}',
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(PinneRadii.tile),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: item.url == null ? null : onOpen,
          child: Padding(
            padding: const EdgeInsets.all(PinneSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.url != null) ...[
                  PreviewThumbnail(item: item, height: 132),
                  const SizedBox(height: PinneSpacing.md),
                ],
                Text(
                  '${_source(item.sourcePlatform)} · ${_words(item.contentType.name)}',
                  style: const TextStyle(
                    color: PinneColors.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                if (item.isExample) ...[
                  const SizedBox(height: PinneSpacing.sm),
                  const ExampleChip(dark: true),
                ],
                const SizedBox(height: PinneSpacing.sm),
                PreviewByline(
                  item: item,
                  color: PinneColors.ink.withValues(alpha: 0.72),
                ),
                if (item.durationSeconds case final seconds?) ...[
                  const SizedBox(height: PinneSpacing.xs),
                  Wrap(
                    spacing: PinneSpacing.xs,
                    children: [
                      PreviewSourceChip(
                        source: item.sourcePlatform,
                        surface: PreviewChipSurface.pastel,
                      ),
                      DurationChip(
                        seconds: seconds,
                        surface: PreviewChipSurface.pastel,
                      ),
                    ],
                  ),
                ] else ...[
                  PreviewSourceChip(
                    source: item.sourcePlatform,
                    surface: PreviewChipSurface.pastel,
                  ),
                ],
                const SizedBox(height: PinneSpacing.sm),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: PinneColors.ink,
                  ),
                ),
                const SizedBox(height: PinneSpacing.sm),
                Text(
                  note?.trim().isNotEmpty == true
                      ? 'Your note: “${note!.trim()}”'
                      : 'No saved note',
                  style: const TextStyle(color: PinneColors.ink, height: 1.4),
                ),
                if (evidence != null) ...[
                  const SizedBox(height: PinneSpacing.md),
                  Text(
                    'Matched ${evidence.field}: ${evidence.snippet}',
                    style: TextStyle(
                      color: PinneColors.ink.withValues(alpha: 0.72),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({
    super.key,
    required this.seed,
    required this.palette,
    required this.title,
    required this.body,
  });

  final int seed;
  final int palette;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Row(
      children: [
        RibbonSpirit(
          seed: seed,
          palette: palette,
          size: 92,
          animate: false,
          mood: RibbonMood.sleepy,
        ),
        const SizedBox(width: PinneSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: PinneSpacing.xs),
              Text(
                body,
                style: const TextStyle(color: PinneColors.muted, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({
    required this.title,
    required this.body,
    required this.action,
  });

  final String title;
  final String body;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: PinneSpacing.xs),
        Text(body, style: const TextStyle(color: PinneColors.muted)),
        const SizedBox(height: PinneSpacing.md),
        FilledButton(onPressed: action, child: const Text('Try again')),
      ],
    ),
  );
}

String _source(SourcePlatform source) => switch (source) {
  SourcePlatform.x => 'X',
  SourcePlatform.youtube => 'YouTube',
  SourcePlatform.web => 'Web',
  SourcePlatform.note => 'Note',
  SourcePlatform.other => 'Other',
  SourcePlatform.instagram => 'Instagram',
  SourcePlatform.tiktok => 'TikTok',
  SourcePlatform.reddit => 'Reddit',
  SourcePlatform.github => 'GitHub',
  SourcePlatform.unknown => 'Unknown',
};

String _words(String value) =>
    '${value[0].toUpperCase()}${value.substring(1).replaceAll('_', ' ')}';
