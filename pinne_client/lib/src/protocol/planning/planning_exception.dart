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
import '../planning/planning_error_code.dart' as _i85m4g70;

/// A planning rule refused the request; `message` says what to do.
abstract class PlanningException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  PlanningException._({
    required this.code,
    required this.message,
    this.sessionIds,
  });

  factory PlanningException({
    required _i85m4g70.PlanningErrorCode code,
    required String message,
    List<_isc.UuidValue>? sessionIds,
  }) = _PlanningExceptionImpl;

  factory PlanningException.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlanningException(
      code: _i85m4g70.PlanningErrorCode.fromJson(
        (jsonSerialization['code'] as String),
      ),
      message: jsonSerialization['message'] as String,
      sessionIds: jsonSerialization['sessionIds'] == null
          ? null
          : _iub9zyhg.Protocol().deserialize<List<_isc.UuidValue>>(
              jsonSerialization['sessionIds'],
            ),
    );
  }

  _i85m4g70.PlanningErrorCode code;

  String message;

  List<_isc.UuidValue>? sessionIds;

  /// Returns a shallow copy of this [PlanningException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlanningException copyWith({
    _i85m4g70.PlanningErrorCode? code,
    String? message,
    List<_isc.UuidValue>? sessionIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlanningException',
      'code': code.toJson(),
      'message': message,
      if (sessionIds != null)
        'sessionIds': sessionIds?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlanningException',
      'code': code.toJson(),
      'message': message,
      if (sessionIds != null)
        'sessionIds': sessionIds?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return 'PlanningException(code: $code, message: $message, sessionIds: $sessionIds)';
  }
}

class _Undefined {}

class _PlanningExceptionImpl extends PlanningException {
  _PlanningExceptionImpl({
    required _i85m4g70.PlanningErrorCode code,
    required String message,
    List<_isc.UuidValue>? sessionIds,
  }) : super._(
         code: code,
         message: message,
         sessionIds: sessionIds,
       );

  /// Returns a shallow copy of this [PlanningException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlanningException copyWith({
    _i85m4g70.PlanningErrorCode? code,
    String? message,
    Object? sessionIds = _Undefined,
  }) {
    return PlanningException(
      code: code ?? this.code,
      message: message ?? this.message,
      sessionIds: sessionIds is List<_isc.UuidValue>?
          ? sessionIds
          : this.sessionIds?.map((e0) => e0).toList(),
    );
  }
}
