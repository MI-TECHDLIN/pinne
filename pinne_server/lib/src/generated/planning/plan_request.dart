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

/// Ask for a plan. Busy times come from the device for device calendars.
abstract class PlanRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PlanRequest._({required this.availability});

  factory PlanRequest({
    required List<_ifygu10u.AvailabilitySnapshot> availability,
  }) = _PlanRequestImpl;

  factory PlanRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlanRequest(
      availability: _i2yoimhd.Protocol()
          .deserialize<List<_ifygu10u.AvailabilitySnapshot>>(
            jsonSerialization['availability'],
          ),
    );
  }

  List<_ifygu10u.AvailabilitySnapshot> availability;

  /// Returns a shallow copy of this [PlanRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlanRequest copyWith({List<_ifygu10u.AvailabilitySnapshot>? availability});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlanRequest',
      'availability': availability.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlanRequest',
      'availability': availability.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PlanRequestImpl extends PlanRequest {
  _PlanRequestImpl({required List<_ifygu10u.AvailabilitySnapshot> availability})
    : super._(availability: availability);

  /// Returns a shallow copy of this [PlanRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlanRequest copyWith({List<_ifygu10u.AvailabilitySnapshot>? availability}) {
    return PlanRequest(
      availability:
          availability ?? this.availability.map((e0) => e0.copyWith()).toList(),
    );
  }
}
