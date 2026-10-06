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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../planning/calendar_write_action.dart' as _ipnw84qo;
import '../planning/calendar_write_outcome.dart' as _ignqw9z8;

abstract class CalendarWriteResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CalendarWriteResult._({
    required this.linkId,
    required this.action,
    required this.outcome,
    required this.sessionRevision,
    this.externalEventId,
    this.providerRevision,
    this.startAt,
    this.endAt,
    this.message,
  });

  factory CalendarWriteResult({
    required _isc.UuidValue linkId,
    required _ipnw84qo.CalendarWriteAction action,
    required _ignqw9z8.CalendarWriteOutcome outcome,
    required int sessionRevision,
    String? externalEventId,
    String? providerRevision,
    DateTime? startAt,
    DateTime? endAt,
    String? message,
  }) = _CalendarWriteResultImpl;

  factory CalendarWriteResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarWriteResult(
      linkId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['linkId']),
      action: _ipnw84qo.CalendarWriteAction.fromJson(
        (jsonSerialization['action'] as String),
      ),
      outcome: _ignqw9z8.CalendarWriteOutcome.fromJson(
        (jsonSerialization['outcome'] as String),
      ),
      sessionRevision: jsonSerialization['sessionRevision'] as int,
      externalEventId: jsonSerialization['externalEventId'] as String?,
      providerRevision: jsonSerialization['providerRevision'] as String?,
      startAt: jsonSerialization['startAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['startAt']),
      endAt: jsonSerialization['endAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      message: jsonSerialization['message'] as String?,
    );
  }

  _isc.UuidValue linkId;

  _ipnw84qo.CalendarWriteAction action;

  _ignqw9z8.CalendarWriteOutcome outcome;

  /// The session's `planRevision` this work was built from. A result for
  /// an older revision does not settle newer work.
  int sessionRevision;

  String? externalEventId;

  String? providerRevision;

  /// The event's current time, for `moved`.
  DateTime? startAt;

  DateTime? endAt;

  String? message;

  /// Returns a shallow copy of this [CalendarWriteResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CalendarWriteResult copyWith({
    _isc.UuidValue? linkId,
    _ipnw84qo.CalendarWriteAction? action,
    _ignqw9z8.CalendarWriteOutcome? outcome,
    int? sessionRevision,
    String? externalEventId,
    String? providerRevision,
    DateTime? startAt,
    DateTime? endAt,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarWriteResult',
      'linkId': linkId.toJson(),
      'action': action.toJson(),
      'outcome': outcome.toJson(),
      'sessionRevision': sessionRevision,
      if (externalEventId != null) 'externalEventId': externalEventId,
      if (providerRevision != null) 'providerRevision': providerRevision,
      if (startAt != null) 'startAt': startAt?.toJson(),
      if (endAt != null) 'endAt': endAt?.toJson(),
      if (message != null) 'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarWriteResult',
      'linkId': linkId.toJson(),
      'action': action.toJson(),
      'outcome': outcome.toJson(),
      'sessionRevision': sessionRevision,
      if (externalEventId != null) 'externalEventId': externalEventId,
      if (providerRevision != null) 'providerRevision': providerRevision,
      if (startAt != null) 'startAt': startAt?.toJson(),
      if (endAt != null) 'endAt': endAt?.toJson(),
      if (message != null) 'message': message,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarWriteResultImpl extends CalendarWriteResult {
  _CalendarWriteResultImpl({
    required _isc.UuidValue linkId,
    required _ipnw84qo.CalendarWriteAction action,
    required _ignqw9z8.CalendarWriteOutcome outcome,
    required int sessionRevision,
    String? externalEventId,
    String? providerRevision,
    DateTime? startAt,
    DateTime? endAt,
    String? message,
  }) : super._(
         linkId: linkId,
         action: action,
         outcome: outcome,
         sessionRevision: sessionRevision,
         externalEventId: externalEventId,
         providerRevision: providerRevision,
         startAt: startAt,
         endAt: endAt,
         message: message,
       );

  /// Returns a shallow copy of this [CalendarWriteResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CalendarWriteResult copyWith({
    _isc.UuidValue? linkId,
    _ipnw84qo.CalendarWriteAction? action,
    _ignqw9z8.CalendarWriteOutcome? outcome,
    int? sessionRevision,
    Object? externalEventId = _Undefined,
    Object? providerRevision = _Undefined,
    Object? startAt = _Undefined,
    Object? endAt = _Undefined,
    Object? message = _Undefined,
  }) {
    return CalendarWriteResult(
      linkId: linkId ?? this.linkId,
      action: action ?? this.action,
      outcome: outcome ?? this.outcome,
      sessionRevision: sessionRevision ?? this.sessionRevision,
      externalEventId: externalEventId is String?
          ? externalEventId
          : this.externalEventId,
      providerRevision: providerRevision is String?
          ? providerRevision
          : this.providerRevision,
      startAt: startAt is DateTime? ? startAt : this.startAt,
      endAt: endAt is DateTime? ? endAt : this.endAt,
      message: message is String? ? message : this.message,
    );
  }
}
