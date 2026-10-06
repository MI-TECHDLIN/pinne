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

/// Thrown when a record does not exist or is not owned by the signed-in user.
/// Both cases look identical to the client so ids cannot be probed.
abstract class RecordNotFoundException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  RecordNotFoundException._({required this.resource});

  factory RecordNotFoundException({required String resource}) =
      _RecordNotFoundExceptionImpl;

  factory RecordNotFoundException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RecordNotFoundException(
      resource: jsonSerialization['resource'] as String,
    );
  }

  String resource;

  /// Returns a shallow copy of this [RecordNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RecordNotFoundException copyWith({String? resource});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecordNotFoundException',
      'resource': resource,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecordNotFoundException',
      'resource': resource,
    };
  }

  @override
  String toString() {
    return 'RecordNotFoundException(resource: $resource)';
  }
}

class _RecordNotFoundExceptionImpl extends RecordNotFoundException {
  _RecordNotFoundExceptionImpl({required String resource})
    : super._(resource: resource);

  /// Returns a shallow copy of this [RecordNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RecordNotFoundException copyWith({String? resource}) {
    return RecordNotFoundException(resource: resource ?? this.resource);
  }
}
