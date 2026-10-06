import 'dart:async';

import 'package:device_calendar_plus/device_calendar_plus.dart' as plugin;
import 'package:flutter/foundation.dart';
import 'package:pinne_calendar/pinne_calendar.dart';

/// Calendar access as the phone reports it.
enum DeviceCalendarAccess { granted, writeOnly, denied, restricted, notAsked }

/// One event as the phone's calendar store returns it. Timed events are
/// instants; all-day events are floating dates in the date fields.
@immutable
class DeviceEvent {
  const DeviceEvent({
    required this.eventId,
    required this.instanceId,
    required this.calendarId,
    required this.start,
    required this.end,
    this.allDay = false,
    this.free = false,
    this.cancelled = false,
    this.description,
    this.url,
  });

  final String eventId;

  /// One occurrence of a recurring event; equals [eventId] for a one-off.
  final String instanceId;
  final String calendarId;
  final DateTime start;
  final DateTime end;
  final bool allDay;

  /// Marked "free" or "show as available", so it does not block.
  final bool free;
  final bool cancelled;
  final String? description;
  final String? url;

  String? get sessionUid =>
      SessionMarker.read(description) ?? SessionMarker.read(url);
}

/// The phone's calendar store, kept thin so tests can fake it.
abstract interface class DeviceCalendarApi {
  /// Whether the platform has a calendar store this app can use.
  bool get supported;

  Future<DeviceCalendarAccess> access();
  Future<DeviceCalendarAccess> requestAccess();
  Future<List<AdapterCalendar>> calendars();

  /// Events overlapping `[start, end)`, recurring ones expanded.
  Future<List<DeviceEvent>> events(
    DateTime start,
    DateTime end, {
    List<String>? calendarIds,
  });
  Future<DeviceEvent?> event(String id);
  Future<String> create({
    required String calendarId,
    required String title,
    required String notes,
    required DateTime start,
    required DateTime end,
    required String timezone,
  });
  Future<void> update(
    String instanceId, {
    required String title,
    required String notes,
    required DateTime start,
    required DateTime end,
  });
  Future<void> delete(String instanceId);
}

/// [DeviceCalendarApi] over `device_calendar_plus`, Android only for now.
class PluginDeviceCalendarApi implements DeviceCalendarApi {
  PluginDeviceCalendarApi();

  final _calendar = plugin.DeviceCalendar.instance;

  @override
  bool get supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static DeviceCalendarAccess _access(plugin.CalendarPermissionStatus s) =>
      switch (s) {
        plugin.CalendarPermissionStatus.granted => DeviceCalendarAccess.granted,
        plugin.CalendarPermissionStatus.writeOnly =>
          DeviceCalendarAccess.writeOnly,
        plugin.CalendarPermissionStatus.denied => DeviceCalendarAccess.denied,
        plugin.CalendarPermissionStatus.restricted =>
          DeviceCalendarAccess.restricted,
        plugin.CalendarPermissionStatus.notDetermined =>
          DeviceCalendarAccess.notAsked,
      };

  @override
  Future<DeviceCalendarAccess> access() async =>
      _access(await _calendar.hasPermissions());

  @override
  Future<DeviceCalendarAccess> requestAccess() async =>
      _access(await _calendar.requestPermissions());

  @override
  Future<List<AdapterCalendar>> calendars() async => [
    for (final c in await _calendar.listCalendars())
      if (!c.hidden)
        AdapterCalendar(
          id: c.id,
          name: c.name,
          readOnly: c.readOnly,
          accountName: c.accountName,
          isPrimary: c.isPrimary,
        ),
  ];

  static DeviceEvent _event(plugin.Event e) => DeviceEvent(
    eventId: e.eventId,
    instanceId: e.instanceId,
    calendarId: e.calendarId,
    start: e.startDate,
    end: e.endDate,
    allDay: e.isAllDay,
    free: e.availability == plugin.EventAvailability.free,
    cancelled: e.status == plugin.EventStatus.canceled,
    description: e.description,
    url: e.url,
  );

  @override
  Future<List<DeviceEvent>> events(
    DateTime start,
    DateTime end, {
    List<String>? calendarIds,
  }) async => [
    for (final e in await _calendar.listEvents(
      start,
      end,
      calendarIds: calendarIds,
    ))
      _event(e),
  ];

