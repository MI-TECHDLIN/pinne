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

enum PlanningErrorCode implements _isc.SerializableModel {
  /// No recent read of every conflict calendar. Unknown is never free.
  availabilityUnverified,

  /// A session now overlaps a busy time or is too soon.
  conflict,

  /// The planner is set to suggest only.
  proposeOnly,

  /// The plan was replaced or is too old to accept.
  planExpired;

  static PlanningErrorCode fromJson(String name) {
    switch (name) {
      case 'availabilityUnverified':
        return PlanningErrorCode.availabilityUnverified;
      case 'conflict':
        return PlanningErrorCode.conflict;
      case 'proposeOnly':
        return PlanningErrorCode.proposeOnly;
      case 'planExpired':
        return PlanningErrorCode.planExpired;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "PlanningErrorCode"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
