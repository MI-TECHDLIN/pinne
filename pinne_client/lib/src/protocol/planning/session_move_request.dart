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
import '../planning/availability_snapshot.dart' as _ifygu10u;

abstract class SessionMoveRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SessionMoveRequest._({
    required this.sessionId,
    required this.operationId,
    required this.startAt,
    required this.availability,
    required this.acceptUnverified,
    this.deviceId,
  });

  factory SessionMoveRequest({
    required _isc.UuidValue sessionId,
    required _isc.UuidValue operationId,
    required DateTime startAt,
    required List<_ifygu10u.AvailabilitySnapshot> availability,
    required bool acceptUnverified,
    _isc.UuidValue? deviceId,
  }) = _SessionMoveRequestImpl;

  factory SessionMoveRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionMoveRequest(
      sessionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['sessionId'],
      ),
      operationId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['operationId'],
      ),
      startAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startAt'],
      ),
      availability: _iub9zyhg.Protocol()
          .deserialize<List<_ifygu10u.AvailabilitySnapshot>>(
            jsonSerialization['availability'],
          ),
      acceptUnverified: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['acceptUnverified'],
      ),
      deviceId: jsonSerialization['deviceId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
    );
  }

  _isc.UuidValue sessionId;

  _isc.UuidValue operationId;

  DateTime startAt;

  List<_ifygu10u.AvailabilitySnapshot> availability;

  bool acceptUnverified;

  _isc.UuidValue? deviceId;

  /// Returns a shallow copy of this [SessionMoveRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SessionMoveRequest copyWith({
    _isc.UuidValue? sessionId,
    _isc.UuidValue? operationId,
    DateTime? startAt,
    List<_ifygu10u.AvailabilitySnapshot>? availability,
    bool? acceptUnverified,
    _isc.UuidValue? deviceId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionMoveRequest',
      'sessionId': sessionId.toJson(),
      'operationId': operationId.toJson(),
      'startAt': startAt.toJson(),
      'availability': availability.toJson(valueToJson: (v) => v.toJson()),
      'acceptUnverified': acceptUnverified,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionMoveRequest',
      'sessionId': sessionId.toJson(),
      'operationId': operationId.toJson(),
      'startAt': startAt.toJson(),
      'availability': availability.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'acceptUnverified': acceptUnverified,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionMoveRequestImpl extends SessionMoveRequest {
  _SessionMoveRequestImpl({
    required _isc.UuidValue sessionId,
    required _isc.UuidValue operationId,
    required DateTime startAt,
    required List<_ifygu10u.AvailabilitySnapshot> availability,
    required bool acceptUnverified,
    _isc.UuidValue? deviceId,
  }) : super._(
         sessionId: sessionId,
         operationId: operationId,
         startAt: startAt,
         availability: availability,
         acceptUnverified: acceptUnverified,
         deviceId: deviceId,
       );

  /// Returns a shallow copy of this [SessionMoveRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SessionMoveRequest copyWith({
    _isc.UuidValue? sessionId,
    _isc.UuidValue? operationId,
    DateTime? startAt,
    List<_ifygu10u.AvailabilitySnapshot>? availability,
    bool? acceptUnverified,
    Object? deviceId = _Undefined,
  }) {
    return SessionMoveRequest(
      sessionId: sessionId ?? this.sessionId,
      operationId: operationId ?? this.operationId,
      startAt: startAt ?? this.startAt,
      availability:
          availability ?? this.availability.map((e0) => e0.copyWith()).toList(),
      acceptUnverified: acceptUnverified ?? this.acceptUnverified,
      deviceId: deviceId is _isc.UuidValue? ? deviceId : this.deviceId,
    );
  }
}
