import '../ai/ai_organization_service.dart';
import '../auth/owner.dart';
import '../generated/protocol.dart';
import '../generated/serverpod.dart';
import 'item_capture.dart';

/// Owner-scoped CRUD for saved items. Every query filters on the signed-in
/// owner, so another user's ids behave exactly like missing ids.
///
/// Enrichment and search are later features.
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

  /// Saves a shared or pasted link or note. Safe to retry with the same
  /// operation id. A recognised duplicate returns the existing item with
  /// `duplicate` set; its notes, collections and first `savedAt` are kept.
  /// The answer never waits for enrichment, which starts as `pending`.
  Future<CaptureResult> capture(Session session, CaptureDraft draft) async {
    final result = await ItemCapture(session, session.ownerId).capture(draft);
    await _scheduleOrganizing(
      session,
      result.itemId,
      session.ownerId,
    );
    return result;
  }

  Future<Item> create(Session session, ItemDraft draft) async {
    final item = await Item.db.insertRow(
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
    await _scheduleOrganizing(
      session,
      item.id!,
      item.ownerId,
    );
    return item;
  }

  Future<void> _scheduleOrganizing(
    Session session,
    UuidValue itemId,
    UuidValue ownerId,
  ) async {
    // Organizing is background work. Configuration, scheduling, or provider
    // failures must never turn a successful save into a failed save.
    try {
      await AiOrganizationService.instance.ensureQueued(
        session,
        ownerId: ownerId,
        itemId: itemId,
      );
      await session.serverpod.futureCalls
          .callWithDelay(Duration.zero, identifier: 'ai-organize-$itemId')
          .aiOrganize
          .process(itemId, ownerId);
    } catch (_) {
      // The explicit reprocess endpoint can enqueue it again later.
    }
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
