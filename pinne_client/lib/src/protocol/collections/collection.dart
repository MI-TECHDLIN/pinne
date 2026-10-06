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

/// A user-defined group of items. Collections can nest; the parent must belong
/// to the same owner and must not create a cycle.
abstract class Collection
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Collection._({
    this.id,
    required this.ownerId,
    required this.name,
    this.description,
    this.parentId,
  });

  factory Collection({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required String name,
    String? description,
    _isc.UuidValue? parentId,
  }) = _CollectionImpl;

  factory Collection.fromJson(Map<String, dynamic> jsonSerialization) {
    return Collection(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  String name;

  String? description;

  _isc.UuidValue? parentId;

  /// Returns a shallow copy of this [Collection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Collection copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    String? name,
    String? description,
    _isc.UuidValue? parentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Collection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parentId': parentId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Collection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parentId': parentId?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CollectionImpl extends Collection {
  _CollectionImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required String name,
    String? description,
    _isc.UuidValue? parentId,
  }) : super._(
         id: id,
         ownerId: ownerId,
         name: name,
         description: description,
         parentId: parentId,
       );

  /// Returns a shallow copy of this [Collection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Collection copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    String? name,
    Object? description = _Undefined,
    Object? parentId = _Undefined,
  }) {
    return Collection(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      parentId: parentId is _isc.UuidValue? ? parentId : this.parentId,
    );
  }
}
