import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/features/planner/planner_api.dart';

/// A planner server in memory. It verifies a plan only when every conflict
/// calendar arrives with a readable snapshot, like the real one.
class FakePlannerApi implements PlannerApi {
  FakePlannerApi({this.conflictCalendars = true});

  bool conflictCalendars;
  final commits = <PlanCommitRequest>[];
  final proposeRequests = <PlanRequest>[];
  final exported = <List<UuidValue>>[];
  final reported = <CalendarWriteResult>[];
  final scheduled = <SessionView>[];
  PlanProposal? current;
  CalendarConnectionView? phone;

  PlannerPreferences prefs = PlannerPreferences(
    id: const Uuid().v4obj(),
    ownerId: const Uuid().v4obj(),
    horizon: PlanHorizon.week,
    weekdays: const [1, 2, 3, 4, 5, 6, 7],
    windowStartMinute: 18 * 60,
    windowEndMinute: 21 * 60,
    sessionMinutes: 15,
    maxSessions: 3,
    bufferMinutes: 10,
    minLeadMinutes: 60,
    timezone: 'UTC',
    approvalMode: ApprovalMode.confirm,
  );

  @override
  Future<List<CalendarRouteStatus>> routes() async => [
    CalendarRouteStatus(
      route: CalendarRoute.androidDevice,
      label: 'Calendars on this phone',
      available: true,
      liveSync: true,
      canReadBusy: true,
      canWrite: true,
    ),
    CalendarRouteStatus(
      route: CalendarRoute.googleCloud,
      label: 'Google Calendar',
      available: false,
      liveSync: false,
      canReadBusy: false,
      canWrite: false,
      limitation: 'Google Calendar is not configured on this server.',
    ),
    CalendarRouteStatus(
      route: CalendarRoute.icsExport,
      label: 'Calendar file (.ics)',
      available: true,
      liveSync: false,
      canReadBusy: false,
      canWrite: false,
      limitation: 'Export only: not live sync and not proof of free time.',
    ),
  ];

  @override
  Future<List<CalendarConnectionView>> connections() async => [?phone];

  @override
  Future<CalendarConnectionView> syncDeviceCalendars(
    DeviceCalendarReport report,
  ) async {
    final owner = prefs.ownerId;
    final connection = CalendarConnection(
      id: phone?.connection.id ?? const Uuid().v4obj(),
      ownerId: owner,
      route: report.route,
      accountKey: report.deviceId.uuid,
      label: report.label,
      deviceId: report.deviceId,
      permission: report.permission,
      lastCheckedAt: report.checkedAt,
    );
    phone = CalendarConnectionView(
      connection: connection,
      selections: [
        for (final c in report.calendars)
          CalendarSelection(
            id: const Uuid().v4obj(),
            ownerId: owner,
            connectionId: connection.id!,
            externalCalendarId: c.externalCalendarId,
            deviceId: report.deviceId,
            name: c.name,
            readOnly: c.readOnly,
            useForConflicts: conflictCalendars,
            useForWrites: c.name == 'Family',
          ),
      ],
    );
    return phone!;
  }

  @override
  Future<List<CalendarConnectionView>> setSelections(
    UuidValue connectionId,
    List<CalendarSelectionChoice> choices,
  ) async {
    phone = phone!.copyWith(
      selections: [
        for (final s in phone!.selections)
          for (final c in choices)
            if (c.selectionId == s.id)
              s.copyWith(
                useForConflicts: c.useForConflicts,
                useForWrites: c.useForWrites,
              ),
      ],
    );
    return [phone!];
  }

  @override
  Future<PlannerPreferences> preferences() async => prefs;

  @override
  Future<PlannerPreferences> savePreferences(
    PlannerPreferencesDraft draft,
  ) async => prefs = prefs.copyWith(
    horizon: draft.horizon,
    approvalMode: draft.approvalMode,
    timezone: draft.timezone,
  );

