import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/library_revision.dart';
import '../../core/server_client.dart';

/// The server calls behind the Collections screen. Kept injectable so the
/// screens can be exercised without a live server.
abstract interface class CollectionsApi {
  Future<List<CollectionSummary>> summaries();

  Future<List<Item>> items(UuidValue collectionId);

  Future<Collection> create(CollectionDraft draft);

  Future<Collection> update(Collection collection);

  Future<void> delete(UuidValue collectionId);

  Future<void> removeItem(UuidValue collectionId, UuidValue itemId);
}

class ServerCollectionsApi implements CollectionsApi {
  ServerCollectionsApi(this.client);

  final Client client;

  @override
  Future<List<CollectionSummary>> summaries() => client.collection.summaries();

  @override
  Future<List<Item>> items(UuidValue collectionId) =>
      client.collection.items(collectionId);

  @override
  Future<Collection> create(CollectionDraft draft) =>
      client.collection.create(draft);

  @override
  Future<Collection> update(Collection collection) =>
      client.collection.update(collection);

  @override
  Future<void> delete(UuidValue collectionId) =>
      client.collection.delete(collectionId);

  @override
  Future<void> removeItem(UuidValue collectionId, UuidValue itemId) =>
      client.collection.removeItem(collectionId, itemId);
}

final collectionsApiProvider = Provider<CollectionsApi>(
  (ref) => ServerCollectionsApi(ref.watch(clientProvider)),
);

/// How many cover palettes a collection can use (`CollectionEndpoint`).
const collectionPaletteCount = 5;

@immutable
class CollectionTileData {
  const CollectionTileData({
    required this.id,
    required this.name,
    required this.coverSeed,
    required this.paletteIndex,
    this.description,
    this.itemCount = 0,
    this.topTags = const [],
    this.recentTitles = const [],
    this.isExample = false,
    this.collection,
  });

  factory CollectionTileData.fromSummary(CollectionSummary summary) {
    final collection = summary.collection;
    return CollectionTileData(
      id: collection.id!,
      name: collection.name,
      description: collection.description,
      coverSeed: collection.coverSeed,
      paletteIndex: collection.paletteIndex,
      itemCount: summary.itemCount,
      topTags: summary.topTags,
      recentTitles: summary.recentTitles,
      isExample: collection.isExample,
      collection: collection,
    );
  }

  final UuidValue id;
  final String name;

  /// What the owner wrote about it; null when they wrote nothing.
  final String? description;
  final int coverSeed;
  final int paletteIndex;
  final int itemCount;
  final List<String> topTags;
  final List<String> recentTitles;
  final bool isExample;

  /// The server row, sent back when the collection is edited.
  final Collection? collection;

  /// "3 saves", or "No saves yet".
  String get countLabel => switch (itemCount) {
    0 => 'No saves yet',
    1 => '1 save',
    _ => '$itemCount saves',
  };

  /// The card's second line: the count and the most used tags.
  String get cardLine => [
    countLabel,
    if (topTags.isNotEmpty) topTags.map((tag) => '#$tag').join(' '),
  ].join(' · ');

  /// True when every word of [query] starts a word of the name or
  /// description, ignoring case: "ui insp" finds "UI inspiration".
  bool matches(String query) {
    final needles = _words(query);
    if (needles.isEmpty) return true;
    final haystack = _words('$name ${description ?? ''}');
    return needles.every(
      (needle) => haystack.any((word) => word.startsWith(needle)),
    );
  }

  static List<String> _words(String text) => text
      .toLowerCase()
      .split(RegExp(r'[^\p{L}\p{N}]+', unicode: true))
      .where((word) => word.isNotEmpty)
      .toList();
}

/// The account's own collections with their counts and tags, by name. A
/// signed-out app has none: sample collections are never shown as if they
/// were the user's. Refetches whenever the library changes.
final collectionsProvider =
    FutureProvider.autoDispose<List<CollectionTileData>>((ref) async {
      if (ref.watch(accountIdProvider) == null) return const [];
      ref.watch(libraryRevisionProvider);
      final summaries = await ref.watch(collectionsApiProvider).summaries();
      return summaries.map(CollectionTileData.fromSummary).toList();
    });

/// The saves in one collection, newest first.
final collectionItemsProvider = FutureProvider.autoDispose
    .family<List<Item>, UuidValue>((ref, collectionId) async {
      if (ref.watch(accountIdProvider) == null) return const [];
      ref.watch(libraryRevisionProvider);
      return ref.watch(collectionsApiProvider).items(collectionId);
    });

/// The palette fewest of [collections] use, so a new collection looks
/// different from its neighbours. The user can change it at any time.
int defaultCollectionPalette(Iterable<CollectionTileData> collections) {
  final uses = List<int>.filled(collectionPaletteCount, 0);
  for (final collection in collections) {
    final index = collection.paletteIndex;
    if (index >= 0 && index < collectionPaletteCount) uses[index]++;
  }
  var best = 0;
  for (var index = 1; index < collectionPaletteCount; index++) {
    if (uses[index] < uses[best]) best = index;
  }
  return best;
}

/// A fresh mesh layout for a new collection's cover.
int newCoverSeed([Random? random]) => (random ?? Random()).nextInt(0x7fffffff);

/// Where new cover seeds come from; tests pin it so goldens are stable.
final coverSeedProvider = Provider<int Function()>((ref) => newCoverSeed);
