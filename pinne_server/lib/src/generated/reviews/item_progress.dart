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

/// Rebuildable projection of valid review events for one owned item.
abstract class ItemProgress
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ItemProgress._({
    this.id,
    required this.ownerId,
    required this.itemId,
    this.firstOpenedAt,
    this.lastOpenedAt,
    int? openCount,
    this.firstReviewedAt,
    this.lastReviewedAt,
    this.completedAt,
    this.appliedAt,
    DateTime? rebuiltAt,
  }) : openCount = openCount ?? 0,
       rebuiltAt = rebuiltAt ?? DateTime.now();

  factory ItemProgress({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    DateTime? firstOpenedAt,
    DateTime? lastOpenedAt,
    int? openCount,
    DateTime? firstReviewedAt,
    DateTime? lastReviewedAt,
    DateTime? completedAt,
    DateTime? appliedAt,
    DateTime? rebuiltAt,
  }) = _ItemProgressImpl;

  factory ItemProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemProgress(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      firstOpenedAt: jsonSerialization['firstOpenedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstOpenedAt'],
            ),
      lastOpenedAt: jsonSerialization['lastOpenedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastOpenedAt'],
            ),
      openCount: jsonSerialization['openCount'] as int?,
      firstReviewedAt: jsonSerialization['firstReviewedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstReviewedAt'],
            ),
      lastReviewedAt: jsonSerialization['lastReviewedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastReviewedAt'],
            ),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      appliedAt: jsonSerialization['appliedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['appliedAt']),
      rebuiltAt: jsonSerialization['rebuiltAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['rebuiltAt']),
    );
  }

  static final t = ItemProgressTable();

  static const db = ItemProgressRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue itemId;

  DateTime? firstOpenedAt;

  DateTime? lastOpenedAt;

  int openCount;

  DateTime? firstReviewedAt;

  DateTime? lastReviewedAt;

  DateTime? completedAt;

  DateTime? appliedAt;

  DateTime rebuiltAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ItemProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ItemProgress copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    DateTime? firstOpenedAt,
    DateTime? lastOpenedAt,
    int? openCount,
    DateTime? firstReviewedAt,
    DateTime? lastReviewedAt,
    DateTime? completedAt,
    DateTime? appliedAt,
    DateTime? rebuiltAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemProgress',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      if (firstOpenedAt != null) 'firstOpenedAt': firstOpenedAt?.toJson(),
      if (lastOpenedAt != null) 'lastOpenedAt': lastOpenedAt?.toJson(),
      'openCount': openCount,
      if (firstReviewedAt != null) 'firstReviewedAt': firstReviewedAt?.toJson(),
      if (lastReviewedAt != null) 'lastReviewedAt': lastReviewedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (appliedAt != null) 'appliedAt': appliedAt?.toJson(),
      'rebuiltAt': rebuiltAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemProgress',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      if (firstOpenedAt != null) 'firstOpenedAt': firstOpenedAt?.toJson(),
      if (lastOpenedAt != null) 'lastOpenedAt': lastOpenedAt?.toJson(),
      'openCount': openCount,
      if (firstReviewedAt != null) 'firstReviewedAt': firstReviewedAt?.toJson(),
      if (lastReviewedAt != null) 'lastReviewedAt': lastReviewedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (appliedAt != null) 'appliedAt': appliedAt?.toJson(),
      'rebuiltAt': rebuiltAt.toJson(),
    };
  }

  static ItemProgressInclude include() {
    return ItemProgressInclude._();
  }

  static ItemProgressIncludeList includeList({
    _is.WhereExpressionBuilder<ItemProgressTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemProgressTable>? orderBy,
    _is.OrderByListBuilder<ItemProgressTable>? orderByList,
    ItemProgressInclude? include,
  }) {
    return ItemProgressIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemProgress.t),
      orderByList: orderByList?.call(ItemProgress.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemProgressImpl extends ItemProgress {
  _ItemProgressImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    DateTime? firstOpenedAt,
    DateTime? lastOpenedAt,
    int? openCount,
    DateTime? firstReviewedAt,
    DateTime? lastReviewedAt,
    DateTime? completedAt,
    DateTime? appliedAt,
    DateTime? rebuiltAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         firstOpenedAt: firstOpenedAt,
         lastOpenedAt: lastOpenedAt,
         openCount: openCount,
         firstReviewedAt: firstReviewedAt,
         lastReviewedAt: lastReviewedAt,
         completedAt: completedAt,
         appliedAt: appliedAt,
         rebuiltAt: rebuiltAt,
       );

  /// Returns a shallow copy of this [ItemProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ItemProgress copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    Object? firstOpenedAt = _Undefined,
    Object? lastOpenedAt = _Undefined,
    int? openCount,
    Object? firstReviewedAt = _Undefined,
    Object? lastReviewedAt = _Undefined,
    Object? completedAt = _Undefined,
    Object? appliedAt = _Undefined,
    DateTime? rebuiltAt,
  }) {
    return ItemProgress(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      firstOpenedAt: firstOpenedAt is DateTime?
          ? firstOpenedAt
          : this.firstOpenedAt,
      lastOpenedAt: lastOpenedAt is DateTime?
          ? lastOpenedAt
          : this.lastOpenedAt,
      openCount: openCount ?? this.openCount,
      firstReviewedAt: firstReviewedAt is DateTime?
          ? firstReviewedAt
          : this.firstReviewedAt,
      lastReviewedAt: lastReviewedAt is DateTime?
          ? lastReviewedAt
          : this.lastReviewedAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      appliedAt: appliedAt is DateTime? ? appliedAt : this.appliedAt,
      rebuiltAt: rebuiltAt ?? this.rebuiltAt,
    );
  }
}

