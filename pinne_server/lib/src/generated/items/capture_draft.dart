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

/// One capture from a device: a shared or pasted link, or a note. Carries no
/// owner and no server id. Retrying with the same [operationId] is safe.
abstract class CaptureDraft
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CaptureDraft._({
    required this.clientItemId,
    required this.operationId,
    this.url,
    this.text,
    this.title,
    this.intention,
    this.collectionIds,
    required this.capturedAt,
  });

  factory CaptureDraft({
    required _is.UuidValue clientItemId,
    required _is.UuidValue operationId,
    String? url,
    String? text,
    String? title,
    String? intention,
    List<_is.UuidValue>? collectionIds,
    required DateTime capturedAt,
  }) = _CaptureDraftImpl;

  factory CaptureDraft.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaptureDraft(
      clientItemId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clientItemId'],
      ),
      operationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['operationId'],
      ),
      url: jsonSerialization['url'] as String?,
      text: jsonSerialization['text'] as String?,
      title: jsonSerialization['title'] as String?,
      intention: jsonSerialization['intention'] as String?,
      collectionIds: jsonSerialization['collectionIds'] == null
          ? null
          : _i2yoimhd.Protocol().deserialize<List<_is.UuidValue>>(
              jsonSerialization['collectionIds'],
            ),
      capturedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['capturedAt'],
      ),
    );
  }

  /// The device's stable id for the captured item.
  _is.UuidValue clientItemId;

  /// Unique per attempt to change server state; retries reuse it.
  _is.UuidValue operationId;

  /// A web link. Either this or [text] is required.
  String? url;

  /// Shared or typed text. Becomes a note unless it contains a link.
  String? text;

  /// The user's title. When absent the server derives a readable one.
  String? title;

  /// Why the user saved it.
  String? intention;

  List<_is.UuidValue>? collectionIds;

  /// When the user saved it on the device, in UTC.
  DateTime capturedAt;

  /// Returns a shallow copy of this [CaptureDraft]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CaptureDraft copyWith({
    _is.UuidValue? clientItemId,
    _is.UuidValue? operationId,
    String? url,
    String? text,
    String? title,
    String? intention,
    List<_is.UuidValue>? collectionIds,
    DateTime? capturedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CaptureDraft',
      'clientItemId': clientItemId.toJson(),
      'operationId': operationId.toJson(),
      if (url != null) 'url': url,
      if (text != null) 'text': text,
      if (title != null) 'title': title,
      if (intention != null) 'intention': intention,
      if (collectionIds != null)
        'collectionIds': collectionIds?.toJson(valueToJson: (v) => v.toJson()),
      'capturedAt': capturedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CaptureDraft',
      'clientItemId': clientItemId.toJson(),
      'operationId': operationId.toJson(),
      if (url != null) 'url': url,
      if (text != null) 'text': text,
      if (title != null) 'title': title,
      if (intention != null) 'intention': intention,
      if (collectionIds != null)
        'collectionIds': collectionIds?.toJson(valueToJson: (v) => v.toJson()),
      'capturedAt': capturedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaptureDraftImpl extends CaptureDraft {
  _CaptureDraftImpl({
    required _is.UuidValue clientItemId,
    required _is.UuidValue operationId,
    String? url,
    String? text,
    String? title,
    String? intention,
    List<_is.UuidValue>? collectionIds,
    required DateTime capturedAt,
  }) : super._(
         clientItemId: clientItemId,
         operationId: operationId,
         url: url,
         text: text,
         title: title,
         intention: intention,
         collectionIds: collectionIds,
         capturedAt: capturedAt,
       );

  /// Returns a shallow copy of this [CaptureDraft]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CaptureDraft copyWith({
    _is.UuidValue? clientItemId,
    _is.UuidValue? operationId,
    Object? url = _Undefined,
    Object? text = _Undefined,
    Object? title = _Undefined,
    Object? intention = _Undefined,
    Object? collectionIds = _Undefined,
    DateTime? capturedAt,
  }) {
    return CaptureDraft(
      clientItemId: clientItemId ?? this.clientItemId,
      operationId: operationId ?? this.operationId,
      url: url is String? ? url : this.url,
      text: text is String? ? text : this.text,
      title: title is String? ? title : this.title,
      intention: intention is String? ? intention : this.intention,
      collectionIds: collectionIds is List<_is.UuidValue>?
          ? collectionIds
          : this.collectionIds?.map((e0) => e0).toList(),
      capturedAt: capturedAt ?? this.capturedAt,
    );
  }
}
