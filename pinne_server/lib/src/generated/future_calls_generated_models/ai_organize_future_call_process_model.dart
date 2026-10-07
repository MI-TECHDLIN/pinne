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
import 'package:serverpod/serverpod.dart' as _is;

abstract class AiOrganizeFutureCallProcessModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AiOrganizeFutureCallProcessModel._({
    required this.itemId,
    required this.ownerId,
  });

  factory AiOrganizeFutureCallProcessModel({
    required _is.UuidValue itemId,
    required _is.UuidValue ownerId,
  }) = _AiOrganizeFutureCallProcessModelImpl;

  factory AiOrganizeFutureCallProcessModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AiOrganizeFutureCallProcessModel(
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
    );
  }

  _is.UuidValue itemId;

  _is.UuidValue ownerId;

  /// Returns a shallow copy of this [AiOrganizeFutureCallProcessModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiOrganizeFutureCallProcessModel copyWith({
    _is.UuidValue? itemId,
    _is.UuidValue? ownerId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiOrganizeFutureCallProcessModel',
      'itemId': itemId.toJson(),
      'ownerId': ownerId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AiOrganizeFutureCallProcessModelImpl
    extends AiOrganizeFutureCallProcessModel {
  _AiOrganizeFutureCallProcessModelImpl({
    required _is.UuidValue itemId,
    required _is.UuidValue ownerId,
  }) : super._(
         itemId: itemId,
         ownerId: ownerId,
       );

  /// Returns a shallow copy of this [AiOrganizeFutureCallProcessModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiOrganizeFutureCallProcessModel copyWith({
    _is.UuidValue? itemId,
    _is.UuidValue? ownerId,
  }) {
    return AiOrganizeFutureCallProcessModel(
      itemId: itemId ?? this.itemId,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
