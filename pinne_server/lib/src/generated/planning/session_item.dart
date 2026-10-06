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

/// An item chosen for a session. Both ends share the owner.
abstract class SessionItem
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  SessionItem._({
    this.id,
    required this.ownerId,
    required this.sessionId,
    required this.itemId,
    required this.position,
    required this.plannedMinutes,
    required this.estimated,
  });

  factory SessionItem({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue sessionId,
    required _is.UuidValue itemId,
    required int position,
    required int plannedMinutes,
    required bool estimated,
  }) = _SessionItemImpl;

  factory SessionItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionItem(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      sessionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sessionId'],
      ),
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      position: jsonSerialization['position'] as int,
      plannedMinutes: jsonSerialization['plannedMinutes'] as int,
      estimated: _is.BoolJsonExtension.fromJson(jsonSerialization['estimated']),
    );
  }

  static final t = SessionItemTable();

  static const db = SessionItemRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue sessionId;

  _is.UuidValue itemId;

  int position;

  /// An estimate unless the item's duration is known.
  int plannedMinutes;

  bool estimated;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SessionItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionItem copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? sessionId,
    _is.UuidValue? itemId,
    int? position,
    int? plannedMinutes,
    bool? estimated,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionItem',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'sessionId': sessionId.toJson(),
      'itemId': itemId.toJson(),
      'position': position,
      'plannedMinutes': plannedMinutes,
      'estimated': estimated,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionItem',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'sessionId': sessionId.toJson(),
      'itemId': itemId.toJson(),
      'position': position,
      'plannedMinutes': plannedMinutes,
      'estimated': estimated,
    };
  }

  static SessionItemInclude include() {
    return SessionItemInclude._();
  }

  static SessionItemIncludeList includeList({
    _is.WhereExpressionBuilder<SessionItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionItemTable>? orderBy,
    _is.OrderByListBuilder<SessionItemTable>? orderByList,
    SessionItemInclude? include,
  }) {
    return SessionItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionItem.t),
      orderByList: orderByList?.call(SessionItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionItemImpl extends SessionItem {
  _SessionItemImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue sessionId,
    required _is.UuidValue itemId,
    required int position,
    required int plannedMinutes,
    required bool estimated,
  }) : super._(
         id: id,
         ownerId: ownerId,
         sessionId: sessionId,
         itemId: itemId,
         position: position,
         plannedMinutes: plannedMinutes,
         estimated: estimated,
       );

  /// Returns a shallow copy of this [SessionItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionItem copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? sessionId,
    _is.UuidValue? itemId,
    int? position,
    int? plannedMinutes,
    bool? estimated,
  }) {
    return SessionItem(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      sessionId: sessionId ?? this.sessionId,
      itemId: itemId ?? this.itemId,
      position: position ?? this.position,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      estimated: estimated ?? this.estimated,
    );
  }
}

class SessionItemUpdateTable extends _is.UpdateTable<SessionItemTable> {
  SessionItemUpdateTable(super.table);

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

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> itemId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.itemId,
        value,
      );

  _is.ColumnValue<int, int> position(int value) => _is.ColumnValue(
    table.position,
    value,
  );

  _is.ColumnValue<int, int> plannedMinutes(int value) => _is.ColumnValue(
    table.plannedMinutes,
    value,
  );

  _is.ColumnValue<bool, bool> estimated(bool value) => _is.ColumnValue(
    table.estimated,
    value,
  );
}

class SessionItemTable extends _is.Table<_is.UuidValue?> {
  SessionItemTable({super.tableRelation}) : super(tableName: 'session_item') {
    updateTable = SessionItemUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    sessionId = _is.ColumnUuid(
      'sessionId',
      this,
    );
    itemId = _is.ColumnUuid(
      'itemId',
      this,
    );
    position = _is.ColumnInt(
      'position',
      this,
    );
    plannedMinutes = _is.ColumnInt(
      'plannedMinutes',
      this,
    );
    estimated = _is.ColumnBool(
      'estimated',
      this,
    );
  }

  late final SessionItemUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid sessionId;

  late final _is.ColumnUuid itemId;

  late final _is.ColumnInt position;

  /// An estimate unless the item's duration is known.
  late final _is.ColumnInt plannedMinutes;

  late final _is.ColumnBool estimated;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    sessionId,
    itemId,
    position,
    plannedMinutes,
    estimated,
  ];
}

class SessionItemInclude extends _is.IncludeObject {
  SessionItemInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => SessionItem.t;
}

