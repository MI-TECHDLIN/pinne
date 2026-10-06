import 'package:pinne_client/pinne_client.dart';

/// The planner and calendar endpoints, behind an interface so tests can use
/// a fake server.
abstract interface class PlannerApi {
  Future<List<CalendarRouteStatus>> routes();
  Future<List<CalendarConnectionView>> connections();
  Future<CalendarConnectionView> syncDeviceCalendars(
    DeviceCalendarReport report,
  );
  Future<List<CalendarConnectionView>> setSelections(
    UuidValue connectionId,
    List<CalendarSelectionChoice> choices,
  );
  Future<PlannerPreferences> preferences();
  Future<PlannerPreferences> savePreferences(PlannerPreferencesDraft draft);
  Future<PlanProposal> propose(PlanRequest request);
  Future<PlanProposal?> currentProposal();
  Future<PlanCommitResult> commit(PlanCommitRequest request);
  Future<List<SessionView>> sessions(DateTime from, DateTime to);
  Future<SessionChangeResult> moveSession(SessionMoveRequest request);
  Future<SessionChangeResult> cancelSession(
    UuidValue sessionId,
    UuidValue operationId,
    UuidValue? deviceId,
  );
  Future<List<CalendarWrite>> deviceWork(UuidValue deviceId);
  Future<void> reportWrites(List<CalendarWriteResult> results);
  Future<String> exportIcs(List<UuidValue> sessionIds);
}

class ServerPlannerApi implements PlannerApi {
  ServerPlannerApi(this._client);

  final Client _client;

  @override
  Future<List<CalendarRouteStatus>> routes() => _client.calendar.routes();

  @override
  Future<List<CalendarConnectionView>> connections() =>
      _client.calendar.connections();

  @override
  Future<CalendarConnectionView> syncDeviceCalendars(
    DeviceCalendarReport report,
  ) => _client.calendar.syncDeviceCalendars(report);

  @override
  Future<List<CalendarConnectionView>> setSelections(
    UuidValue connectionId,
    List<CalendarSelectionChoice> choices,
  ) => _client.calendar.setSelections(connectionId, choices);

  @override
  Future<PlannerPreferences> preferences() => _client.planner.preferences();

  @override
  Future<PlannerPreferences> savePreferences(PlannerPreferencesDraft draft) =>
      _client.planner.savePreferences(draft);

  @override
  Future<PlanProposal> propose(PlanRequest request) =>
      _client.planner.propose(request);

  @override
  Future<PlanProposal?> currentProposal() => _client.planner.currentProposal();

  @override
  Future<PlanCommitResult> commit(PlanCommitRequest request) =>
      _client.planner.commit(request);

  @override
  Future<List<SessionView>> sessions(DateTime from, DateTime to) =>
      _client.planner.sessions(from, to);

  @override
  Future<SessionChangeResult> moveSession(SessionMoveRequest request) =>
      _client.planner.moveSession(request);

  @override
  Future<SessionChangeResult> cancelSession(
    UuidValue sessionId,
    UuidValue operationId,
    UuidValue? deviceId,
  ) => _client.planner.cancelSession(sessionId, operationId, deviceId);

  @override
  Future<List<CalendarWrite>> deviceWork(UuidValue deviceId) =>
      _client.planner.deviceWork(deviceId);

  @override
  Future<void> reportWrites(List<CalendarWriteResult> results) =>
      _client.planner.reportWrites(results);

  @override
  Future<String> exportIcs(List<UuidValue> sessionIds) =>
      _client.planner.exportIcs(sessionIds);
}
