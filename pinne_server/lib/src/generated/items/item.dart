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
    this.noteText,
    _ic14w5wg.ContentType? contentType,
    this.intention,
    int? priority,
    _i6i14d93.ItemLifecycle? lifecycle,
    DateTime? savedAt,
    _iib6h77f.EnrichmentState? enrichmentState,
    _idll96tf.AccessState? accessState,
    int? revision,
  }) : sourcePlatform = sourcePlatform ?? _ixm5zqtz.SourcePlatform.web,
       contentType = contentType ?? _ic14w5wg.ContentType.other,
       priority = priority ?? 0,
       lifecycle = lifecycle ?? _i6i14d93.ItemLifecycle.active,
       savedAt = savedAt ?? DateTime.now(),
       enrichmentState = enrichmentState ?? _iib6h77f.EnrichmentState.pending,
       accessState = accessState ?? _idll96tf.AccessState.unknown,
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
    String? noteText,
    _ic14w5wg.ContentType? contentType,
    String? intention,
    int? priority,
    _i6i14d93.ItemLifecycle? lifecycle,
    DateTime? savedAt,
    _iib6h77f.EnrichmentState? enrichmentState,
    _idll96tf.AccessState? accessState,
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
      noteText: jsonSerialization['noteText'] as String?,
      contentType: jsonSerialization['contentType'] == null
          ? null
          : _ic14w5wg.ContentType.fromJson(
              (jsonSerialization['contentType'] as String),
            ),
      intention: jsonSerialization['intention'] as String?,
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

  /// The text of a note-only item. Null for links.
  String? noteText;

  _ic14w5wg.ContentType contentType;

  /// The user's own note on why they saved this item.
  String? intention;

  int priority;

  _i6i14d93.ItemLifecycle lifecycle;

  /// When the user first saved it, on their device. Never moved by a later
  /// duplicate capture.
  DateTime savedAt;

  _iib6h77f.EnrichmentState enrichmentState;

  _idll96tf.AccessState accessState;

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
    String? noteText,
    _ic14w5wg.ContentType? contentType,
    String? intention,
    int? priority,
    _i6i14d93.ItemLifecycle? lifecycle,
    DateTime? savedAt,
    _iib6h77f.EnrichmentState? enrichmentState,
    _idll96tf.AccessState? accessState,
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
      if (noteText != null) 'noteText': noteText,
      'contentType': contentType.toJson(),
      if (intention != null) 'intention': intention,
      'priority': priority,
      'lifecycle': lifecycle.toJson(),
      'savedAt': savedAt.toJson(),
      'enrichmentState': enrichmentState.toJson(),
      'accessState': accessState.toJson(),
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
      if (noteText != null) 'noteText': noteText,
      'contentType': contentType.toJson(),
      if (intention != null) 'intention': intention,
      'priority': priority,
      'lifecycle': lifecycle.toJson(),
      'savedAt': savedAt.toJson(),
      'enrichmentState': enrichmentState.toJson(),
      'accessState': accessState.toJson(),
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
    String? noteText,
    _ic14w5wg.ContentType? contentType,
    String? intention,
    int? priority,
    _i6i14d93.ItemLifecycle? lifecycle,
    DateTime? savedAt,
    _iib6h77f.EnrichmentState? enrichmentState,
    _idll96tf.AccessState? accessState,
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
         noteText: noteText,
         contentType: contentType,
         intention: intention,
         priority: priority,
         lifecycle: lifecycle,
         savedAt: savedAt,
         enrichmentState: enrichmentState,
         accessState: accessState,
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
    Object? noteText = _Undefined,
    _ic14w5wg.ContentType? contentType,
    Object? intention = _Undefined,
    int? priority,
    _i6i14d93.ItemLifecycle? lifecycle,
    DateTime? savedAt,
    _iib6h77f.EnrichmentState? enrichmentState,
    _idll96tf.AccessState? accessState,
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
      noteText: noteText is String? ? noteText : this.noteText,
      contentType: contentType ?? this.contentType,
      intention: intention is String? ? intention : this.intention,
      priority: priority ?? this.priority,
      lifecycle: lifecycle ?? this.lifecycle,
      savedAt: savedAt ?? this.savedAt,
      enrichmentState: enrichmentState ?? this.enrichmentState,
      accessState: accessState ?? this.accessState,
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

  /// The text of a note-only item. Null for links.
  late final _is.ColumnString noteText;

  late final _is.ColumnEnum<_ic14w5wg.ContentType> contentType;

  /// The user's own note on why they saved this item.
  late final _is.ColumnString intention;

  late final _is.ColumnInt priority;

  late final _is.ColumnEnum<_i6i14d93.ItemLifecycle> lifecycle;

  /// When the user first saved it, on their device. Never moved by a later
  /// duplicate capture.
  late final _is.ColumnDateTime savedAt;

  late final _is.ColumnEnum<_iib6h77f.EnrichmentState> enrichmentState;

  late final _is.ColumnEnum<_idll96tf.AccessState> accessState;

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
    noteText,
    contentType,
    intention,
    priority,
    lifecycle,
    savedAt,
    enrichmentState,
    accessState,
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
