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
import '../common/assignment_origin.dart' as _i12d5boj;
import '../items/access_state.dart' as _idll96tf;
import '../items/content_type.dart' as _ic14w5wg;
import '../items/enrichment_state.dart' as _iib6h77f;
import '../items/item_lifecycle.dart' as _i6i14d93;
import '../items/source_platform.dart' as _ixm5zqtz;

/// A saved resource. Every row is owned by one auth user; the owner is set by
/// the server from the signed-in session and never taken from the client.
abstract class Item
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Item._({
    this.id,
    required this.ownerId,
    this.clientItemId,
    this.url,
    this.canonicalUrl,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    this.sourceItemId,
    required this.title,
    bool? titleManuallyLocked,
    this.noteText,
    _ic14w5wg.ContentType? contentType,
    this.intention,
    this.summary,
    this.summaryOrigin,
    bool? summaryManuallyLocked,
    int? priority,
    _i6i14d93.ItemLifecycle? lifecycle,
    DateTime? savedAt,
    _iib6h77f.EnrichmentState? enrichmentState,
    _idll96tf.AccessState? accessState,
    this.previewDescription,
    this.previewAuthor,
    this.previewSiteName,
    this.previewProvider,
    this.thumbnailUrl,
    this.durationSeconds,
    this.previewMetadataJson,
    this.previewUpdatedAt,
    this.previewStartedAt,
    int? previewAttemptCount,
    bool? isExample,
    int? revision,
  }) : sourcePlatform = sourcePlatform ?? _ixm5zqtz.SourcePlatform.web,
       titleManuallyLocked = titleManuallyLocked ?? false,
       contentType = contentType ?? _ic14w5wg.ContentType.other,
       summaryManuallyLocked = summaryManuallyLocked ?? false,
       priority = priority ?? 0,
       lifecycle = lifecycle ?? _i6i14d93.ItemLifecycle.active,
       savedAt = savedAt ?? DateTime.now(),
       enrichmentState = enrichmentState ?? _iib6h77f.EnrichmentState.pending,
       accessState = accessState ?? _idll96tf.AccessState.unknown,
       previewAttemptCount = previewAttemptCount ?? 0,
       isExample = isExample ?? false,
       revision = revision ?? 1;

  factory Item({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    _isc.UuidValue? clientItemId,
    String? url,
    String? canonicalUrl,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    String? sourceItemId,
    required String title,
    bool? titleManuallyLocked,
    String? noteText,
    _ic14w5wg.ContentType? contentType,
    String? intention,
    String? summary,
    _i12d5boj.AssignmentOrigin? summaryOrigin,
    bool? summaryManuallyLocked,
    int? priority,
    _i6i14d93.ItemLifecycle? lifecycle,
    DateTime? savedAt,
    _iib6h77f.EnrichmentState? enrichmentState,
    _idll96tf.AccessState? accessState,
    String? previewDescription,
    String? previewAuthor,
    String? previewSiteName,
    String? previewProvider,
    String? thumbnailUrl,
    int? durationSeconds,
    String? previewMetadataJson,
    DateTime? previewUpdatedAt,
    DateTime? previewStartedAt,
    int? previewAttemptCount,
    bool? isExample,
    int? revision,
  }) = _ItemImpl;

  factory Item.fromJson(Map<String, dynamic> jsonSerialization) {
    return Item(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      clientItemId: jsonSerialization['clientItemId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['clientItemId'],
            ),
      url: jsonSerialization['url'] as String?,
      canonicalUrl: jsonSerialization['canonicalUrl'] as String?,
      sourcePlatform: jsonSerialization['sourcePlatform'] == null
          ? null
          : _ixm5zqtz.SourcePlatform.fromJson(
              (jsonSerialization['sourcePlatform'] as String),
            ),
      sourceItemId: jsonSerialization['sourceItemId'] as String?,
      title: jsonSerialization['title'] as String,
      titleManuallyLocked: jsonSerialization['titleManuallyLocked'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['titleManuallyLocked'],
            ),
      noteText: jsonSerialization['noteText'] as String?,
      contentType: jsonSerialization['contentType'] == null
          ? null
          : _ic14w5wg.ContentType.fromJson(
              (jsonSerialization['contentType'] as String),
            ),
      intention: jsonSerialization['intention'] as String?,
      summary: jsonSerialization['summary'] as String?,
      summaryOrigin: jsonSerialization['summaryOrigin'] == null
          ? null
          : _i12d5boj.AssignmentOrigin.fromJson(
              (jsonSerialization['summaryOrigin'] as String),
            ),
      summaryManuallyLocked: jsonSerialization['summaryManuallyLocked'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['summaryManuallyLocked'],
            ),
      priority: jsonSerialization['priority'] as int?,
      lifecycle: jsonSerialization['lifecycle'] == null
          ? null
          : _i6i14d93.ItemLifecycle.fromJson(
              (jsonSerialization['lifecycle'] as String),
            ),
      savedAt: jsonSerialization['savedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['savedAt']),
      enrichmentState: jsonSerialization['enrichmentState'] == null
          ? null
          : _iib6h77f.EnrichmentState.fromJson(
              (jsonSerialization['enrichmentState'] as String),
            ),
      accessState: jsonSerialization['accessState'] == null
          ? null
          : _idll96tf.AccessState.fromJson(
              (jsonSerialization['accessState'] as String),
            ),
      previewDescription: jsonSerialization['previewDescription'] as String?,
      previewAuthor: jsonSerialization['previewAuthor'] as String?,
      previewSiteName: jsonSerialization['previewSiteName'] as String?,
      previewProvider: jsonSerialization['previewProvider'] as String?,
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
      durationSeconds: jsonSerialization['durationSeconds'] as int?,
      previewMetadataJson: jsonSerialization['previewMetadataJson'] as String?,
      previewUpdatedAt: jsonSerialization['previewUpdatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['previewUpdatedAt'],
            ),
      previewStartedAt: jsonSerialization['previewStartedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['previewStartedAt'],
            ),
      previewAttemptCount: jsonSerialization['previewAttemptCount'] as int?,
      isExample: jsonSerialization['isExample'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isExample']),
      revision: jsonSerialization['revision'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  /// The id the capturing device gave the item, so a retried capture maps
  /// to this row instead of creating another.
  _isc.UuidValue? clientItemId;

  /// The URL as shared by the user, minus tracking parameters. Null for
  /// note-only items.
  String? url;

  /// Normalized URL used to recognize duplicates.
  String? canonicalUrl;

  _ixm5zqtz.SourcePlatform sourcePlatform;

  /// The platform's own id for the item, such as a post or video id. Used
  /// with the platform to recognize duplicates.
  String? sourceItemId;

  String title;

  /// True when the title came from a user edit. Preview jobs must never
  /// replace it.
  bool titleManuallyLocked;

  /// The text of a note-only item. Null for links.
  String? noteText;

  _ic14w5wg.ContentType contentType;

  /// The user's own note on why they saved this item.
  String? intention;

  /// Accepted AI summary. It never replaces text the user has locked.
  String? summary;

  _i12d5boj.AssignmentOrigin? summaryOrigin;

  bool summaryManuallyLocked;

  int priority;

  _i6i14d93.ItemLifecycle lifecycle;

  /// When the user first saved it, on their device. Never moved by a later
  /// duplicate capture.
  DateTime savedAt;

  _iib6h77f.EnrichmentState enrichmentState;

  _idll96tf.AccessState accessState;

  /// Normalized, plain-text preview evidence. Remote HTML is never stored or
  /// rendered. The image remains a remote URL and is not proxied in v1.
  String? previewDescription;

  String? previewAuthor;

  String? previewSiteName;

  String? previewProvider;

  String? thumbnailUrl;

  int? durationSeconds;

  String? previewMetadataJson;

  DateTime? previewUpdatedAt;

  DateTime? previewStartedAt;

  int previewAttemptCount;

  /// True only for opt-in starter content created by ExampleSavesEndpoint.
  bool isExample;

  /// Optimistic concurrency counter, bumped on every server-side update.
  int revision;

  /// Returns a shallow copy of this [Item]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Item copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? clientItemId,
    String? url,
    String? canonicalUrl,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    String? sourceItemId,
    String? title,
    bool? titleManuallyLocked,
    String? noteText,
    _ic14w5wg.ContentType? contentType,
    String? intention,
    String? summary,
    _i12d5boj.AssignmentOrigin? summaryOrigin,
    bool? summaryManuallyLocked,
    int? priority,
    _i6i14d93.ItemLifecycle? lifecycle,
    DateTime? savedAt,
    _iib6h77f.EnrichmentState? enrichmentState,
    _idll96tf.AccessState? accessState,
    String? previewDescription,
    String? previewAuthor,
    String? previewSiteName,
    String? previewProvider,
    String? thumbnailUrl,
    int? durationSeconds,
    String? previewMetadataJson,
    DateTime? previewUpdatedAt,
    DateTime? previewStartedAt,
    int? previewAttemptCount,
    bool? isExample,
    int? revision,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Item',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      if (clientItemId != null) 'clientItemId': clientItemId?.toJson(),
      if (url != null) 'url': url,
      if (canonicalUrl != null) 'canonicalUrl': canonicalUrl,
      'sourcePlatform': sourcePlatform.toJson(),
      if (sourceItemId != null) 'sourceItemId': sourceItemId,
      'title': title,
      'titleManuallyLocked': titleManuallyLocked,
      if (noteText != null) 'noteText': noteText,
      'contentType': contentType.toJson(),
      if (intention != null) 'intention': intention,
      if (summary != null) 'summary': summary,
      if (summaryOrigin != null) 'summaryOrigin': summaryOrigin?.toJson(),
      'summaryManuallyLocked': summaryManuallyLocked,
      'priority': priority,
      'lifecycle': lifecycle.toJson(),
      'savedAt': savedAt.toJson(),
      'enrichmentState': enrichmentState.toJson(),
      'accessState': accessState.toJson(),
      if (previewDescription != null) 'previewDescription': previewDescription,
      if (previewAuthor != null) 'previewAuthor': previewAuthor,
      if (previewSiteName != null) 'previewSiteName': previewSiteName,
      if (previewProvider != null) 'previewProvider': previewProvider,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      if (previewMetadataJson != null)
        'previewMetadataJson': previewMetadataJson,
      if (previewUpdatedAt != null)
        'previewUpdatedAt': previewUpdatedAt?.toJson(),
      if (previewStartedAt != null)
        'previewStartedAt': previewStartedAt?.toJson(),
      'previewAttemptCount': previewAttemptCount,
      'isExample': isExample,
      'revision': revision,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Item',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      if (clientItemId != null) 'clientItemId': clientItemId?.toJson(),
      if (url != null) 'url': url,
      if (canonicalUrl != null) 'canonicalUrl': canonicalUrl,
      'sourcePlatform': sourcePlatform.toJson(),
      if (sourceItemId != null) 'sourceItemId': sourceItemId,
      'title': title,
      'titleManuallyLocked': titleManuallyLocked,
      if (noteText != null) 'noteText': noteText,
      'contentType': contentType.toJson(),
      if (intention != null) 'intention': intention,
      if (summary != null) 'summary': summary,
      if (summaryOrigin != null) 'summaryOrigin': summaryOrigin?.toJson(),
      'summaryManuallyLocked': summaryManuallyLocked,
      'priority': priority,
      'lifecycle': lifecycle.toJson(),
      'savedAt': savedAt.toJson(),
      'enrichmentState': enrichmentState.toJson(),
      'accessState': accessState.toJson(),
      if (previewDescription != null) 'previewDescription': previewDescription,
      if (previewAuthor != null) 'previewAuthor': previewAuthor,
      if (previewSiteName != null) 'previewSiteName': previewSiteName,
      if (previewProvider != null) 'previewProvider': previewProvider,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      if (previewMetadataJson != null)
        'previewMetadataJson': previewMetadataJson,
      if (previewUpdatedAt != null)
        'previewUpdatedAt': previewUpdatedAt?.toJson(),
      if (previewStartedAt != null)
        'previewStartedAt': previewStartedAt?.toJson(),
      'previewAttemptCount': previewAttemptCount,
      'isExample': isExample,
      'revision': revision,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemImpl extends Item {
  _ItemImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    _isc.UuidValue? clientItemId,
    String? url,
    String? canonicalUrl,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    String? sourceItemId,
    required String title,
    bool? titleManuallyLocked,
    String? noteText,
    _ic14w5wg.ContentType? contentType,
    String? intention,
    String? summary,
    _i12d5boj.AssignmentOrigin? summaryOrigin,
    bool? summaryManuallyLocked,
    int? priority,
    _i6i14d93.ItemLifecycle? lifecycle,
    DateTime? savedAt,
    _iib6h77f.EnrichmentState? enrichmentState,
    _idll96tf.AccessState? accessState,
    String? previewDescription,
    String? previewAuthor,
    String? previewSiteName,
    String? previewProvider,
    String? thumbnailUrl,
    int? durationSeconds,
    String? previewMetadataJson,
    DateTime? previewUpdatedAt,
    DateTime? previewStartedAt,
    int? previewAttemptCount,
    bool? isExample,
    int? revision,
  }) : super._(
         id: id,
         ownerId: ownerId,
         clientItemId: clientItemId,
         url: url,
         canonicalUrl: canonicalUrl,
         sourcePlatform: sourcePlatform,
         sourceItemId: sourceItemId,
         title: title,
         titleManuallyLocked: titleManuallyLocked,
         noteText: noteText,
         contentType: contentType,
         intention: intention,
         summary: summary,
         summaryOrigin: summaryOrigin,
         summaryManuallyLocked: summaryManuallyLocked,
         priority: priority,
         lifecycle: lifecycle,
         savedAt: savedAt,
         enrichmentState: enrichmentState,
         accessState: accessState,
         previewDescription: previewDescription,
         previewAuthor: previewAuthor,
         previewSiteName: previewSiteName,
         previewProvider: previewProvider,
         thumbnailUrl: thumbnailUrl,
         durationSeconds: durationSeconds,
         previewMetadataJson: previewMetadataJson,
         previewUpdatedAt: previewUpdatedAt,
         previewStartedAt: previewStartedAt,
         previewAttemptCount: previewAttemptCount,
         isExample: isExample,
         revision: revision,
       );

  /// Returns a shallow copy of this [Item]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Item copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    Object? clientItemId = _Undefined,
    Object? url = _Undefined,
    Object? canonicalUrl = _Undefined,
    _ixm5zqtz.SourcePlatform? sourcePlatform,
    Object? sourceItemId = _Undefined,
    String? title,
    bool? titleManuallyLocked,
    Object? noteText = _Undefined,
    _ic14w5wg.ContentType? contentType,
    Object? intention = _Undefined,
    Object? summary = _Undefined,
    Object? summaryOrigin = _Undefined,
    bool? summaryManuallyLocked,
    int? priority,
    _i6i14d93.ItemLifecycle? lifecycle,
    DateTime? savedAt,
    _iib6h77f.EnrichmentState? enrichmentState,
    _idll96tf.AccessState? accessState,
    Object? previewDescription = _Undefined,
    Object? previewAuthor = _Undefined,
    Object? previewSiteName = _Undefined,
    Object? previewProvider = _Undefined,
    Object? thumbnailUrl = _Undefined,
    Object? durationSeconds = _Undefined,
    Object? previewMetadataJson = _Undefined,
    Object? previewUpdatedAt = _Undefined,
    Object? previewStartedAt = _Undefined,
    int? previewAttemptCount,
    bool? isExample,
    int? revision,
  }) {
    return Item(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      clientItemId: clientItemId is _isc.UuidValue?
          ? clientItemId
          : this.clientItemId,
      url: url is String? ? url : this.url,
      canonicalUrl: canonicalUrl is String? ? canonicalUrl : this.canonicalUrl,
      sourcePlatform: sourcePlatform ?? this.sourcePlatform,
      sourceItemId: sourceItemId is String? ? sourceItemId : this.sourceItemId,
      title: title ?? this.title,
      titleManuallyLocked: titleManuallyLocked ?? this.titleManuallyLocked,
      noteText: noteText is String? ? noteText : this.noteText,
      contentType: contentType ?? this.contentType,
      intention: intention is String? ? intention : this.intention,
      summary: summary is String? ? summary : this.summary,
      summaryOrigin: summaryOrigin is _i12d5boj.AssignmentOrigin?
          ? summaryOrigin
          : this.summaryOrigin,
      summaryManuallyLocked:
          summaryManuallyLocked ?? this.summaryManuallyLocked,
      priority: priority ?? this.priority,
      lifecycle: lifecycle ?? this.lifecycle,
      savedAt: savedAt ?? this.savedAt,
      enrichmentState: enrichmentState ?? this.enrichmentState,
      accessState: accessState ?? this.accessState,
      previewDescription: previewDescription is String?
          ? previewDescription
          : this.previewDescription,
      previewAuthor: previewAuthor is String?
          ? previewAuthor
          : this.previewAuthor,
      previewSiteName: previewSiteName is String?
          ? previewSiteName
          : this.previewSiteName,
      previewProvider: previewProvider is String?
          ? previewProvider
          : this.previewProvider,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
      durationSeconds: durationSeconds is int?
          ? durationSeconds
          : this.durationSeconds,
      previewMetadataJson: previewMetadataJson is String?
          ? previewMetadataJson
          : this.previewMetadataJson,
      previewUpdatedAt: previewUpdatedAt is DateTime?
          ? previewUpdatedAt
          : this.previewUpdatedAt,
      previewStartedAt: previewStartedAt is DateTime?
          ? previewStartedAt
          : this.previewStartedAt,
      previewAttemptCount: previewAttemptCount ?? this.previewAttemptCount,
      isExample: isExample ?? this.isExample,
      revision: revision ?? this.revision,
    );
  }
}
