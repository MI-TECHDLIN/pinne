import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:pinne_calendar/pinne_calendar.dart' as cal;
import 'package:pinne_client/pinne_client.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/server_client.dart';
import 'calendar_write_runner.dart';
import 'device_calendar_adapter.dart';
import 'device_identity.dart';
import 'planner_api.dart';

final plannerApiProvider = Provider<PlannerApi>(
  (ref) => ServerPlannerApi(ref.watch(clientProvider)),
);

final deviceCalendarApiProvider = Provider<DeviceCalendarApi>(
  (ref) => PluginDeviceCalendarApi(),
);

final deviceCalendarAdapterProvider = Provider<AndroidDeviceCalendarAdapter>(
  (ref) => AndroidDeviceCalendarAdapter(ref.watch(deviceCalendarApiProvider)),
);

/// This install's id; device calendar work is scoped to it.
final deviceIdProvider = FutureProvider<UuidValue>((ref) => loadDeviceId());

/// The phone's IANA time zone, or UTC when the platform cannot say.
final deviceTimezoneProvider = FutureProvider<String>((ref) async {
  try {
    final zone = (await FlutterTimezone.getLocalTimezone()).identifier;
    return cal.isKnownTimeZone(zone) ? zone : 'UTC';
  } catch (_) {
    return 'UTC';
  }
});

/// Shares an `.ics` file through the system share sheet.
final icsSharerProvider = Provider<Future<void> Function(String ics)>(
  (ref) => (ics) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            utf8.encode(ics),
            mimeType: 'text/calendar',
          ),
        ],
        fileNameOverrides: const ['pinne-review-sessions.ics'],
        subject: 'Pinne review sessions',
        text:
            'Export only: a one-time copy that does not sync and is not proof '
            'of free time.',
      ),
    );
  },
);

/// Everything the Planner and Calendar connections screens show.
@immutable
class PlannerState {
  const PlannerState({
    required this.deviceId,
    required this.preferences,
    required this.routes,
    required this.connections,
    required this.access,
    required this.deviceSupported,
    required this.sessions,
    this.proposal,
    this.lastCheckedAt,
    this.notice,
  });

  final UuidValue deviceId;
  final PlannerPreferences preferences;
  final List<CalendarRouteStatus> routes;
  final List<CalendarConnectionView> connections;
  final DeviceCalendarAccess access;
  final bool deviceSupported;

  /// Scheduled sessions from yesterday to two months ahead.
  final List<SessionView> sessions;
  final PlanProposal? proposal;

  /// When busy times were last read on this phone.
  final DateTime? lastCheckedAt;

  /// A plain message about the last action, such as why a plan could not be
  /// accepted.
  final String? notice;

  /// This phone's connection, if it has reported its calendars.
  CalendarConnectionView? get phone {
    for (final c in connections) {
      if (c.connection.deviceId == deviceId) return c;
    }
    return null;
  }

  List<CalendarSelection> get conflictCalendars => [
    for (final c in connections)
      for (final s in c.selections)
        if (s.useForConflicts) s,
  ];

  CalendarSelection? get writeCalendar {
    for (final c in connections) {
      for (final s in c.selections) {
        if (s.useForWrites) return s;
      }
    }
    return null;
  }

  String get timezone => preferences.timezone;

  PlannerState copyWith({
    PlannerPreferences? preferences,
    List<CalendarRouteStatus>? routes,
    List<CalendarConnectionView>? connections,
    DeviceCalendarAccess? access,
    List<SessionView>? sessions,
    PlanProposal? Function()? proposal,
    DateTime? lastCheckedAt,
    String? Function()? notice,
  }) => PlannerState(
    deviceId: deviceId,
    preferences: preferences ?? this.preferences,
    routes: routes ?? this.routes,
    connections: connections ?? this.connections,
    access: access ?? this.access,
    deviceSupported: deviceSupported,
    sessions: sessions ?? this.sessions,
    proposal: proposal != null ? proposal() : this.proposal,
    lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
    notice: notice != null ? notice() : this.notice,
  );
}

