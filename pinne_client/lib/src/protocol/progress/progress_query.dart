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
import '../progress/progress_period.dart' as _ibqwo0mh;

/// What the app asks progress for. The owner comes from the session.
abstract class ProgressQuery
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProgressQuery._({
    required this.period,
    this.customStartDate,
    this.customEndDate,
    required this.timezone,
    required this.timezoneOffsetMinutes,
  });

  factory ProgressQuery({
    required _ibqwo0mh.ProgressPeriod period,
    String? customStartDate,
    String? customEndDate,
    required String timezone,
    required int timezoneOffsetMinutes,
  }) = _ProgressQueryImpl;

  factory ProgressQuery.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProgressQuery(
      period: _ibqwo0mh.ProgressPeriod.fromJson(
        (jsonSerialization['period'] as String),
      ),
      customStartDate: jsonSerialization['customStartDate'] as String?,
      customEndDate: jsonSerialization['customEndDate'] as String?,
      timezone: jsonSerialization['timezone'] as String,
      timezoneOffsetMinutes: jsonSerialization['timezoneOffsetMinutes'] as int,
    );
  }

  _ibqwo0mh.ProgressPeriod period;

  /// Local start date (yyyy-MM-dd, inclusive). Only for `custom`.
  String? customStartDate;

  /// Local end date (yyyy-MM-dd, exclusive). Only for `custom`.
  String? customEndDate;

  /// IANA timezone of the device, kept for display and logs.
  String timezone;

  /// The device's current UTC offset. Local dates of the cohort are derived
  /// from it, the same way review events derive their effective local date.
  int timezoneOffsetMinutes;

  /// Returns a shallow copy of this [ProgressQuery]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProgressQuery copyWith({
    _ibqwo0mh.ProgressPeriod? period,
    String? customStartDate,
    String? customEndDate,
    String? timezone,
    int? timezoneOffsetMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProgressQuery',
      'period': period.toJson(),
      if (customStartDate != null) 'customStartDate': customStartDate,
      if (customEndDate != null) 'customEndDate': customEndDate,
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProgressQuery',
      'period': period.toJson(),
      if (customStartDate != null) 'customStartDate': customStartDate,
      if (customEndDate != null) 'customEndDate': customEndDate,
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProgressQueryImpl extends ProgressQuery {
  _ProgressQueryImpl({
    required _ibqwo0mh.ProgressPeriod period,
    String? customStartDate,
    String? customEndDate,
    required String timezone,
    required int timezoneOffsetMinutes,
  }) : super._(
         period: period,
         customStartDate: customStartDate,
         customEndDate: customEndDate,
         timezone: timezone,
         timezoneOffsetMinutes: timezoneOffsetMinutes,
       );

  /// Returns a shallow copy of this [ProgressQuery]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProgressQuery copyWith({
    _ibqwo0mh.ProgressPeriod? period,
    Object? customStartDate = _Undefined,
    Object? customEndDate = _Undefined,
    String? timezone,
    int? timezoneOffsetMinutes,
  }) {
    return ProgressQuery(
      period: period ?? this.period,
      customStartDate: customStartDate is String?
          ? customStartDate
          : this.customStartDate,
      customEndDate: customEndDate is String?
          ? customEndDate
          : this.customEndDate,
      timezone: timezone ?? this.timezone,
      timezoneOffsetMinutes:
          timezoneOffsetMinutes ?? this.timezoneOffsetMinutes,
    );
  }
}
