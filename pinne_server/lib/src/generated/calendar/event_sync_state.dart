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

/// Where a session's calendar event stands.
enum EventSyncState implements _is.SerializableModel {
  pendingCreate,
  synced,
  pendingUpdate,
  pendingDelete,
  deleted,

  /// The event disappeared from the calendar outside Pinne.
  missing,

  /// The id now points at an event Pinne did not create; left untouched.
  foreign;

  static EventSyncState fromJson(String name) {
    switch (name) {
      case 'pendingCreate':
        return EventSyncState.pendingCreate;
      case 'synced':
        return EventSyncState.synced;
      case 'pendingUpdate':
        return EventSyncState.pendingUpdate;
      case 'pendingDelete':
        return EventSyncState.pendingDelete;
      case 'deleted':
        return EventSyncState.deleted;
      case 'missing':
        return EventSyncState.missing;
      case 'foreign':
        return EventSyncState.foreign;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "EventSyncState"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
