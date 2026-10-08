import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Records immutable review facts and rebuilds the disposable progress view.
class ReviewService {
  const ReviewService();

  Future<ReviewEventReceipt> record(
    Session session,
    UuidValue ownerId,
    ReviewEventDraft draft,
  ) {
    _validate(draft);
    return session.db.transaction((transaction) async {
      // The owned item is the serialization point for both retries and
      // different events that rebuild the same progress projection.
      await _ownedItemForUpdate(
        session,
        ownerId,
        draft.itemId,
        transaction,
      );
      final existing = await ReviewEvent.db.findFirstRow(
        session,
        where: (t) =>
            t.ownerId.equals(ownerId) &
            t.clientEventId.equals(draft.clientEventId.trim()),
        transaction: transaction,
      );
      if (existing != null) {
        if (!_sameEvent(existing, draft)) {
          throw ValidationException(
            message: 'That client event id was already used for another event.',
          );
        }
        final progress = await _rebuild(
          session,
          ownerId,
          draft.itemId,
          transaction,
        );
        return ReviewEventReceipt(event: existing, progress: progress);
      }

      ReviewEvent? compensated;
      if (draft.eventType == ReviewEventType.undo) {
        compensated = await ReviewEvent.db.findFirstRow(
          session,
          where: (t) =>
              t.id.equals(draft.compensatesEventId!) &
              t.ownerId.equals(ownerId) &
              t.itemId.equals(draft.itemId),
          transaction: transaction,
        );
        if (compensated == null ||
            compensated.eventType == ReviewEventType.undo) {
          throw RecordNotFoundException(resource: 'review event');
        }
        final priorUndo = await ReviewEvent.db.findFirstRow(
          session,
          where: (t) =>
              t.ownerId.equals(ownerId) &
              t.compensatesEventId.equals(compensated!.id!),
          transaction: transaction,
        );
        if (priorUndo != null) {
          throw ValidationException(
            message: 'That event has already been undone.',
          );
        }
      }

      final occurredAt = draft.occurredAt.toUtc();
      final local = occurredAt.add(
        Duration(minutes: draft.timezoneOffsetMinutes),
      );
      final event = await ReviewEvent.db.insertRow(
        session,
        ReviewEvent(
          ownerId: ownerId,
          itemId: draft.itemId,
          clientEventId: draft.clientEventId.trim(),
          eventType: draft.eventType,
          occurredAt: occurredAt,
          timezone: draft.timezone.trim(),
          effectiveLocalDate: _date(local),
          compensatesEventId: compensated?.id,
        ),
        transaction: transaction,
      );
      final progress = await _rebuild(
        session,
        ownerId,
        draft.itemId,
        transaction,
      );
      return ReviewEventReceipt(event: event, progress: progress);
    });
  }

  Future<ItemProgress> rebuild(
    Session session,
    UuidValue ownerId,
    UuidValue itemId,
  ) => session.db.transaction(
    (transaction) => _rebuild(session, ownerId, itemId, transaction),
  );

  Future<ItemProgress> _rebuild(
    Session session,
    UuidValue ownerId,
    UuidValue itemId,
    Transaction transaction,
  ) async {
    final events = await ReviewEvent.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.itemId.equals(itemId),
      orderByList: (t) => [t.occurredAt, t.id],
      transaction: transaction,
    );
    final valid = validEvents(events);

    DateTime? firstOpened;
    DateTime? lastOpened;
    DateTime? firstReviewed;
    DateTime? lastReviewed;
    DateTime? completed;
    DateTime? applied;
    var openCount = 0;
    for (final event in valid) {
      switch (event.eventType) {
        case ReviewEventType.opened:
          openCount++;
          firstOpened ??= event.occurredAt;
          lastOpened = event.occurredAt;
        case ReviewEventType.reviewed:
          firstReviewed ??= event.occurredAt;
          lastReviewed = event.occurredAt;
        case ReviewEventType.completed:
          completed ??= event.occurredAt;
          firstReviewed ??= event.occurredAt;
          lastReviewed = event.occurredAt;
        case ReviewEventType.applied:
          applied ??= event.occurredAt;
          firstReviewed ??= event.occurredAt;
          lastReviewed = event.occurredAt;
        case ReviewEventType.undo:
          break;
      }
    }

    await ItemProgress.db.deleteWhere(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.itemId.equals(itemId),
      transaction: transaction,
    );
    return ItemProgress.db.insertRow(
      session,
      ItemProgress(
        ownerId: ownerId,
        itemId: itemId,
        firstOpenedAt: firstOpened,
        lastOpenedAt: lastOpened,
        openCount: openCount,
        firstReviewedAt: firstReviewed,
        lastReviewedAt: lastReviewed,
        completedAt: completed,
        appliedAt: applied,
        rebuiltAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
  }

  /// The events that still stand: undo events and the events they
  /// compensate are dropped. Order is preserved.
  static Iterable<ReviewEvent> validEvents(Iterable<ReviewEvent> events) {
    final compensatedIds = events
        .where((event) => event.eventType == ReviewEventType.undo)
        .map((event) => event.compensatesEventId)
        .whereType<UuidValue>()
        .toSet();
    return events.where(
      (event) =>
          event.eventType != ReviewEventType.undo &&
          !compensatedIds.contains(event.id),
    );
  }

  /// Whether an event counts as reviewing its item. Opening never does.
  static bool qualifies(ReviewEventType type) => switch (type) {
    ReviewEventType.reviewed ||
    ReviewEventType.completed ||
    ReviewEventType.applied => true,
    ReviewEventType.opened || ReviewEventType.undo => false,
  };

  static void _validate(ReviewEventDraft draft) {
    final clientId = draft.clientEventId.trim();
    if (clientId.isEmpty || clientId.length > 120) {
      throw ValidationException(
        message: 'A valid client event id is required.',
      );
    }
    if (draft.timezone.trim().isEmpty || draft.timezone.length > 80) {
      throw ValidationException(message: 'A timezone is required.');
    }
    if (draft.timezoneOffsetMinutes < -840 ||
        draft.timezoneOffsetMinutes > 840) {
      throw ValidationException(message: 'Timezone offset is out of range.');
    }
    final undo = draft.eventType == ReviewEventType.undo;
    if (undo != (draft.compensatesEventId != null)) {
      throw ValidationException(
        message: undo
            ? 'Undo must identify the event it compensates.'
            : 'Only undo can compensate another event.',
      );
    }
  }

  static bool _sameEvent(ReviewEvent event, ReviewEventDraft draft) =>
      event.itemId == draft.itemId &&
      event.eventType == draft.eventType &&
      event.occurredAt == draft.occurredAt.toUtc() &&
      event.timezone == draft.timezone.trim() &&
      event.compensatesEventId == draft.compensatesEventId;

  static Future<Item> _ownedItemForUpdate(
    Session session,
    UuidValue ownerId,
    UuidValue itemId,
    Transaction transaction,
  ) async {
    final item = await Item.db.findFirstRow(
      session,
      where: (t) => t.id.equals(itemId) & t.ownerId.equals(ownerId),
      transaction: transaction,
      lockMode: LockMode.forUpdate,
    );
    if (item == null) throw RecordNotFoundException(resource: 'item');
    return item;
  }

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
