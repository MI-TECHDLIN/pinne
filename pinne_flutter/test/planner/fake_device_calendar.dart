import 'dart:async';

import 'package:pinne_calendar/pinne_calendar.dart';
import 'package:pinne_flutter/features/planner/device_calendar_adapter.dart';

/// An in-memory phone calendar store. Recurring events are given as their
/// expanded occurrences, as the Calendar Provider returns them.
class FakeDeviceCalendar implements DeviceCalendarApi {
  FakeDeviceCalendar({
    this.supported = true,
    this.currentAccess = DeviceCalendarAccess.granted,
    List<AdapterCalendar>? calendars,
  }) : _calendars =
           calendars ??
           const [
             AdapterCalendar(id: '1', name: 'Work', readOnly: false),
             AdapterCalendar(id: '2', name: 'Family', readOnly: false),
           ];

  @override
  bool supported;
  DeviceCalendarAccess currentAccess;
  final List<AdapterCalendar> _calendars;
  final stored = <DeviceEvent>[];
  var _next = 100;

  /// When set, the next create stores the event and then throws, like a
  /// platform call that times out after the provider committed.
  bool timeoutAfterNextCreate = false;
  int creates = 0;
  int updates = 0;
  int deletes = 0;

  @override
  Future<DeviceCalendarAccess> access() async => currentAccess;

  @override
  Future<DeviceCalendarAccess> requestAccess() async => currentAccess;

  @override
  Future<List<AdapterCalendar>> calendars() async => _calendars;

  @override
  Future<List<DeviceEvent>> events(
    DateTime start,
    DateTime end, {
    List<String>? calendarIds,
  }) async => [
    for (final e in stored)
      if ((calendarIds == null || calendarIds.contains(e.calendarId)) &&
          e.start.isBefore(end) &&
          e.end.isAfter(start))
        e,
  ];

  @override
  Future<DeviceEvent?> event(String id) async {
    for (final e in stored) {
      if (e.instanceId == id || e.eventId == id) return e;
    }
    return null;
  }

  @override
  Future<String> create({
    required String calendarId,
    required String title,
    required String notes,
    required DateTime start,
    required DateTime end,
    required String timezone,
  }) async {
    creates++;
    final id = '${_next++}';
    stored.add(
      DeviceEvent(
        eventId: id,
        instanceId: id,
        calendarId: calendarId,
        start: start,
        end: end,
        description: notes,
      ),
    );
    if (timeoutAfterNextCreate) {
      timeoutAfterNextCreate = false;
      throw TimeoutException('No answer from the calendar provider');
    }
    return id;
  }

  @override
  Future<void> update(
    String instanceId, {
    required String title,
    required String notes,
    required DateTime start,
    required DateTime end,
  }) async {
    updates++;
    final index = stored.indexWhere((e) => e.instanceId == instanceId);
    final old = stored[index];
    stored[index] = DeviceEvent(
      eventId: old.eventId,
      instanceId: old.instanceId,
      calendarId: old.calendarId,
      start: start,
      end: end,
      description: notes,
    );
  }

  @override
  Future<void> delete(String instanceId) async {
    deletes++;
    stored.removeWhere((e) => e.instanceId == instanceId);
  }
}
