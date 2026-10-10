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
import '../common/assignment_origin.dart' as _i12d5boj;
import '../items/access_state.dart' as _idll96tf;
import '../items/content_type.dart' as _ic14w5wg;
import '../items/enrichment_state.dart' as _iib6h77f;
import '../items/item_lifecycle.dart' as _i6i14d93;
import '../items/source_platform.dart' as _ixm5zqtz;

/// A saved resource. Every row is owned by one auth user; the owner is set by
/// the server from the signed-in session and never taken from the client.
abstract class Item
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
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
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    _is.UuidValue? clientItemId,
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
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      clientItemId: jsonSerialization['clientItemId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
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
          : _is.BoolJsonExtension.fromJson(
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
          : _is.BoolJsonExtension.fromJson(
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
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['savedAt']),
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
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['previewUpdatedAt'],
            ),
      previewStartedAt: jsonSerialization['previewStartedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['previewStartedAt'],
            ),
      previewAttemptCount: jsonSerialization['previewAttemptCount'] as int?,
      isExample: jsonSerialization['isExample'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isExample']),
      revision: jsonSerialization['revision'] as int?,
    );
  }

  static final t = ItemTable();

  static const db = ItemRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  /// The id the capturing device gave the item, so a retried capture maps
  /// to this row instead of creating another.
  _is.UuidValue? clientItemId;

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

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Item]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Item copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? clientItemId,
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

  static ItemInclude include() {
    return ItemInclude._();
  }

  static ItemIncludeList includeList({
    _is.WhereExpressionBuilder<ItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemTable>? orderBy,
    _is.OrderByListBuilder<ItemTable>? orderByList,
    ItemInclude? include,
  }) {
    return ItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Item.t),
      orderByList: orderByList?.call(Item.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemImpl extends Item {
  _ItemImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    _is.UuidValue? clientItemId,
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
  @_is.useResult
  @override
  Item copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
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
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      clientItemId: clientItemId is _is.UuidValue?
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

class ItemUpdateTable extends _is.UpdateTable<ItemTable> {
  ItemUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clientItemId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.clientItemId,
    value,
  );

  _is.ColumnValue<String, String> url(String? value) => _is.ColumnValue(
    table.url,
    value,
  );

  _is.ColumnValue<String, String> canonicalUrl(String? value) =>
      _is.ColumnValue(
        table.canonicalUrl,
        value,
      );

  _is.ColumnValue<_ixm5zqtz.SourcePlatform, _ixm5zqtz.SourcePlatform>
  sourcePlatform(_ixm5zqtz.SourcePlatform value) => _is.ColumnValue(
    table.sourcePlatform,
    value,
  );

  _is.ColumnValue<String, String> sourceItemId(String? value) =>
      _is.ColumnValue(
        table.sourceItemId,
        value,
      );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<bool, bool> titleManuallyLocked(bool value) =>
      _is.ColumnValue(
        table.titleManuallyLocked,
        value,
      );

  _is.ColumnValue<String, String> noteText(String? value) => _is.ColumnValue(
    table.noteText,
    value,
  );

  _is.ColumnValue<_ic14w5wg.ContentType, _ic14w5wg.ContentType> contentType(
    _ic14w5wg.ContentType value,
  ) => _is.ColumnValue(
    table.contentType,
    value,
  );

  _is.ColumnValue<String, String> intention(String? value) => _is.ColumnValue(
    table.intention,
    value,
  );

  _is.ColumnValue<String, String> summary(String? value) => _is.ColumnValue(
    table.summary,
    value,
  );

  _is.ColumnValue<_i12d5boj.AssignmentOrigin, _i12d5boj.AssignmentOrigin>
  summaryOrigin(_i12d5boj.AssignmentOrigin? value) => _is.ColumnValue(
    table.summaryOrigin,
    value,
  );

  _is.ColumnValue<bool, bool> summaryManuallyLocked(bool value) =>
      _is.ColumnValue(
        table.summaryManuallyLocked,
        value,
      );

  _is.ColumnValue<int, int> priority(int value) => _is.ColumnValue(
    table.priority,
    value,
  );

  _is.ColumnValue<_i6i14d93.ItemLifecycle, _i6i14d93.ItemLifecycle> lifecycle(
    _i6i14d93.ItemLifecycle value,
  ) => _is.ColumnValue(
    table.lifecycle,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> savedAt(DateTime value) =>
      _is.ColumnValue(
        table.savedAt,
        value,
      );

  _is.ColumnValue<_iib6h77f.EnrichmentState, _iib6h77f.EnrichmentState>
  enrichmentState(_iib6h77f.EnrichmentState value) => _is.ColumnValue(
    table.enrichmentState,
    value,
  );

  _is.ColumnValue<_idll96tf.AccessState, _idll96tf.AccessState> accessState(
    _idll96tf.AccessState value,
  ) => _is.ColumnValue(
    table.accessState,
    value,
  );

  _is.ColumnValue<String, String> previewDescription(String? value) =>
      _is.ColumnValue(
        table.previewDescription,
        value,
      );

  _is.ColumnValue<String, String> previewAuthor(String? value) =>
      _is.ColumnValue(
        table.previewAuthor,
        value,
      );

  _is.ColumnValue<String, String> previewSiteName(String? value) =>
      _is.ColumnValue(
        table.previewSiteName,
        value,
      );

  _is.ColumnValue<String, String> previewProvider(String? value) =>
      _is.ColumnValue(
        table.previewProvider,
        value,
      );

  _is.ColumnValue<String, String> thumbnailUrl(String? value) =>
      _is.ColumnValue(
        table.thumbnailUrl,
        value,
      );

  _is.ColumnValue<int, int> durationSeconds(int? value) => _is.ColumnValue(
    table.durationSeconds,
    value,
  );

  _is.ColumnValue<String, String> previewMetadataJson(String? value) =>
      _is.ColumnValue(
        table.previewMetadataJson,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> previewUpdatedAt(DateTime? value) =>
      _is.ColumnValue(
        table.previewUpdatedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> previewStartedAt(DateTime? value) =>
      _is.ColumnValue(
        table.previewStartedAt,
        value,
      );

  _is.ColumnValue<int, int> previewAttemptCount(int value) => _is.ColumnValue(
    table.previewAttemptCount,
    value,
  );

  _is.ColumnValue<bool, bool> isExample(bool value) => _is.ColumnValue(
    table.isExample,
    value,
  );

  _is.ColumnValue<int, int> revision(int value) => _is.ColumnValue(
    table.revision,
    value,
  );
}

class ItemTable extends _is.Table<_is.UuidValue?> {
  ItemTable({super.tableRelation}) : super(tableName: 'item') {
    updateTable = ItemUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    clientItemId = _is.ColumnUuid(
      'clientItemId',
      this,
    );
    url = _is.ColumnString(
      'url',
      this,
    );
    canonicalUrl = _is.ColumnString(
      'canonicalUrl',
      this,
    );
    sourcePlatform = _is.ColumnEnum(
      'sourcePlatform',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    sourceItemId = _is.ColumnString(
      'sourceItemId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    titleManuallyLocked = _is.ColumnBool(
      'titleManuallyLocked',
      this,
      hasDefault: true,
    );
    noteText = _is.ColumnString(
      'noteText',
      this,
    );
    contentType = _is.ColumnEnum(
      'contentType',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    intention = _is.ColumnString(
      'intention',
      this,
    );
    summary = _is.ColumnString(
      'summary',
      this,
    );
    summaryOrigin = _is.ColumnEnum(
      'summaryOrigin',
      this,
      _is.EnumSerialization.byName,
    );
    summaryManuallyLocked = _is.ColumnBool(
      'summaryManuallyLocked',
      this,
      hasDefault: true,
    );
    priority = _is.ColumnInt(
      'priority',
      this,
      hasDefault: true,
    );
    lifecycle = _is.ColumnEnum(
      'lifecycle',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    savedAt = _is.ColumnDateTime(
      'savedAt',
      this,
      hasDefault: true,
    );
    enrichmentState = _is.ColumnEnum(
      'enrichmentState',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    accessState = _is.ColumnEnum(
      'accessState',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    previewDescription = _is.ColumnString(
      'previewDescription',
      this,
    );
    previewAuthor = _is.ColumnString(
      'previewAuthor',
      this,
    );
    previewSiteName = _is.ColumnString(
      'previewSiteName',
      this,
    );
    previewProvider = _is.ColumnString(
      'previewProvider',
      this,
    );
    thumbnailUrl = _is.ColumnString(
      'thumbnailUrl',
      this,
    );
    durationSeconds = _is.ColumnInt(
      'durationSeconds',
      this,
    );
    previewMetadataJson = _is.ColumnString(
      'previewMetadataJson',
      this,
    );
    previewUpdatedAt = _is.ColumnDateTime(
      'previewUpdatedAt',
      this,
    );
    previewStartedAt = _is.ColumnDateTime(
      'previewStartedAt',
      this,
    );
    previewAttemptCount = _is.ColumnInt(
      'previewAttemptCount',
      this,
      hasDefault: true,
    );
    isExample = _is.ColumnBool(
      'isExample',
      this,
      hasDefault: true,
    );
    revision = _is.ColumnInt(
      'revision',
      this,
      hasDefault: true,
    );
  }

  late final ItemUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  /// The id the capturing device gave the item, so a retried capture maps
  /// to this row instead of creating another.
  late final _is.ColumnUuid clientItemId;

  /// The URL as shared by the user, minus tracking parameters. Null for
  /// note-only items.
  late final _is.ColumnString url;

  /// Normalized URL used to recognize duplicates.
  late final _is.ColumnString canonicalUrl;

  late final _is.ColumnEnum<_ixm5zqtz.SourcePlatform> sourcePlatform;

  /// The platform's own id for the item, such as a post or video id. Used
  /// with the platform to recognize duplicates.
  late final _is.ColumnString sourceItemId;

  late final _is.ColumnString title;

  /// True when the title came from a user edit. Preview jobs must never
  /// replace it.
  late final _is.ColumnBool titleManuallyLocked;

  /// The text of a note-only item. Null for links.
  late final _is.ColumnString noteText;

  late final _is.ColumnEnum<_ic14w5wg.ContentType> contentType;

  /// The user's own note on why they saved this item.
  late final _is.ColumnString intention;

  /// Accepted AI summary. It never replaces text the user has locked.
  late final _is.ColumnString summary;

  late final _is.ColumnEnum<_i12d5boj.AssignmentOrigin> summaryOrigin;

  late final _is.ColumnBool summaryManuallyLocked;

  late final _is.ColumnInt priority;

  late final _is.ColumnEnum<_i6i14d93.ItemLifecycle> lifecycle;

  /// When the user first saved it, on their device. Never moved by a later
  /// duplicate capture.
  late final _is.ColumnDateTime savedAt;

  late final _is.ColumnEnum<_iib6h77f.EnrichmentState> enrichmentState;

  late final _is.ColumnEnum<_idll96tf.AccessState> accessState;

  /// Normalized, plain-text preview evidence. Remote HTML is never stored or
  /// rendered. The image remains a remote URL and is not proxied in v1.
  late final _is.ColumnString previewDescription;

  late final _is.ColumnString previewAuthor;

  late final _is.ColumnString previewSiteName;

  late final _is.ColumnString previewProvider;

  late final _is.ColumnString thumbnailUrl;

  late final _is.ColumnInt durationSeconds;

  late final _is.ColumnString previewMetadataJson;

  late final _is.ColumnDateTime previewUpdatedAt;

  late final _is.ColumnDateTime previewStartedAt;

  late final _is.ColumnInt previewAttemptCount;

  /// True only for opt-in starter content created by ExampleSavesEndpoint.
  late final _is.ColumnBool isExample;

  /// Optimistic concurrency counter, bumped on every server-side update.
  late final _is.ColumnInt revision;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    clientItemId,
    url,
    canonicalUrl,
    sourcePlatform,
    sourceItemId,
    title,
    titleManuallyLocked,
    noteText,
    contentType,
    intention,
    summary,
    summaryOrigin,
    summaryManuallyLocked,
    priority,
    lifecycle,
    savedAt,
    enrichmentState,
    accessState,
    previewDescription,
    previewAuthor,
    previewSiteName,
    previewProvider,
    thumbnailUrl,
    durationSeconds,
    previewMetadataJson,
    previewUpdatedAt,
    previewStartedAt,
    previewAttemptCount,
    isExample,
    revision,
  ];
}

class ItemInclude extends _is.IncludeObject {
  ItemInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Item.t;
}

class ItemIncludeList extends _is.IncludeList {
  ItemIncludeList._({
    _is.WhereExpressionBuilder<ItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Item.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Item.t;
}

class ItemRepository {
  const ItemRepository._();

  /// Returns a list of [Item]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Item>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemTable>? orderBy,
    _is.OrderByListBuilder<ItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Item>(
      where: where?.call(Item.t),
      orderBy: orderBy?.call(Item.t),
      orderByList: orderByList?.call(Item.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Item] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Item?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemTable>? where,
    int? offset,
    _is.OrderByBuilder<ItemTable>? orderBy,
    _is.OrderByListBuilder<ItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Item>(
      where: where?.call(Item.t),
      orderBy: orderBy?.call(Item.t),
      orderByList: orderByList?.call(Item.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Item] by its [id] or null if no such row exists.
  Future<Item?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Item>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Item]s in the list and returns the inserted rows.
  ///
  /// The returned [Item]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Item>> insert(
    _is.DatabaseSession session,
    List<Item> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Item>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Item] and returns the inserted row.
  ///
  /// The returned [Item] will have its `id` field set.
  Future<Item> insertRow(
    _is.DatabaseSession session,
    Item row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Item>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Item]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Item]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Item>> upsert(
    _is.DatabaseSession session,
    List<Item> rows, {
    required _is.ColumnSelections<ItemTable> conflictColumns,
    _is.ColumnSelections<ItemTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Item>(
      rows,
      conflictColumns: conflictColumns(Item.t),
      updateColumns: updateColumns?.call(Item.t),
      updateWhere: updateWhere?.call(Item.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Item] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Item] will have its `id` field set.
  Future<Item?> upsertRow(
    _is.DatabaseSession session,
    Item row, {
    required _is.ColumnSelections<ItemTable> conflictColumns,
    _is.ColumnSelections<ItemTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Item>(
      row,
      conflictColumns: conflictColumns(Item.t),
      updateColumns: updateColumns?.call(Item.t),
      updateWhere: updateWhere?.call(Item.t),
      transaction: transaction,
    );
  }

  /// Updates all [Item]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Item>> update(
    _is.DatabaseSession session,
    List<Item> rows, {
    _is.ColumnSelections<ItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Item>(
      rows,
      columns: columns?.call(Item.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Item]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Item> updateRow(
    _is.DatabaseSession session,
    Item row, {
    _is.ColumnSelections<ItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Item>(
      row,
      columns: columns?.call(Item.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Item] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Item?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Item>(
      id,
      columnValues: columnValues(Item.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Item]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Item>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemTable>? orderBy,
    _is.OrderByListBuilder<ItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Item>(
      columnValues: columnValues(Item.t.updateTable),
      where: where(Item.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Item.t),
      orderByList: orderByList?.call(Item.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Item]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Item>> delete(
    _is.DatabaseSession session,
    List<Item> rows, {
    _is.OrderByBuilder<ItemTable>? orderBy,
    _is.OrderByListBuilder<ItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Item>(
      rows,
      orderBy: orderBy?.call(Item.t),
      orderByList: orderByList?.call(Item.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Item].
  Future<Item> deleteRow(
    _is.DatabaseSession session,
    Item row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Item>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Item>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemTable> where,
    _is.OrderByBuilder<ItemTable>? orderBy,
    _is.OrderByListBuilder<ItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Item>(
      where: where(Item.t),
      orderBy: orderBy?.call(Item.t),
      orderByList: orderByList?.call(Item.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Item>(
      where: where?.call(Item.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Item] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Item>(
      where: where(Item.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
