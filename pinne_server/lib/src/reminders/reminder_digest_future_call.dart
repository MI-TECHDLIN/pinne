import 'package:serverpod/serverpod.dart';

import 'review_digest_service.dart';

/// Periodically materializes grouped, delivery-ready digests. The service is
/// idempotent, so Serverpod's at-least-once future-call execution is safe.
class ReminderDigestFutureCall extends FutureCall {
  Future<void> recompute(Session session) async {
    await const ReviewDigestService().recomputeAll(session);
  }
}
