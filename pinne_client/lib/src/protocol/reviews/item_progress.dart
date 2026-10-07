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

/// Rebuildable projection of valid review events for one owned item.
abstract class ItemProgress
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ItemProgress._({
    this.id,
    required this.ownerId,
    required this.itemId,
    this.firstOpenedAt,
    this.lastOpenedAt,
    int? openCount,
    this.firstReviewedAt,
    this.lastReviewedAt,
    this.completedAt,
    this.appliedAt,
    DateTime? rebuiltAt,
  }) : openCount = openCount ?? 0,
       rebuiltAt = rebuiltAt ?? DateTime.now();

  factory ItemProgress({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    DateTime? firstOpenedAt,
    DateTime? lastOpenedAt,
    int? openCount,
    DateTime? firstReviewedAt,
    DateTime? lastReviewedAt,
    DateTime? completedAt,
    DateTime? appliedAt,
    DateTime? rebuiltAt,
  }) = _ItemProgressImpl;

  factory ItemProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemProgress(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      firstOpenedAt: jsonSerialization['firstOpenedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstOpenedAt'],
            ),
      lastOpenedAt: jsonSerialization['lastOpenedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastOpenedAt'],
            ),
      openCount: jsonSerialization['openCount'] as int?,
      firstReviewedAt: jsonSerialization['firstReviewedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstReviewedAt'],
            ),
      lastReviewedAt: jsonSerialization['lastReviewedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastReviewedAt'],
            ),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      appliedAt: jsonSerialization['appliedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['appliedAt']),
      rebuiltAt: jsonSerialization['rebuiltAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['rebuiltAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue itemId;

  DateTime? firstOpenedAt;

  DateTime? lastOpenedAt;

  int openCount;

  DateTime? firstReviewedAt;

  DateTime? lastReviewedAt;

  DateTime? completedAt;

  DateTime? appliedAt;

  DateTime rebuiltAt;

  /// Returns a shallow copy of this [ItemProgress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ItemProgress copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    DateTime? firstOpenedAt,
    DateTime? lastOpenedAt,
    int? openCount,
    DateTime? firstReviewedAt,
    DateTime? lastReviewedAt,
    DateTime? completedAt,
    DateTime? appliedAt,
    DateTime? rebuiltAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemProgress',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      if (firstOpenedAt != null) 'firstOpenedAt': firstOpenedAt?.toJson(),
      if (lastOpenedAt != null) 'lastOpenedAt': lastOpenedAt?.toJson(),
      'openCount': openCount,
      if (firstReviewedAt != null) 'firstReviewedAt': firstReviewedAt?.toJson(),
      if (lastReviewedAt != null) 'lastReviewedAt': lastReviewedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (appliedAt != null) 'appliedAt': appliedAt?.toJson(),
      'rebuiltAt': rebuiltAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemProgress',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      if (firstOpenedAt != null) 'firstOpenedAt': firstOpenedAt?.toJson(),
      if (lastOpenedAt != null) 'lastOpenedAt': lastOpenedAt?.toJson(),
      'openCount': openCount,
      if (firstReviewedAt != null) 'firstReviewedAt': firstReviewedAt?.toJson(),
      if (lastReviewedAt != null) 'lastReviewedAt': lastReviewedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (appliedAt != null) 'appliedAt': appliedAt?.toJson(),
      'rebuiltAt': rebuiltAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemProgressImpl extends ItemProgress {
  _ItemProgressImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    DateTime? firstOpenedAt,
    DateTime? lastOpenedAt,
    int? openCount,
    DateTime? firstReviewedAt,
    DateTime? lastReviewedAt,
    DateTime? completedAt,
    DateTime? appliedAt,
    DateTime? rebuiltAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         firstOpenedAt: firstOpenedAt,
         lastOpenedAt: lastOpenedAt,
         openCount: openCount,
         firstReviewedAt: firstReviewedAt,
         lastReviewedAt: lastReviewedAt,
         completedAt: completedAt,
         appliedAt: appliedAt,
         rebuiltAt: rebuiltAt,
       );

  /// Returns a shallow copy of this [ItemProgress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ItemProgress copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    Object? firstOpenedAt = _Undefined,
    Object? lastOpenedAt = _Undefined,
    int? openCount,
    Object? firstReviewedAt = _Undefined,
    Object? lastReviewedAt = _Undefined,
    Object? completedAt = _Undefined,
    Object? appliedAt = _Undefined,
    DateTime? rebuiltAt,
  }) {
    return ItemProgress(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      firstOpenedAt: firstOpenedAt is DateTime?
          ? firstOpenedAt
          : this.firstOpenedAt,
      lastOpenedAt: lastOpenedAt is DateTime?
          ? lastOpenedAt
          : this.lastOpenedAt,
      openCount: openCount ?? this.openCount,
      firstReviewedAt: firstReviewedAt is DateTime?
          ? firstReviewedAt
          : this.firstReviewedAt,
      lastReviewedAt: lastReviewedAt is DateTime?
          ? lastReviewedAt
          : this.lastReviewedAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      appliedAt: appliedAt is DateTime? ? appliedAt : this.appliedAt,
      rebuiltAt: rebuiltAt ?? this.rebuiltAt,
    );
  }
}
