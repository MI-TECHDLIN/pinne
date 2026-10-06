/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import '../planning/calendar_write_action.dart' as _ipnw84qo;

/// Work for the device that holds the write calendar.
abstract class CalendarWrite
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CalendarWrite._({
    required this.linkId,
    required this.action,
    required this.sessionId,
    required this.eventUid,
    required this.externalCalendarId,
    this.externalEventId,
    required this.startAt,
    required this.endAt,
    required this.timezone,
    required this.title,
    required this.notes,
    required this.sessionRevision,
  });

  factory CalendarWrite({
    required _is.UuidValue linkId,
    required _ipnw84qo.CalendarWriteAction action,
    required _is.UuidValue sessionId,
    required String eventUid,
    required String externalCalendarId,
    String? externalEventId,
    required DateTime startAt,
    required DateTime endAt,
    required String timezone,
    required String title,
    required String notes,
    required int sessionRevision,
  }) = _CalendarWriteImpl;

  factory CalendarWrite.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarWrite(
      linkId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['linkId']),
      action: _ipnw84qo.CalendarWriteAction.fromJson(
        (jsonSerialization['action'] as String),
      ),
      sessionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sessionId'],
      ),
      eventUid: jsonSerialization['eventUid'] as String,
      externalCalendarId: jsonSerialization['externalCalendarId'] as String,
      externalEventId: jsonSerialization['externalEventId'] as String?,
      startAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['startAt']),
      endAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      timezone: jsonSerialization['timezone'] as String,
      title: jsonSerialization['title'] as String,
      notes: jsonSerialization['notes'] as String,
      sessionRevision: jsonSerialization['sessionRevision'] as int,
    );
  }

  _is.UuidValue linkId;

  _ipnw84qo.CalendarWriteAction action;

  _is.UuidValue sessionId;

  String eventUid;

  String externalCalendarId;

  String? externalEventId;

  DateTime startAt;

  DateTime endAt;

  String timezone;

  String title;

  String notes;

  /// The session's `planRevision` this work was built from. A result for
  /// an older revision does not settle newer work.
  int sessionRevision;

  /// Returns a shallow copy of this [CalendarWrite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CalendarWrite copyWith({
    _is.UuidValue? linkId,
    _ipnw84qo.CalendarWriteAction? action,
    _is.UuidValue? sessionId,
    String? eventUid,
    String? externalCalendarId,
    String? externalEventId,
    DateTime? startAt,
    DateTime? endAt,
    String? timezone,
    String? title,
    String? notes,
    int? sessionRevision,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarWrite',
      'linkId': linkId.toJson(),
      'action': action.toJson(),
      'sessionId': sessionId.toJson(),
      'eventUid': eventUid,
      'externalCalendarId': externalCalendarId,
      if (externalEventId != null) 'externalEventId': externalEventId,
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'timezone': timezone,
      'title': title,
      'notes': notes,
      'sessionRevision': sessionRevision,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarWrite',
      'linkId': linkId.toJson(),
      'action': action.toJson(),
      'sessionId': sessionId.toJson(),
      'eventUid': eventUid,
      'externalCalendarId': externalCalendarId,
      if (externalEventId != null) 'externalEventId': externalEventId,
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'timezone': timezone,
      'title': title,
      'notes': notes,
      'sessionRevision': sessionRevision,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarWriteImpl extends CalendarWrite {
  _CalendarWriteImpl({
    required _is.UuidValue linkId,
    required _ipnw84qo.CalendarWriteAction action,
    required _is.UuidValue sessionId,
    required String eventUid,
    required String externalCalendarId,
    String? externalEventId,
    required DateTime startAt,
    required DateTime endAt,
    required String timezone,
    required String title,
    required String notes,
    required int sessionRevision,
  }) : super._(
         linkId: linkId,
         action: action,
         sessionId: sessionId,
         eventUid: eventUid,
         externalCalendarId: externalCalendarId,
         externalEventId: externalEventId,
         startAt: startAt,
         endAt: endAt,
         timezone: timezone,
         title: title,
         notes: notes,
         sessionRevision: sessionRevision,
       );

  /// Returns a shallow copy of this [CalendarWrite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CalendarWrite copyWith({
    _is.UuidValue? linkId,
    _ipnw84qo.CalendarWriteAction? action,
    _is.UuidValue? sessionId,
    String? eventUid,
    String? externalCalendarId,
    Object? externalEventId = _Undefined,
    DateTime? startAt,
    DateTime? endAt,
    String? timezone,
    String? title,
    String? notes,
    int? sessionRevision,
  }) {
    return CalendarWrite(
      linkId: linkId ?? this.linkId,
      action: action ?? this.action,
      sessionId: sessionId ?? this.sessionId,
      eventUid: eventUid ?? this.eventUid,
      externalCalendarId: externalCalendarId ?? this.externalCalendarId,
      externalEventId: externalEventId is String?
          ? externalEventId
          : this.externalEventId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      timezone: timezone ?? this.timezone,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      sessionRevision: sessionRevision ?? this.sessionRevision,
    );
  }
}