class ItemProgressUpdateTable extends _is.UpdateTable<ItemProgressTable> {
  ItemProgressUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> itemId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.itemId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> firstOpenedAt(DateTime? value) =>
      _is.ColumnValue(
        table.firstOpenedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastOpenedAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastOpenedAt,
        value,
      );

  _is.ColumnValue<int, int> openCount(int value) => _is.ColumnValue(
    table.openCount,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> firstReviewedAt(DateTime? value) =>
      _is.ColumnValue(
        table.firstReviewedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastReviewedAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastReviewedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _is.ColumnValue(
        table.completedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> appliedAt(DateTime? value) =>
      _is.ColumnValue(
        table.appliedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> rebuiltAt(DateTime value) =>
      _is.ColumnValue(
        table.rebuiltAt,
        value,
      );
}

class ItemProgressTable extends _is.Table<_is.UuidValue?> {
  ItemProgressTable({super.tableRelation}) : super(tableName: 'item_progress') {
    updateTable = ItemProgressUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    itemId = _is.ColumnUuid(
      'itemId',
      this,
    );
    firstOpenedAt = _is.ColumnDateTime(
      'firstOpenedAt',
      this,
    );
    lastOpenedAt = _is.ColumnDateTime(
      'lastOpenedAt',
      this,
    );
    openCount = _is.ColumnInt(
      'openCount',
      this,
      hasDefault: true,
    );
    firstReviewedAt = _is.ColumnDateTime(
      'firstReviewedAt',
      this,
    );
    lastReviewedAt = _is.ColumnDateTime(
      'lastReviewedAt',
      this,
    );
    completedAt = _is.ColumnDateTime(
      'completedAt',
      this,
    );
    appliedAt = _is.ColumnDateTime(
      'appliedAt',
      this,
    );
    rebuiltAt = _is.ColumnDateTime(
      'rebuiltAt',
      this,
      hasDefault: true,
    );
  }

  late final ItemProgressUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid itemId;

  late final _is.ColumnDateTime firstOpenedAt;

  late final _is.ColumnDateTime lastOpenedAt;

  late final _is.ColumnInt openCount;

  late final _is.ColumnDateTime firstReviewedAt;

  late final _is.ColumnDateTime lastReviewedAt;

  late final _is.ColumnDateTime completedAt;

  late final _is.ColumnDateTime appliedAt;

  late final _is.ColumnDateTime rebuiltAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    itemId,
    firstOpenedAt,
    lastOpenedAt,
    openCount,
    firstReviewedAt,
    lastReviewedAt,
    completedAt,
    appliedAt,
    rebuiltAt,
  ];
}

class ItemProgressInclude extends _is.IncludeObject {
  ItemProgressInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ItemProgress.t;
}

class ItemProgressIncludeList extends _is.IncludeList {
  ItemProgressIncludeList._({
    _is.WhereExpressionBuilder<ItemProgressTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ItemProgress.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ItemProgress.t;
}

class ItemProgressRepository {
  const ItemProgressRepository._();

  /// Returns a list of [ItemProgress]s matching the given query parameters.
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
  Future<List<ItemProgress>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemProgressTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemProgressTable>? orderBy,
    _is.OrderByListBuilder<ItemProgressTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ItemProgress>(
      where: where?.call(ItemProgress.t),
      orderBy: orderBy?.call(ItemProgress.t),
      orderByList: orderByList?.call(ItemProgress.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ItemProgress] matching the given query parameters.
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
  Future<ItemProgress?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemProgressTable>? where,
    int? offset,
    _is.OrderByBuilder<ItemProgressTable>? orderBy,
    _is.OrderByListBuilder<ItemProgressTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ItemProgress>(
      where: where?.call(ItemProgress.t),
      orderBy: orderBy?.call(ItemProgress.t),
      orderByList: orderByList?.call(ItemProgress.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ItemProgress] by its [id] or null if no such row exists.
  Future<ItemProgress?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ItemProgress>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ItemProgress]s in the list and returns the inserted rows.
  ///
  /// The returned [ItemProgress]s will have their `id` fields set.
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
  Future<List<ItemProgress>> insert(
    _is.DatabaseSession session,
    List<ItemProgress> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ItemProgress>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ItemProgress] and returns the inserted row.
  ///
  /// The returned [ItemProgress] will have its `id` field set.
  Future<ItemProgress> insertRow(
    _is.DatabaseSession session,
    ItemProgress row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ItemProgress>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ItemProgress]s in the list and returns the resulting rows.
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
  /// The returned [ItemProgress]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemProgress>> upsert(
    _is.DatabaseSession session,
    List<ItemProgress> rows, {
    required _is.ColumnSelections<ItemProgressTable> conflictColumns,
    _is.ColumnSelections<ItemProgressTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemProgressTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ItemProgress>(
      rows,
      conflictColumns: conflictColumns(ItemProgress.t),
      updateColumns: updateColumns?.call(ItemProgress.t),
      updateWhere: updateWhere?.call(ItemProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ItemProgress] and returns the resulting row.
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
  /// The returned [ItemProgress] will have its `id` field set.
  Future<ItemProgress?> upsertRow(
    _is.DatabaseSession session,
    ItemProgress row, {
    required _is.ColumnSelections<ItemProgressTable> conflictColumns,
    _is.ColumnSelections<ItemProgressTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemProgressTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ItemProgress>(
      row,
      conflictColumns: conflictColumns(ItemProgress.t),
      updateColumns: updateColumns?.call(ItemProgress.t),
      updateWhere: updateWhere?.call(ItemProgress.t),
      transaction: transaction,
    );
  }

  /// Updates all [ItemProgress]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemProgress>> update(
    _is.DatabaseSession session,
    List<ItemProgress> rows, {
    _is.ColumnSelections<ItemProgressTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ItemProgress>(
      rows,
      columns: columns?.call(ItemProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ItemProgress]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ItemProgress> updateRow(
    _is.DatabaseSession session,
    ItemProgress row, {
    _is.ColumnSelections<ItemProgressTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ItemProgress>(
      row,
      columns: columns?.call(ItemProgress.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ItemProgress] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ItemProgress?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ItemProgressUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ItemProgress>(
      id,
      columnValues: columnValues(ItemProgress.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ItemProgress]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemProgress>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ItemProgressUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ItemProgressTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemProgressTable>? orderBy,
    _is.OrderByListBuilder<ItemProgressTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ItemProgress>(
      columnValues: columnValues(ItemProgress.t.updateTable),
      where: where(ItemProgress.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemProgress.t),
      orderByList: orderByList?.call(ItemProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ItemProgress]s in the list and returns the deleted rows.
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
  Future<List<ItemProgress>> delete(
    _is.DatabaseSession session,
    List<ItemProgress> rows, {
    _is.OrderByBuilder<ItemProgressTable>? orderBy,
    _is.OrderByListBuilder<ItemProgressTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ItemProgress>(
      rows,
      orderBy: orderBy?.call(ItemProgress.t),
      orderByList: orderByList?.call(ItemProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ItemProgress].
  Future<ItemProgress> deleteRow(
    _is.DatabaseSession session,
    ItemProgress row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ItemProgress>(
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
  Future<List<ItemProgress>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemProgressTable> where,
    _is.OrderByBuilder<ItemProgressTable>? orderBy,
    _is.OrderByListBuilder<ItemProgressTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ItemProgress>(
      where: where(ItemProgress.t),
      orderBy: orderBy?.call(ItemProgress.t),
      orderByList: orderByList?.call(ItemProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemProgressTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ItemProgress>(
      where: where?.call(ItemProgress.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ItemProgress] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemProgressTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ItemProgress>(
      where: where(ItemProgress.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
