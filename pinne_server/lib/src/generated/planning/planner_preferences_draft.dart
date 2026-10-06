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
import 'package:pinne_server/src/generated/protocol.dart' as _i2yoimhd;
import 'package:serverpod/serverpod.dart' as _is;
import '../planning/approval_mode.dart' as _i6o5tozv;
import '../planning/plan_horizon.dart' as _if2ouyp9;

/// Editable planning rules. The owner comes from the session.
abstract class PlannerPreferencesDraft
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PlannerPreferencesDraft._({
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

  factory PlannerPreferencesDraft({
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
  }) = _PlannerPreferencesDraftImpl;

  factory PlannerPreferencesDraft.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PlannerPreferencesDraft(
      horizon: _if2ouyp9.PlanHorizon.fromJson(
        (jsonSerialization['horizon'] as String),
      ),
      weekdays: _i2yoimhd.Protocol().deserialize<List<int>>(
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

  _if2ouyp9.PlanHorizon horizon;

  List<int> weekdays;

  int windowStartMinute;

  int windowEndMinute;

  int sessionMinutes;

  int maxSessions;

  int bufferMinutes;

  int minLeadMinutes;

  String timezone;

  _i6o5tozv.ApprovalMode approvalMode;

  /// Returns a shallow copy of this [PlannerPreferencesDraft]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlannerPreferencesDraft copyWith({
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
      '__className__': 'PlannerPreferencesDraft',
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
      '__className__': 'PlannerPreferencesDraft',
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
    return _is.SerializationManager.encode(this);
  }
}

class _PlannerPreferencesDraftImpl extends PlannerPreferencesDraft {
  _PlannerPreferencesDraftImpl({
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

  /// Returns a shallow copy of this [PlannerPreferencesDraft]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlannerPreferencesDraft copyWith({
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
    return PlannerPreferencesDraft(
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
