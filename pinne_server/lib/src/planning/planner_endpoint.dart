import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';
import 'planner.dart';

/// Review-session planning: preferences, propose, commit, move, cancel,
/// device calendar work and iCalendar export. See [Planner] for the rules.
class PlannerEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Planner _planner(Session session) => Planner(session, session.ownerId);

  /// The owner's planning rules; defaults have a null id until saved.
  Future<PlannerPreferences> preferences(Session session) =>
      _planner(session).preferences();

  Future<PlannerPreferences> savePreferences(
    Session session,
    PlannerPreferencesDraft draft,
  ) => _planner(session).savePreferences(draft);

  /// Proposes sessions in free time. Nothing is scheduled or written.
  Future<PlanProposal> propose(Session session, PlanRequest request) =>
      _planner(session).propose(request);

  Future<PlanProposal?> currentProposal(Session session) =>
      _planner(session).currentProposal();

  /// Accepts a plan after checking availability again. Safe to retry with
  /// the same operation id.
  Future<PlanCommitResult> commit(Session session, PlanCommitRequest request) =>
      _planner(session).commit(request);

  /// Scheduled sessions overlapping `[from, to)`.
  Future<List<SessionView>> sessions(
    Session session,
    DateTime from,
    DateTime to,
  ) => _planner(session).sessions(from, to);

  Future<SessionChangeResult> moveSession(
    Session session,
    SessionMoveRequest request,
  ) => _planner(session).move(request);

  Future<SessionChangeResult> cancelSession(
    Session session,
    UuidValue sessionId,
    UuidValue operationId,
    UuidValue? deviceId,
  ) => _planner(session).cancel(sessionId, operationId, deviceId);

  /// Calendar events this device should create, move, remove or check.
  Future<List<CalendarWrite>> deviceWork(Session session, UuidValue deviceId) =>
      _planner(session).deviceWork(deviceId);

  Future<void> reportWrites(
    Session session,
    List<CalendarWriteResult> results,
  ) => _planner(session).reportWrites(results);

  /// An export-only `.ics` file: a copy to import, not a live sync, and not
  /// proof of free time.
  Future<String> exportIcs(Session session, List<UuidValue> sessionIds) =>
      _planner(session).exportIcs(sessionIds);
}
