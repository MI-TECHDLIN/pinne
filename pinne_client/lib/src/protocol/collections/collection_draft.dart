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

/// Client input for creating a collection.
abstract class CollectionDraft
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CollectionDraft._({
    required this.name,
    this.description,
    this.parentId,
    required this.coverSeed,
    required this.paletteIndex,
  });

  factory CollectionDraft({
    required String name,
    String? description,
    _isc.UuidValue? parentId,
    required int coverSeed,
    required int paletteIndex,
  }) = _CollectionDraftImpl;

  factory CollectionDraft.fromJson(Map<String, dynamic> jsonSerialization) {
    return CollectionDraft(
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
      coverSeed: jsonSerialization['coverSeed'] as int,
      paletteIndex: jsonSerialization['paletteIndex'] as int,
    );
  }

  String name;

  String? description;

  _isc.UuidValue? parentId;

  int coverSeed;

  int paletteIndex;

  /// Returns a shallow copy of this [CollectionDraft]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CollectionDraft copyWith({
    String? name,
    String? description,
    _isc.UuidValue? parentId,
    int? coverSeed,
    int? paletteIndex,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CollectionDraft',
      'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parentId': parentId?.toJson(),
      'coverSeed': coverSeed,
      'paletteIndex': paletteIndex,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CollectionDraft',
      'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parentId': parentId?.toJson(),
      'coverSeed': coverSeed,
      'paletteIndex': paletteIndex,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CollectionDraftImpl extends CollectionDraft {
  _CollectionDraftImpl({
    required String name,
    String? description,
    _isc.UuidValue? parentId,
    required int coverSeed,
    required int paletteIndex,
  }) : super._(
         name: name,
         description: description,
         parentId: parentId,
         coverSeed: coverSeed,
         paletteIndex: paletteIndex,
       );

  /// Returns a shallow copy of this [CollectionDraft]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CollectionDraft copyWith({
    String? name,
    Object? description = _Undefined,
    Object? parentId = _Undefined,
    int? coverSeed,
    int? paletteIndex,
  }) {
    return CollectionDraft(
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      parentId: parentId is _isc.UuidValue? ? parentId : this.parentId,
      coverSeed: coverSeed ?? this.coverSeed,
      paletteIndex: paletteIndex ?? this.paletteIndex,
    );
  }
}
