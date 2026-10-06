import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';

/// Owner-scoped CRUD for saved items. Every query filters on the signed-in
/// owner, so another user's ids behave exactly like missing ids.
///
/// Capture enrichment, duplicate resolution and search are later features.
class ItemEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const defaultPageSize = 50;
  static const maxPageSize = 100;

  /// Newest first. [before] is the `savedAt` of the last item on the previous
  /// page.
  Future<List<Item>> list(
    Session session, {
    int? limit,
    DateTime? before,
  }) async {
    final owner = session.ownerId;
    return Item.db.find(
      session,
      where: (t) {
        final mine = t.ownerId.equals(owner);
        return before == null ? mine : mine & (t.savedAt < before);
      },
      orderByList: (t) => [t.savedAt.desc(), t.id.desc()],
      limit: (limit ?? defaultPageSize).clamp(1, maxPageSize),
    );
  }

  Future<Item?> get(Session session, UuidValue id) async {
    final owner = session.ownerId;
    return Item.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.ownerId.equals(owner),
    );
  }

  Future<Item> create(Session session, ItemDraft draft) async {
    return Item.db.insertRow(
      session,
      Item(
        ownerId: session.ownerId,
        url: draft.url,
        sourcePlatform: draft.sourcePlatform,
        title: draft.title,
        contentType: draft.contentType,
        intention: draft.intention,
        priority: draft.priority,
        savedAt: draft.savedAt?.toUtc() ?? DateTime.now().toUtc(),
      ),
    );
  }

  /// Applies the user-editable fields of [item]. The stored owner, saved time
  /// and canonical URL are kept. Fails when [item] carries a stale revision.
  Future<Item> update(Session session, Item item) async {
    final id = item.id;
    final existing = id == null ? null : await get(session, id);
    if (existing == null) throw RecordNotFoundException(resource: 'item');
    if (existing.revision != item.revision) {
      throw ValidationException(
        message: 'Item changed elsewhere; reload and try again.',
      );
    }
    return Item.db.updateRow(
      session,
      existing.copyWith(
        url: item.url,
        sourcePlatform: item.sourcePlatform,
        title: item.title,
        contentType: item.contentType,
        intention: item.intention,
        priority: item.priority,
        lifecycle: item.lifecycle,
        revision: existing.revision + 1,
      ),
    );
  }

  /// Returns false when there was nothing of the owner's to delete.
  Future<bool> delete(Session session, UuidValue id) async {
    final owner = session.ownerId;
    final deleted = await Item.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id) & t.ownerId.equals(owner),
    );
    return deleted.isNotEmpty;
  }
}
