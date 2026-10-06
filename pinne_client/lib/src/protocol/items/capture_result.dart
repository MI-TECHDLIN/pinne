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
import '../items/enrichment_state.dart' as _iib6h77f;
import '../items/source_platform.dart' as _ixm5zqtz;

/// The server's answer to a capture. Replaying the same operation returns
/// the same item and duplicate flag.
abstract class CaptureResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CaptureResult._({
    required this.itemId,
    required this.clientItemId,
    required this.revision,
    required this.title,
    required this.sourcePlatform,
    this.sourceItemId,
    this.canonicalUrl,
    required this.duplicate,
    this.duplicateOf,
    required this.enrichmentState,
    required this.savedAt,
  });

  factory CaptureResult({
    required _isc.UuidValue itemId,
    required _isc.UuidValue clientItemId,
    required int revision,
    required String title,
    required _ixm5zqtz.SourcePlatform sourcePlatform,
    String? sourceItemId,
    String? canonicalUrl,
    required bool duplicate,
    _isc.UuidValue? duplicateOf,
    required _iib6h77f.EnrichmentState enrichmentState,
    required DateTime savedAt,
  }) = _CaptureResultImpl;

  factory CaptureResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaptureResult(
      itemId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      clientItemId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clientItemId'],
      ),
      revision: jsonSerialization['revision'] as int,
      title: jsonSerialization['title'] as String,
      sourcePlatform: _ixm5zqtz.SourcePlatform.fromJson(
        (jsonSerialization['sourcePlatform'] as String),
      ),
      sourceItemId: jsonSerialization['sourceItemId'] as String?,
      canonicalUrl: jsonSerialization['canonicalUrl'] as String?,
      duplicate: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['duplicate'],
      ),
      duplicateOf: jsonSerialization['duplicateOf'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['duplicateOf'],
            ),
      enrichmentState: _iib6h77f.EnrichmentState.fromJson(
        (jsonSerialization['enrichmentState'] as String),
      ),
      savedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['savedAt'],
      ),
    );
  }

  _isc.UuidValue itemId;

  _isc.UuidValue clientItemId;

  int revision;

  String title;

  _ixm5zqtz.SourcePlatform sourcePlatform;

  String? sourceItemId;

  String? canonicalUrl;

  /// True when the capture matched an item the owner had already saved.
  bool duplicate;

  /// The existing item a duplicate capture resolved to.
  _isc.UuidValue? duplicateOf;

  _iib6h77f.EnrichmentState enrichmentState;

  DateTime savedAt;

  /// Returns a shallow copy of this [CaptureResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CaptureResult copyWith({
    _isc.UuidValue? itemId,
    _isc.UuidValue? clientItemId,
    int? revision,
    String? title,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    String? sourceItemId,
    String? canonicalUrl,
    bool? duplicate,
    _isc.UuidValue? duplicateOf,
    _iib6h77f.EnrichmentState? enrichmentState,
    DateTime? savedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CaptureResult',
      'itemId': itemId.toJson(),
      'clientItemId': clientItemId.toJson(),
      'revision': revision,
      'title': title,
      'sourcePlatform': sourcePlatform.toJson(),
      if (sourceItemId != null) 'sourceItemId': sourceItemId,
      if (canonicalUrl != null) 'canonicalUrl': canonicalUrl,
      'duplicate': duplicate,
      if (duplicateOf != null) 'duplicateOf': duplicateOf?.toJson(),
      'enrichmentState': enrichmentState.toJson(),
      'savedAt': savedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CaptureResult',
      'itemId': itemId.toJson(),
      'clientItemId': clientItemId.toJson(),
      'revision': revision,
      'title': title,
      'sourcePlatform': sourcePlatform.toJson(),
      if (sourceItemId != null) 'sourceItemId': sourceItemId,
      if (canonicalUrl != null) 'canonicalUrl': canonicalUrl,
      'duplicate': duplicate,
      if (duplicateOf != null) 'duplicateOf': duplicateOf?.toJson(),
      'enrichmentState': enrichmentState.toJson(),
      'savedAt': savedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaptureResultImpl extends CaptureResult {
  _CaptureResultImpl({
    required _isc.UuidValue itemId,
    required _isc.UuidValue clientItemId,
    required int revision,
    required String title,
    required _ixm5zqtz.SourcePlatform sourcePlatform,
    String? sourceItemId,
    String? canonicalUrl,
    required bool duplicate,
    _isc.UuidValue? duplicateOf,
    required _iib6h77f.EnrichmentState enrichmentState,
    required DateTime savedAt,
  }) : super._(
         itemId: itemId,
         clientItemId: clientItemId,
         revision: revision,
         title: title,
         sourcePlatform: sourcePlatform,
         sourceItemId: sourceItemId,
         canonicalUrl: canonicalUrl,
         duplicate: duplicate,
         duplicateOf: duplicateOf,
         enrichmentState: enrichmentState,
         savedAt: savedAt,
       );

  /// Returns a shallow copy of this [CaptureResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CaptureResult copyWith({
    _isc.UuidValue? itemId,
    _isc.UuidValue? clientItemId,
    int? revision,
    String? title,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    Object? sourceItemId = _Undefined,
    Object? canonicalUrl = _Undefined,
    bool? duplicate,
    Object? duplicateOf = _Undefined,
    _iib6h77f.EnrichmentState? enrichmentState,
    DateTime? savedAt,
  }) {
    return CaptureResult(
      itemId: itemId ?? this.itemId,
      clientItemId: clientItemId ?? this.clientItemId,
      revision: revision ?? this.revision,
      title: title ?? this.title,
      sourcePlatform: sourcePlatform ?? this.sourcePlatform,
      sourceItemId: sourceItemId is String? ? sourceItemId : this.sourceItemId,
      canonicalUrl: canonicalUrl is String? ? canonicalUrl : this.canonicalUrl,
      duplicate: duplicate ?? this.duplicate,
      duplicateOf: duplicateOf is _isc.UuidValue?
          ? duplicateOf
          : this.duplicateOf,
      enrichmentState: enrichmentState ?? this.enrichmentState,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
