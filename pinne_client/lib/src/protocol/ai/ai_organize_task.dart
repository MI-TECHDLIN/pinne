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
import '../ai/ai_processing_state.dart' as _isczc8jm;

/// Durable idempotency record for the at-least-once future call.
abstract class AiOrganizeTask
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiOrganizeTask._({
    this.id,
    required this.ownerId,
    required this.itemId,
    _isczc8jm.AiProcessingState? state,
    int? requestedVersion,
    int? processedVersion,
    bool? dailySlotClaimed,
    this.quotaDateKey,
    this.claimedAt,
    this.completedAt,
    this.provider,
  }) : state = state ?? _isczc8jm.AiProcessingState.queued,
       requestedVersion = requestedVersion ?? 1,
       processedVersion = processedVersion ?? 0,
       dailySlotClaimed = dailySlotClaimed ?? false;

  factory AiOrganizeTask({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    _isczc8jm.AiProcessingState? state,
    int? requestedVersion,
    int? processedVersion,
    bool? dailySlotClaimed,
    String? quotaDateKey,
    DateTime? claimedAt,
    DateTime? completedAt,
    String? provider,
  }) = _AiOrganizeTaskImpl;

  factory AiOrganizeTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiOrganizeTask(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      state: jsonSerialization['state'] == null
          ? null
          : _isczc8jm.AiProcessingState.fromJson(
              (jsonSerialization['state'] as String),
            ),
      requestedVersion: jsonSerialization['requestedVersion'] as int?,
      processedVersion: jsonSerialization['processedVersion'] as int?,
      dailySlotClaimed: jsonSerialization['dailySlotClaimed'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['dailySlotClaimed'],
            ),
      quotaDateKey: jsonSerialization['quotaDateKey'] as String?,
      claimedAt: jsonSerialization['claimedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['claimedAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      provider: jsonSerialization['provider'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue itemId;

  _isczc8jm.AiProcessingState state;

  int requestedVersion;

  int processedVersion;

  bool dailySlotClaimed;

  String? quotaDateKey;

  DateTime? claimedAt;

  DateTime? completedAt;

  String? provider;

  /// Returns a shallow copy of this [AiOrganizeTask]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiOrganizeTask copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    _isczc8jm.AiProcessingState? state,
    int? requestedVersion,
    int? processedVersion,
    bool? dailySlotClaimed,
    String? quotaDateKey,
    DateTime? claimedAt,
    DateTime? completedAt,
    String? provider,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiOrganizeTask',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'state': state.toJson(),
      'requestedVersion': requestedVersion,
      'processedVersion': processedVersion,
      'dailySlotClaimed': dailySlotClaimed,
      if (quotaDateKey != null) 'quotaDateKey': quotaDateKey,
      if (claimedAt != null) 'claimedAt': claimedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (provider != null) 'provider': provider,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiOrganizeTask',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'state': state.toJson(),
      'requestedVersion': requestedVersion,
      'processedVersion': processedVersion,
      'dailySlotClaimed': dailySlotClaimed,
      if (quotaDateKey != null) 'quotaDateKey': quotaDateKey,
      if (claimedAt != null) 'claimedAt': claimedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (provider != null) 'provider': provider,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiOrganizeTaskImpl extends AiOrganizeTask {
  _AiOrganizeTaskImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    _isczc8jm.AiProcessingState? state,
    int? requestedVersion,
    int? processedVersion,
    bool? dailySlotClaimed,
    String? quotaDateKey,
    DateTime? claimedAt,
    DateTime? completedAt,
    String? provider,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         state: state,
         requestedVersion: requestedVersion,
         processedVersion: processedVersion,
         dailySlotClaimed: dailySlotClaimed,
         quotaDateKey: quotaDateKey,
         claimedAt: claimedAt,
         completedAt: completedAt,
         provider: provider,
       );

  /// Returns a shallow copy of this [AiOrganizeTask]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiOrganizeTask copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    _isczc8jm.AiProcessingState? state,
    int? requestedVersion,
    int? processedVersion,
    bool? dailySlotClaimed,
    Object? quotaDateKey = _Undefined,
    Object? claimedAt = _Undefined,
    Object? completedAt = _Undefined,
    Object? provider = _Undefined,
  }) {
    return AiOrganizeTask(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      state: state ?? this.state,
      requestedVersion: requestedVersion ?? this.requestedVersion,
      processedVersion: processedVersion ?? this.processedVersion,
      dailySlotClaimed: dailySlotClaimed ?? this.dailySlotClaimed,
      quotaDateKey: quotaDateKey is String? ? quotaDateKey : this.quotaDateKey,
      claimedAt: claimedAt is DateTime? ? claimedAt : this.claimedAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      provider: provider is String? ? provider : this.provider,
    );
  }
}
