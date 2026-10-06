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

/// One calendar as the device lists it.
abstract class DeviceCalendarInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceCalendarInfo._({
    required this.externalCalendarId,
    required this.name,
    this.accountName,
    required this.readOnly,
    required this.isPrimary,
  });

  factory DeviceCalendarInfo({
    required String externalCalendarId,
    required String name,
    String? accountName,
    required bool readOnly,
    required bool isPrimary,
  }) = _DeviceCalendarInfoImpl;

  factory DeviceCalendarInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceCalendarInfo(
      externalCalendarId: jsonSerialization['externalCalendarId'] as String,
      name: jsonSerialization['name'] as String,
      accountName: jsonSerialization['accountName'] as String?,
      readOnly: _is.BoolJsonExtension.fromJson(jsonSerialization['readOnly']),
      isPrimary: _is.BoolJsonExtension.fromJson(jsonSerialization['isPrimary']),
    );
  }

  String externalCalendarId;

  String name;

  String? accountName;

  bool readOnly;

  bool isPrimary;

  /// Returns a shallow copy of this [DeviceCalendarInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceCalendarInfo copyWith({
    String? externalCalendarId,
    String? name,
    String? accountName,
    bool? readOnly,
    bool? isPrimary,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceCalendarInfo',
      'externalCalendarId': externalCalendarId,
      'name': name,
      if (accountName != null) 'accountName': accountName,
      'readOnly': readOnly,
      'isPrimary': isPrimary,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceCalendarInfo',
      'externalCalendarId': externalCalendarId,
      'name': name,
      if (accountName != null) 'accountName': accountName,
      'readOnly': readOnly,
      'isPrimary': isPrimary,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceCalendarInfoImpl extends DeviceCalendarInfo {
  _DeviceCalendarInfoImpl({
    required String externalCalendarId,
    required String name,
    String? accountName,
    required bool readOnly,
    required bool isPrimary,
  }) : super._(
         externalCalendarId: externalCalendarId,
         name: name,
         accountName: accountName,
         readOnly: readOnly,
         isPrimary: isPrimary,
       );

  /// Returns a shallow copy of this [DeviceCalendarInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceCalendarInfo copyWith({
    String? externalCalendarId,
    String? name,
    Object? accountName = _Undefined,
    bool? readOnly,
    bool? isPrimary,
  }) {
    return DeviceCalendarInfo(
      externalCalendarId: externalCalendarId ?? this.externalCalendarId,
      name: name ?? this.name,
      accountName: accountName is String? ? accountName : this.accountName,
      readOnly: readOnly ?? this.readOnly,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}
