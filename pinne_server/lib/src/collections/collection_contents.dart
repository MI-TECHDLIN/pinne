import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// One collection with its newest saves and their tag names.
class CollectionContents {
  const CollectionContents({
    required this.collection,
    required this.itemCount,
    required this.items,
    required this.tagsByItem,
  });

  final Collection collection;

  /// Every save in the collection, including ones [items] leaves out.
  final int itemCount;

  /// The most recently added saves, newest first.
  final List<Item> items;
  final Map<UuidValue, List<String>> tagsByItem;

  List<String> tagsOf(Item item) => tagsByItem[item.id] ?? const [];
}

/// Loads [ownerId]'s collections, each with up to [perCollection] of its most
/// recently added saves. [excludeItemId] is left out of every collection's
/// items (but still counted), so an item is never compared with itself.
///
/// Every query filters on the owner, so memberships can only reach the
/// owner's own items and tags.
Future<List<CollectionContents>> loadCollectionContents(
  Session session, {
  required UuidValue ownerId,
  int perCollection = 10,
  UuidValue? excludeItemId,
}) async {
  final collections = await Collection.db.find(
    session,
    where: (t) => t.ownerId.equals(ownerId),
    orderBy: (t) => t.name,
  );
  if (collections.isEmpty) return const [];
  // Membership ids are UUIDv7, so the newest additions sort last.
  final memberships = await ItemCollection.db.find(
    session,
    where: (t) => t.ownerId.equals(ownerId),
    orderByList: (t) => [t.id.desc()],
  );
  final counts = <UuidValue, int>{};
  final newest = <UuidValue, List<UuidValue>>{};
  for (final membership in memberships) {
    final collectionId = membership.collectionId;
    counts[collectionId] = (counts[collectionId] ?? 0) + 1;
    if (membership.itemId == excludeItemId) continue;
    final ids = newest.putIfAbsent(collectionId, () => []);
    if (ids.length < perCollection) ids.add(membership.itemId);
  }
  final itemIds = {for (final ids in newest.values) ...ids};
  final items = itemIds.isEmpty
      ? const <Item>[]
      : await Item.db.find(
          session,
          where: (t) => t.ownerId.equals(ownerId) & t.id.inSet(itemIds),
        );
  final itemsById = {for (final item in items) item.id!: item};
  final tagsByItem = <UuidValue, List<String>>{};
  if (itemIds.isNotEmpty) {
    final itemTags = await ItemTag.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.itemId.inSet(itemIds),
    );
    final tagIds = {for (final itemTag in itemTags) itemTag.tagId};
    final tags = tagIds.isEmpty
        ? const <Tag>[]
        : await Tag.db.find(
            session,
            where: (t) => t.ownerId.equals(ownerId) & t.id.inSet(tagIds),
          );
    final names = {for (final tag in tags) tag.id!: tag.displayName};
    for (final itemTag in itemTags) {
      final name = names[itemTag.tagId];
      if (name == null) continue;
      tagsByItem.putIfAbsent(itemTag.itemId, () => []).add(name);
    }
  }
  return [
    for (final collection in collections)
      CollectionContents(
        collection: collection,
        itemCount: counts[collection.id] ?? 0,
        items: [
          for (final id in newest[collection.id] ?? const <UuidValue>[])
            ?itemsById[id],
        ],
        tagsByItem: tagsByItem,
      ),
  ];
}

/// The collection names an owner already uses, compared without case or
/// surrounding space.
String collectionNameKey(String name) =>
    name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

/// The cover palette fewest of [collections] use, so a new collection looks
/// different from its neighbours. Ties go to the lowest index.
int leastUsedPalette(Iterable<Collection> collections, int paletteCount) {
  final uses = List<int>.filled(paletteCount, 0);
  for (final collection in collections) {
    final index = collection.paletteIndex;
    if (index >= 0 && index < paletteCount) uses[index]++;
  }
  var best = 0;
  for (var index = 1; index < paletteCount; index++) {
    if (uses[index] < uses[best]) best = index;
  }
  return best;
}
