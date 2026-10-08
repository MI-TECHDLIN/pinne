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

abstract class ProgressSettingsDraft
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProgressSettingsDraft._({
    required this.streakEnabled,
    required this.weeklyGoalDays,
  });

  factory ProgressSettingsDraft({
    required bool streakEnabled,
    required int weeklyGoalDays,
  }) = _ProgressSettingsDraftImpl;

  factory ProgressSettingsDraft.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProgressSettingsDraft(
      streakEnabled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['streakEnabled'],
      ),
      weeklyGoalDays: jsonSerialization['weeklyGoalDays'] as int,
    );
  }

  bool streakEnabled;

  int weeklyGoalDays;

  /// Returns a shallow copy of this [ProgressSettingsDraft]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProgressSettingsDraft copyWith({
    bool? streakEnabled,
    int? weeklyGoalDays,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProgressSettingsDraft',
      'streakEnabled': streakEnabled,
      'weeklyGoalDays': weeklyGoalDays,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProgressSettingsDraft',
      'streakEnabled': streakEnabled,
      'weeklyGoalDays': weeklyGoalDays,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ProgressSettingsDraftImpl extends ProgressSettingsDraft {
  _ProgressSettingsDraftImpl({
    required bool streakEnabled,
    required int weeklyGoalDays,
  }) : super._(
         streakEnabled: streakEnabled,
         weeklyGoalDays: weeklyGoalDays,
       );

  /// Returns a shallow copy of this [ProgressSettingsDraft]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProgressSettingsDraft copyWith({
    bool? streakEnabled,
    int? weeklyGoalDays,
  }) {
    return ProgressSettingsDraft(
      streakEnabled: streakEnabled ?? this.streakEnabled,
      weeklyGoalDays: weeklyGoalDays ?? this.weeklyGoalDays,
    );
  }
}
