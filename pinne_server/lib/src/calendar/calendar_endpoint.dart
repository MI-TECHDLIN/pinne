import 'package:pinne_calendar/pinne_calendar.dart' as cal;
import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';
import 'google_calendar_adapter.dart';

/// Calendar routes, connections and the owner's choice of conflict and write
/// calendars. Device calendars are read and written on the phone; the server
/// keeps only which calendars to use and when they were last read.
class CalendarEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const maxCalendarsPerDevice = 100;

  /// Every route and what it can do on this server right now.
  Future<List<CalendarRouteStatus>> routes(Session session) async {
    final google = GoogleCalendarAdapter(
      credentialsPresent:
          session.serverpod.getPassword(GoogleCalendarAdapter.passwordKey) !=
          null,
    );
    final googleCaps = await google.capabilities();
    final export = await const cal.IcsExportAdapter().capabilities();
    return [
      CalendarRouteStatus(
        route: CalendarRoute.androidDevice,
        label: 'Calendars on this phone',
        available: true,
        liveSync: true,
        canReadBusy: true,
        canWrite: true,
        limitation:
            'Read on your phone, so busy times are only as fresh as the last '
            'check. Some accounts may not appear in the phone calendar.',
      ),
      CalendarRouteStatus(
        route: CalendarRoute.googleCloud,
        label: 'Google Calendar',
        available: googleCaps.blockedBy == null,
        liveSync: googleCaps.liveSync,
        canReadBusy: googleCaps.can(cal.CalendarCapability.readBusy),
        canWrite: googleCaps.can(cal.CalendarCapability.createEvent),
        limitation: googleCaps.limitation,
      ),
      CalendarRouteStatus(
        route: CalendarRoute.icsExport,
        label: 'Calendar file (.ics)',
        available: true,
        liveSync: export.liveSync,
        canReadBusy: false,
        canWrite: false,
        limitation: export.limitation,
      ),
    ];
  }

  /// Starts the Google Calendar consent flow. Refused with a structured
  /// error until the route is configured and built.
  Future<void> authorizeGoogle(Session session) async {
    final google = GoogleCalendarAdapter(
      credentialsPresent:
          session.serverpod.getPassword(GoogleCalendarAdapter.passwordKey) !=
          null,
    );
    final caps = await google.capabilities();
    throw CalendarRouteException(
      route: CalendarRoute.googleCloud,
      capability: cal.CalendarCapability.listCalendars.name,
      failure: caps.blockedBy!.name,
      message: caps.limitation!,
    );
  }

  Future<List<CalendarConnectionView>> connections(Session session) async {
    final owner = session.ownerId;
    final connections = await CalendarConnection.db.find(
      session,
      where: (t) => t.ownerId.equals(owner),
      orderBy: (t) => t.createdAt,
    );
    final selections = await CalendarSelection.db.find(
      session,
      where: (t) => t.ownerId.equals(owner),
      orderBy: (t) => t.name,
    );
    return [
      for (final connection in connections)
        CalendarConnectionView(
          connection: connection,
          selections: [
            for (final s in selections)
              if (s.connectionId == connection.id) s,
          ],
        ),
    ];
  }

  /// Records what a device can see: its permission and calendars. Existing
  /// choices are kept; new calendars are checked for conflicts by default,
  /// because checking more calendars can only avoid clashes. No calendar is
  /// chosen for writing until the owner picks one.
  Future<CalendarConnectionView> syncDeviceCalendars(
    Session session,
    DeviceCalendarReport report,
  ) async {
    if (report.route != CalendarRoute.androidDevice) {
      throw CalendarRouteException(
        route: report.route,
        capability: cal.CalendarCapability.listCalendars.name,
        failure: cal.CapabilityFailure.unsupported.name,
        message: 'Only device routes report calendars from the phone.',
      );
    }
    if (report.calendars.length > maxCalendarsPerDevice) {
      throw ValidationException(message: 'Too many calendars.');
    }
    final owner = session.ownerId;
    final label = report.label.trim().isEmpty ? 'This phone' : report.label;
    final listed = report.permission == CalendarPermission.granted;
    final now = DateTime.now().toUtc();

    await session.db.transaction((tx) async {
      final connection = (await CalendarConnection.db.upsertRow(
        session,
        CalendarConnection(
          ownerId: owner,
          route: report.route,
          accountKey: report.deviceId.uuid,
          label: label,
          deviceId: report.deviceId,
          permission: report.permission,
          lastCheckedAt: listed ? _notInFuture(report.checkedAt, now) : null,
        ),
        conflictColumns: (t) => [t.ownerId, t.route, t.accountKey],
        updateWhere: (t) => t.ownerId.equals(owner),
        updateColumns: (t) => [
          t.label,
          t.permission,
          if (listed) t.lastCheckedAt,
        ],
        transaction: tx,
      ))!;
      // Without permission the list is empty, which says nothing about which
      // calendars exist, so the stored choices stay.
      if (!listed) return;

      final existing = await CalendarSelection.db.find(
        session,
        where: (t) => t.connectionId.equals(connection.id!),
        transaction: tx,
      );
      final byExternal = {for (final s in existing) s.externalCalendarId: s};
      final reported = {
        for (final c in report.calendars) c.externalCalendarId: c,
      };
      final gone = [
        for (final s in existing)
          if (!reported.containsKey(s.externalCalendarId)) s,
      ];
      if (gone.isNotEmpty) {
        await CalendarSelection.db.delete(session, gone, transaction: tx);
      }
      for (final calendar in reported.values) {
        final known = byExternal[calendar.externalCalendarId];
        if (known == null) {
          await CalendarSelection.db.insertRow(
            session,
            CalendarSelection(
              ownerId: owner,
              connectionId: connection.id!,
              externalCalendarId: calendar.externalCalendarId,
              deviceId: report.deviceId,
              name: calendar.name,
              accountName: calendar.accountName,
              readOnly: calendar.readOnly,
              useForConflicts: true,
            ),
            transaction: tx,
          );
        } else {
          await CalendarSelection.db.updateRow(
            session,
            known.copyWith(
              name: calendar.name,
              accountName: calendar.accountName,
              readOnly: calendar.readOnly,
              // A calendar that became read-only can no longer take sessions.
              useForWrites: known.useForWrites && !calendar.readOnly,
            ),
            transaction: tx,
          );
        }
      }
    });
    return (await connections(
      session,
    )).firstWhere((c) => c.connection.accountKey == report.deviceId.uuid);
  }

  /// Applies the owner's choices for a connection's calendars. At most one
  /// calendar of the owner takes writes; choosing one clears the others.
  Future<List<CalendarConnectionView>> setSelections(
    Session session,
    UuidValue connectionId,
    List<CalendarSelectionChoice> choices,
  ) async {
    final owner = session.ownerId;
    final writes = choices.where((c) => c.useForWrites).length;
    if (writes > 1) {
      throw ValidationException(message: 'Choose one calendar for sessions.');
    }
    await session.db.transaction((tx) async {
      final connection = await CalendarConnection.db.findFirstRow(
        session,
        where: (t) => t.id.equals(connectionId) & t.ownerId.equals(owner),
        transaction: tx,
      );
      if (connection == null) {
        throw RecordNotFoundException(resource: 'calendar connection');
      }
      final selections = await CalendarSelection.db.find(
        session,
        where: (t) =>
            t.ownerId.equals(owner) & t.connectionId.equals(connectionId),
        transaction: tx,
      );
      final byId = {for (final s in selections) s.id!: s};
      for (final choice in choices) {
        final selection = byId[choice.selectionId];
        if (selection == null) {
          throw RecordNotFoundException(resource: 'calendar');
        }
        if (choice.useForWrites && selection.readOnly) {
          throw CalendarRouteException(
            route: connection.route,
            capability: cal.CalendarCapability.createEvent.name,
            failure: cal.CapabilityFailure.readOnlyCalendar.name,
            message: '"${selection.name}" is read-only. Choose another.',
          );
        }
      }
      if (writes == 1) {
        final others = await CalendarSelection.db.find(
          session,
          where: (t) => t.ownerId.equals(owner) & t.useForWrites.equals(true),
          transaction: tx,
        );
        final cleared = [
          for (final s in others)
            if (!choices.any((c) => c.selectionId == s.id))
              s.copyWith(useForWrites: false),
        ];
        if (cleared.isNotEmpty) {
          await CalendarSelection.db.update(session, cleared, transaction: tx);
        }
      }
      await CalendarSelection.db.update(session, [
        for (final choice in choices)
          byId[choice.selectionId]!.copyWith(
            useForConflicts: choice.useForConflicts,
            useForWrites: choice.useForWrites,
          ),
      ], transaction: tx);
    });
    return connections(session);
  }

  /// Stops using a connection. Sessions already scheduled stay in Pinne and
  /// events already written stay in the calendar; nothing is deleted there.
  Future<bool> disconnect(Session session, UuidValue connectionId) async {
    final owner = session.ownerId;
    final deleted = await CalendarConnection.db.deleteWhere(
      session,
      where: (t) => t.id.equals(connectionId) & t.ownerId.equals(owner),
    );
    return deleted.isNotEmpty;
  }

  static DateTime _notInFuture(DateTime reported, DateTime now) {
    final utc = reported.toUtc();
    return utc.isAfter(now) ? now : utc;
  }
}
