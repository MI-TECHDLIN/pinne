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

enum CalendarWriteOutcome implements _isc.SerializableModel {
  done,

  /// Delete found nothing to delete.
  alreadyGone,

  /// The event id points at an event Pinne did not write; left untouched.
  notOurs,

  /// The user moved the event in their calendar app.
  moved,

  /// The user removed the event in their calendar app.
  missing,

  /// Will be retried.
  failed;

  static CalendarWriteOutcome fromJson(String name) {
    switch (name) {
      case 'done':
        return CalendarWriteOutcome.done;
      case 'alreadyGone':
        return CalendarWriteOutcome.alreadyGone;
      case 'notOurs':
        return CalendarWriteOutcome.notOurs;
      case 'moved':
        return CalendarWriteOutcome.moved;
      case 'missing':
        return CalendarWriteOutcome.missing;
      case 'failed':
        return CalendarWriteOutcome.failed;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "CalendarWriteOutcome"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
