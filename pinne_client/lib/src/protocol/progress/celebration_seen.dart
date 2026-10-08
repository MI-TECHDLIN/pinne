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

/// A milestone celebration the owner has already seen.
abstract class CelebrationSeen
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CelebrationSeen._({
    this.id,
    required this.ownerId,
    required this.milestoneKey,
    DateTime? seenAt,
  }) : seenAt = seenAt ?? DateTime.now();

  factory CelebrationSeen({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required String milestoneKey,
    DateTime? seenAt,
  }) = _CelebrationSeenImpl;

  factory CelebrationSeen.fromJson(Map<String, dynamic> jsonSerialization) {
    return CelebrationSeen(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      milestoneKey: jsonSerialization['milestoneKey'] as String,
      seenAt: jsonSerialization['seenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['seenAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  String milestoneKey;

  DateTime seenAt;

  /// Returns a shallow copy of this [CelebrationSeen]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CelebrationSeen copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    String? milestoneKey,
    DateTime? seenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CelebrationSeen',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'milestoneKey': milestoneKey,
      'seenAt': seenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CelebrationSeen',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'milestoneKey': milestoneKey,
      'seenAt': seenAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CelebrationSeenImpl extends CelebrationSeen {
  _CelebrationSeenImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required String milestoneKey,
    DateTime? seenAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         milestoneKey: milestoneKey,
         seenAt: seenAt,
       );

  /// Returns a shallow copy of this [CelebrationSeen]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CelebrationSeen copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    String? milestoneKey,
    DateTime? seenAt,
  }) {
    return CelebrationSeen(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      milestoneKey: milestoneKey ?? this.milestoneKey,
      seenAt: seenAt ?? this.seenAt,
    );
  }
}
