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

/// Whether the original content could be reached. Independent of lifecycle
/// and enrichment. A link that was never fetched is `unknown`.
enum AccessState implements _isc.SerializableModel {
  available,
  loginRequired,
  unavailable,
  unknown;

  static AccessState fromJson(String name) {
    switch (name) {
      case 'available':
        return AccessState.available;
      case 'loginRequired':
        return AccessState.loginRequired;
      case 'unavailable':
        return AccessState.unavailable;
      case 'unknown':
        return AccessState.unknown;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AccessState"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
