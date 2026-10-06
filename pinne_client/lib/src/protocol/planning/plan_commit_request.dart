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

/// Accept a plan. Busy times must be read again right before this call.
abstract class PlanCommitRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlanCommitRequest._({
    required this.planId,
    required this.operationId,
    required this.availability,
    required this.acceptUnverified,
    this.deviceId,
  });

  factory PlanCommitRequest({
    required _isc.UuidValue planId,
    required _isc.UuidValue operationId,
    required List<_ifygu10u.AvailabilitySnapshot> availability,
    required bool acceptUnverified,
    _isc.UuidValue? deviceId,
  }) = _PlanCommitRequestImpl;

  factory PlanCommitRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlanCommitRequest(
      planId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['planId']),
      operationId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['operationId'],
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

  _isc.UuidValue planId;

  /// Stable across retries of the same acceptance.
  _isc.UuidValue operationId;

  List<_ifygu10u.AvailabilitySnapshot> availability;

  /// The user chose to keep the sessions without a calendar check. They are
  /// saved in Pinne only, never written to a calendar, and labelled.
  bool acceptUnverified;

  _isc.UuidValue? deviceId;

  /// Returns a shallow copy of this [PlanCommitRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlanCommitRequest copyWith({
    _isc.UuidValue? planId,
    _isc.UuidValue? operationId,
    List<_ifygu10u.AvailabilitySnapshot>? availability,
    bool? acceptUnverified,
    _isc.UuidValue? deviceId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlanCommitRequest',
      'planId': planId.toJson(),
      'operationId': operationId.toJson(),
      'availability': availability.toJson(valueToJson: (v) => v.toJson()),
      'acceptUnverified': acceptUnverified,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlanCommitRequest',
      'planId': planId.toJson(),
      'operationId': operationId.toJson(),
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

class _PlanCommitRequestImpl extends PlanCommitRequest {
  _PlanCommitRequestImpl({
    required _isc.UuidValue planId,
    required _isc.UuidValue operationId,
    required List<_ifygu10u.AvailabilitySnapshot> availability,
    required bool acceptUnverified,
    _isc.UuidValue? deviceId,
  }) : super._(
         planId: planId,
         operationId: operationId,
         availability: availability,
         acceptUnverified: acceptUnverified,
         deviceId: deviceId,
       );

  /// Returns a shallow copy of this [PlanCommitRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlanCommitRequest copyWith({
    _isc.UuidValue? planId,
    _isc.UuidValue? operationId,
    List<_ifygu10u.AvailabilitySnapshot>? availability,
    bool? acceptUnverified,
    Object? deviceId = _Undefined,
  }) {
    return PlanCommitRequest(
      planId: planId ?? this.planId,
      operationId: operationId ?? this.operationId,
      availability:
          availability ?? this.availability.map((e0) => e0.copyWith()).toList(),
      acceptUnverified: acceptUnverified ?? this.acceptUnverified,
      deviceId: deviceId is _isc.UuidValue? ? deviceId : this.deviceId,
    );
  }
}
