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
import 'package:pinne_client/src/protocol/protocol.dart' as _iub9zyhg;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../planning/calendar_coverage.dart' as _ip3capvs;

/// One proposal of review sessions, with the availability it was based on.
abstract class ReviewPlan
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReviewPlan._({
    this.id,
    required this.ownerId,
    DateTime? createdAt,
    required this.horizonStart,
    required this.horizonEnd,
    required this.timezone,
    required this.coverage,
    required this.availabilityVerified,
    this.commitOperationId,
    this.committedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ReviewPlan({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    DateTime? createdAt,
    required DateTime horizonStart,
    required DateTime horizonEnd,
    required String timezone,
    required List<_ip3capvs.CalendarCoverage> coverage,
    required bool availabilityVerified,
    _isc.UuidValue? commitOperationId,
    DateTime? committedAt,
  }) = _ReviewPlanImpl;

  factory ReviewPlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewPlan(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      horizonStart: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['horizonStart'],
      ),
      horizonEnd: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['horizonEnd'],
      ),
      timezone: jsonSerialization['timezone'] as String,
      coverage: _iub9zyhg.Protocol()
          .deserialize<List<_ip3capvs.CalendarCoverage>>(
            jsonSerialization['coverage'],
          ),
      availabilityVerified: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['availabilityVerified'],
      ),
      commitOperationId: jsonSerialization['commitOperationId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['commitOperationId'],
            ),
      committedAt: jsonSerialization['committedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['committedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  DateTime createdAt;

  DateTime horizonStart;

  DateTime horizonEnd;

  String timezone;

  List<_ip3capvs.CalendarCoverage> coverage;

  /// True only when every conflict calendar was checked recently.
  bool availabilityVerified;

  /// Set once accepted; a retry with the same id replays the result.
  _isc.UuidValue? commitOperationId;

  DateTime? committedAt;

  /// Returns a shallow copy of this [ReviewPlan]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReviewPlan copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    DateTime? createdAt,
    DateTime? horizonStart,
    DateTime? horizonEnd,
    String? timezone,
    List<_ip3capvs.CalendarCoverage>? coverage,
    bool? availabilityVerified,
    _isc.UuidValue? commitOperationId,
    DateTime? committedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewPlan',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'createdAt': createdAt.toJson(),
      'horizonStart': horizonStart.toJson(),
      'horizonEnd': horizonEnd.toJson(),
      'timezone': timezone,
      'coverage': coverage.toJson(valueToJson: (v) => v.toJson()),
      'availabilityVerified': availabilityVerified,
      if (commitOperationId != null)
        'commitOperationId': commitOperationId?.toJson(),
      if (committedAt != null) 'committedAt': committedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewPlan',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'createdAt': createdAt.toJson(),
      'horizonStart': horizonStart.toJson(),
      'horizonEnd': horizonEnd.toJson(),
      'timezone': timezone,
      'coverage': coverage.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'availabilityVerified': availabilityVerified,
      if (commitOperationId != null)
        'commitOperationId': commitOperationId?.toJson(),
      if (committedAt != null) 'committedAt': committedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewPlanImpl extends ReviewPlan {
  _ReviewPlanImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    DateTime? createdAt,
    required DateTime horizonStart,
    required DateTime horizonEnd,
    required String timezone,
    required List<_ip3capvs.CalendarCoverage> coverage,
    required bool availabilityVerified,
    _isc.UuidValue? commitOperationId,
    DateTime? committedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         createdAt: createdAt,
         horizonStart: horizonStart,
         horizonEnd: horizonEnd,
         timezone: timezone,
         coverage: coverage,
         availabilityVerified: availabilityVerified,
         commitOperationId: commitOperationId,
         committedAt: committedAt,
       );

  /// Returns a shallow copy of this [ReviewPlan]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReviewPlan copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    DateTime? createdAt,
    DateTime? horizonStart,
    DateTime? horizonEnd,
    String? timezone,
    List<_ip3capvs.CalendarCoverage>? coverage,
    bool? availabilityVerified,
    Object? commitOperationId = _Undefined,
    Object? committedAt = _Undefined,
  }) {
    return ReviewPlan(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      horizonStart: horizonStart ?? this.horizonStart,
      horizonEnd: horizonEnd ?? this.horizonEnd,
      timezone: timezone ?? this.timezone,
      coverage: coverage ?? this.coverage.map((e0) => e0.copyWith()).toList(),
      availabilityVerified: availabilityVerified ?? this.availabilityVerified,
      commitOperationId: commitOperationId is _isc.UuidValue?
          ? commitOperationId
          : this.commitOperationId,
      committedAt: committedAt is DateTime? ? committedAt : this.committedAt,
    );
  }
}