final plannerProvider = AsyncNotifierProvider<PlannerController, PlannerState>(
  PlannerController.new,
);

/// Loads planning state and runs the propose, accept, move and cancel flows.
///
/// Busy times are read on this phone right before every propose, accept and
/// move, and calendar events are written only after the server has stored
/// the plan and handed back the work.
class PlannerController extends AsyncNotifier<PlannerState> {
  PlannerApi get _api => ref.read(plannerApiProvider);
  AndroidDeviceCalendarAdapter get _adapter =>
      ref.read(deviceCalendarAdapterProvider);

  /// One operation id per plan acceptance, reused if the call is retried.
  final _commitOperations = <UuidValue, UuidValue>{};

  static const _readAhead = Duration(days: 40);

  @override
  Future<PlannerState> build() async {
    final deviceId = await ref.watch(deviceIdProvider.future);
    var prefs = await _api.preferences();
    if (prefs.id == null) {
      prefs = await _api.savePreferences(
        _draftOf(prefs).copyWith(
          timezone: await ref.read(deviceTimezoneProvider.future),
        ),
      );
    }
    final supported = _adapter.api.supported;
    final access = supported
        ? await _adapter.api.access()
        : DeviceCalendarAccess.denied;
    var connections = await _api.connections();
    final hasPhone = connections.any((c) => c.connection.deviceId == deviceId);
    if (supported && (hasPhone || access == DeviceCalendarAccess.granted)) {
      await _reportCalendars(deviceId, access);
      connections = await _api.connections();
    }
    final initial = PlannerState(
      deviceId: deviceId,
      preferences: prefs,
      routes: await _api.routes(),
      connections: connections,
      access: access,
      deviceSupported: supported,
      sessions: await _loadSessions(),
      proposal: await _api.currentProposal(),
      lastCheckedAt: connections
          .where((c) => c.connection.deviceId == deviceId)
          .map((c) => c.connection.lastCheckedAt)
          .nonNulls
          .firstOrNull,
    );
    unawaited(Future.microtask(syncCalendar));
    return initial;
  }

  PlannerState get _current => state.requireValue;

  Future<List<SessionView>> _loadSessions() {
    final now = DateTime.now();
    return _api.sessions(
      now.subtract(const Duration(days: 1)),
      now.add(const Duration(days: 62)),
    );
  }

  static PlannerPreferencesDraft _draftOf(PlannerPreferences p) =>
      PlannerPreferencesDraft(
        horizon: p.horizon,
        weekdays: p.weekdays,
        windowStartMinute: p.windowStartMinute,
        windowEndMinute: p.windowEndMinute,
        sessionMinutes: p.sessionMinutes,
        maxSessions: p.maxSessions,
        bufferMinutes: p.bufferMinutes,
        minLeadMinutes: p.minLeadMinutes,
        timezone: p.timezone,
        approvalMode: p.approvalMode,
      );

  static CalendarPermission _permission(DeviceCalendarAccess access) =>
      switch (access) {
        DeviceCalendarAccess.granted => CalendarPermission.granted,
        DeviceCalendarAccess.writeOnly => CalendarPermission.writeOnly,
        DeviceCalendarAccess.denied => CalendarPermission.denied,
        DeviceCalendarAccess.restricted => CalendarPermission.restricted,
        DeviceCalendarAccess.notAsked => CalendarPermission.notRequested,
      };

  Future<void> _reportCalendars(
    UuidValue deviceId,
    DeviceCalendarAccess access,
  ) async {
    final calendars = access == DeviceCalendarAccess.granted
        ? await _adapter.listCalendars()
        : const <cal.AdapterCalendar>[];
    await _api.syncDeviceCalendars(
      DeviceCalendarReport(
        route: CalendarRoute.androidDevice,
        deviceId: deviceId,
        label: 'This phone',
        permission: _permission(access),
        calendars: [
          for (final c in calendars)
            DeviceCalendarInfo(
              externalCalendarId: c.id,
              name: c.name,
              accountName: c.accountName,
              readOnly: c.readOnly,
              isPrimary: c.isPrimary,
            ),
        ],
        checkedAt: DateTime.now().toUtc(),
      ),
    );
  }

