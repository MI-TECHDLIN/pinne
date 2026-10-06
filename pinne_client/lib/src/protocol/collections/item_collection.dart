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
import '../common/assignment_origin.dart' as _i12d5boj;

/// Membership of an item in a collection. Both ends must share the row owner.
abstract class ItemCollection
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ItemCollection._({
    this.id,
    required this.ownerId,
    required this.itemId,
    required this.collectionId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) : origin = origin ?? _i12d5boj.AssignmentOrigin.manual,
       manuallyLocked = manuallyLocked ?? false;

  factory ItemCollection({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    required _isc.UuidValue collectionId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) = _ItemCollectionImpl;

  factory ItemCollection.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemCollection(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      collectionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['collectionId'],
      ),
      origin: jsonSerialization['origin'] == null
          ? null
          : _i12d5boj.AssignmentOrigin.fromJson(
              (jsonSerialization['origin'] as String),
            ),
      manuallyLocked: jsonSerialization['manuallyLocked'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['manuallyLocked'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue itemId;

  _isc.UuidValue collectionId;

  _i12d5boj.AssignmentOrigin origin;

  /// True when the user placed it by hand, so AI must not move it.
  bool manuallyLocked;

  /// Returns a shallow copy of this [ItemCollection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ItemCollection copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    _isc.UuidValue? collectionId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemCollection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'collectionId': collectionId.toJson(),
      'origin': origin.toJson(),
      'manuallyLocked': manuallyLocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemCollection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'collectionId': collectionId.toJson(),
      'origin': origin.toJson(),
      'manuallyLocked': manuallyLocked,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemCollectionImpl extends ItemCollection {
  _ItemCollectionImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    required _isc.UuidValue collectionId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         collectionId: collectionId,
         origin: origin,
         manuallyLocked: manuallyLocked,
       );

  /// Returns a shallow copy of this [ItemCollection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ItemCollection copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    _isc.UuidValue? collectionId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) {
    return ItemCollection(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      collectionId: collectionId ?? this.collectionId,
      origin: origin ?? this.origin,
      manuallyLocked: manuallyLocked ?? this.manuallyLocked,
    );
  }
}
