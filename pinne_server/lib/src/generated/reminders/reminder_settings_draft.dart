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

abstract class ReminderSettingsDraft
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ReminderSettingsDraft._({
    required this.delayHours,
    required this.timezone,
    required this.timezoneOffsetMinutes,
    this.quietStartMinute,
    this.quietEndMinute,
    required this.dailyCap,
    required this.remindersPaused,
    required this.queueLimit,
    required this.dismissCooldownMinutes,
  });

  factory ReminderSettingsDraft({
    required int delayHours,
    required String timezone,
    required int timezoneOffsetMinutes,
    int? quietStartMinute,
    int? quietEndMinute,
    required int dailyCap,
    required bool remindersPaused,
    required int queueLimit,
    required int dismissCooldownMinutes,
  }) = _ReminderSettingsDraftImpl;

  factory ReminderSettingsDraft.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReminderSettingsDraft(
      delayHours: jsonSerialization['delayHours'] as int,
      timezone: jsonSerialization['timezone'] as String,
      timezoneOffsetMinutes: jsonSerialization['timezoneOffsetMinutes'] as int,
      quietStartMinute: jsonSerialization['quietStartMinute'] as int?,
      quietEndMinute: jsonSerialization['quietEndMinute'] as int?,
      dailyCap: jsonSerialization['dailyCap'] as int,
      remindersPaused: _is.BoolJsonExtension.fromJson(
        jsonSerialization['remindersPaused'],
      ),
      queueLimit: jsonSerialization['queueLimit'] as int,
      dismissCooldownMinutes:
          jsonSerialization['dismissCooldownMinutes'] as int,
    );
  }

  int delayHours;

  String timezone;

  int timezoneOffsetMinutes;

  int? quietStartMinute;

  int? quietEndMinute;

  int dailyCap;

  bool remindersPaused;

  int queueLimit;

  int dismissCooldownMinutes;

  /// Returns a shallow copy of this [ReminderSettingsDraft]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReminderSettingsDraft copyWith({
    int? delayHours,
    String? timezone,
    int? timezoneOffsetMinutes,
    int? quietStartMinute,
    int? quietEndMinute,
    int? dailyCap,
    bool? remindersPaused,
    int? queueLimit,
    int? dismissCooldownMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReminderSettingsDraft',
      'delayHours': delayHours,
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
      if (quietStartMinute != null) 'quietStartMinute': quietStartMinute,
      if (quietEndMinute != null) 'quietEndMinute': quietEndMinute,
      'dailyCap': dailyCap,
      'remindersPaused': remindersPaused,
      'queueLimit': queueLimit,
      'dismissCooldownMinutes': dismissCooldownMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReminderSettingsDraft',
      'delayHours': delayHours,
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
      if (quietStartMinute != null) 'quietStartMinute': quietStartMinute,
      if (quietEndMinute != null) 'quietEndMinute': quietEndMinute,
      'dailyCap': dailyCap,
      'remindersPaused': remindersPaused,
      'queueLimit': queueLimit,
      'dismissCooldownMinutes': dismissCooldownMinutes,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderSettingsDraftImpl extends ReminderSettingsDraft {
  _ReminderSettingsDraftImpl({
    required int delayHours,
    required String timezone,
    required int timezoneOffsetMinutes,
    int? quietStartMinute,
    int? quietEndMinute,
    required int dailyCap,
    required bool remindersPaused,
    required int queueLimit,
    required int dismissCooldownMinutes,
  }) : super._(
         delayHours: delayHours,
         timezone: timezone,
         timezoneOffsetMinutes: timezoneOffsetMinutes,
         quietStartMinute: quietStartMinute,
         quietEndMinute: quietEndMinute,
         dailyCap: dailyCap,
         remindersPaused: remindersPaused,
         queueLimit: queueLimit,
         dismissCooldownMinutes: dismissCooldownMinutes,
       );

  /// Returns a shallow copy of this [ReminderSettingsDraft]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReminderSettingsDraft copyWith({
    int? delayHours,
    String? timezone,
    int? timezoneOffsetMinutes,
    Object? quietStartMinute = _Undefined,
    Object? quietEndMinute = _Undefined,
    int? dailyCap,
    bool? remindersPaused,
    int? queueLimit,
    int? dismissCooldownMinutes,
  }) {
    return ReminderSettingsDraft(
      delayHours: delayHours ?? this.delayHours,
      timezone: timezone ?? this.timezone,
      timezoneOffsetMinutes:
          timezoneOffsetMinutes ?? this.timezoneOffsetMinutes,
      quietStartMinute: quietStartMinute is int?
          ? quietStartMinute
          : this.quietStartMinute,
      quietEndMinute: quietEndMinute is int?
          ? quietEndMinute
          : this.quietEndMinute,
      dailyCap: dailyCap ?? this.dailyCap,
      remindersPaused: remindersPaused ?? this.remindersPaused,
      queueLimit: queueLimit ?? this.queueLimit,
      dismissCooldownMinutes:
          dismissCooldownMinutes ?? this.dismissCooldownMinutes,
    );
  }
}
