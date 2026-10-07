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

/// Account-wide reminder preferences. Collection-specific delay overrides live
/// in ReminderRule and item controls take precedence over both.
abstract class ReminderSettings
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReminderSettings._({
    this.id,
    required this.ownerId,
    int? delayHours,
    String? timezone,
    int? timezoneOffsetMinutes,
    this.quietStartMinute,
    this.quietEndMinute,
    int? dailyCap,
    bool? remindersPaused,
    int? queueLimit,
    int? dismissCooldownMinutes,
  }) : delayHours = delayHours ?? 24,
       timezone = timezone ?? 'UTC',
       timezoneOffsetMinutes = timezoneOffsetMinutes ?? 0,
       dailyCap = dailyCap ?? 1,
       remindersPaused = remindersPaused ?? false,
       queueLimit = queueLimit ?? 5,
       dismissCooldownMinutes = dismissCooldownMinutes ?? 120;

  factory ReminderSettings({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    int? delayHours,
    String? timezone,
    int? timezoneOffsetMinutes,
    int? quietStartMinute,
    int? quietEndMinute,
    int? dailyCap,
    bool? remindersPaused,
    int? queueLimit,
    int? dismissCooldownMinutes,
  }) = _ReminderSettingsImpl;

  factory ReminderSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReminderSettings(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      delayHours: jsonSerialization['delayHours'] as int?,
      timezone: jsonSerialization['timezone'] as String?,
      timezoneOffsetMinutes: jsonSerialization['timezoneOffsetMinutes'] as int?,
      quietStartMinute: jsonSerialization['quietStartMinute'] as int?,
      quietEndMinute: jsonSerialization['quietEndMinute'] as int?,
      dailyCap: jsonSerialization['dailyCap'] as int?,
      remindersPaused: jsonSerialization['remindersPaused'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['remindersPaused'],
            ),
      queueLimit: jsonSerialization['queueLimit'] as int?,
      dismissCooldownMinutes:
          jsonSerialization['dismissCooldownMinutes'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  int delayHours;

  String timezone;

  /// Offset captured with the IANA timezone so quiet hours are deterministic
  /// even when a worker cannot load platform timezone data.
  int timezoneOffsetMinutes;

  int? quietStartMinute;

  int? quietEndMinute;

  int dailyCap;

  bool remindersPaused;

  int queueLimit;

  int dismissCooldownMinutes;

  /// Returns a shallow copy of this [ReminderSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReminderSettings copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
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
      '__className__': 'ReminderSettings',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
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
      '__className__': 'ReminderSettings',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderSettingsImpl extends ReminderSettings {
  _ReminderSettingsImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    int? delayHours,
    String? timezone,
    int? timezoneOffsetMinutes,
    int? quietStartMinute,
    int? quietEndMinute,
    int? dailyCap,
    bool? remindersPaused,
    int? queueLimit,
    int? dismissCooldownMinutes,
  }) : super._(
         id: id,
         ownerId: ownerId,
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

  /// Returns a shallow copy of this [ReminderSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReminderSettings copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
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
    return ReminderSettings(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
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
