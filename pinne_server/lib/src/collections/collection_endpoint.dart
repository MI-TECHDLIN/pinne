import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';
import 'collection_contents.dart';

/// Owner-scoped CRUD for collections. A parent must belong to the same owner
/// and must not make the tree cyclic. Names are trimmed and unique per owner,
/// ignoring case.
class CollectionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const maxDepth = 8;
  static const maxCoverSeed = 0x7fffffff;
  static const allowedPaletteIndexes = {0, 1, 2, 3, 4};
  static const maxNameLength = 60;
  static const maxDescriptionLength = 200;

  Future<List<Collection>> list(Session session) async {
    final owner = session.ownerId;
    return Collection.db.find(
      session,
      where: (t) => t.ownerId.equals(owner),
      orderBy: (t) => t.name,
    );
  }

  Future<Collection?> get(Session session, UuidValue id) async {
    final owner = session.ownerId;
    return Collection.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.ownerId.equals(owner),
    );
  }

  /// Every collection with what its card shows, sorted by name.
  Future<List<CollectionSummary>> summaries(Session session) async {
    final contents = await loadCollectionContents(
      session,
      ownerId: session.ownerId,
      perCollection: 20,
    );
    return [
      for (final entry in contents)
        CollectionSummary(
          collection: entry.collection,
          itemCount: entry.itemCount,
          topTags: _topTags(entry),
          recentTitles: [for (final item in entry.items.take(3)) item.title],
        ),
    ];
  }

  /// The saves in one of the owner's collections, newest first.
  Future<List<Item>> items(Session session, UuidValue collectionId) async {
    final owner = session.ownerId;
    if (await get(session, collectionId) == null) {
      throw RecordNotFoundException(resource: 'collection');
    }
    final memberships = await ItemCollection.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(owner) & t.collectionId.equals(collectionId),
    );
    if (memberships.isEmpty) return const [];
    return Item.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.id.inSet(<UuidValue>{for (final row in memberships) row.itemId}),
      orderByList: (t) => [t.savedAt.desc(), t.id.desc()],
    );
  }

  /// Takes an item out of a collection. The item itself stays saved.
  Future<bool> removeItem(
    Session session,
    UuidValue collectionId,
    UuidValue itemId,
  ) async {
    final owner = session.ownerId;
    final removed = await ItemCollection.db.deleteWhere(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.collectionId.equals(collectionId) &
          t.itemId.equals(itemId),
    );
    return removed.isNotEmpty;
  }

  Future<Collection> create(Session session, CollectionDraft draft) async {
    _validateCover(
      coverSeed: draft.coverSeed,
      paletteIndex: draft.paletteIndex,
    );
    final name = await _uniqueName(session, draft.name, collectionId: null);
    await _checkParent(session, collectionId: null, parentId: draft.parentId);
    return Collection.db.insertRow(
      session,
      Collection(
        ownerId: session.ownerId,
        name: name,
        description: _description(draft.description),
        parentId: draft.parentId,
        coverSeed: draft.coverSeed,
        paletteIndex: draft.paletteIndex,
      ),
    );
  }

  Future<Collection> update(Session session, Collection collection) async {
    final id = collection.id;
    final existing = id == null ? null : await get(session, id);
    if (existing == null) {
      throw RecordNotFoundException(resource: 'collection');
    }
    _validateCover(
      coverSeed: collection.coverSeed,
      paletteIndex: collection.paletteIndex,
    );
    final name = await _uniqueName(session, collection.name, collectionId: id);
    await _checkParent(
      session,
      collectionId: id,
      parentId: collection.parentId,
    );
    return Collection.db.updateRow(
      session,
      existing.copyWith(
        name: name,
        description: _description(collection.description),
        parentId: collection.parentId,
        coverSeed: collection.coverSeed,
        paletteIndex: collection.paletteIndex,
      ),
    );
  }

  /// Deletes the collection only. Its saves stay, just outside it.
  Future<bool> delete(Session session, UuidValue id) async {
    final owner = session.ownerId;
    final deleted = await Collection.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id) & t.ownerId.equals(owner),
    );
    return deleted.isNotEmpty;
  }

  /// The trimmed [name], refused when empty, too long, or already used by
  /// another of the owner's collections in any letter case.
  Future<String> _uniqueName(
    Session session,
    String name, {
    required UuidValue? collectionId,
  }) async {
    final trimmed = name.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmed.isEmpty) {
      throw ValidationException(message: 'Give the collection a name.');
    }
    if (trimmed.length > maxNameLength) {
      throw ValidationException(
        message: 'Collection names can be up to $maxNameLength characters.',
      );
    }
    final key = collectionNameKey(trimmed);
    final owned = await Collection.db.find(
      session,
      where: (t) => t.ownerId.equals(session.ownerId),
    );
    if (owned.any(
      (other) =>
          other.id != collectionId && collectionNameKey(other.name) == key,
    )) {
      throw ValidationException(
        message: 'You already have a collection called "$trimmed".',
      );
    }
    return trimmed;
  }

  String? _description(String? description) {
    final trimmed = description?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (trimmed.length > maxDescriptionLength) {
      throw ValidationException(
        message: 'Descriptions can be up to $maxDescriptionLength characters.',
      );
    }
    return trimmed;
  }

  static List<String> _topTags(CollectionContents contents) {
    final counts = <String, int>{};
    for (final item in contents.items) {
      for (final tag in contents.tagsOf(item)) {
        counts[tag] = (counts[tag] ?? 0) + 1;
      }
    }
    final ranked = counts.keys.toList()
      ..sort((a, b) {
        final byCount = counts[b]!.compareTo(counts[a]!);
        return byCount != 0 ? byCount : a.compareTo(b);
      });
    return ranked.take(3).toList();
  }

  void _validateCover({required int coverSeed, required int paletteIndex}) {
    if (coverSeed < 0 || coverSeed > maxCoverSeed) {
      throw ValidationException(
        message: 'Cover seed must be between 0 and $maxCoverSeed.',
      );
    }
    if (!allowedPaletteIndexes.contains(paletteIndex)) {
      throw ValidationException(message: 'Unknown collection cover palette.');
    }
  }

  /// Walks up from [parentId] and rejects foreign parents, cycles through
  /// [collectionId] and trees deeper than [maxDepth].
  Future<void> _checkParent(
    Session session, {
    required UuidValue? collectionId,
    required UuidValue? parentId,
  }) async {
    var cursor = parentId;
    var depth = 0;
    while (cursor != null) {
      if (cursor == collectionId) {
        throw ValidationException(
          message: 'A collection cannot be inside itself.',
        );
      }
      if (++depth >= maxDepth) {
        throw ValidationException(message: 'Collections nest too deeply.');
      }
      final parent = await get(session, cursor);
      if (parent == null) {
        throw RecordNotFoundException(resource: 'collection');
      }
      cursor = parent.parentId;
    }
  }
}
