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
import 'package:serverpod/serverpod.dart' as _is;

/// Editable profile fields. Identity always comes from the session.
abstract class ProfileDraft
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProfileDraft._({
    required this.displayName,
    required this.avatarSeed,
    required this.avatarPalette,
  });

  factory ProfileDraft({
    required String displayName,
    required int avatarSeed,
    required int avatarPalette,
  }) = _ProfileDraftImpl;

  factory ProfileDraft.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProfileDraft(
      displayName: jsonSerialization['displayName'] as String,
      avatarSeed: jsonSerialization['avatarSeed'] as int,
      avatarPalette: jsonSerialization['avatarPalette'] as int,
    );
  }

  String displayName;

  int avatarSeed;

  int avatarPalette;

  /// Returns a shallow copy of this [ProfileDraft]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProfileDraft copyWith({
    String? displayName,
    int? avatarSeed,
    int? avatarPalette,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProfileDraft',
      'displayName': displayName,
      'avatarSeed': avatarSeed,
      'avatarPalette': avatarPalette,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProfileDraft',
      'displayName': displayName,
      'avatarSeed': avatarSeed,
      'avatarPalette': avatarPalette,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ProfileDraftImpl extends ProfileDraft {
  _ProfileDraftImpl({
    required String displayName,
    required int avatarSeed,
    required int avatarPalette,
  }) : super._(
         displayName: displayName,
         avatarSeed: avatarSeed,
         avatarPalette: avatarPalette,
       );

  /// Returns a shallow copy of this [ProfileDraft]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProfileDraft copyWith({
    String? displayName,
    int? avatarSeed,
    int? avatarPalette,
  }) {
    return ProfileDraft(
      displayName: displayName ?? this.displayName,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      avatarPalette: avatarPalette ?? this.avatarPalette,
    );
  }
}