  /// Asks for calendar access and reports this phone's calendars.
  Future<void> connectPhone() => _guard(() async {
    final access = await _adapter.api.requestAccess();
    await _reportCalendars(_current.deviceId, access);
    state = AsyncData(
      _current.copyWith(
        access: access,
        connections: await _api.connections(),
        notice: () => access == DeviceCalendarAccess.granted
            ? null
            : 'Calendar access was not given. You can still plan, keep '
                  'sessions in Pinne and export them.',
      ),
    );
  });

  Future<void> setChoices(
    UuidValue connectionId,
    List<CalendarSelectionChoice> choices,
  ) => _guard(() async {
    final connections = await _api.setSelections(connectionId, choices);
    state = AsyncData(_current.copyWith(connections: connections));
  });

  Future<void> savePreferences(PlannerPreferencesDraft draft) =>
      _guard(() async {
        final prefs = await _api.savePreferences(draft);
        state = AsyncData(_current.copyWith(preferences: prefs));
      });

  /// Reads busy times of this phone's conflict calendars. A calendar that
  /// cannot be read is sent as unreadable, never as free.
  Future<List<AvailabilitySnapshot>> _readAvailability() async {
    final current = _current;
    final phone = current.phone;
    if (phone == null) return const [];
    final now = DateTime.now().toUtc();
    final window = cal.TimeInterval(
      now.subtract(const Duration(hours: 1)),
      now.add(_readAhead),
    );
    final snapshots = <AvailabilitySnapshot>[];
    DateTime? checked;
    for (final selection in phone.selections) {
      if (!selection.useForConflicts) continue;
      try {
        final read = await _adapter.readBusyIntervals(
          calendarIds: [selection.externalCalendarId],
          window: window,
          timezone: current.timezone,
        );
        checked = read.checkedAt;
        snapshots.add(
          AvailabilitySnapshot(
            selectionId: selection.id!,
            checkedAt: read.checkedAt,
            windowStart: window.start,
            windowEnd: window.end,
            readable: true,
            intervals: [
              for (final b in read.intervals)
                BusyInterval(
                  startAt: b.span.start,
                  endAt: b.span.end,
                  allDay: b.allDay,
                  sessionUid: b.sessionUid,
                ),
            ],
          ),
        );
      } on cal.CalendarCapabilityException catch (e) {
        snapshots.add(
          AvailabilitySnapshot(
            selectionId: selection.id!,
            checkedAt: now,
            windowStart: window.start,
            windowEnd: window.end,
            readable: false,
            problem: e.message,
            intervals: const [],
          ),
        );
      }
    }
    if (checked != null) {
      state = AsyncData(_current.copyWith(lastCheckedAt: checked));
    }
    return snapshots;
  }

  /// Proposes sessions for the planner's horizon. Nothing is scheduled.
  Future<void> propose({String? notice}) => _guard(() async {
    final availability = await _readAvailability();
    final proposal = await _api.propose(
      PlanRequest(availability: availability),
    );
    state = AsyncData(
      _current.copyWith(proposal: () => proposal, notice: () => notice),
    );
  });

