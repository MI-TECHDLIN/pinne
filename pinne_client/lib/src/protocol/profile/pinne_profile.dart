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

/// One avatar recipe and display name per signed-in owner.
abstract class PinneProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PinneProfile._({
    this.id,
    required this.ownerId,
    required this.displayName,
    required this.avatarSeed,
    required this.avatarPalette,
  });

  factory PinneProfile({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required String displayName,
    required int avatarSeed,
    required int avatarPalette,
  }) = _PinneProfileImpl;

  factory PinneProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return PinneProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      displayName: jsonSerialization['displayName'] as String,
      avatarSeed: jsonSerialization['avatarSeed'] as int,
      avatarPalette: jsonSerialization['avatarPalette'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  String displayName;

  int avatarSeed;

  int avatarPalette;

  /// Returns a shallow copy of this [PinneProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PinneProfile copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    String? displayName,
    int? avatarSeed,
    int? avatarPalette,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PinneProfile',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'displayName': displayName,
      'avatarSeed': avatarSeed,
      'avatarPalette': avatarPalette,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PinneProfile',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'displayName': displayName,
      'avatarSeed': avatarSeed,
      'avatarPalette': avatarPalette,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PinneProfileImpl extends PinneProfile {
  _PinneProfileImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required String displayName,
    required int avatarSeed,
    required int avatarPalette,
  }) : super._(
         id: id,
         ownerId: ownerId,
         displayName: displayName,
         avatarSeed: avatarSeed,
         avatarPalette: avatarPalette,
       );

  /// Returns a shallow copy of this [PinneProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PinneProfile copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    String? displayName,
    int? avatarSeed,
    int? avatarPalette,
  }) {
    return PinneProfile(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      displayName: displayName ?? this.displayName,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      avatarPalette: avatarPalette ?? this.avatarPalette,
    );
  }
}
