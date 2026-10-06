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

/// Public server health, safe to show before sign-in.
abstract class ServerHealth
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ServerHealth._({
    required this.ok,
    required this.databaseOk,
    required this.serverTime,
    required this.version,
  });

  factory ServerHealth({
    required bool ok,
    required bool databaseOk,
    required DateTime serverTime,
    required String version,
  }) = _ServerHealthImpl;

  factory ServerHealth.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerHealth(
      ok: _is.BoolJsonExtension.fromJson(jsonSerialization['ok']),
      databaseOk: _is.BoolJsonExtension.fromJson(
        jsonSerialization['databaseOk'],
      ),
      serverTime: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      version: jsonSerialization['version'] as String,
    );
  }

  bool ok;

  bool databaseOk;

  DateTime serverTime;

  String version;

  /// Returns a shallow copy of this [ServerHealth]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ServerHealth copyWith({
    bool? ok,
    bool? databaseOk,
    DateTime? serverTime,
    String? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServerHealth',
      'ok': ok,
      'databaseOk': databaseOk,
      'serverTime': serverTime.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ServerHealth',
      'ok': ok,
      'databaseOk': databaseOk,
      'serverTime': serverTime.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ServerHealthImpl extends ServerHealth {
  _ServerHealthImpl({
    required bool ok,
    required bool databaseOk,
    required DateTime serverTime,
    required String version,
  }) : super._(
         ok: ok,
         databaseOk: databaseOk,
         serverTime: serverTime,
         version: version,
       );

  /// Returns a shallow copy of this [ServerHealth]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ServerHealth copyWith({
    bool? ok,
    bool? databaseOk,
    DateTime? serverTime,
    String? version,
  }) {
    return ServerHealth(
      ok: ok ?? this.ok,
      databaseOk: databaseOk ?? this.databaseOk,
      serverTime: serverTime ?? this.serverTime,
      version: version ?? this.version,
    );
  }
}