  /// Accepts the current proposal. With [unverified] the user keeps the
  /// sessions in Pinne without a calendar check; nothing is written to a
  /// calendar then.
  Future<void> accept({bool unverified = false}) => _guard(() async {
    final proposal = _current.proposal;
    if (proposal == null) return;
    final planId = proposal.plan.id!;
    final operationId = _commitOperations.putIfAbsent(
      planId,
      () => const Uuid().v4obj(),
    );
    final availability = await _readAvailability();
    final PlanCommitResult result;
    try {
      result = await _api.commit(
        PlanCommitRequest(
          planId: planId,
          operationId: operationId,
          availability: availability,
          acceptUnverified: unverified,
          deviceId: _current.deviceId,
        ),
      );
    } on PlanningException catch (e) {
      if (e.code == PlanningErrorCode.conflict ||
          e.code == PlanningErrorCode.planExpired) {
        // Revise the proposal with what is in the calendar now.
        _commitOperations.remove(planId);
        final revised = await _api.propose(
          PlanRequest(availability: availability),
        );
        state = AsyncData(
          _current.copyWith(
            proposal: () => revised,
            notice: () =>
                'Your calendar changed, so the plan was revised. Check the '
                'new times and accept again.',
          ),
        );
        return;
      }
      rethrow;
    }
    _commitOperations.remove(planId);
    await _runWrites(result.writes);
    state = AsyncData(
      _current.copyWith(
        proposal: () => null,
        sessions: await _loadSessions(),
        notice: () => unverified
            ? 'Kept in Pinne. These times were not checked against your '
                  'calendar.'
            : null,
      ),
    );
  });

  /// Moves a scheduled session to [startAt] after a fresh availability read.
  Future<void> move(SessionView view, DateTime startAt) => _guard(() async {
    final availability = await _readAvailability();
    final result = await _api.moveSession(
      SessionMoveRequest(
        sessionId: view.session.id!,
        operationId: const Uuid().v4obj(),
        startAt: startAt.toUtc(),
        availability: availability,
        acceptUnverified: !view.session.availabilityVerified,
        deviceId: _current.deviceId,
      ),
    );
    await _runWrites(result.writes);
    state = AsyncData(_current.copyWith(sessions: await _loadSessions()));
  });

  Future<void> cancel(SessionView view) => _guard(() async {
    final result = await _api.cancelSession(
      view.session.id!,
      const Uuid().v4obj(),
      _current.deviceId,
    );
    await _runWrites(result.writes);
    state = AsyncData(_current.copyWith(sessions: await _loadSessions()));
  });

  /// Exports sessions as an `.ics` file through the share sheet.
  Future<void> exportIcs(List<SessionView> views) => _guard(() async {
    if (views.isEmpty) return;
    final ics = await _api.exportIcs([for (final v in views) v.session.id!]);
    await ref.read(icsSharerProvider)(ics);
  });

  /// Writes pending events on this phone and checks that upcoming ones
  /// were not moved or removed in the calendar app.
  Future<void> syncCalendar() async {
    if (!state.hasValue || !_current.deviceSupported) return;
    try {
      final work = await _api.deviceWork(_current.deviceId);
      if (work.isEmpty) return;
      if (await _runWrites(work)) {
        state = AsyncData(_current.copyWith(sessions: await _loadSessions()));
      }
    } catch (_) {
      // Offline or no permission: the work stays queued on the server.
    }
  }

  /// Returns whether anything was reported.
  Future<bool> _runWrites(List<CalendarWrite> writes) async {
    if (writes.isEmpty || !_current.deviceSupported) return false;
    final results = await CalendarWriteRunner(_adapter).run(writes);
    if (results.isEmpty) return false;
    await _api.reportWrites(results);
    return true;
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on PlanningException catch (e) {
      _notice(e.message);
    } on CalendarRouteException catch (e) {
      _notice(e.message);
    } on ValidationException catch (e) {
      _notice(e.message);
    } on RecordNotFoundException {
      _notice('That is no longer there. Pull to refresh.');
      ref.invalidateSelf();
    } catch (e) {
      _notice('Could not reach Pinne. Check your connection and try again.');
    }
  }

  void _notice(String message) {
    if (!state.hasValue) return;
    state = AsyncData(_current.copyWith(notice: () => message));
  }

  void clearNotice() {
    if (!state.hasValue || _current.notice == null) return;
    state = AsyncData(_current.copyWith(notice: () => null));
  }
}
