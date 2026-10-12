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

/// Client-facing settings without a client-supplied owner id.
abstract class AiSettings
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AiSettings._({
    required this.available,
    required this.enabled,
    required this.disclosure,
  });

  factory AiSettings({
    required bool available,
    required bool enabled,
    required String disclosure,
  }) = _AiSettingsImpl;

  factory AiSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiSettings(
      available: _is.BoolJsonExtension.fromJson(jsonSerialization['available']),
      enabled: _is.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      disclosure: jsonSerialization['disclosure'] as String,
    );
  }

  bool available;

  bool enabled;

  String disclosure;

  /// Returns a shallow copy of this [AiSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiSettings copyWith({
    bool? available,
    bool? enabled,
    String? disclosure,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiSettings',
      'available': available,
      'enabled': enabled,
      'disclosure': disclosure,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiSettings',
      'available': available,
      'enabled': enabled,
      'disclosure': disclosure,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AiSettingsImpl extends AiSettings {
  _AiSettingsImpl({
    required bool available,
    required bool enabled,
    required String disclosure,
  }) : super._(
         available: available,
         enabled: enabled,
         disclosure: disclosure,
       );

  /// Returns a shallow copy of this [AiSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiSettings copyWith({
    bool? available,
    bool? enabled,
    String? disclosure,
  }) {
    return AiSettings(
      available: available ?? this.available,
      enabled: enabled ?? this.enabled,
      disclosure: disclosure ?? this.disclosure,
    );
  }
}
