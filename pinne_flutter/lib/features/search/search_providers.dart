import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/server_client.dart';

final searchEndpointProvider = Provider<EndpointSearch>(
  (ref) => ref.watch(clientProvider).search,
);

final collectionEndpointProvider = Provider<EndpointCollection>(
  (ref) => ref.watch(clientProvider).collection,
);

final searchQueryProvider = NotifierProvider<SearchQuery, String>(
  SearchQuery.new,
);

class SearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void set(String value) => state = value.trim();
}

class SearchFilters {
  const SearchFilters({
    this.source,
    this.contentType,
    this.collectionId,
    this.collectionName,
    this.reviewStatus,
  });

  final SourcePlatform? source;
  final ContentType? contentType;
  final UuidValue? collectionId;
  final String? collectionName;
  final ReviewStatusFilter? reviewStatus;
}

final searchFiltersProvider =
    NotifierProvider<SearchFilterController, SearchFilters>(
      SearchFilterController.new,
    );

class SearchFilterController extends Notifier<SearchFilters> {
  @override
  SearchFilters build() => const SearchFilters();

  void clear() => state = const SearchFilters();

  void source(SourcePlatform? value) => state = SearchFilters(
    source: state.source == value ? null : value,
    contentType: state.contentType,
    collectionId: state.collectionId,
    collectionName: state.collectionName,
    reviewStatus: state.reviewStatus,
  );

  void contentType(ContentType? value) => state = SearchFilters(
    source: state.source,
    contentType: state.contentType == value ? null : value,
    collectionId: state.collectionId,
    collectionName: state.collectionName,
    reviewStatus: state.reviewStatus,
  );

  void collection(Collection? value) => state = SearchFilters(
    source: state.source,
    contentType: state.contentType,
    collectionId: value?.id,
    collectionName: value?.name,
    reviewStatus: state.reviewStatus,
  );

  void reviewStatus(ReviewStatusFilter? value) => state = SearchFilters(
    source: state.source,
    contentType: state.contentType,
    collectionId: state.collectionId,
    collectionName: state.collectionName,
    reviewStatus: state.reviewStatus == value ? null : value,
  );
}

final searchCollectionsProvider = FutureProvider.autoDispose<List<Collection>>((
  ref,
) async {
  if (!ref.watch(signedInProvider)) return [];
  return ref.watch(collectionEndpointProvider).list();
});

final searchPageProvider =
    AsyncNotifierProvider.autoDispose<SearchResults, SearchPage>(
      SearchResults.new,
    );

class SearchResults extends AsyncNotifier<SearchPage> {
  @override
  Future<SearchPage> build() => _fetch(
    query: ref.watch(searchQueryProvider),
    filters: ref.watch(searchFiltersProvider),
    signedIn: ref.watch(signedInProvider),
  );

  Future<SearchPage> _fetch({
    required String query,
    required SearchFilters filters,
    required bool signedIn,
    String? cursor,
  }) async {
    if (query.isEmpty || !signedIn) {
      return SearchPage(results: []);
    }
    return ref
        .read(searchEndpointProvider)
        .keyword(
          query: query,
          source: filters.source,
          contentType: filters.contentType,
          collectionId: filters.collectionId,
          reviewStatus: filters.reviewStatus,
          cursor: cursor,
        );
  }

  Future<void> loadMore() async {
    final current = state.value;
    final cursor = current?.nextCursor;
    if (current == null || cursor == null || state.isLoading) return;
    state = const AsyncLoading<SearchPage>();
    state = await AsyncValue.guard(() async {
      final next = await _fetch(
        query: ref.read(searchQueryProvider),
        filters: ref.read(searchFiltersProvider),
        signedIn: ref.read(signedInProvider),
        cursor: cursor,
      );
      return SearchPage(
        results: [...current.results, ...next.results],
        nextCursor: next.nextCursor,
      );
    });
  }
}
