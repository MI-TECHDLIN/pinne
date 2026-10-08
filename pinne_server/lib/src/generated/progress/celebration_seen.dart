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

/// A milestone celebration the owner has already seen.
abstract class CelebrationSeen
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CelebrationSeen._({
    this.id,
    required this.ownerId,
    required this.milestoneKey,
    DateTime? seenAt,
  }) : seenAt = seenAt ?? DateTime.now();

  factory CelebrationSeen({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String milestoneKey,
    DateTime? seenAt,
  }) = _CelebrationSeenImpl;

  factory CelebrationSeen.fromJson(Map<String, dynamic> jsonSerialization) {
    return CelebrationSeen(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      milestoneKey: jsonSerialization['milestoneKey'] as String,
      seenAt: jsonSerialization['seenAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['seenAt']),
    );
  }

  static final t = CelebrationSeenTable();

  static const db = CelebrationSeenRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  String milestoneKey;

  DateTime seenAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CelebrationSeen]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CelebrationSeen copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    String? milestoneKey,
    DateTime? seenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CelebrationSeen',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'milestoneKey': milestoneKey,
      'seenAt': seenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CelebrationSeen',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'milestoneKey': milestoneKey,
      'seenAt': seenAt.toJson(),
    };
  }

  static CelebrationSeenInclude include() {
    return CelebrationSeenInclude._();
  }

  static CelebrationSeenIncludeList includeList({
    _is.WhereExpressionBuilder<CelebrationSeenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CelebrationSeenTable>? orderBy,
    _is.OrderByListBuilder<CelebrationSeenTable>? orderByList,
    CelebrationSeenInclude? include,
  }) {
    return CelebrationSeenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CelebrationSeen.t),
      orderByList: orderByList?.call(CelebrationSeen.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CelebrationSeenImpl extends CelebrationSeen {
  _CelebrationSeenImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String milestoneKey,
    DateTime? seenAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         milestoneKey: milestoneKey,
         seenAt: seenAt,
       );

  /// Returns a shallow copy of this [CelebrationSeen]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CelebrationSeen copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    String? milestoneKey,
    DateTime? seenAt,
  }) {
    return CelebrationSeen(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      milestoneKey: milestoneKey ?? this.milestoneKey,
      seenAt: seenAt ?? this.seenAt,
    );
  }
}

class CelebrationSeenUpdateTable extends _is.UpdateTable<CelebrationSeenTable> {
  CelebrationSeenUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> milestoneKey(String value) => _is.ColumnValue(
    table.milestoneKey,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> seenAt(DateTime value) => _is.ColumnValue(
    table.seenAt,
    value,
  );
}

class CelebrationSeenTable extends _is.Table<_is.UuidValue?> {
  CelebrationSeenTable({super.tableRelation})
    : super(tableName: 'celebration_seen') {
    updateTable = CelebrationSeenUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    milestoneKey = _is.ColumnString(
      'milestoneKey',
      this,
    );
    seenAt = _is.ColumnDateTime(
      'seenAt',
      this,
      hasDefault: true,
    );
  }

  late final CelebrationSeenUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnString milestoneKey;

  late final _is.ColumnDateTime seenAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    milestoneKey,
    seenAt,
  ];
}

class CelebrationSeenInclude extends _is.IncludeObject {
  CelebrationSeenInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => CelebrationSeen.t;
}

