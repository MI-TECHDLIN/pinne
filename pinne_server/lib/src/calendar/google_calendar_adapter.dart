import 'package:pinne_calendar/pinne_calendar.dart';

/// The Google Calendar cloud route.
///
/// It needs an OAuth client (`googleCalendarClientSecret` in
/// `config/passwords.yaml`) and a per-user consent flow for FreeBusy and
/// event scopes. Neither exists yet, so every operation is refused with a
/// structured [CalendarCapabilityException]: `notConfigured` without
/// credentials, `unsupported` with them, because the consent flow and token
/// store are not built. It never reports availability it did not read.
final class GoogleCalendarAdapter implements CalendarAdapter {
  const GoogleCalendarAdapter({required this.credentialsPresent});

  final bool credentialsPresent;

  /// The passwords key that would hold the OAuth web client JSON.
  static const passwordKey = 'googleCalendarClientSecret';

  @override
  CalendarRouteKind get route => CalendarRouteKind.googleCloud;

  CapabilityFailure get _failure => credentialsPresent
      ? CapabilityFailure.unsupported
      : CapabilityFailure.notConfigured;

  String get _reason => credentialsPresent
      ? 'Google Calendar sync is not built into this version of Pinne yet.'
      : 'Google Calendar is not configured on this server. It needs Google '
            'OAuth client credentials.';

  @override
  Future<AdapterCapabilities> capabilities() async => AdapterCapabilities(
    route: route,
    supported: const {},
    liveSync: false,
    blockedBy: _failure,
    limitation: _reason,
  );

  Never _refuse(CalendarCapability capability) =>
      throw CalendarCapabilityException(
        route: route,
        capability: capability,
        failure: _failure,
        message: _reason,
      );

  @override
  Future<List<AdapterCalendar>> listCalendars() async =>
      _refuse(CalendarCapability.listCalendars);

  @override
  Future<BusyRead> readBusyIntervals({
    required List<String> calendarIds,
    required TimeInterval window,
    required String timezone,
  }) async => _refuse(CalendarCapability.readBusy);

  @override
  Future<SessionEventRef> createSessionEvent(SessionEventDraft draft) async =>
      _refuse(CalendarCapability.createEvent);

  @override
  Future<SessionEventRef> updateSessionEvent(
    SessionEventRef ref,
    SessionEventDraft draft,
  ) async => _refuse(CalendarCapability.updateEvent);

  @override
  Future<void> deleteSessionEvent(
    SessionEventRef ref, {
    required String uid,
  }) async => _refuse(CalendarCapability.deleteEvent);

  @override
  Future<ReconcileResult> reconcile(
    SessionEventDraft draft, {
    SessionEventRef? known,
  }) async => _refuse(CalendarCapability.reconcile);
}
