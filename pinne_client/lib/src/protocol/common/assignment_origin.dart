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

/// How an item was placed into a collection or given a tag.
enum AssignmentOrigin implements _isc.SerializableModel {
  manual,
  ai,
  imported;

  static AssignmentOrigin fromJson(String name) {
    switch (name) {
      case 'manual':
        return AssignmentOrigin.manual;
      case 'ai':
        return AssignmentOrigin.ai;
      case 'imported':
        return AssignmentOrigin.imported;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AssignmentOrigin"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
