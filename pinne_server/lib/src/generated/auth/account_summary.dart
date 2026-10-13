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
import '../auth/profile_account_type.dart' as _i57fdtnn;

/// Owner-only authentication details safe to show on the profile screen.
abstract class AccountSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AccountSummary._({
    required this.type,
    this.email,
    required this.memberSince,
  });

  factory AccountSummary({
    required _i57fdtnn.ProfileAccountType type,
    String? email,
    required DateTime memberSince,
  }) = _AccountSummaryImpl;

  factory AccountSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountSummary(
      type: _i57fdtnn.ProfileAccountType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      email: jsonSerialization['email'] as String?,
      memberSince: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['memberSince'],
      ),
    );
  }

  _i57fdtnn.ProfileAccountType type;

  String? email;

  DateTime memberSince;

  /// Returns a shallow copy of this [AccountSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccountSummary copyWith({
    _i57fdtnn.ProfileAccountType? type,
    String? email,
    DateTime? memberSince,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountSummary',
      'type': type.toJson(),
      if (email != null) 'email': email,
      'memberSince': memberSince.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountSummary',
      'type': type.toJson(),
      if (email != null) 'email': email,
      'memberSince': memberSince.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountSummaryImpl extends AccountSummary {
  _AccountSummaryImpl({
    required _i57fdtnn.ProfileAccountType type,
    String? email,
    required DateTime memberSince,
  }) : super._(
         type: type,
         email: email,
         memberSince: memberSince,
       );

  /// Returns a shallow copy of this [AccountSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccountSummary copyWith({
    _i57fdtnn.ProfileAccountType? type,
    Object? email = _Undefined,
    DateTime? memberSince,
  }) {
    return AccountSummary(
      type: type ?? this.type,
      email: email is String? ? email : this.email,
      memberSince: memberSince ?? this.memberSince,
    );
  }
}
