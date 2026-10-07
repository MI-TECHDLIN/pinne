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
import '../planning/approval_mode.dart' as _i6o5tozv;
import '../planning/session_status.dart' as _ikijcapq;

/// A planned block of review time. Its calendar event is a separate link;
/// an elapsed session does not mean its items were reviewed.
abstract class ReviewSession
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReviewSession._({
    this.id,
    required this.ownerId,
    this.planId,
    required this.startAt,
    required this.endAt,
    required this.timezone,
    required this.status,
    required this.schedulingMode,
    required this.availabilityVerified,
    int? planRevision,
    this.lastOperationId,
    DateTime? createdAt,
  }) : planRevision = planRevision ?? 1,
       createdAt = createdAt ?? DateTime.now();

  factory ReviewSession({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    _isc.UuidValue? planId,
    required DateTime startAt,
    required DateTime endAt,
    required String timezone,
    required _ikijcapq.SessionStatus status,
    required _i6o5tozv.ApprovalMode schedulingMode,
    required bool availabilityVerified,
    int? planRevision,
    _isc.UuidValue? lastOperationId,
    DateTime? createdAt,
  }) = _ReviewSessionImpl;

  factory ReviewSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewSession(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      planId: jsonSerialization['planId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['planId']),
      startAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startAt'],
      ),
      endAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      timezone: jsonSerialization['timezone'] as String,
      status: _ikijcapq.SessionStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      schedulingMode: _i6o5tozv.ApprovalMode.fromJson(
        (jsonSerialization['schedulingMode'] as String),
      ),
      availabilityVerified: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['availabilityVerified'],
      ),
      planRevision: jsonSerialization['planRevision'] as int?,
      lastOperationId: jsonSerialization['lastOperationId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['lastOperationId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue? planId;

  DateTime startAt;

  DateTime endAt;

  String timezone;

  _ikijcapq.SessionStatus status;

  _i6o5tozv.ApprovalMode schedulingMode;

  /// False when the user kept it without a calendar check.
  bool availabilityVerified;

  /// Bumped on every move.
  int planRevision;

  /// The last move or cancel, so a retry is answered without repeating it.
  _isc.UuidValue? lastOperationId;

  DateTime createdAt;

  /// Returns a shallow copy of this [ReviewSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReviewSession copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? planId,
    DateTime? startAt,
    DateTime? endAt,
    String? timezone,
    _ikijcapq.SessionStatus? status,
    _i6o5tozv.ApprovalMode? schedulingMode,
    bool? availabilityVerified,
    int? planRevision,
    _isc.UuidValue? lastOperationId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewSession',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      if (planId != null) 'planId': planId?.toJson(),
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'timezone': timezone,
      'status': status.toJson(),
      'schedulingMode': schedulingMode.toJson(),
      'availabilityVerified': availabilityVerified,
      'planRevision': planRevision,
      if (lastOperationId != null) 'lastOperationId': lastOperationId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewSession',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      if (planId != null) 'planId': planId?.toJson(),
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'timezone': timezone,
      'status': status.toJson(),
      'schedulingMode': schedulingMode.toJson(),
      'availabilityVerified': availabilityVerified,
      'planRevision': planRevision,
      if (lastOperationId != null) 'lastOperationId': lastOperationId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewSessionImpl extends ReviewSession {
  _ReviewSessionImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    _isc.UuidValue? planId,
    required DateTime startAt,
    required DateTime endAt,
    required String timezone,
    required _ikijcapq.SessionStatus status,
    required _i6o5tozv.ApprovalMode schedulingMode,
    required bool availabilityVerified,
    int? planRevision,
    _isc.UuidValue? lastOperationId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         planId: planId,
         startAt: startAt,
         endAt: endAt,
         timezone: timezone,
         status: status,
         schedulingMode: schedulingMode,
         availabilityVerified: availabilityVerified,
         planRevision: planRevision,
         lastOperationId: lastOperationId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReviewSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReviewSession copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    Object? planId = _Undefined,
    DateTime? startAt,
    DateTime? endAt,
    String? timezone,
    _ikijcapq.SessionStatus? status,
    _i6o5tozv.ApprovalMode? schedulingMode,
    bool? availabilityVerified,
    int? planRevision,
    Object? lastOperationId = _Undefined,
    DateTime? createdAt,
  }) {
    return ReviewSession(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      planId: planId is _isc.UuidValue? ? planId : this.planId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      timezone: timezone ?? this.timezone,
      status: status ?? this.status,
      schedulingMode: schedulingMode ?? this.schedulingMode,
      availabilityVerified: availabilityVerified ?? this.availabilityVerified,
      planRevision: planRevision ?? this.planRevision,
      lastOperationId: lastOperationId is _isc.UuidValue?
          ? lastOperationId
          : this.lastOperationId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
