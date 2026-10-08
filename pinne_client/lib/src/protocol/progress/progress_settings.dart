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

/// The owner's progress preferences. Streaks are opt-in.
abstract class ProgressSettings
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProgressSettings._({
    this.id,
    required this.ownerId,
    bool? streakEnabled,
    int? weeklyGoalDays,
  }) : streakEnabled = streakEnabled ?? false,
       weeklyGoalDays = weeklyGoalDays ?? 3;

  factory ProgressSettings({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    bool? streakEnabled,
    int? weeklyGoalDays,
  }) = _ProgressSettingsImpl;

  factory ProgressSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProgressSettings(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      streakEnabled: jsonSerialization['streakEnabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['streakEnabled']),
      weeklyGoalDays: jsonSerialization['weeklyGoalDays'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  bool streakEnabled;

  /// Distinct review days per week that count as the weekly goal.
  int weeklyGoalDays;

  /// Returns a shallow copy of this [ProgressSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProgressSettings copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    bool? streakEnabled,
    int? weeklyGoalDays,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProgressSettings',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'streakEnabled': streakEnabled,
      'weeklyGoalDays': weeklyGoalDays,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProgressSettings',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'streakEnabled': streakEnabled,
      'weeklyGoalDays': weeklyGoalDays,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProgressSettingsImpl extends ProgressSettings {
  _ProgressSettingsImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    bool? streakEnabled,
    int? weeklyGoalDays,
  }) : super._(
         id: id,
         ownerId: ownerId,
         streakEnabled: streakEnabled,
         weeklyGoalDays: weeklyGoalDays,
       );

  /// Returns a shallow copy of this [ProgressSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProgressSettings copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    bool? streakEnabled,
    int? weeklyGoalDays,
  }) {
    return ProgressSettings(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      streakEnabled: streakEnabled ?? this.streakEnabled,
      weeklyGoalDays: weeklyGoalDays ?? this.weeklyGoalDays,
    );
  }
}
