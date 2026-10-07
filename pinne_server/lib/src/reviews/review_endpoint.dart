import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';
import 'review_service.dart';

class ReviewEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final ReviewService _service = const ReviewService();

  Future<ReviewEventReceipt> record(
    Session session,
    ReviewEventDraft draft,
  ) => _service.record(session, session.ownerId, draft);

  Future<ItemProgress?> progress(Session session, UuidValue itemId) {
    final owner = session.ownerId;
    return ItemProgress.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(owner) & t.itemId.equals(itemId),
    );
  }
}
