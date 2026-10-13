import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shell/pinne_page.dart';
import '../../shell/responsive.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import '../../ui/item_preview.dart';
import '../../ui/pinne_loading.dart';
import '../settings/profile_provider.dart';
import '../examples/example_saves.dart';
import 'search_history.dart';
import 'search_providers.dart';
import '../../ui/feedback/error_state.dart';

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
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
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
      _runSearch(value);
    });
  }

  void _runSearch(String value) {
    ref.read(searchQueryProvider.notifier).set(value);
    ref.read(searchHistoryProvider.notifier).add(value);
  }

  void _repeatSearch(String value) {
    _debounce?.cancel();
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    _runSearch(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final page = ref.watch(searchPageProvider);
    final history = ref.watch(searchHistoryProvider);
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
          onSubmitted: (value) {
            _debounce?.cancel();
            _runSearch(value);
          },
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
            fillColor: context.pinne.glass,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(PinneRadii.chip)),
              borderSide: BorderSide(color: context.pinne.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(PinneRadii.chip)),
              borderSide: BorderSide(color: context.pinne.line),
            ),
          ),
        ),
        if (query.isEmpty && history.isNotEmpty) ...[
          const SizedBox(height: PinneSpacing.md),
          _RecentSearches(
            searches: history,
            onSearch: _repeatSearch,
            onRemove: ref.read(searchHistoryProvider.notifier).remove,
            onClear: () => _confirmClearHistory(context),
          ),
        ],
        const SizedBox(height: PinneSpacing.md),
        const _FilterChips(),
        const SizedBox(height: PinneSpacing.lg),
        page.when(
          loading: () => const _SearchResultsSkeleton(),
          error: (error, _) => PinneErrorCard(
            error: error,
            subject: 'search results',
            onRetry: () => ref.invalidate(searchPageProvider),
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
                body: 'Try fewer words or clear a filter. Your saves are still here.',
              );
            }
            return _SearchResults(
              data: data,
              loading: page.isLoading,
              onOpen: _open,
              onMore: () => ref.read(searchPageProvider.notifier).loadMore(),
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

  Future<void> _confirmClearHistory(BuildContext context) async {
    final clear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear recent searches?'),
        content: const Text('This removes search history from this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const ValueKey('confirm-clear-search-history'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
    if (clear == true) {
      await ref.read(searchHistoryProvider.notifier).clear();
    }
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.data,
    required this.loading,
    required this.onOpen,
    required this.onMore,
  });

  final SearchPage data;
  final bool loading;
  final ValueChanged<Item> onOpen;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = switch (PinneBreakpoints.of(context)) {
          PinneWindowClass.compact => 1,
          PinneWindowClass.medium => 2,
          PinneWindowClass.expanded => 3,
        };
        final width =
            (constraints.maxWidth - PinneSpacing.md * (columns - 1)) / columns;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: PinneSpacing.md,
              runSpacing: PinneSpacing.md,
              children: [
                for (var i = 0; i < data.results.length; i++)
                  SizedBox(
                    width: width,
                    child: SearchResultCard(
                      key: ValueKey('search-result-${data.results[i].item.id}'),
                      result: data.results[i],
                      color: context
                          .pinne
                          .tilePalette[i % context.pinne.tilePalette.length],
                      onOpen: () => onOpen(data.results[i].item),
                    ),
                  ),
              ],
            ),
            if (data.nextCursor != null) ...[
              const SizedBox(height: PinneSpacing.md),
              Align(
                alignment: Alignment.center,
                child: FilledButton(
                  key: const ValueKey('search-more'),
                  onPressed: loading ? null : onMore,
                  child: const Text('More results'),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.searches,
    required this.onSearch,
    required this.onRemove,
    required this.onClear,
  });

  final List<String> searches;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onRemove;
  final Future<void> Function() onClear;

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent searches',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton(
              key: const ValueKey('clear-search-history'),
              onPressed: onClear,
              child: const Text('Clear all'),
            ),
          ],
        ),
        Text(
          'Stored only on this device.',
          style: TextStyle(color: context.pinne.muted, fontSize: 12),
        ),
        const SizedBox(height: PinneSpacing.xs),
        for (final search in searches)
          Material(
            type: MaterialType.transparency,
            child: ListTile(
              key: ValueKey('recent-search-$search'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history_rounded),
              title: Text(search),
              onTap: () => onSearch(search),
              trailing: IconButton(
                tooltip: 'Remove $search from recent searches',
                onPressed: () => onRemove(search),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ),
      ],
    ),
  );
}

class _SearchResultsSkeleton extends StatelessWidget {
  const _SearchResultsSkeleton();

  @override
  Widget build(BuildContext context) => const Column(
    key: ValueKey('search-results-skeleton'),
    children: [
      PinneCardSkeleton(
        height: 246,
        showThumbnail: true,
        label: 'Loading search result',
      ),
      SizedBox(height: PinneSpacing.md),
      PinneCardSkeleton(
        height: 246,
        showThumbnail: true,
        label: 'Loading search result',
      ),
    ],
  );
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
      labelStyle: TextStyle(
        color: selected == null ? context.pinne.muted : context.pinne.onViolet,
      ),
      side: BorderSide(
        color: selected == null ? context.pinne.line : context.pinne.violet,
      ),
      backgroundColor: selected == null
          ? context.pinne.glass
          : context.pinne.violet,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: PinneSpacing.xs),
          Icon(
            Icons.expand_more_rounded,
            size: 16,
            color: selected == null ? null : context.pinne.onViolet,
          ),
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
          mouseCursor: item.url == null
              ? MouseCursor.defer
              : SystemMouseCursors.click,
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
                  style: TextStyle(
                    color: context.pinne.ink,
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
                  color: context.pinne.ink.withValues(alpha: 0.72),
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
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(color: context.pinne.ink),
                ),
                const SizedBox(height: PinneSpacing.sm),
                Text(
                  note?.trim().isNotEmpty == true
                      ? 'Your note: “${note!.trim()}”'
                      : 'No saved note',
                  style: TextStyle(color: context.pinne.ink, height: 1.4),
                ),
                if (evidence != null) ...[
                  const SizedBox(height: PinneSpacing.md),
                  Text(
                    'Matched ${evidence.field}: ${evidence.snippet}',
                    style: TextStyle(
                      color: context.pinne.ink.withValues(alpha: 0.72),
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
                style: TextStyle(color: context.pinne.muted, height: 1.4),
              ),
            ],
          ),
        ),
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
