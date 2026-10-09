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

/// Summary used by the client to offer and manage optional example saves.
abstract class ExampleSavesStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ExampleSavesStatus._({
    required this.totalItemCount,
    required this.exampleItemCount,
    required this.exampleCollectionCount,
  });

  factory ExampleSavesStatus({
    required int totalItemCount,
    required int exampleItemCount,
    required int exampleCollectionCount,
  }) = _ExampleSavesStatusImpl;

  factory ExampleSavesStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExampleSavesStatus(
      totalItemCount: jsonSerialization['totalItemCount'] as int,
      exampleItemCount: jsonSerialization['exampleItemCount'] as int,
      exampleCollectionCount:
          jsonSerialization['exampleCollectionCount'] as int,
    );
  }

  int totalItemCount;

  int exampleItemCount;

  int exampleCollectionCount;

  /// Returns a shallow copy of this [ExampleSavesStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ExampleSavesStatus copyWith({
    int? totalItemCount,
    int? exampleItemCount,
    int? exampleCollectionCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExampleSavesStatus',
      'totalItemCount': totalItemCount,
      'exampleItemCount': exampleItemCount,
      'exampleCollectionCount': exampleCollectionCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExampleSavesStatus',
      'totalItemCount': totalItemCount,
      'exampleItemCount': exampleItemCount,
      'exampleCollectionCount': exampleCollectionCount,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ExampleSavesStatusImpl extends ExampleSavesStatus {
  _ExampleSavesStatusImpl({
    required int totalItemCount,
    required int exampleItemCount,
    required int exampleCollectionCount,
  }) : super._(
         totalItemCount: totalItemCount,
         exampleItemCount: exampleItemCount,
         exampleCollectionCount: exampleCollectionCount,
       );

  /// Returns a shallow copy of this [ExampleSavesStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ExampleSavesStatus copyWith({
    int? totalItemCount,
    int? exampleItemCount,
    int? exampleCollectionCount,
  }) {
    return ExampleSavesStatus(
      totalItemCount: totalItemCount ?? this.totalItemCount,
      exampleItemCount: exampleItemCount ?? this.exampleItemCount,
      exampleCollectionCount:
          exampleCollectionCount ?? this.exampleCollectionCount,
    );
  }
}
