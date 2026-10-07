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

/// Item-specific reminder controls. Snooze and pause override broader rules.
abstract class ItemReviewControl
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ItemReviewControl._({
    this.id,
    required this.ownerId,
    required this.itemId,
    this.snoozedUntil,
    bool? remindersPaused,
    this.lastDismissedAt,
  }) : remindersPaused = remindersPaused ?? false;

  factory ItemReviewControl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    DateTime? snoozedUntil,
    bool? remindersPaused,
    DateTime? lastDismissedAt,
  }) = _ItemReviewControlImpl;

  factory ItemReviewControl.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemReviewControl(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      snoozedUntil: jsonSerialization['snoozedUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['snoozedUntil'],
            ),
      remindersPaused: jsonSerialization['remindersPaused'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['remindersPaused'],
            ),
      lastDismissedAt: jsonSerialization['lastDismissedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastDismissedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue itemId;

  DateTime? snoozedUntil;

  bool remindersPaused;

  DateTime? lastDismissedAt;

  /// Returns a shallow copy of this [ItemReviewControl]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ItemReviewControl copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    DateTime? snoozedUntil,
    bool? remindersPaused,
    DateTime? lastDismissedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemReviewControl',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      if (snoozedUntil != null) 'snoozedUntil': snoozedUntil?.toJson(),
      'remindersPaused': remindersPaused,
      if (lastDismissedAt != null) 'lastDismissedAt': lastDismissedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemReviewControl',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      if (snoozedUntil != null) 'snoozedUntil': snoozedUntil?.toJson(),
      'remindersPaused': remindersPaused,
      if (lastDismissedAt != null) 'lastDismissedAt': lastDismissedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemReviewControlImpl extends ItemReviewControl {
  _ItemReviewControlImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    DateTime? snoozedUntil,
    bool? remindersPaused,
    DateTime? lastDismissedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         snoozedUntil: snoozedUntil,
         remindersPaused: remindersPaused,
         lastDismissedAt: lastDismissedAt,
       );

  /// Returns a shallow copy of this [ItemReviewControl]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ItemReviewControl copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    Object? snoozedUntil = _Undefined,
    bool? remindersPaused,
    Object? lastDismissedAt = _Undefined,
  }) {
    return ItemReviewControl(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      snoozedUntil: snoozedUntil is DateTime?
          ? snoozedUntil
          : this.snoozedUntil,
      remindersPaused: remindersPaused ?? this.remindersPaused,
      lastDismissedAt: lastDismissedAt is DateTime?
          ? lastDismissedAt
          : this.lastDismissedAt,
    );
  }
}
