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
import '../calendar/calendar_permission.dart' as _if02ip72;
import '../calendar/calendar_route.dart' as _iwvtbtmv;

/// One calendar route for an owner, such as the calendars on one phone.
/// Provider secrets never live in this row.
abstract class CalendarConnection
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CalendarConnection._({
    this.id,
    required this.ownerId,
    required this.route,
    required this.accountKey,
    required this.label,
    this.deviceId,
    required this.permission,
    this.lastCheckedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CalendarConnection({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _iwvtbtmv.CalendarRoute route,
    required String accountKey,
    required String label,
    _isc.UuidValue? deviceId,
    required _if02ip72.CalendarPermission permission,
    DateTime? lastCheckedAt,
    DateTime? createdAt,
  }) = _CalendarConnectionImpl;

  factory CalendarConnection.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarConnection(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      route: _iwvtbtmv.CalendarRoute.fromJson(
        (jsonSerialization['route'] as String),
      ),
      accountKey: jsonSerialization['accountKey'] as String,
      label: jsonSerialization['label'] as String,
      deviceId: jsonSerialization['deviceId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
      permission: _if02ip72.CalendarPermission.fromJson(
        (jsonSerialization['permission'] as String),
      ),
      lastCheckedAt: jsonSerialization['lastCheckedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastCheckedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _iwvtbtmv.CalendarRoute route;

  /// For a device route, the id of the app install that holds the calendars.
  String accountKey;

  /// A name the user recognises, such as the phone model.
  String label;

  /// For device routes: only this install acts on the calendars.
  _isc.UuidValue? deviceId;

  _if02ip72.CalendarPermission permission;

  /// When the route last listed calendars or read busy times successfully.
  DateTime? lastCheckedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [CalendarConnection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CalendarConnection copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _iwvtbtmv.CalendarRoute? route,
    String? accountKey,
    String? label,
    _isc.UuidValue? deviceId,
    _if02ip72.CalendarPermission? permission,
    DateTime? lastCheckedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarConnection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'route': route.toJson(),
      'accountKey': accountKey,
      'label': label,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'permission': permission.toJson(),
      if (lastCheckedAt != null) 'lastCheckedAt': lastCheckedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarConnection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'route': route.toJson(),
      'accountKey': accountKey,
      'label': label,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'permission': permission.toJson(),
      if (lastCheckedAt != null) 'lastCheckedAt': lastCheckedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarConnectionImpl extends CalendarConnection {
  _CalendarConnectionImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _iwvtbtmv.CalendarRoute route,
    required String accountKey,
    required String label,
    _isc.UuidValue? deviceId,
    required _if02ip72.CalendarPermission permission,
    DateTime? lastCheckedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         route: route,
         accountKey: accountKey,
         label: label,
         deviceId: deviceId,
         permission: permission,
         lastCheckedAt: lastCheckedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CalendarConnection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CalendarConnection copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _iwvtbtmv.CalendarRoute? route,
    String? accountKey,
    String? label,
    Object? deviceId = _Undefined,
    _if02ip72.CalendarPermission? permission,
    Object? lastCheckedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return CalendarConnection(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      route: route ?? this.route,
      accountKey: accountKey ?? this.accountKey,
      label: label ?? this.label,
      deviceId: deviceId is _isc.UuidValue? ? deviceId : this.deviceId,
      permission: permission ?? this.permission,
      lastCheckedAt: lastCheckedAt is DateTime?
          ? lastCheckedAt
          : this.lastCheckedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
