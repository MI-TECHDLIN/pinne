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

/// Per-owner calls of the remote provider. Date keys are UTC YYYY-MM-DD.
abstract class AiDailyUsage
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AiDailyUsage._({
    this.id,
    required this.ownerId,
    required this.dateKey,
    int? requestCount,
  }) : requestCount = requestCount ?? 0;

  factory AiDailyUsage({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String dateKey,
    int? requestCount,
  }) = _AiDailyUsageImpl;

  factory AiDailyUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiDailyUsage(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      dateKey: jsonSerialization['dateKey'] as String,
      requestCount: jsonSerialization['requestCount'] as int?,
    );
  }

  static final t = AiDailyUsageTable();

  static const db = AiDailyUsageRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  String dateKey;

  int requestCount;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AiDailyUsage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiDailyUsage copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    String? dateKey,
    int? requestCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiDailyUsage',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'dateKey': dateKey,
      'requestCount': requestCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiDailyUsage',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'dateKey': dateKey,
      'requestCount': requestCount,
    };
  }

  static AiDailyUsageInclude include() {
    return AiDailyUsageInclude._();
  }

  static AiDailyUsageIncludeList includeList({
    _is.WhereExpressionBuilder<AiDailyUsageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiDailyUsageTable>? orderBy,
    _is.OrderByListBuilder<AiDailyUsageTable>? orderByList,
    AiDailyUsageInclude? include,
  }) {
    return AiDailyUsageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiDailyUsage.t),
      orderByList: orderByList?.call(AiDailyUsage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiDailyUsageImpl extends AiDailyUsage {
  _AiDailyUsageImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String dateKey,
    int? requestCount,
  }) : super._(
         id: id,
         ownerId: ownerId,
         dateKey: dateKey,
         requestCount: requestCount,
       );

  /// Returns a shallow copy of this [AiDailyUsage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiDailyUsage copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    String? dateKey,
    int? requestCount,
  }) {
    return AiDailyUsage(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      dateKey: dateKey ?? this.dateKey,
      requestCount: requestCount ?? this.requestCount,
    );
  }
}

class AiDailyUsageUpdateTable extends _is.UpdateTable<AiDailyUsageTable> {
  AiDailyUsageUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> dateKey(String value) => _is.ColumnValue(
    table.dateKey,
    value,
  );

  _is.ColumnValue<int, int> requestCount(int value) => _is.ColumnValue(
    table.requestCount,
    value,
  );
}

class AiDailyUsageTable extends _is.Table<_is.UuidValue?> {
  AiDailyUsageTable({super.tableRelation})
    : super(tableName: 'ai_daily_usage') {
    updateTable = AiDailyUsageUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    dateKey = _is.ColumnString(
      'dateKey',
      this,
    );
    requestCount = _is.ColumnInt(
      'requestCount',
      this,
      hasDefault: true,
    );
  }

  late final AiDailyUsageUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnString dateKey;

  late final _is.ColumnInt requestCount;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    dateKey,
    requestCount,
  ];
}

class AiDailyUsageInclude extends _is.IncludeObject {
  AiDailyUsageInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => AiDailyUsage.t;
}

