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

/// How well one conflict calendar was checked for a plan.
enum CoverageState implements _isc.SerializableModel {
  /// Read recently over the whole plan window.
  checked,

  /// Read, but too long ago to trust.
  stale,

  /// Read, but not over the whole plan window.
  partial,

  /// The device could not read it, such as after permission was revoked.
  unreadable,

  /// No reading was sent for it.
  notChecked;

  static CoverageState fromJson(String name) {
    switch (name) {
      case 'checked':
        return CoverageState.checked;
      case 'stale':
        return CoverageState.stale;
      case 'partial':
        return CoverageState.partial;
      case 'unreadable':
        return CoverageState.unreadable;
      case 'notChecked':
        return CoverageState.notChecked;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "CoverageState"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
