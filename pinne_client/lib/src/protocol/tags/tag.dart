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

/// A label. Names are unique per owner after normalization.
abstract class Tag
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Tag._({
    this.id,
    required this.ownerId,
    required this.normalizedName,
    required this.displayName,
  });

  factory Tag({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required String normalizedName,
    required String displayName,
  }) = _TagImpl;

  factory Tag.fromJson(Map<String, dynamic> jsonSerialization) {
    return Tag(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      normalizedName: jsonSerialization['normalizedName'] as String,
      displayName: jsonSerialization['displayName'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  String normalizedName;

  String displayName;

  /// Returns a shallow copy of this [Tag]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Tag copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    String? normalizedName,
    String? displayName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Tag',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'normalizedName': normalizedName,
      'displayName': displayName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Tag',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'normalizedName': normalizedName,
      'displayName': displayName,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TagImpl extends Tag {
  _TagImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required String normalizedName,
    required String displayName,
  }) : super._(
         id: id,
         ownerId: ownerId,
         normalizedName: normalizedName,
         displayName: displayName,
       );

  /// Returns a shallow copy of this [Tag]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Tag copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    String? normalizedName,
    String? displayName,
  }) {
    return Tag(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      normalizedName: normalizedName ?? this.normalizedName,
      displayName: displayName ?? this.displayName,
    );
  }
}
