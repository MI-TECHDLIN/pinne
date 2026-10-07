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
import '../planning/planning_error_code.dart' as _i85m4g70;

/// A planning rule refused the request; `message` says what to do.
abstract class PlanningException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  PlanningException._({
    required this.code,
    required this.message,
    this.sessionIds,
  });

  factory PlanningException({
    required _i85m4g70.PlanningErrorCode code,
    required String message,
    List<_is.UuidValue>? sessionIds,
  }) = _PlanningExceptionImpl;

  factory PlanningException.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlanningException(
      code: _i85m4g70.PlanningErrorCode.fromJson(
        (jsonSerialization['code'] as String),
      ),
      message: jsonSerialization['message'] as String,
      sessionIds: jsonSerialization['sessionIds'] == null
          ? null
          : _i2yoimhd.Protocol().deserialize<List<_is.UuidValue>>(
              jsonSerialization['sessionIds'],
            ),
    );
  }

  _i85m4g70.PlanningErrorCode code;

  String message;

  List<_is.UuidValue>? sessionIds;

  /// Returns a shallow copy of this [PlanningException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlanningException copyWith({
    _i85m4g70.PlanningErrorCode? code,
    String? message,
    List<_is.UuidValue>? sessionIds,
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
    List<_is.UuidValue>? sessionIds,
  }) : super._(
         code: code,
         message: message,
         sessionIds: sessionIds,
       );

  /// Returns a shallow copy of this [PlanningException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlanningException copyWith({
    _i85m4g70.PlanningErrorCode? code,
    String? message,
    Object? sessionIds = _Undefined,
  }) {
    return PlanningException(
      code: code ?? this.code,
      message: message ?? this.message,
      sessionIds: sessionIds is List<_is.UuidValue>?
          ? sessionIds
          : this.sessionIds?.map((e0) => e0).toList(),
    );
  }
}