class AiDailyUsageIncludeList extends _is.IncludeList {
  AiDailyUsageIncludeList._({
    _is.WhereExpressionBuilder<AiDailyUsageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AiDailyUsage.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AiDailyUsage.t;
}

class AiDailyUsageRepository {
  const AiDailyUsageRepository._();

  /// Returns a list of [AiDailyUsage]s matching the given query parameters.
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
  Future<List<AiDailyUsage>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiDailyUsageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiDailyUsageTable>? orderBy,
    _is.OrderByListBuilder<AiDailyUsageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AiDailyUsage>(
      where: where?.call(AiDailyUsage.t),
      orderBy: orderBy?.call(AiDailyUsage.t),
      orderByList: orderByList?.call(AiDailyUsage.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AiDailyUsage] matching the given query parameters.
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
  Future<AiDailyUsage?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiDailyUsageTable>? where,
    int? offset,
    _is.OrderByBuilder<AiDailyUsageTable>? orderBy,
    _is.OrderByListBuilder<AiDailyUsageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AiDailyUsage>(
      where: where?.call(AiDailyUsage.t),
      orderBy: orderBy?.call(AiDailyUsage.t),
      orderByList: orderByList?.call(AiDailyUsage.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AiDailyUsage] by its [id] or null if no such row exists.
  Future<AiDailyUsage?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AiDailyUsage>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AiDailyUsage]s in the list and returns the inserted rows.
  ///
  /// The returned [AiDailyUsage]s will have their `id` fields set.
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
  Future<List<AiDailyUsage>> insert(
    _is.DatabaseSession session,
    List<AiDailyUsage> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AiDailyUsage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AiDailyUsage] and returns the inserted row.
  ///
  /// The returned [AiDailyUsage] will have its `id` field set.
  Future<AiDailyUsage> insertRow(
    _is.DatabaseSession session,
    AiDailyUsage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AiDailyUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AiDailyUsage]s in the list and returns the resulting rows.
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
  /// The returned [AiDailyUsage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiDailyUsage>> upsert(
    _is.DatabaseSession session,
    List<AiDailyUsage> rows, {
    required _is.ColumnSelections<AiDailyUsageTable> conflictColumns,
    _is.ColumnSelections<AiDailyUsageTable>? updateColumns,
    _is.WhereExpressionBuilder<AiDailyUsageTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AiDailyUsage>(
      rows,
      conflictColumns: conflictColumns(AiDailyUsage.t),
      updateColumns: updateColumns?.call(AiDailyUsage.t),
      updateWhere: updateWhere?.call(AiDailyUsage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AiDailyUsage] and returns the resulting row.
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
  /// The returned [AiDailyUsage] will have its `id` field set.
  Future<AiDailyUsage?> upsertRow(
    _is.DatabaseSession session,
    AiDailyUsage row, {
    required _is.ColumnSelections<AiDailyUsageTable> conflictColumns,
    _is.ColumnSelections<AiDailyUsageTable>? updateColumns,
    _is.WhereExpressionBuilder<AiDailyUsageTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AiDailyUsage>(
      row,
      conflictColumns: conflictColumns(AiDailyUsage.t),
      updateColumns: updateColumns?.call(AiDailyUsage.t),
      updateWhere: updateWhere?.call(AiDailyUsage.t),
      transaction: transaction,
    );
  }

  /// Updates all [AiDailyUsage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiDailyUsage>> update(
    _is.DatabaseSession session,
    List<AiDailyUsage> rows, {
    _is.ColumnSelections<AiDailyUsageTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AiDailyUsage>(
      rows,
      columns: columns?.call(AiDailyUsage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AiDailyUsage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AiDailyUsage> updateRow(
    _is.DatabaseSession session,
    AiDailyUsage row, {
    _is.ColumnSelections<AiDailyUsageTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AiDailyUsage>(
      row,
      columns: columns?.call(AiDailyUsage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiDailyUsage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AiDailyUsage?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AiDailyUsageUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AiDailyUsage>(
      id,
      columnValues: columnValues(AiDailyUsage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AiDailyUsage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiDailyUsage>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AiDailyUsageUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AiDailyUsageTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiDailyUsageTable>? orderBy,
    _is.OrderByListBuilder<AiDailyUsageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AiDailyUsage>(
      columnValues: columnValues(AiDailyUsage.t.updateTable),
      where: where(AiDailyUsage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiDailyUsage.t),
      orderByList: orderByList?.call(AiDailyUsage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AiDailyUsage]s in the list and returns the deleted rows.
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
  Future<List<AiDailyUsage>> delete(
    _is.DatabaseSession session,
    List<AiDailyUsage> rows, {
    _is.OrderByBuilder<AiDailyUsageTable>? orderBy,
    _is.OrderByListBuilder<AiDailyUsageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AiDailyUsage>(
      rows,
      orderBy: orderBy?.call(AiDailyUsage.t),
      orderByList: orderByList?.call(AiDailyUsage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AiDailyUsage].
  Future<AiDailyUsage> deleteRow(
    _is.DatabaseSession session,
    AiDailyUsage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AiDailyUsage>(
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
  Future<List<AiDailyUsage>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiDailyUsageTable> where,
    _is.OrderByBuilder<AiDailyUsageTable>? orderBy,
    _is.OrderByListBuilder<AiDailyUsageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AiDailyUsage>(
      where: where(AiDailyUsage.t),
      orderBy: orderBy?.call(AiDailyUsage.t),
      orderByList: orderByList?.call(AiDailyUsage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiDailyUsageTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AiDailyUsage>(
      where: where?.call(AiDailyUsage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AiDailyUsage] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiDailyUsageTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AiDailyUsage>(
      where: where(AiDailyUsage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
