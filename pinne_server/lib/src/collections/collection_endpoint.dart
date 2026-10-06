import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';

/// Owner-scoped CRUD for collections. A parent must belong to the same owner
/// and must not make the tree cyclic.
class CollectionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const maxDepth = 8;

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

  Future<Collection> create(Session session, CollectionDraft draft) async {
    await _checkParent(session, collectionId: null, parentId: draft.parentId);
    return Collection.db.insertRow(
      session,
      Collection(
        ownerId: session.ownerId,
        name: draft.name,
        description: draft.description,
        parentId: draft.parentId,
      ),
    );
  }

  Future<Collection> update(Session session, Collection collection) async {
    final id = collection.id;
    final existing = id == null ? null : await get(session, id);
    if (existing == null) {
      throw RecordNotFoundException(resource: 'collection');
    }
    await _checkParent(
      session,
      collectionId: id,
      parentId: collection.parentId,
    );
    return Collection.db.updateRow(
      session,
      existing.copyWith(
        name: collection.name,
        description: collection.description,
        parentId: collection.parentId,
      ),
    );
  }

  Future<bool> delete(Session session, UuidValue id) async {
    final owner = session.ownerId;
    final deleted = await Collection.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id) & t.ownerId.equals(owner),
    );
    return deleted.isNotEmpty;
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
