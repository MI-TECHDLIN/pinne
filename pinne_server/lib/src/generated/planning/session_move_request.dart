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
import 'package:pinne_server/src/generated/protocol.dart' as _i2yoimhd;
import 'package:serverpod/serverpod.dart' as _is;
import '../planning/availability_snapshot.dart' as _ifygu10u;

abstract class SessionMoveRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SessionMoveRequest._({
    required this.sessionId,
    required this.operationId,
    required this.startAt,
    required this.availability,
    required this.acceptUnverified,
    this.deviceId,
  });

  factory SessionMoveRequest({
    required _is.UuidValue sessionId,
    required _is.UuidValue operationId,
    required DateTime startAt,
    required List<_ifygu10u.AvailabilitySnapshot> availability,
    required bool acceptUnverified,
    _is.UuidValue? deviceId,
  }) = _SessionMoveRequestImpl;

  factory SessionMoveRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionMoveRequest(
      sessionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sessionId'],
      ),
      operationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['operationId'],
      ),
      startAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['startAt']),
      availability: _i2yoimhd.Protocol()
          .deserialize<List<_ifygu10u.AvailabilitySnapshot>>(
            jsonSerialization['availability'],
          ),
      acceptUnverified: _is.BoolJsonExtension.fromJson(
        jsonSerialization['acceptUnverified'],
      ),
      deviceId: jsonSerialization['deviceId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
    );
  }

  _is.UuidValue sessionId;

  _is.UuidValue operationId;

  DateTime startAt;

  List<_ifygu10u.AvailabilitySnapshot> availability;

  bool acceptUnverified;

  _is.UuidValue? deviceId;

  /// Returns a shallow copy of this [SessionMoveRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionMoveRequest copyWith({
    _is.UuidValue? sessionId,
    _is.UuidValue? operationId,
    DateTime? startAt,
    List<_ifygu10u.AvailabilitySnapshot>? availability,
    bool? acceptUnverified,
    _is.UuidValue? deviceId,
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
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionMoveRequestImpl extends SessionMoveRequest {
  _SessionMoveRequestImpl({
    required _is.UuidValue sessionId,
    required _is.UuidValue operationId,
    required DateTime startAt,
    required List<_ifygu10u.AvailabilitySnapshot> availability,
    required bool acceptUnverified,
    _is.UuidValue? deviceId,
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
  @_is.useResult
  @override
  SessionMoveRequest copyWith({
    _is.UuidValue? sessionId,
    _is.UuidValue? operationId,
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
      deviceId: deviceId is _is.UuidValue? ? deviceId : this.deviceId,
    );
  }
}
