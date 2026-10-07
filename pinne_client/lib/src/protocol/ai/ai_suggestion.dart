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
import '../ai/ai_evidence_coverage.dart' as _i2dlbls7;
import '../ai/ai_suggestion_kind.dart' as _i21092i4;
import '../ai/ai_suggestion_status.dart' as _i42gk45p;
import '../common/assignment_origin.dart' as _i12d5boj;

/// A proposed organization change. Suggestions remain separate from manual
/// collection memberships and tags until the owner accepts them.
abstract class AiSuggestion
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiSuggestion._({
    this.id,
    required this.ownerId,
    required this.itemId,
    required this.kind,
    _i12d5boj.AssignmentOrigin? origin,
    this.collectionId,
    this.value,
    required this.rationale,
    _i2dlbls7.AiEvidenceCoverage? evidenceCoverage,
    bool? uncertain,
    _i42gk45p.AiSuggestionStatus? status,
    DateTime? createdAt,
    this.resolvedAt,
  }) : origin = origin ?? _i12d5boj.AssignmentOrigin.ai,
       evidenceCoverage =
           evidenceCoverage ?? _i2dlbls7.AiEvidenceCoverage.metadataOnly,
       uncertain = uncertain ?? false,
       status = status ?? _i42gk45p.AiSuggestionStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory AiSuggestion({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    required _i21092i4.AiSuggestionKind kind,
    _i12d5boj.AssignmentOrigin? origin,
    _isc.UuidValue? collectionId,
    String? value,
    required String rationale,
    _i2dlbls7.AiEvidenceCoverage? evidenceCoverage,
    bool? uncertain,
    _i42gk45p.AiSuggestionStatus? status,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) = _AiSuggestionImpl;

  factory AiSuggestion.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiSuggestion(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      kind: _i21092i4.AiSuggestionKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      origin: jsonSerialization['origin'] == null
          ? null
          : _i12d5boj.AssignmentOrigin.fromJson(
              (jsonSerialization['origin'] as String),
            ),
      collectionId: jsonSerialization['collectionId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['collectionId'],
            ),
      value: jsonSerialization['value'] as String?,
      rationale: jsonSerialization['rationale'] as String,
      evidenceCoverage: jsonSerialization['evidenceCoverage'] == null
          ? null
          : _i2dlbls7.AiEvidenceCoverage.fromJson(
              (jsonSerialization['evidenceCoverage'] as String),
            ),
      uncertain: jsonSerialization['uncertain'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['uncertain']),
      status: jsonSerialization['status'] == null
          ? null
          : _i42gk45p.AiSuggestionStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['resolvedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue itemId;

  _i21092i4.AiSuggestionKind kind;

  _i12d5boj.AssignmentOrigin origin;

  _isc.UuidValue? collectionId;

  String? value;

  String rationale;

  _i2dlbls7.AiEvidenceCoverage evidenceCoverage;

  bool uncertain;

  _i42gk45p.AiSuggestionStatus status;

  DateTime createdAt;

  DateTime? resolvedAt;

  /// Returns a shallow copy of this [AiSuggestion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiSuggestion copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    _i21092i4.AiSuggestionKind? kind,
    _i12d5boj.AssignmentOrigin? origin,
    _isc.UuidValue? collectionId,
    String? value,
    String? rationale,
    _i2dlbls7.AiEvidenceCoverage? evidenceCoverage,
    bool? uncertain,
    _i42gk45p.AiSuggestionStatus? status,
    DateTime? createdAt,
    DateTime? resolvedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiSuggestion',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'kind': kind.toJson(),
      'origin': origin.toJson(),
      if (collectionId != null) 'collectionId': collectionId?.toJson(),
      if (value != null) 'value': value,
      'rationale': rationale,
      'evidenceCoverage': evidenceCoverage.toJson(),
      'uncertain': uncertain,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiSuggestion',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'kind': kind.toJson(),
      'origin': origin.toJson(),
      if (collectionId != null) 'collectionId': collectionId?.toJson(),
      if (value != null) 'value': value,
      'rationale': rationale,
      'evidenceCoverage': evidenceCoverage.toJson(),
      'uncertain': uncertain,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiSuggestionImpl extends AiSuggestion {
  _AiSuggestionImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    required _i21092i4.AiSuggestionKind kind,
    _i12d5boj.AssignmentOrigin? origin,
    _isc.UuidValue? collectionId,
    String? value,
    required String rationale,
    _i2dlbls7.AiEvidenceCoverage? evidenceCoverage,
    bool? uncertain,
    _i42gk45p.AiSuggestionStatus? status,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         kind: kind,
         origin: origin,
         collectionId: collectionId,
         value: value,
         rationale: rationale,
         evidenceCoverage: evidenceCoverage,
         uncertain: uncertain,
         status: status,
         createdAt: createdAt,
         resolvedAt: resolvedAt,
       );

  /// Returns a shallow copy of this [AiSuggestion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiSuggestion copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    _i21092i4.AiSuggestionKind? kind,
    _i12d5boj.AssignmentOrigin? origin,
    Object? collectionId = _Undefined,
    Object? value = _Undefined,
    String? rationale,
    _i2dlbls7.AiEvidenceCoverage? evidenceCoverage,
    bool? uncertain,
    _i42gk45p.AiSuggestionStatus? status,
    DateTime? createdAt,
    Object? resolvedAt = _Undefined,
  }) {
    return AiSuggestion(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      kind: kind ?? this.kind,
      origin: origin ?? this.origin,
      collectionId: collectionId is _isc.UuidValue?
          ? collectionId
          : this.collectionId,
      value: value is String? ? value : this.value,
      rationale: rationale ?? this.rationale,
      evidenceCoverage: evidenceCoverage ?? this.evidenceCoverage,
      uncertain: uncertain ?? this.uncertain,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
    );
  }
}