  List<CalendarSelection> get _conflicts => [
    for (final s in phone?.selections ?? const <CalendarSelection>[])
      if (s.useForConflicts) s,
  ];

  @override
  Future<PlanProposal> propose(PlanRequest request) async {
    proposeRequests.add(request);
    final coverage = [
      for (final s in _conflicts)
        CalendarCoverage(
          selectionId: s.id!,
          calendarName: s.name,
          route: CalendarRoute.androidDevice,
          state:
              request.availability.any(
                (a) => a.selectionId == s.id && a.readable,
              )
              ? CoverageState.checked
              : CoverageState.unreadable,
          checkedAt: DateTime.now().toUtc(),
        ),
    ];
    final verified =
        coverage.isNotEmpty &&
        coverage.every((c) => c.state == CoverageState.checked);
    final plan = ReviewPlan(
      id: const Uuid().v4obj(),
      ownerId: prefs.ownerId,
      horizonStart: DateTime.now().toUtc(),
      horizonEnd: DateTime.now().toUtc().add(const Duration(days: 7)),
      timezone: 'UTC',
      coverage: coverage,
      availabilityVerified: verified,
    );
    final today = DateTime.now().toUtc();
    final start = DateTime.utc(today.year, today.month, today.day, 18);
    current = PlanProposal(
      plan: plan,
      approvalMode: prefs.approvalMode,
      canCommit: verified,
      commitBlockedReason: verified
          ? null
          : coverage.isEmpty
          ? 'No calendar is chosen for checking busy times.'
          : 'Busy times could not be confirmed.',
      writeCalendarName: verified ? 'Family' : null,
      sessions: [
        SessionView(
          session: ReviewSession(
            id: const Uuid().v4obj(),
            ownerId: prefs.ownerId,
            planId: plan.id,
            startAt: start,
            endAt: start.add(const Duration(minutes: 15)),
            timezone: 'UTC',
            status: SessionStatus.proposed,
            schedulingMode: ApprovalMode.confirm,
            availabilityVerified: verified,
          ),
          items: [
            SessionItemView(
              itemId: const Uuid().v4obj(),
              title: 'Flutter sidebar thread',
              plannedMinutes: 5,
              estimated: true,
            ),
          ],
        ),
      ],
    );
    return current!;
  }

  @override
  Future<PlanProposal?> currentProposal() async => current;

  @override
  Future<PlanCommitResult> commit(PlanCommitRequest request) async {
    commits.add(request);
    final views = [
      for (final v in current!.sessions)
        v.copyWith(
          session: v.session.copyWith(status: SessionStatus.scheduled),
          calendarName: request.acceptUnverified ? null : 'Family',
          syncState: request.acceptUnverified
              ? null
              : EventSyncState.pendingCreate,
        ),
    ];
    scheduled.addAll(views);
    current = null;
    return PlanCommitResult(sessions: views, writes: const []);
  }

  @override
  Future<List<SessionView>> sessions(DateTime from, DateTime to) async =>
      scheduled;

  @override
  Future<SessionChangeResult> moveSession(SessionMoveRequest request) =>
      throw UnimplementedError();

  @override
  Future<SessionChangeResult> cancelSession(
    UuidValue sessionId,
    UuidValue operationId,
    UuidValue? deviceId,
  ) async {
    final view = scheduled.firstWhere((v) => v.session.id == sessionId);
    scheduled.remove(view);
    return SessionChangeResult(
      session: view.copyWith(
        session: view.session.copyWith(status: SessionStatus.cancelled),
      ),
      writes: const [],
    );
  }

  @override
  Future<List<CalendarWrite>> deviceWork(UuidValue deviceId) async => const [];

  @override
  Future<void> reportWrites(List<CalendarWriteResult> results) async =>
      reported.addAll(results);

  @override
  Future<String> exportIcs(List<UuidValue> sessionIds) async {
    exported.add(sessionIds);
    return 'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nEND:VCALENDAR\r\n';
  }
}
