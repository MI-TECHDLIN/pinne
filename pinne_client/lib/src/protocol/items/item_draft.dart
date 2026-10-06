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
import '../items/content_type.dart' as _ic14w5wg;
import '../items/source_platform.dart' as _ixm5zqtz;

/// Client input for creating an item. Carries no owner or id; the server
/// assigns both.
abstract class ItemDraft
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ItemDraft._({
    this.url,
    required this.title,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    _ic14w5wg.ContentType? contentType,
    this.intention,
    int? priority,
    this.savedAt,
  }) : sourcePlatform = sourcePlatform ?? _ixm5zqtz.SourcePlatform.web,
       contentType = contentType ?? _ic14w5wg.ContentType.other,
       priority = priority ?? 0;

  factory ItemDraft({
    String? url,
    required String title,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    _ic14w5wg.ContentType? contentType,
    String? intention,
    int? priority,
    DateTime? savedAt,
  }) = _ItemDraftImpl;

  factory ItemDraft.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemDraft(
      url: jsonSerialization['url'] as String?,
      title: jsonSerialization['title'] as String,
      sourcePlatform: jsonSerialization['sourcePlatform'] == null
          ? null
          : _ixm5zqtz.SourcePlatform.fromJson(
              (jsonSerialization['sourcePlatform'] as String),
            ),
      contentType: jsonSerialization['contentType'] == null
          ? null
          : _ic14w5wg.ContentType.fromJson(
              (jsonSerialization['contentType'] as String),
            ),
      intention: jsonSerialization['intention'] as String?,
      priority: jsonSerialization['priority'] as int?,
      savedAt: jsonSerialization['savedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['savedAt']),
    );
  }

  String? url;

  String title;

  _ixm5zqtz.SourcePlatform sourcePlatform;

  _ic14w5wg.ContentType contentType;

  String? intention;

  int priority;

  /// When the user saved it on the device, if captured offline.
  DateTime? savedAt;

  /// Returns a shallow copy of this [ItemDraft]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ItemDraft copyWith({
    String? url,
    String? title,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    _ic14w5wg.ContentType? contentType,
    String? intention,
    int? priority,
    DateTime? savedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemDraft',
      if (url != null) 'url': url,
      'title': title,
      'sourcePlatform': sourcePlatform.toJson(),
      'contentType': contentType.toJson(),
      if (intention != null) 'intention': intention,
      'priority': priority,
      if (savedAt != null) 'savedAt': savedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemDraft',
      if (url != null) 'url': url,
      'title': title,
      'sourcePlatform': sourcePlatform.toJson(),
      'contentType': contentType.toJson(),
      if (intention != null) 'intention': intention,
      'priority': priority,
      if (savedAt != null) 'savedAt': savedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemDraftImpl extends ItemDraft {
  _ItemDraftImpl({
    String? url,
    required String title,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    _ic14w5wg.ContentType? contentType,
    String? intention,
    int? priority,
    DateTime? savedAt,
  }) : super._(
         url: url,
         title: title,
         sourcePlatform: sourcePlatform,
         contentType: contentType,
         intention: intention,
         priority: priority,
         savedAt: savedAt,
       );

  /// Returns a shallow copy of this [ItemDraft]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ItemDraft copyWith({
    Object? url = _Undefined,
    String? title,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    _ic14w5wg.ContentType? contentType,
    Object? intention = _Undefined,
    int? priority,
    Object? savedAt = _Undefined,
  }) {
    return ItemDraft(
      url: url is String? ? url : this.url,
      title: title ?? this.title,
      sourcePlatform: sourcePlatform ?? this.sourcePlatform,
      contentType: contentType ?? this.contentType,
      intention: intention is String? ? intention : this.intention,
      priority: priority ?? this.priority,
      savedAt: savedAt is DateTime? ? savedAt : this.savedAt,
    );
  }
}
