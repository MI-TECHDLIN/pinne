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
import '../calendar/calendar_permission.dart' as _if02ip72;
import '../calendar/calendar_route.dart' as _iwvtbtmv;
import '../calendar/device_calendar_info.dart' as _i1nod3w8;

/// What a device reports about its calendars after asking the OS.
abstract class DeviceCalendarReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceCalendarReport._({
    required this.route,
    required this.deviceId,
    required this.label,
    required this.permission,
    required this.calendars,
    required this.checkedAt,
  });

  factory DeviceCalendarReport({
    required _iwvtbtmv.CalendarRoute route,
    required _isc.UuidValue deviceId,
    required String label,
    required _if02ip72.CalendarPermission permission,
    required List<_i1nod3w8.DeviceCalendarInfo> calendars,
    required DateTime checkedAt,
  }) = _DeviceCalendarReportImpl;

  factory DeviceCalendarReport.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceCalendarReport(
      route: _iwvtbtmv.CalendarRoute.fromJson(
        (jsonSerialization['route'] as String),
      ),
      deviceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      label: jsonSerialization['label'] as String,
      permission: _if02ip72.CalendarPermission.fromJson(
        (jsonSerialization['permission'] as String),
      ),
      calendars: _iub9zyhg.Protocol()
          .deserialize<List<_i1nod3w8.DeviceCalendarInfo>>(
            jsonSerialization['calendars'],
          ),
      checkedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['checkedAt'],
      ),
    );
  }

  _iwvtbtmv.CalendarRoute route;

  _isc.UuidValue deviceId;

  String label;

  _if02ip72.CalendarPermission permission;

  /// Empty when permission does not allow listing.
  List<_i1nod3w8.DeviceCalendarInfo> calendars;

  DateTime checkedAt;

  /// Returns a shallow copy of this [DeviceCalendarReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceCalendarReport copyWith({
    _iwvtbtmv.CalendarRoute? route,
    _isc.UuidValue? deviceId,
    String? label,
    _if02ip72.CalendarPermission? permission,
    List<_i1nod3w8.DeviceCalendarInfo>? calendars,
    DateTime? checkedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceCalendarReport',
      'route': route.toJson(),
      'deviceId': deviceId.toJson(),
      'label': label,
      'permission': permission.toJson(),
      'calendars': calendars.toJson(valueToJson: (v) => v.toJson()),
      'checkedAt': checkedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceCalendarReport',
      'route': route.toJson(),
      'deviceId': deviceId.toJson(),
      'label': label,
      'permission': permission.toJson(),
      'calendars': calendars.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'checkedAt': checkedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeviceCalendarReportImpl extends DeviceCalendarReport {
  _DeviceCalendarReportImpl({
    required _iwvtbtmv.CalendarRoute route,
    required _isc.UuidValue deviceId,
    required String label,
    required _if02ip72.CalendarPermission permission,
    required List<_i1nod3w8.DeviceCalendarInfo> calendars,
    required DateTime checkedAt,
  }) : super._(
         route: route,
         deviceId: deviceId,
         label: label,
         permission: permission,
         calendars: calendars,
         checkedAt: checkedAt,
       );

  /// Returns a shallow copy of this [DeviceCalendarReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceCalendarReport copyWith({
    _iwvtbtmv.CalendarRoute? route,
    _isc.UuidValue? deviceId,
    String? label,
    _if02ip72.CalendarPermission? permission,
    List<_i1nod3w8.DeviceCalendarInfo>? calendars,
    DateTime? checkedAt,
  }) {
    return DeviceCalendarReport(
      route: route ?? this.route,
      deviceId: deviceId ?? this.deviceId,
      label: label ?? this.label,
      permission: permission ?? this.permission,
      calendars:
          calendars ?? this.calendars.map((e0) => e0.copyWith()).toList(),
      checkedAt: checkedAt ?? this.checkedAt,
    );
  }
}
