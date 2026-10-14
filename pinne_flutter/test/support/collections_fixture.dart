import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/features/collections/collections_providers.dart';

final _owner = UuidValue.fromString('00000000-0000-4000-8000-000000000001');

UuidValue fixtureId(int n) => UuidValue.fromString(
  '00000000-0000-4000-8000-${n.toRadixString(16).padLeft(12, '0')}',
);

CollectionSummary fixtureSummary({
  required int n,
  required String name,
  String? description,
  int paletteIndex = 0,
  int coverSeed = 1847,
  int itemCount = 0,
  List<String> topTags = const [],
  List<String> recentTitles = const [],
}) => CollectionSummary(
  collection: Collection(
    id: fixtureId(n),
    ownerId: _owner,
    name: name,
    description: description,
    coverSeed: coverSeed,
    paletteIndex: paletteIndex,
  ),
  itemCount: itemCount,
  topTags: topTags,
  recentTitles: recentTitles,
);

/// A believable account's collections, for goldens and contrast checks.
final fixtureSummaries = [
  fixtureSummary(
    n: 0xc01,
    name: 'UI inspiration',
    description: 'Screens and interfaces I like.',
    coverSeed: 1847,
    paletteIndex: 0,
    itemCount: 12,
    topTags: ['design', 'dribbble'],
    recentTitles: ['Fintech dashboard concept'],
  ),
  fixtureSummary(
    n: 0xc02,
    name: 'Flutter tips',
    coverSeed: 90210,
    paletteIndex: 2,
    itemCount: 8,
    topTags: ['flutter'],
  ),
  fixtureSummary(
    n: 0xc03,
    name: 'Cooking',
    coverSeed: 7331,
    paletteIndex: 1,
    itemCount: 1,
    topTags: ['recipe'],
  ),
  fixtureSummary(
    n: 0xc04,
    name: 'Reading list',
    coverSeed: 24680,
    paletteIndex: 3,
  ),
];

List<CollectionTileData> get fixtureTiles =>
    fixtureSummaries.map(CollectionTileData.fromSummary).toList();

Item fixtureItem(int n, String title, {String? site, String? summary}) => Item(
  id: fixtureId(0x1000 + n),
  ownerId: _owner,
  title: title,
  url: 'https://example.com/$n',
  previewSiteName: site,
  summary: summary,
  savedAt: DateTime.utc(2026, 10, n),
);

/// A [CollectionsApi] kept in memory, so screens can create, edit, delete
/// and fill collections as they would against the server.
class FakeCollectionsApi implements CollectionsApi {
  FakeCollectionsApi([List<CollectionSummary>? summaries])
    : summariesList = [...?summaries];

  final List<CollectionSummary> summariesList;
  final itemsById = <UuidValue, List<Item>>{};
  var _next = 0xd00;
  int summaryCalls = 0;
  final created = <CollectionDraft>[];

  @override
  Future<List<CollectionSummary>> summaries() async {
    summaryCalls++;
    return [
      for (final summary in summariesList)
        summary.copyWith(
          itemCount:
              itemsById[summary.collection.id]?.length ?? summary.itemCount,
        ),
    ]..sort((a, b) => a.collection.name.compareTo(b.collection.name));
  }

  @override
  Future<List<Item>> items(UuidValue collectionId) async => [
    ...?itemsById[collectionId],
  ];

  void _checkName(String name, UuidValue? except) {
    final key = name.trim().toLowerCase();
    if (summariesList.any(
      (s) =>
          s.collection.id != except && s.collection.name.toLowerCase() == key,
    )) {
      throw ValidationException(
        message: 'You already have a collection called "${name.trim()}".',
      );
    }
  }

  @override
  Future<Collection> create(CollectionDraft draft) async {
    _checkName(draft.name, null);
    created.add(draft);
    final collection = Collection(
      id: fixtureId(_next++),
      ownerId: _owner,
      name: draft.name.trim(),
      description: draft.description,
      coverSeed: draft.coverSeed,
      paletteIndex: draft.paletteIndex,
    );
    summariesList.add(
      CollectionSummary(
        collection: collection,
        itemCount: 0,
        topTags: const [],
        recentTitles: const [],
      ),
    );
    return collection;
  }

  @override
  Future<Collection> update(Collection collection) async {
    _checkName(collection.name, collection.id);
    final index = summariesList.indexWhere(
      (s) => s.collection.id == collection.id,
    );
    if (index < 0) throw RecordNotFoundException(resource: 'collection');
    summariesList[index] = summariesList[index].copyWith(
      collection: collection.copyWith(name: collection.name.trim()),
    );
    return summariesList[index].collection;
  }

  @override
  Future<void> delete(UuidValue collectionId) async {
    summariesList.removeWhere((s) => s.collection.id == collectionId);
    itemsById.remove(collectionId);
  }

  @override
  Future<void> removeItem(UuidValue collectionId, UuidValue itemId) async {
    itemsById[collectionId]?.removeWhere((item) => item.id == itemId);
  }

  /// What accepting "Collection: X" does on the server.
  void file(UuidValue collectionId, Item item) {
    itemsById.putIfAbsent(collectionId, () => []).insert(0, item);
  }
}
