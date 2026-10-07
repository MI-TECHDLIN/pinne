import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Chooses which saved items fill planned sessions.
///
/// This is the seam for the review queue: when it lands, a queue-backed
/// source replaces [UnreviewedItemSource] without touching the planner.
abstract interface class SessionItemSource {
  /// Up to [limit] of the owner's items worth a session, best first.
  Future<List<Item>> candidates(
    Session session,
    UuidValue owner, {
    required int limit,
    required Set<UuidValue> exclude,
    Transaction? transaction,
  });
}

/// Active items with no valid review yet, highest priority and oldest first.
///
/// A review is valid when a reviewed, completed or applied event exists that
/// no undo event compensates. Opening alone never counts.
class UnreviewedItemSource implements SessionItemSource {
  const UnreviewedItemSource();

  static const _scan = 200;

  static const _qualifying = {
    ReviewEventType.reviewed,
    ReviewEventType.completed,
    ReviewEventType.applied,
  };

  @override
  Future<List<Item>> candidates(
    Session session,
    UuidValue owner, {
    required int limit,
    required Set<UuidValue> exclude,
    Transaction? transaction,
  }) async {
    if (limit <= 0) return const [];
    final items = await Item.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(owner) & t.lifecycle.equals(ItemLifecycle.active),
      orderByList: (t) => [t.priority.desc(), t.savedAt.asc(), t.id.asc()],
      limit: _scan,
      transaction: transaction,
    );
    final open = [
      for (final item in items)
        if (!exclude.contains(item.id)) item,
    ];
    if (open.isEmpty) return const [];

    final events = await ReviewEvent.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.itemId.inSet({for (final item in open) item.id!}) &
          t.eventType.inSet({..._qualifying, ReviewEventType.undo}),
      transaction: transaction,
    );
    final undone = {
      for (final e in events)
        if (e.eventType == ReviewEventType.undo && e.compensatesEventId != null)
          e.compensatesEventId!,
    };
    final reviewed = {
      for (final e in events)
        if (_qualifying.contains(e.eventType) && !undone.contains(e.id))
          e.itemId,
    };
    return [
      for (final item in open)
        if (!reviewed.contains(item.id)) item,
    ].take(limit).toList();
  }
}
