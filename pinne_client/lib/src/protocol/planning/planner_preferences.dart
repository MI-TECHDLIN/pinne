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
import 'package:pinne_client/src/protocol/protocol.dart' as _iub9zyhg;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../planning/approval_mode.dart' as _i6o5tozv;
import '../planning/plan_horizon.dart' as _if2ouyp9;

/// The owner's planning rules. Times are local to `timezone`.
abstract class PlannerPreferences
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlannerPreferences._({
    this.id,
    required this.ownerId,
    required this.horizon,
    required this.weekdays,
    required this.windowStartMinute,
    required this.windowEndMinute,
    required this.sessionMinutes,
    required this.maxSessions,
    required this.bufferMinutes,
    required this.minLeadMinutes,
    required this.timezone,
    required this.approvalMode,
  });

  factory PlannerPreferences({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _if2ouyp9.PlanHorizon horizon,
    required List<int> weekdays,
    required int windowStartMinute,
    required int windowEndMinute,
    required int sessionMinutes,
    required int maxSessions,
    required int bufferMinutes,
    required int minLeadMinutes,
    required String timezone,
    required _i6o5tozv.ApprovalMode approvalMode,
  }) = _PlannerPreferencesImpl;

  factory PlannerPreferences.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlannerPreferences(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      horizon: _if2ouyp9.PlanHorizon.fromJson(
        (jsonSerialization['horizon'] as String),
      ),
      weekdays: _iub9zyhg.Protocol().deserialize<List<int>>(
        jsonSerialization['weekdays'],
      ),
      windowStartMinute: jsonSerialization['windowStartMinute'] as int,
      windowEndMinute: jsonSerialization['windowEndMinute'] as int,
      sessionMinutes: jsonSerialization['sessionMinutes'] as int,
      maxSessions: jsonSerialization['maxSessions'] as int,
      bufferMinutes: jsonSerialization['bufferMinutes'] as int,
      minLeadMinutes: jsonSerialization['minLeadMinutes'] as int,
      timezone: jsonSerialization['timezone'] as String,
      approvalMode: _i6o5tozv.ApprovalMode.fromJson(
        (jsonSerialization['approvalMode'] as String),
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _if2ouyp9.PlanHorizon horizon;

  /// ISO weekdays, 1 Monday to 7 Sunday.
  List<int> weekdays;

  /// Minutes after local midnight.
  int windowStartMinute;

  int windowEndMinute;

  int sessionMinutes;

  int maxSessions;

  int bufferMinutes;

  int minLeadMinutes;

  /// IANA time zone, such as Africa/Lagos.
  String timezone;

  _i6o5tozv.ApprovalMode approvalMode;

  /// Returns a shallow copy of this [PlannerPreferences]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlannerPreferences copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _if2ouyp9.PlanHorizon? horizon,
    List<int>? weekdays,
    int? windowStartMinute,
    int? windowEndMinute,
    int? sessionMinutes,
    int? maxSessions,
    int? bufferMinutes,
    int? minLeadMinutes,
    String? timezone,
    _i6o5tozv.ApprovalMode? approvalMode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlannerPreferences',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'horizon': horizon.toJson(),
      'weekdays': weekdays.toJson(),
      'windowStartMinute': windowStartMinute,
      'windowEndMinute': windowEndMinute,
      'sessionMinutes': sessionMinutes,
      'maxSessions': maxSessions,
      'bufferMinutes': bufferMinutes,
      'minLeadMinutes': minLeadMinutes,
      'timezone': timezone,
      'approvalMode': approvalMode.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlannerPreferences',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'horizon': horizon.toJson(),
      'weekdays': weekdays.toJson(),
      'windowStartMinute': windowStartMinute,
      'windowEndMinute': windowEndMinute,
      'sessionMinutes': sessionMinutes,
      'maxSessions': maxSessions,
      'bufferMinutes': bufferMinutes,
      'minLeadMinutes': minLeadMinutes,
      'timezone': timezone,
      'approvalMode': approvalMode.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlannerPreferencesImpl extends PlannerPreferences {
  _PlannerPreferencesImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _if2ouyp9.PlanHorizon horizon,
    required List<int> weekdays,
    required int windowStartMinute,
    required int windowEndMinute,
    required int sessionMinutes,
    required int maxSessions,
    required int bufferMinutes,
    required int minLeadMinutes,
    required String timezone,
    required _i6o5tozv.ApprovalMode approvalMode,
  }) : super._(
         id: id,
         ownerId: ownerId,
         horizon: horizon,
         weekdays: weekdays,
         windowStartMinute: windowStartMinute,
         windowEndMinute: windowEndMinute,
         sessionMinutes: sessionMinutes,
         maxSessions: maxSessions,
         bufferMinutes: bufferMinutes,
         minLeadMinutes: minLeadMinutes,
         timezone: timezone,
         approvalMode: approvalMode,
       );

  /// Returns a shallow copy of this [PlannerPreferences]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlannerPreferences copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _if2ouyp9.PlanHorizon? horizon,
    List<int>? weekdays,
    int? windowStartMinute,
    int? windowEndMinute,
    int? sessionMinutes,
    int? maxSessions,
    int? bufferMinutes,
    int? minLeadMinutes,
    String? timezone,
    _i6o5tozv.ApprovalMode? approvalMode,
  }) {
    return PlannerPreferences(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      horizon: horizon ?? this.horizon,
      weekdays: weekdays ?? this.weekdays.map((e0) => e0).toList(),
      windowStartMinute: windowStartMinute ?? this.windowStartMinute,
      windowEndMinute: windowEndMinute ?? this.windowEndMinute,
      sessionMinutes: sessionMinutes ?? this.sessionMinutes,
      maxSessions: maxSessions ?? this.maxSessions,
      bufferMinutes: bufferMinutes ?? this.bufferMinutes,
      minLeadMinutes: minLeadMinutes ?? this.minLeadMinutes,
      timezone: timezone ?? this.timezone,
      approvalMode: approvalMode ?? this.approvalMode,
    );
  }
}
