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

/// Accept a plan. Busy times must be read again right before this call.
abstract class PlanCommitRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PlanCommitRequest._({
    required this.planId,
    required this.operationId,
    required this.availability,
    required this.acceptUnverified,
    this.deviceId,
  });

  factory PlanCommitRequest({
    required _is.UuidValue planId,
    required _is.UuidValue operationId,
    required List<_ifygu10u.AvailabilitySnapshot> availability,
    required bool acceptUnverified,
    _is.UuidValue? deviceId,
  }) = _PlanCommitRequestImpl;

  factory PlanCommitRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlanCommitRequest(
      planId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['planId']),
      operationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['operationId'],
      ),
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

  _is.UuidValue planId;

  /// Stable across retries of the same acceptance.
  _is.UuidValue operationId;

  List<_ifygu10u.AvailabilitySnapshot> availability;

  /// The user chose to keep the sessions without a calendar check. They are
  /// saved in Pinne only, never written to a calendar, and labelled.
  bool acceptUnverified;

  _is.UuidValue? deviceId;

  /// Returns a shallow copy of this [PlanCommitRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlanCommitRequest copyWith({
    _is.UuidValue? planId,
    _is.UuidValue? operationId,
    List<_ifygu10u.AvailabilitySnapshot>? availability,
    bool? acceptUnverified,
    _is.UuidValue? deviceId,
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
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlanCommitRequestImpl extends PlanCommitRequest {
  _PlanCommitRequestImpl({
    required _is.UuidValue planId,
    required _is.UuidValue operationId,
    required List<_ifygu10u.AvailabilitySnapshot> availability,
    required bool acceptUnverified,
    _is.UuidValue? deviceId,
  }) : super._(
         planId: planId,
         operationId: operationId,
         availability: availability,
         acceptUnverified: acceptUnverified,
         deviceId: deviceId,
       );

  /// Returns a shallow copy of this [PlanCommitRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlanCommitRequest copyWith({
    _is.UuidValue? planId,
    _is.UuidValue? operationId,
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
      deviceId: deviceId is _is.UuidValue? ? deviceId : this.deviceId,
    );
  }
}