  @override
  Future<DeviceEvent?> event(String id) async {
    final e = await _calendar.getEvent(id);
    return e == null ? null : _event(e);
  }

  @override
  Future<String> create({
    required String calendarId,
    required String title,
    required String notes,
    required DateTime start,
    required DateTime end,
    required String timezone,
  }) => _calendar.createEvent(
    calendarId: calendarId,
    title: title,
    description: notes,
    startDate: start.toLocal(),
    endDate: end.toLocal(),
    timeZone: timezone,
  );

  @override
  Future<void> update(
    String instanceId, {
    required String title,
    required String notes,
    required DateTime start,
    required DateTime end,
  }) => _calendar.updateEvent(
    instanceId: instanceId,
    title: title,
    description: plugin.Patch.set(notes),
    startDate: start.toLocal(),
    endDate: end.toLocal(),
  );

  @override
  Future<void> delete(String instanceId) =>
      _calendar.deleteEvent(instanceId: instanceId);
}

/// The Android device route of the [CalendarAdapter] contract. It runs on
/// the phone: busy times are read here and sent to the planner, and session
/// events are written here after the server has stored the plan.
class AndroidDeviceCalendarAdapter implements CalendarAdapter {
  AndroidDeviceCalendarAdapter(this.api, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DeviceCalendarApi api;
  final DateTime Function() _clock;

  /// How far around a session's time to look for its event by uid.
  static const searchMargin = Duration(days: 31);

  @override
  CalendarRouteKind get route => CalendarRouteKind.androidDevice;

  @override
  Future<AdapterCapabilities> capabilities() async {
    if (!api.supported) {
      return AdapterCapabilities(
        route: route,
        supported: const {},
        liveSync: false,
        blockedBy: CapabilityFailure.unsupported,
        limitation: 'Phone calendars are only available on Android.',
      );
    }
    final access = await api.access();
    return switch (access) {
      DeviceCalendarAccess.granted => AdapterCapabilities(
        route: route,
        supported: const {
          CalendarCapability.listCalendars,
          CalendarCapability.readBusy,
          CalendarCapability.createEvent,
          CalendarCapability.updateEvent,
          CalendarCapability.deleteEvent,
          CalendarCapability.reconcile,
        },
        liveSync: true,
        limitation:
            'Busy times are as fresh as the last read on this phone. Some '
            'accounts may not appear in the phone calendar.',
      ),
      DeviceCalendarAccess.writeOnly => AdapterCapabilities(
        route: route,
        supported: const {CalendarCapability.createEvent},
        liveSync: true,
        blockedBy: CapabilityFailure.writeOnly,
        limitation: 'Add-only access cannot check when you are busy.',
      ),
      _ => AdapterCapabilities(
        route: route,
        supported: const {},
        liveSync: false,
        blockedBy: CapabilityFailure.permissionDenied,
        limitation: 'Calendar access is off for Pinne.',
      ),
    };
  }

  Future<void> _require(CalendarCapability capability) async {
    final caps = await capabilities();
    if (caps.can(capability)) return;
    throw CalendarCapabilityException(
      route: route,
      capability: capability,
      failure: caps.blockedBy ?? CapabilityFailure.unsupported,
      message: caps.limitation ?? 'Not available.',
    );
  }

  @override
  Future<List<AdapterCalendar>> listCalendars() async {
    await _require(CalendarCapability.listCalendars);
    return api.calendars();
  }

  @override
  Future<BusyRead> readBusyIntervals({
    required List<String> calendarIds,
    required TimeInterval window,
    required String timezone,
  }) async {
    await _require(CalendarCapability.readBusy);
    final checkedAt = _clock().toUtc();
    final events = calendarIds.isEmpty
        ? const <DeviceEvent>[]
        : await api.events(
            window.start.toLocal(),
            window.end.toLocal(),
            calendarIds: calendarIds,
          );
    return BusyRead(
      calendarIds: calendarIds,
      window: window,
      checkedAt: checkedAt,
      intervals: [
        for (final e in events) ?normalizeEvent(e, timezone),
      ],
    );
  }

  /// The occupied interval of [event], or null when it does not block:
  /// cancelled, marked free, or zero-length. Tentative events block. An
  /// all-day event covers its dates from local midnight in [timezone], so it
  /// is 23 or 25 hours long across a daylight-saving change.
  static BusyInterval? normalizeEvent(DeviceEvent event, String timezone) {
    if (event.cancelled || event.free) return null;
    if (event.allDay) {
      final first = LocalDate(
        event.start.year,
        event.start.month,
        event.start.day,
      );
      var after = LocalDate(event.end.year, event.end.month, event.end.day);
      // The end date is exclusive; a one-day event may report its own date.
      if (after.compareTo(first) <= 0) after = first.addDays(1);
      return BusyInterval(
        span: TimeInterval(first.at(timezone, 0), after.at(timezone, 0)),
        timezone: timezone,
        allDay: true,
        sessionUid: event.sessionUid,
      );
    }
    final span = TimeInterval.tryCreate(event.start, event.end);
    if (span == null) return null;
    return BusyInterval(
      span: span,
      timezone: timezone,
      sessionUid: event.sessionUid,
    );
  }

  @override
  Future<SessionEventRef> createSessionEvent(SessionEventDraft draft) async {
    await _require(CalendarCapability.createEvent);
    final id = await api.create(
      calendarId: draft.calendarId,
      title: draft.title,
      notes: _notes(draft),
      start: draft.span.start,
      end: draft.span.end,
      timezone: draft.timezone,
    );
    return SessionEventRef(calendarId: draft.calendarId, eventId: id);
  }

  @override
  Future<SessionEventRef> updateSessionEvent(
    SessionEventRef ref,
    SessionEventDraft draft,
  ) async {
    await _require(CalendarCapability.updateEvent);
    await _requireOurs(ref, draft.uid, CalendarCapability.updateEvent);
    await api.update(
      ref.eventId,
      title: draft.title,
      notes: _notes(draft),
      start: draft.span.start,
      end: draft.span.end,
    );
    return ref;
  }

  @override
  Future<void> deleteSessionEvent(
    SessionEventRef ref, {
    required String uid,
  }) async {
    await _require(CalendarCapability.deleteEvent);
    final existing = await api.event(ref.eventId);
    if (existing == null) return;
    if (existing.sessionUid != uid) _foreign(CalendarCapability.deleteEvent);
    await api.delete(ref.eventId);
  }

  @override
  Future<ReconcileResult> reconcile(
    SessionEventDraft draft, {
    SessionEventRef? known,
  }) async {
    await _require(CalendarCapability.reconcile);
    var foreign = false;
    if (known != null) {
      final event = await api.event(known.eventId);
      if (event != null && event.sessionUid == draft.uid) {
        return _found(event, draft);
      }
      foreign = event != null;
    }
    final nearby = await api.events(
      draft.span.start.subtract(searchMargin).toLocal(),
      draft.span.end.add(searchMargin).toLocal(),
      calendarIds: [draft.calendarId],
    );
    for (final event in nearby) {
      if (event.sessionUid == draft.uid && !event.cancelled) {
        return _found(event, draft);
      }
    }
    return ReconcileResult(
      foreign ? ReconcileState.foreign : ReconcileState.missing,
    );
  }

  ReconcileResult _found(DeviceEvent event, SessionEventDraft draft) {
    final span = TimeInterval.tryCreate(event.start, event.end);
    final ref = SessionEventRef(
      calendarId: event.calendarId,
      eventId: event.instanceId,
    );
    return ReconcileResult(
      span == draft.span ? ReconcileState.matches : ReconcileState.moved,
      ref: ref,
      span: span,
    );
  }

  Future<void> _requireOurs(
    SessionEventRef ref,
    String uid,
    CalendarCapability capability,
  ) async {
    final existing = await api.event(ref.eventId);
    if (existing == null) {
      throw CalendarCapabilityException(
        route: route,
        capability: capability,
        failure: CapabilityFailure.calendarMissing,
        message: 'The event is no longer in the calendar.',
      );
    }
    if (existing.sessionUid != uid) _foreign(capability);
  }

  Never _foreign(CalendarCapability capability) =>
      throw CalendarCapabilityException(
        route: route,
        capability: capability,
        failure: CapabilityFailure.unsupported,
        message: 'That event was not created by Pinne, so it was not changed.',
      );

  static String _notes(SessionEventDraft draft) =>
      SessionMarker.read(draft.notes) == draft.uid
      ? draft.notes
      : '${draft.notes}\n\n${SessionMarker.line(draft.uid)}';
}
