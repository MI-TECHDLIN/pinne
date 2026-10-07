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

/// An item chosen for a session. Both ends share the owner.
abstract class SessionItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SessionItem._({
    this.id,
    required this.ownerId,
    required this.sessionId,
    required this.itemId,
    required this.position,
    required this.plannedMinutes,
    required this.estimated,
  });

  factory SessionItem({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue sessionId,
    required _isc.UuidValue itemId,
    required int position,
    required int plannedMinutes,
    required bool estimated,
  }) = _SessionItemImpl;

  factory SessionItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionItem(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      sessionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['sessionId'],
      ),
      itemId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      position: jsonSerialization['position'] as int,
      plannedMinutes: jsonSerialization['plannedMinutes'] as int,
      estimated: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['estimated'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue sessionId;

  _isc.UuidValue itemId;

  int position;

  /// An estimate unless the item's duration is known.
  int plannedMinutes;

  bool estimated;

  /// Returns a shallow copy of this [SessionItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SessionItem copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? sessionId,
    _isc.UuidValue? itemId,
    int? position,
    int? plannedMinutes,
    bool? estimated,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionItem',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'sessionId': sessionId.toJson(),
      'itemId': itemId.toJson(),
      'position': position,
      'plannedMinutes': plannedMinutes,
      'estimated': estimated,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionItem',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'sessionId': sessionId.toJson(),
      'itemId': itemId.toJson(),
      'position': position,
      'plannedMinutes': plannedMinutes,
      'estimated': estimated,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionItemImpl extends SessionItem {
  _SessionItemImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue sessionId,
    required _isc.UuidValue itemId,
    required int position,
    required int plannedMinutes,
    required bool estimated,
  }) : super._(
         id: id,
         ownerId: ownerId,
         sessionId: sessionId,
         itemId: itemId,
         position: position,
         plannedMinutes: plannedMinutes,
         estimated: estimated,
       );

  /// Returns a shallow copy of this [SessionItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SessionItem copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? sessionId,
    _isc.UuidValue? itemId,
    int? position,
    int? plannedMinutes,
    bool? estimated,
  }) {
    return SessionItem(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      sessionId: sessionId ?? this.sessionId,
      itemId: itemId ?? this.itemId,
      position: position ?? this.position,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      estimated: estimated ?? this.estimated,
    );
  }
}
