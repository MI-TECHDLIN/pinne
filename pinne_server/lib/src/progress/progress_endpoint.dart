import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';
import 'progress_service.dart';

class ProgressEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final ProgressService _service = const ProgressService();

  Future<ProgressReport> report(Session session, ProgressQuery query) =>
      _service.report(session, session.ownerId, query);

  /// Marks milestone celebrations as seen so each one shows exactly once.
  Future<void> markCelebrated(Session session, List<String> keys) =>
      _service.markCelebrated(session, session.ownerId, keys);

  Future<ProgressSettings> settings(Session session) =>
      _service.getSettings(session, session.ownerId);

  Future<ProgressSettings> updateSettings(
    Session session,
    ProgressSettingsDraft draft,
  ) => _service.saveSettings(session, session.ownerId, draft);
}
