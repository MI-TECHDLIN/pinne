import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';
import 'review_queue_service.dart';

class ReviewQueueEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final ReviewQueueService _service = const ReviewQueueService();

  Future<ReviewQueueResult> get(
    Session session, {
    required int timeBudgetMinutes,
  }) => _service.build(
    session,
    ownerId: session.ownerId,
    timeBudgetMinutes: timeBudgetMinutes,
  );

  Future<ItemReviewControl> snooze(
    Session session,
    UuidValue itemId,
    DateTime until,
  ) => _service.snooze(session, session.ownerId, itemId, until);

  Future<ItemReviewControl> pause(
    Session session,
    UuidValue itemId,
    bool paused,
  ) => _service.pause(session, session.ownerId, itemId, paused);

  Future<Item> archive(Session session, UuidValue itemId) =>
      _service.archive(session, session.ownerId, itemId);

  Future<ReminderSettings> settings(Session session) =>
      _service.getSettings(session, session.ownerId);

  Future<ReminderSettings> updateSettings(
    Session session,
    ReminderSettingsDraft draft,
  ) => _service.saveSettings(session, session.ownerId, draft);
}