class CelebrationSeenIncludeList extends _is.IncludeList {
  CelebrationSeenIncludeList._({
    _is.WhereExpressionBuilder<CelebrationSeenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CelebrationSeen.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CelebrationSeen.t;
}

class CelebrationSeenRepository {
  const CelebrationSeenRepository._();

  /// Returns a list of [CelebrationSeen]s matching the given query parameters.
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
  Future<List<CelebrationSeen>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CelebrationSeenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CelebrationSeenTable>? orderBy,
    _is.OrderByListBuilder<CelebrationSeenTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CelebrationSeen>(
      where: where?.call(CelebrationSeen.t),
      orderBy: orderBy?.call(CelebrationSeen.t),
      orderByList: orderByList?.call(CelebrationSeen.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CelebrationSeen] matching the given query parameters.
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
  Future<CelebrationSeen?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CelebrationSeenTable>? where,
    int? offset,
    _is.OrderByBuilder<CelebrationSeenTable>? orderBy,
    _is.OrderByListBuilder<CelebrationSeenTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CelebrationSeen>(
      where: where?.call(CelebrationSeen.t),
      orderBy: orderBy?.call(CelebrationSeen.t),
      orderByList: orderByList?.call(CelebrationSeen.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CelebrationSeen] by its [id] or null if no such row exists.
  Future<CelebrationSeen?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CelebrationSeen>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CelebrationSeen]s in the list and returns the inserted rows.
  ///
  /// The returned [CelebrationSeen]s will have their `id` fields set.
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
  Future<List<CelebrationSeen>> insert(
    _is.DatabaseSession session,
    List<CelebrationSeen> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CelebrationSeen>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CelebrationSeen] and returns the inserted row.
  ///
  /// The returned [CelebrationSeen] will have its `id` field set.
  Future<CelebrationSeen> insertRow(
    _is.DatabaseSession session,
    CelebrationSeen row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CelebrationSeen>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CelebrationSeen]s in the list and returns the resulting rows.
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
  /// The returned [CelebrationSeen]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CelebrationSeen>> upsert(
    _is.DatabaseSession session,
    List<CelebrationSeen> rows, {
    required _is.ColumnSelections<CelebrationSeenTable> conflictColumns,
    _is.ColumnSelections<CelebrationSeenTable>? updateColumns,
    _is.WhereExpressionBuilder<CelebrationSeenTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CelebrationSeen>(
      rows,
      conflictColumns: conflictColumns(CelebrationSeen.t),
      updateColumns: updateColumns?.call(CelebrationSeen.t),
      updateWhere: updateWhere?.call(CelebrationSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CelebrationSeen] and returns the resulting row.
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
  /// The returned [CelebrationSeen] will have its `id` field set.
  Future<CelebrationSeen?> upsertRow(
    _is.DatabaseSession session,
    CelebrationSeen row, {
    required _is.ColumnSelections<CelebrationSeenTable> conflictColumns,
    _is.ColumnSelections<CelebrationSeenTable>? updateColumns,
    _is.WhereExpressionBuilder<CelebrationSeenTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CelebrationSeen>(
      row,
      conflictColumns: conflictColumns(CelebrationSeen.t),
      updateColumns: updateColumns?.call(CelebrationSeen.t),
      updateWhere: updateWhere?.call(CelebrationSeen.t),
      transaction: transaction,
    );
  }

  /// Updates all [CelebrationSeen]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CelebrationSeen>> update(
    _is.DatabaseSession session,
    List<CelebrationSeen> rows, {
    _is.ColumnSelections<CelebrationSeenTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CelebrationSeen>(
      rows,
      columns: columns?.call(CelebrationSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CelebrationSeen]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CelebrationSeen> updateRow(
    _is.DatabaseSession session,
    CelebrationSeen row, {
    _is.ColumnSelections<CelebrationSeenTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CelebrationSeen>(
      row,
      columns: columns?.call(CelebrationSeen.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CelebrationSeen] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CelebrationSeen?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CelebrationSeenUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CelebrationSeen>(
      id,
      columnValues: columnValues(CelebrationSeen.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CelebrationSeen]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CelebrationSeen>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CelebrationSeenUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CelebrationSeenTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CelebrationSeenTable>? orderBy,
    _is.OrderByListBuilder<CelebrationSeenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CelebrationSeen>(
      columnValues: columnValues(CelebrationSeen.t.updateTable),
      where: where(CelebrationSeen.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CelebrationSeen.t),
      orderByList: orderByList?.call(CelebrationSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CelebrationSeen]s in the list and returns the deleted rows.
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
  Future<List<CelebrationSeen>> delete(
    _is.DatabaseSession session,
    List<CelebrationSeen> rows, {
    _is.OrderByBuilder<CelebrationSeenTable>? orderBy,
    _is.OrderByListBuilder<CelebrationSeenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CelebrationSeen>(
      rows,
      orderBy: orderBy?.call(CelebrationSeen.t),
      orderByList: orderByList?.call(CelebrationSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CelebrationSeen].
  Future<CelebrationSeen> deleteRow(
    _is.DatabaseSession session,
    CelebrationSeen row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CelebrationSeen>(
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
  Future<List<CelebrationSeen>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CelebrationSeenTable> where,
    _is.OrderByBuilder<CelebrationSeenTable>? orderBy,
    _is.OrderByListBuilder<CelebrationSeenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CelebrationSeen>(
      where: where(CelebrationSeen.t),
      orderBy: orderBy?.call(CelebrationSeen.t),
      orderByList: orderByList?.call(CelebrationSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CelebrationSeenTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CelebrationSeen>(
      where: where?.call(CelebrationSeen.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CelebrationSeen] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CelebrationSeenTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CelebrationSeen>(
      where: where(CelebrationSeen.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
