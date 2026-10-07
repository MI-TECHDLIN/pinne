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

/// A calendar of a connection, with how the owner uses it. Device calendar
/// ids are only meaningful on the device in `deviceId`.
abstract class CalendarSelection
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CalendarSelection._({
    this.id,
    required this.ownerId,
    required this.connectionId,
    required this.externalCalendarId,
    this.deviceId,
    required this.name,
    this.accountName,
    required this.readOnly,
    bool? useForConflicts,
    bool? useForWrites,
  }) : useForConflicts = useForConflicts ?? false,
       useForWrites = useForWrites ?? false;

  factory CalendarSelection({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue connectionId,
    required String externalCalendarId,
    _isc.UuidValue? deviceId,
    required String name,
    String? accountName,
    required bool readOnly,
    bool? useForConflicts,
    bool? useForWrites,
  }) = _CalendarSelectionImpl;

  factory CalendarSelection.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarSelection(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      connectionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['connectionId'],
      ),
      externalCalendarId: jsonSerialization['externalCalendarId'] as String,
      deviceId: jsonSerialization['deviceId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
      name: jsonSerialization['name'] as String,
      accountName: jsonSerialization['accountName'] as String?,
      readOnly: _isc.BoolJsonExtension.fromJson(jsonSerialization['readOnly']),
      useForConflicts: jsonSerialization['useForConflicts'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['useForConflicts'],
            ),
      useForWrites: jsonSerialization['useForWrites'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['useForWrites']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue connectionId;

  String externalCalendarId;

  _isc.UuidValue? deviceId;

  String name;

  String? accountName;

  bool readOnly;

  /// Busy times in this calendar block sessions.
  bool useForConflicts;

  /// Sessions are written here. At most one per owner.
  bool useForWrites;

  /// Returns a shallow copy of this [CalendarSelection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CalendarSelection copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? connectionId,
    String? externalCalendarId,
    _isc.UuidValue? deviceId,
    String? name,
    String? accountName,
    bool? readOnly,
    bool? useForConflicts,
    bool? useForWrites,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarSelection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'connectionId': connectionId.toJson(),
      'externalCalendarId': externalCalendarId,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'name': name,
      if (accountName != null) 'accountName': accountName,
      'readOnly': readOnly,
      'useForConflicts': useForConflicts,
      'useForWrites': useForWrites,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarSelection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'connectionId': connectionId.toJson(),
      'externalCalendarId': externalCalendarId,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'name': name,
      if (accountName != null) 'accountName': accountName,
      'readOnly': readOnly,
      'useForConflicts': useForConflicts,
      'useForWrites': useForWrites,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarSelectionImpl extends CalendarSelection {
  _CalendarSelectionImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue connectionId,
    required String externalCalendarId,
    _isc.UuidValue? deviceId,
    required String name,
    String? accountName,
    required bool readOnly,
    bool? useForConflicts,
    bool? useForWrites,
  }) : super._(
         id: id,
         ownerId: ownerId,
         connectionId: connectionId,
         externalCalendarId: externalCalendarId,
         deviceId: deviceId,
         name: name,
         accountName: accountName,
         readOnly: readOnly,
         useForConflicts: useForConflicts,
         useForWrites: useForWrites,
       );

  /// Returns a shallow copy of this [CalendarSelection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CalendarSelection copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? connectionId,
    String? externalCalendarId,
    Object? deviceId = _Undefined,
    String? name,
    Object? accountName = _Undefined,
    bool? readOnly,
    bool? useForConflicts,
    bool? useForWrites,
  }) {
    return CalendarSelection(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      connectionId: connectionId ?? this.connectionId,
      externalCalendarId: externalCalendarId ?? this.externalCalendarId,
      deviceId: deviceId is _isc.UuidValue? ? deviceId : this.deviceId,
      name: name ?? this.name,
      accountName: accountName is String? ? accountName : this.accountName,
      readOnly: readOnly ?? this.readOnly,
      useForConflicts: useForConflicts ?? this.useForConflicts,
      useForWrites: useForWrites ?? this.useForWrites,
    );
  }
}
