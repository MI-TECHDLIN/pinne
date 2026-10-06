import 'time_interval.dart';

/// How a calendar is reached. Device routes run on the phone; a server cannot
/// call them on demand.
enum CalendarRouteKind {
  /// The Android Calendar Provider on the user's phone.
  androidDevice,

  /// Google Calendar through the server, with OAuth.
  googleCloud,

  /// An iCalendar file the user imports. No availability, no live sync.
  icsExport,
}

/// One operation of the adapter contract.
enum CalendarCapability {
  listCalendars,
  readBusy,
  createEvent,
  updateEvent,
  deleteEvent,
  reconcile,
  exportFile,
}

/// Why an operation cannot run.
enum CapabilityFailure {
  /// The route never offers this operation.
  unsupported,

  /// The route needs server configuration that is missing.
  notConfigured,

  /// The user has not granted access, or revoked it.
  permissionDenied,

  /// Access allows adding events but not reading them.
  writeOnly,

  /// The chosen calendar cannot be written.
  readOnlyCalendar,

  /// The calendar no longer exists on this route.
  calendarMissing,

  /// The provider did not answer; retrying later may work.
  unavailable,
}

/// A structured refusal from an adapter. Callers switch on [failure]; the
/// [message] is safe to show and never carries secrets.
final class CalendarCapabilityException implements Exception {
  const CalendarCapabilityException({
    required this.route,
    required this.capability,
    required this.failure,
    required this.message,
  });

  final CalendarRouteKind route;
  final CalendarCapability capability;
  final CapabilityFailure failure;
  final String message;

  @override
  String toString() =>
      'CalendarCapabilityException(${route.name}.${capability.name}: '
      '${failure.name}) $message';
}

/// What a route can do right now, given configuration and permission.
final class AdapterCapabilities {
  const AdapterCapabilities({
    required this.route,
    required this.supported,
    required this.liveSync,
    this.blockedBy,
    this.limitation,
  });

  final CalendarRouteKind route;
  final Set<CalendarCapability> supported;

  /// Whether reads reflect the real calendar. False for export files.
  final bool liveSync;

  /// Set when the route cannot run at all, such as missing configuration or
  /// permission.
  final CapabilityFailure? blockedBy;

  /// A plain-language limit to show the user, if any.
  final String? limitation;

  bool can(CalendarCapability capability) =>
      blockedBy == null && supported.contains(capability);
}

/// A calendar reachable through a route. Device ids are only meaningful on
/// the device that read them.
final class AdapterCalendar {
  const AdapterCalendar({
    required this.id,
    required this.name,
    required this.readOnly,
    this.accountName,
    this.isPrimary = false,
  });

  final String id;
  final String name;
  final bool readOnly;
  final String? accountName;
  final bool isPrimary;
}

/// One normalized occupied interval: UTC, start inclusive, end exclusive,
/// with the IANA zone it was resolved in.
final class BusyInterval {
  const BusyInterval({
    required this.span,
    required this.timezone,
    this.allDay = false,
    this.sessionUid,
  });

  final TimeInterval span;
  final String timezone;

  /// All-day events are floating dates resolved to [timezone]'s local
  /// midnight-to-midnight.
  final bool allDay;

  /// Set when the event is one Pinne created, so a session being moved does
  /// not collide with itself.
  final String? sessionUid;
}

/// The result of reading availability: which calendars and window were
/// checked, and when.
final class BusyRead {
  const BusyRead({
    required this.calendarIds,
    required this.window,
    required this.checkedAt,
    required this.intervals,
  });

  final List<String> calendarIds;
  final TimeInterval window;
  final DateTime checkedAt;
  final List<BusyInterval> intervals;
}

/// A session event to write. [uid] is stable for the session, so a retry
/// after an ambiguous failure can find the event instead of duplicating it.
final class SessionEventDraft {
  const SessionEventDraft({
    required this.uid,
    required this.calendarId,
    required this.title,
    required this.notes,
    required this.span,
    required this.timezone,
  });

  final String uid;
  final String calendarId;
  final String title;
  final String notes;
  final TimeInterval span;
  final String timezone;
}

/// Where a written event lives.
final class SessionEventRef {
  const SessionEventRef({
    required this.calendarId,
    required this.eventId,
    this.revision,
  });

  final String calendarId;
  final String eventId;
  final String? revision;
}

enum ReconcileState {
  /// The event exists where and when the session expects.
  matches,

  /// The event exists but the user moved it in their calendar app.
  moved,

  /// No event carries the session's uid.
  missing,
}

final class ReconcileResult {
  const ReconcileResult(this.state, {this.ref, this.span});

  final ReconcileState state;
  final SessionEventRef? ref;

  /// The event's current time, when it exists.
  final TimeInterval? span;
}

/// The provider-independent calendar contract. Every route implements all
/// operations; an operation the route cannot do throws
/// [CalendarCapabilityException] instead of pretending.
///
/// Update and delete only touch events whose stored session marker matches
/// the draft's uid, so an unrelated event is never changed.
abstract interface class CalendarAdapter {
  CalendarRouteKind get route;

  Future<AdapterCapabilities> capabilities();

  Future<List<AdapterCalendar>> listCalendars();

  /// Occupied intervals of [calendarIds] overlapping [window]. Recurring
  /// events are expanded, cancelled and free events skipped, all-day events
  /// resolved in [timezone].
  Future<BusyRead> readBusyIntervals({
    required List<String> calendarIds,
    required TimeInterval window,
    required String timezone,
  });

  Future<SessionEventRef> createSessionEvent(SessionEventDraft draft);

  Future<SessionEventRef> updateSessionEvent(
    SessionEventRef ref,
    SessionEventDraft draft,
  );

  /// Removes the session's event. An event that is already gone is fine.
  Future<void> deleteSessionEvent(SessionEventRef ref, {required String uid});

  /// Finds the event for [draft] by [known] reference or by its uid marker.
  Future<ReconcileResult> reconcile(
    SessionEventDraft draft, {
    SessionEventRef? known,
  });
}

/// Text Pinne stores in the events it creates, so it can recognise them.
abstract final class SessionMarker {
  static const _prefix = 'pinne-session:';

  /// A line identifying the session's event.
  static String line(String uid) => '$_prefix$uid';

  /// The uid in [text], if it carries a marker.
  static String? read(String? text) {
    if (text == null) return null;
    final start = text.indexOf(_prefix);
    if (start < 0) return null;
    final rest = text.substring(start + _prefix.length);
    final end = rest.indexOf(RegExp(r'\s'));
    final uid = end < 0 ? rest : rest.substring(0, end);
    return uid.isEmpty ? null : uid;
  }
}
