import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show Uuid, UuidValue;

import 'test_tools/serverpod_test_tools.dart';

/// A phone with a work, a family and a read-only holidays calendar. Work and
/// family are checked for conflicts; family takes the sessions.
class PhoneCalendars {
  PhoneCalendars._(this.deviceId, this.connection, this.work, this.family);

  final UuidValue deviceId;
  final CalendarConnection connection;
  final CalendarSelection work;
  final CalendarSelection family;

  static Future<PhoneCalendars> connect(
    TestEndpoints endpoints,
    TestSessionBuilder user, {
    bool writeToFamily = true,
  }) async {
    final deviceId = const Uuid().v4obj();
    final view = await endpoints.calendar.syncDeviceCalendars(
      user,
      report(deviceId),
    );
    CalendarSelection named(String name) =>
        view.selections.firstWhere((s) => s.name == name);
    final work = named('Work');
    final family = named('Family');
    await endpoints.calendar.setSelections(user, view.connection.id!, [
      CalendarSelectionChoice(
        selectionId: work.id!,
        useForConflicts: true,
        useForWrites: false,
      ),
      CalendarSelectionChoice(
        selectionId: family.id!,
        useForConflicts: true,
        useForWrites: writeToFamily,
      ),
      CalendarSelectionChoice(
        selectionId: named('Holidays').id!,
        useForConflicts: false,
        useForWrites: false,
      ),
    ]);
    return PhoneCalendars._(deviceId, view.connection, work, family);
  }

  static DeviceCalendarReport report(
    UuidValue deviceId, {
    CalendarPermission permission = CalendarPermission.granted,
    bool withHolidays = true,
  }) => DeviceCalendarReport(
    route: CalendarRoute.androidDevice,
    deviceId: deviceId,
    label: 'Pixel',
    permission: permission,
    calendars: permission != CalendarPermission.granted
        ? []
        : [
            DeviceCalendarInfo(
              externalCalendarId: '1',
              name: 'Work',
              readOnly: false,
              isPrimary: true,
            ),
            DeviceCalendarInfo(
              externalCalendarId: '2',
              name: 'Family',
              readOnly: false,
              isPrimary: false,
            ),
            if (withHolidays)
              DeviceCalendarInfo(
                externalCalendarId: '3',
                name: 'Holidays',
                readOnly: true,
                isPrimary: false,
              ),
          ],
    checkedAt: DateTime.now().toUtc(),
  );

  /// Fresh readings of both conflict calendars over the next 40 days.
  List<AvailabilitySnapshot> readings({
    List<BusyInterval> work = const [],
    List<BusyInterval> family = const [],
    DateTime? checkedAt,
  }) => [
    snapshot(this.work.id!, work, checkedAt: checkedAt),
    snapshot(this.family.id!, family, checkedAt: checkedAt),
  ];
}

AvailabilitySnapshot snapshot(
  UuidValue selectionId,
  List<BusyInterval> intervals, {
  DateTime? checkedAt,
  bool readable = true,
}) {
  final now = DateTime.now().toUtc();
  return AvailabilitySnapshot(
    selectionId: selectionId,
    checkedAt: checkedAt ?? now,
    windowStart: now.subtract(const Duration(hours: 1)),
    windowEnd: now.add(const Duration(days: 40)),
    readable: readable,
    intervals: readable ? intervals : [],
  );
}

BusyInterval busy(DateTime start, Duration length, {String? sessionUid}) =>
    BusyInterval(
      startAt: start,
      endAt: start.add(length),
      allDay: false,
      sessionUid: sessionUid,
    );

/// Plans in UTC, any time of day, so tests do not depend on the clock.
PlannerPreferencesDraft anyTimePreferences({
  ApprovalMode approvalMode = ApprovalMode.confirm,
  int maxSessions = 3,
  int bufferMinutes = 0,
}) => PlannerPreferencesDraft(
  horizon: PlanHorizon.week,
  weekdays: [1, 2, 3, 4, 5, 6, 7],
  windowStartMinute: 0,
  windowEndMinute: 24 * 60,
  sessionMinutes: 30,
  maxSessions: maxSessions,
  bufferMinutes: bufferMinutes,
  minLeadMinutes: 60,
  timezone: 'UTC',
  approvalMode: approvalMode,
);
