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
import '../calendar/event_sync_state.dart' as _ipxlzb0n;

/// Maps a review session to the event written for it. The remote event id
/// is stored only after the device or provider confirms it.
abstract class CalendarEventLink
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CalendarEventLink._({
    this.id,
    required this.ownerId,
    required this.sessionId,
    required this.selectionId,
    this.deviceId,
    required this.eventUid,
    this.externalEventId,
    this.providerRevision,
    required this.syncState,
    required this.operationId,
    this.lastError,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory CalendarEventLink({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue sessionId,
    required _is.UuidValue selectionId,
    _is.UuidValue? deviceId,
    required String eventUid,
    String? externalEventId,
    String? providerRevision,
    required _ipxlzb0n.EventSyncState syncState,
    required _is.UuidValue operationId,
    String? lastError,
    DateTime? updatedAt,
  }) = _CalendarEventLinkImpl;

  factory CalendarEventLink.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarEventLink(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      sessionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sessionId'],
      ),
      selectionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['selectionId'],
      ),
      deviceId: jsonSerialization['deviceId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
      eventUid: jsonSerialization['eventUid'] as String,
      externalEventId: jsonSerialization['externalEventId'] as String?,
      providerRevision: jsonSerialization['providerRevision'] as String?,
      syncState: _ipxlzb0n.EventSyncState.fromJson(
        (jsonSerialization['syncState'] as String),
      ),
      operationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['operationId'],
      ),
      lastError: jsonSerialization['lastError'] as String?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = CalendarEventLinkTable();

  static const db = CalendarEventLinkRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue sessionId;

  _is.UuidValue selectionId;

  /// The install that writes the event, for device routes.
  _is.UuidValue? deviceId;

  /// Stable for the session; stored in the event so a retry finds it.
  String eventUid;

  String? externalEventId;

  String? providerRevision;

  _ipxlzb0n.EventSyncState syncState;

  /// The commit, move or cancel that last changed this link.
  _is.UuidValue operationId;

  String? lastError;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CalendarEventLink]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CalendarEventLink copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? sessionId,
    _is.UuidValue? selectionId,
    _is.UuidValue? deviceId,
    String? eventUid,
    String? externalEventId,
    String? providerRevision,
    _ipxlzb0n.EventSyncState? syncState,
    _is.UuidValue? operationId,
    String? lastError,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarEventLink',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'sessionId': sessionId.toJson(),
      'selectionId': selectionId.toJson(),
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'eventUid': eventUid,
      if (externalEventId != null) 'externalEventId': externalEventId,
      if (providerRevision != null) 'providerRevision': providerRevision,
      'syncState': syncState.toJson(),
      'operationId': operationId.toJson(),
      if (lastError != null) 'lastError': lastError,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarEventLink',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'sessionId': sessionId.toJson(),
      'selectionId': selectionId.toJson(),
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'eventUid': eventUid,
      if (externalEventId != null) 'externalEventId': externalEventId,
      if (providerRevision != null) 'providerRevision': providerRevision,
      'syncState': syncState.toJson(),
      'operationId': operationId.toJson(),
      if (lastError != null) 'lastError': lastError,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CalendarEventLinkInclude include() {
    return CalendarEventLinkInclude._();
  }

  static CalendarEventLinkIncludeList includeList({
    _is.WhereExpressionBuilder<CalendarEventLinkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CalendarEventLinkTable>? orderBy,
    _is.OrderByListBuilder<CalendarEventLinkTable>? orderByList,
    CalendarEventLinkInclude? include,
  }) {
    return CalendarEventLinkIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarEventLink.t),
      orderByList: orderByList?.call(CalendarEventLink.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarEventLinkImpl extends CalendarEventLink {
  _CalendarEventLinkImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue sessionId,
    required _is.UuidValue selectionId,
    _is.UuidValue? deviceId,
    required String eventUid,
    String? externalEventId,
    String? providerRevision,
    required _ipxlzb0n.EventSyncState syncState,
    required _is.UuidValue operationId,
    String? lastError,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         sessionId: sessionId,
         selectionId: selectionId,
         deviceId: deviceId,
         eventUid: eventUid,
         externalEventId: externalEventId,
         providerRevision: providerRevision,
         syncState: syncState,
         operationId: operationId,
         lastError: lastError,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CalendarEventLink]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CalendarEventLink copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? sessionId,
    _is.UuidValue? selectionId,
    Object? deviceId = _Undefined,
    String? eventUid,
    Object? externalEventId = _Undefined,
    Object? providerRevision = _Undefined,
    _ipxlzb0n.EventSyncState? syncState,
    _is.UuidValue? operationId,
    Object? lastError = _Undefined,
    DateTime? updatedAt,
  }) {
    return CalendarEventLink(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      sessionId: sessionId ?? this.sessionId,
      selectionId: selectionId ?? this.selectionId,
      deviceId: deviceId is _is.UuidValue? ? deviceId : this.deviceId,
      eventUid: eventUid ?? this.eventUid,
      externalEventId: externalEventId is String?
          ? externalEventId
          : this.externalEventId,
      providerRevision: providerRevision is String?
          ? providerRevision
          : this.providerRevision,
      syncState: syncState ?? this.syncState,
      operationId: operationId ?? this.operationId,
      lastError: lastError is String? ? lastError : this.lastError,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CalendarEventLinkUpdateTable
    extends _is.UpdateTable<CalendarEventLinkTable> {
  CalendarEventLinkUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sessionId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.sessionId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> selectionId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.selectionId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> deviceId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<String, String> eventUid(String value) => _is.ColumnValue(
    table.eventUid,
    value,
  );

  _is.ColumnValue<String, String> externalEventId(String? value) =>
      _is.ColumnValue(
        table.externalEventId,
        value,
      );

  _is.ColumnValue<String, String> providerRevision(String? value) =>
      _is.ColumnValue(
        table.providerRevision,
        value,
      );

  _is.ColumnValue<_ipxlzb0n.EventSyncState, _ipxlzb0n.EventSyncState> syncState(
    _ipxlzb0n.EventSyncState value,
  ) => _is.ColumnValue(
    table.syncState,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> operationId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.operationId,
    value,
  );

  _is.ColumnValue<String, String> lastError(String? value) => _is.ColumnValue(
    table.lastError,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class CalendarEventLinkTable extends _is.Table<_is.UuidValue?> {
  CalendarEventLinkTable({super.tableRelation})
    : super(tableName: 'calendar_event_link') {
    updateTable = CalendarEventLinkUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    sessionId = _is.ColumnUuid(
      'sessionId',
      this,
    );
    selectionId = _is.ColumnUuid(
      'selectionId',
      this,
    );
    deviceId = _is.ColumnUuid(
      'deviceId',
      this,
    );
    eventUid = _is.ColumnString(
      'eventUid',
      this,
    );
    externalEventId = _is.ColumnString(
      'externalEventId',
      this,
    );
    providerRevision = _is.ColumnString(
      'providerRevision',
      this,
    );
    syncState = _is.ColumnEnum(
      'syncState',
      this,
      _is.EnumSerialization.byName,
    );
    operationId = _is.ColumnUuid(
      'operationId',
      this,
    );
    lastError = _is.ColumnString(
      'lastError',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final CalendarEventLinkUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid sessionId;

  late final _is.ColumnUuid selectionId;

  /// The install that writes the event, for device routes.
  late final _is.ColumnUuid deviceId;

  /// Stable for the session; stored in the event so a retry finds it.
  late final _is.ColumnString eventUid;

  late final _is.ColumnString externalEventId;

  late final _is.ColumnString providerRevision;

  late final _is.ColumnEnum<_ipxlzb0n.EventSyncState> syncState;

  /// The commit, move or cancel that last changed this link.
  late final _is.ColumnUuid operationId;

  late final _is.ColumnString lastError;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    sessionId,
    selectionId,
    deviceId,
    eventUid,
    externalEventId,
    providerRevision,
    syncState,
    operationId,
    lastError,
    updatedAt,
  ];
}

class CalendarEventLinkInclude extends _is.IncludeObject {
  CalendarEventLinkInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => CalendarEventLink.t;
}

class CalendarEventLinkIncludeList extends _is.IncludeList {
  CalendarEventLinkIncludeList._({
    _is.WhereExpressionBuilder<CalendarEventLinkTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CalendarEventLink.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CalendarEventLink.t;
}

class CalendarEventLinkRepository {
  const CalendarEventLinkRepository._();

  /// Returns a list of [CalendarEventLink]s matching the given query parameters.
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
  Future<List<CalendarEventLink>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CalendarEventLinkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CalendarEventLinkTable>? orderBy,
    _is.OrderByListBuilder<CalendarEventLinkTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CalendarEventLink>(
      where: where?.call(CalendarEventLink.t),
      orderBy: orderBy?.call(CalendarEventLink.t),
      orderByList: orderByList?.call(CalendarEventLink.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CalendarEventLink] matching the given query parameters.
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
  Future<CalendarEventLink?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CalendarEventLinkTable>? where,
    int? offset,
    _is.OrderByBuilder<CalendarEventLinkTable>? orderBy,
    _is.OrderByListBuilder<CalendarEventLinkTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CalendarEventLink>(
      where: where?.call(CalendarEventLink.t),
      orderBy: orderBy?.call(CalendarEventLink.t),
      orderByList: orderByList?.call(CalendarEventLink.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CalendarEventLink] by its [id] or null if no such row exists.
  Future<CalendarEventLink?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CalendarEventLink>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CalendarEventLink]s in the list and returns the inserted rows.
  ///
  /// The returned [CalendarEventLink]s will have their `id` fields set.
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
  Future<List<CalendarEventLink>> insert(
    _is.DatabaseSession session,
    List<CalendarEventLink> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CalendarEventLink>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CalendarEventLink] and returns the inserted row.
  ///
  /// The returned [CalendarEventLink] will have its `id` field set.
  Future<CalendarEventLink> insertRow(
    _is.DatabaseSession session,
    CalendarEventLink row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CalendarEventLink>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CalendarEventLink]s in the list and returns the resulting rows.
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
  /// The returned [CalendarEventLink]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CalendarEventLink>> upsert(
    _is.DatabaseSession session,
    List<CalendarEventLink> rows, {
    required _is.ColumnSelections<CalendarEventLinkTable> conflictColumns,
    _is.ColumnSelections<CalendarEventLinkTable>? updateColumns,
    _is.WhereExpressionBuilder<CalendarEventLinkTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CalendarEventLink>(
      rows,
      conflictColumns: conflictColumns(CalendarEventLink.t),
      updateColumns: updateColumns?.call(CalendarEventLink.t),
      updateWhere: updateWhere?.call(CalendarEventLink.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CalendarEventLink] and returns the resulting row.
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
  /// The returned [CalendarEventLink] will have its `id` field set.
  Future<CalendarEventLink?> upsertRow(
    _is.DatabaseSession session,
    CalendarEventLink row, {
    required _is.ColumnSelections<CalendarEventLinkTable> conflictColumns,
    _is.ColumnSelections<CalendarEventLinkTable>? updateColumns,
    _is.WhereExpressionBuilder<CalendarEventLinkTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CalendarEventLink>(
      row,
      conflictColumns: conflictColumns(CalendarEventLink.t),
      updateColumns: updateColumns?.call(CalendarEventLink.t),
      updateWhere: updateWhere?.call(CalendarEventLink.t),
      transaction: transaction,
    );
  }

  /// Updates all [CalendarEventLink]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CalendarEventLink>> update(
    _is.DatabaseSession session,
    List<CalendarEventLink> rows, {
    _is.ColumnSelections<CalendarEventLinkTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CalendarEventLink>(
      rows,
      columns: columns?.call(CalendarEventLink.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CalendarEventLink]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CalendarEventLink> updateRow(
    _is.DatabaseSession session,
    CalendarEventLink row, {
    _is.ColumnSelections<CalendarEventLinkTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CalendarEventLink>(
      row,
      columns: columns?.call(CalendarEventLink.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CalendarEventLink] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CalendarEventLink?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CalendarEventLinkUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CalendarEventLink>(
      id,
      columnValues: columnValues(CalendarEventLink.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CalendarEventLink]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CalendarEventLink>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CalendarEventLinkUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CalendarEventLinkTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CalendarEventLinkTable>? orderBy,
    _is.OrderByListBuilder<CalendarEventLinkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CalendarEventLink>(
      columnValues: columnValues(CalendarEventLink.t.updateTable),
      where: where(CalendarEventLink.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarEventLink.t),
      orderByList: orderByList?.call(CalendarEventLink.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CalendarEventLink]s in the list and returns the deleted rows.
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
  Future<List<CalendarEventLink>> delete(
    _is.DatabaseSession session,
    List<CalendarEventLink> rows, {
    _is.OrderByBuilder<CalendarEventLinkTable>? orderBy,
    _is.OrderByListBuilder<CalendarEventLinkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CalendarEventLink>(
      rows,
      orderBy: orderBy?.call(CalendarEventLink.t),
      orderByList: orderByList?.call(CalendarEventLink.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CalendarEventLink].
  Future<CalendarEventLink> deleteRow(
    _is.DatabaseSession session,
    CalendarEventLink row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CalendarEventLink>(
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
  Future<List<CalendarEventLink>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CalendarEventLinkTable> where,
    _is.OrderByBuilder<CalendarEventLinkTable>? orderBy,
    _is.OrderByListBuilder<CalendarEventLinkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CalendarEventLink>(
      where: where(CalendarEventLink.t),
      orderBy: orderBy?.call(CalendarEventLink.t),
      orderByList: orderByList?.call(CalendarEventLink.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CalendarEventLinkTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CalendarEventLink>(
      where: where?.call(CalendarEventLink.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CalendarEventLink] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CalendarEventLinkTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CalendarEventLink>(
      where: where(CalendarEventLink.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
