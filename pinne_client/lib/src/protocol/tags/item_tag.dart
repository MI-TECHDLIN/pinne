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

/// A tag on an item. Both ends must share the row owner.
abstract class ItemTag
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ItemTag._({
    this.id,
    required this.ownerId,
    required this.itemId,
    required this.tagId,
    _i12d5boj.AssignmentOrigin? origin,
  }) : origin = origin ?? _i12d5boj.AssignmentOrigin.manual;

  factory ItemTag({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    required _isc.UuidValue tagId,
    _i12d5boj.AssignmentOrigin? origin,
  }) = _ItemTagImpl;

  factory ItemTag.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemTag(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      tagId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['tagId']),
      origin: jsonSerialization['origin'] == null
          ? null
          : _i12d5boj.AssignmentOrigin.fromJson(
              (jsonSerialization['origin'] as String),
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue itemId;

  _isc.UuidValue tagId;

  _i12d5boj.AssignmentOrigin origin;

  /// Returns a shallow copy of this [ItemTag]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ItemTag copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    _isc.UuidValue? tagId,
    _i12d5boj.AssignmentOrigin? origin,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemTag',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'tagId': tagId.toJson(),
      'origin': origin.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemTag',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'tagId': tagId.toJson(),
      'origin': origin.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemTagImpl extends ItemTag {
  _ItemTagImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    required _isc.UuidValue tagId,
    _i12d5boj.AssignmentOrigin? origin,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         tagId: tagId,
         origin: origin,
       );

  /// Returns a shallow copy of this [ItemTag]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ItemTag copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    _isc.UuidValue? tagId,
    _i12d5boj.AssignmentOrigin? origin,
  }) {
    return ItemTag(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      tagId: tagId ?? this.tagId,
      origin: origin ?? this.origin,
    );
  }
}
