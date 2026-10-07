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

/// Per-owner calls of the remote provider. Date keys are UTC YYYY-MM-DD.
abstract class AiDailyUsage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiDailyUsage._({
    this.id,
    required this.ownerId,
    required this.dateKey,
    int? requestCount,
  }) : requestCount = requestCount ?? 0;

  factory AiDailyUsage({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required String dateKey,
    int? requestCount,
  }) = _AiDailyUsageImpl;

  factory AiDailyUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiDailyUsage(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      dateKey: jsonSerialization['dateKey'] as String,
      requestCount: jsonSerialization['requestCount'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  String dateKey;

  int requestCount;

  /// Returns a shallow copy of this [AiDailyUsage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiDailyUsage copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    String? dateKey,
    int? requestCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiDailyUsage',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'dateKey': dateKey,
      'requestCount': requestCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiDailyUsage',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'dateKey': dateKey,
      'requestCount': requestCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiDailyUsageImpl extends AiDailyUsage {
  _AiDailyUsageImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required String dateKey,
    int? requestCount,
  }) : super._(
         id: id,
         ownerId: ownerId,
         dateKey: dateKey,
         requestCount: requestCount,
       );

  /// Returns a shallow copy of this [AiDailyUsage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiDailyUsage copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    String? dateKey,
    int? requestCount,
  }) {
    return AiDailyUsage(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      dateKey: dateKey ?? this.dateKey,
      requestCount: requestCount ?? this.requestCount,
    );
  }
}
