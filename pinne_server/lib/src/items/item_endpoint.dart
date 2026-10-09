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
    await _scheduleEnrichment(session, result.itemId, session.ownerId);
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
        titleManuallyLocked: true,
        contentType: draft.contentType,
        intention: draft.intention,
        priority: draft.priority,
        savedAt: draft.savedAt?.toUtc() ?? DateTime.now().toUtc(),
      ),
    );
    await _scheduleEnrichment(session, item.id!, item.ownerId);
    return item;
  }

  Future<void> _scheduleEnrichment(
    Session session,
    UuidValue itemId,
    UuidValue ownerId,
  ) async {
    final item = await Item.db.findFirstRow(
      session,
      where: (t) => t.id.equals(itemId) & t.ownerId.equals(ownerId),
    );
    if (item?.url == null) {
      await _scheduleOrganizing(session, itemId, ownerId);
      return;
    }
    // Existing metadata can still be organized immediately. A successful
    // preview requests a newer AI task version with the richer evidence.
    await _scheduleOrganizing(session, itemId, ownerId);
    // Preview work is entirely detached from capture. Scheduling failures are
    // recoverable through refreshPreview and must not make a saved link fail.
    try {
      await session.serverpod.futureCalls
          .callWithDelay(Duration.zero, identifier: 'link-preview-$itemId')
          .linkPreview
          .process(itemId, ownerId);
    } catch (_) {}
  }

  /// Queues a fresh preview for one owned item. A foreign id is indistinguish-
  /// able from a missing id and the network work remains asynchronous.
  Future<Item> refreshPreview(Session session, UuidValue id) async {
    final owner = session.ownerId;
    final item = await Item.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.ownerId.equals(owner),
    );
    if (item == null) throw RecordNotFoundException(resource: 'item');
    if (item.url == null) return item;
    final queued = await Item.db.updateRow(
      session,
      item.copyWith(
        enrichmentState: EnrichmentState.pending,
        accessState: AccessState.unknown,
        previewAttemptCount: 0,
        previewStartedAt: null,
        revision: item.revision + 1,
      ),
    );
    try {
      await session.serverpod.futureCalls
          .callWithDelay(
            Duration.zero,
            identifier: 'link-preview-$id-refresh-${queued.revision}',
          )
          .linkPreview
          .process(id, owner);
    } catch (_) {}
    return queued;
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
        titleManuallyLocked:
            existing.titleManuallyLocked || item.title != existing.title,
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