class SessionItemIncludeList extends _is.IncludeList {
  SessionItemIncludeList._({
    _is.WhereExpressionBuilder<SessionItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SessionItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => SessionItem.t;
}

class SessionItemRepository {
  const SessionItemRepository._();

  /// Returns a list of [SessionItem]s matching the given query parameters.
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
  Future<List<SessionItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionItemTable>? orderBy,
    _is.OrderByListBuilder<SessionItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SessionItem>(
      where: where?.call(SessionItem.t),
      orderBy: orderBy?.call(SessionItem.t),
      orderByList: orderByList?.call(SessionItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SessionItem] matching the given query parameters.
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
  Future<SessionItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionItemTable>? where,
    int? offset,
    _is.OrderByBuilder<SessionItemTable>? orderBy,
    _is.OrderByListBuilder<SessionItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SessionItem>(
      where: where?.call(SessionItem.t),
      orderBy: orderBy?.call(SessionItem.t),
      orderByList: orderByList?.call(SessionItem.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SessionItem] by its [id] or null if no such row exists.
  Future<SessionItem?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SessionItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SessionItem]s in the list and returns the inserted rows.
  ///
  /// The returned [SessionItem]s will have their `id` fields set.
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
  Future<List<SessionItem>> insert(
    _is.DatabaseSession session,
    List<SessionItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SessionItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SessionItem] and returns the inserted row.
  ///
  /// The returned [SessionItem] will have its `id` field set.
  Future<SessionItem> insertRow(
    _is.DatabaseSession session,
    SessionItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SessionItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SessionItem]s in the list and returns the resulting rows.
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
  /// The returned [SessionItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionItem>> upsert(
    _is.DatabaseSession session,
    List<SessionItem> rows, {
    required _is.ColumnSelections<SessionItemTable> conflictColumns,
    _is.ColumnSelections<SessionItemTable>? updateColumns,
    _is.WhereExpressionBuilder<SessionItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SessionItem>(
      rows,
      conflictColumns: conflictColumns(SessionItem.t),
      updateColumns: updateColumns?.call(SessionItem.t),
      updateWhere: updateWhere?.call(SessionItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SessionItem] and returns the resulting row.
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
  /// The returned [SessionItem] will have its `id` field set.
  Future<SessionItem?> upsertRow(
    _is.DatabaseSession session,
    SessionItem row, {
    required _is.ColumnSelections<SessionItemTable> conflictColumns,
    _is.ColumnSelections<SessionItemTable>? updateColumns,
    _is.WhereExpressionBuilder<SessionItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SessionItem>(
      row,
      conflictColumns: conflictColumns(SessionItem.t),
      updateColumns: updateColumns?.call(SessionItem.t),
      updateWhere: updateWhere?.call(SessionItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [SessionItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionItem>> update(
    _is.DatabaseSession session,
    List<SessionItem> rows, {
    _is.ColumnSelections<SessionItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SessionItem>(
      rows,
      columns: columns?.call(SessionItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SessionItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SessionItem> updateRow(
    _is.DatabaseSession session,
    SessionItem row, {
    _is.ColumnSelections<SessionItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SessionItem>(
      row,
      columns: columns?.call(SessionItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SessionItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SessionItem?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<SessionItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SessionItem>(
      id,
      columnValues: columnValues(SessionItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SessionItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SessionItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SessionItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionItemTable>? orderBy,
    _is.OrderByListBuilder<SessionItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SessionItem>(
      columnValues: columnValues(SessionItem.t.updateTable),
      where: where(SessionItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionItem.t),
      orderByList: orderByList?.call(SessionItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SessionItem]s in the list and returns the deleted rows.
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
  Future<List<SessionItem>> delete(
    _is.DatabaseSession session,
    List<SessionItem> rows, {
    _is.OrderByBuilder<SessionItemTable>? orderBy,
    _is.OrderByListBuilder<SessionItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SessionItem>(
      rows,
      orderBy: orderBy?.call(SessionItem.t),
      orderByList: orderByList?.call(SessionItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SessionItem].
  Future<SessionItem> deleteRow(
    _is.DatabaseSession session,
    SessionItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SessionItem>(
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
  Future<List<SessionItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SessionItemTable> where,
    _is.OrderByBuilder<SessionItemTable>? orderBy,
    _is.OrderByListBuilder<SessionItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SessionItem>(
      where: where(SessionItem.t),
      orderBy: orderBy?.call(SessionItem.t),
      orderByList: orderByList?.call(SessionItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SessionItem>(
      where: where?.call(SessionItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SessionItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SessionItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SessionItem>(
      where: where(SessionItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
