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

/// The stored outcome of one capture operation, so a retried operation gets
/// the same answer even when it matched a duplicate and created no item.
abstract class CaptureReceipt
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CaptureReceipt._({
    this.id,
    required this.ownerId,
    required this.operationId,
    required this.clientItemId,
    required this.itemId,
    required this.requestHash,
    required this.duplicate,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  factory CaptureReceipt({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue operationId,
    required _is.UuidValue clientItemId,
    required _is.UuidValue itemId,
    required String requestHash,
    required bool duplicate,
    DateTime? receivedAt,
  }) = _CaptureReceiptImpl;

  factory CaptureReceipt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaptureReceipt(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      operationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['operationId'],
      ),
      clientItemId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clientItemId'],
      ),
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      requestHash: jsonSerialization['requestHash'] as String,
      duplicate: _is.BoolJsonExtension.fromJson(jsonSerialization['duplicate']),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
    );
  }

  static final t = CaptureReceiptTable();

  static const db = CaptureReceiptRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue operationId;

  _is.UuidValue clientItemId;

  _is.UuidValue itemId;

  /// Hash of the capture payload. The same operation id with a different
  /// payload is refused.
  String requestHash;

  bool duplicate;

  DateTime receivedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CaptureReceipt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CaptureReceipt copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? operationId,
    _is.UuidValue? clientItemId,
    _is.UuidValue? itemId,
    String? requestHash,
    bool? duplicate,
    DateTime? receivedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CaptureReceipt',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'operationId': operationId.toJson(),
      'clientItemId': clientItemId.toJson(),
      'itemId': itemId.toJson(),
      'requestHash': requestHash,
      'duplicate': duplicate,
      'receivedAt': receivedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CaptureReceiptInclude include() {
    return CaptureReceiptInclude._();
  }

  static CaptureReceiptIncludeList includeList({
    _is.WhereExpressionBuilder<CaptureReceiptTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaptureReceiptTable>? orderBy,
    _is.OrderByListBuilder<CaptureReceiptTable>? orderByList,
    CaptureReceiptInclude? include,
  }) {
    return CaptureReceiptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaptureReceipt.t),
      orderByList: orderByList?.call(CaptureReceipt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaptureReceiptImpl extends CaptureReceipt {
  _CaptureReceiptImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue operationId,
    required _is.UuidValue clientItemId,
    required _is.UuidValue itemId,
    required String requestHash,
    required bool duplicate,
    DateTime? receivedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         operationId: operationId,
         clientItemId: clientItemId,
         itemId: itemId,
         requestHash: requestHash,
         duplicate: duplicate,
         receivedAt: receivedAt,
       );

  /// Returns a shallow copy of this [CaptureReceipt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CaptureReceipt copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? operationId,
    _is.UuidValue? clientItemId,
    _is.UuidValue? itemId,
    String? requestHash,
    bool? duplicate,
    DateTime? receivedAt,
  }) {
    return CaptureReceipt(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      operationId: operationId ?? this.operationId,
      clientItemId: clientItemId ?? this.clientItemId,
      itemId: itemId ?? this.itemId,
      requestHash: requestHash ?? this.requestHash,
      duplicate: duplicate ?? this.duplicate,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }
}

class CaptureReceiptUpdateTable extends _is.UpdateTable<CaptureReceiptTable> {
  CaptureReceiptUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> operationId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.operationId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clientItemId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.clientItemId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> itemId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.itemId,
        value,
      );

  _is.ColumnValue<String, String> requestHash(String value) => _is.ColumnValue(
    table.requestHash,
    value,
  );

  _is.ColumnValue<bool, bool> duplicate(bool value) => _is.ColumnValue(
    table.duplicate,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> receivedAt(DateTime value) =>
      _is.ColumnValue(
        table.receivedAt,
        value,
      );
}

class CaptureReceiptTable extends _is.Table<_is.UuidValue?> {
  CaptureReceiptTable({super.tableRelation})
    : super(tableName: 'capture_receipt') {
    updateTable = CaptureReceiptUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    operationId = _is.ColumnUuid(
      'operationId',
      this,
    );
    clientItemId = _is.ColumnUuid(
      'clientItemId',
      this,
    );
    itemId = _is.ColumnUuid(
      'itemId',
      this,
    );
    requestHash = _is.ColumnString(
      'requestHash',
      this,
    );
    duplicate = _is.ColumnBool(
      'duplicate',
      this,
    );
    receivedAt = _is.ColumnDateTime(
      'receivedAt',
      this,
      hasDefault: true,
    );
  }

  late final CaptureReceiptUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid operationId;

  late final _is.ColumnUuid clientItemId;

  late final _is.ColumnUuid itemId;

  /// Hash of the capture payload. The same operation id with a different
  /// payload is refused.
  late final _is.ColumnString requestHash;

  late final _is.ColumnBool duplicate;

  late final _is.ColumnDateTime receivedAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    operationId,
    clientItemId,
    itemId,
    requestHash,
    duplicate,
    receivedAt,
  ];
}

class CaptureReceiptInclude extends _is.IncludeObject {
  CaptureReceiptInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => CaptureReceipt.t;
}

class CaptureReceiptIncludeList extends _is.IncludeList {
  CaptureReceiptIncludeList._({
    _is.WhereExpressionBuilder<CaptureReceiptTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CaptureReceipt.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CaptureReceipt.t;
}

class CaptureReceiptRepository {
  const CaptureReceiptRepository._();

  /// Returns a list of [CaptureReceipt]s matching the given query parameters.
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
  Future<List<CaptureReceipt>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaptureReceiptTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaptureReceiptTable>? orderBy,
    _is.OrderByListBuilder<CaptureReceiptTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CaptureReceipt>(
      where: where?.call(CaptureReceipt.t),
      orderBy: orderBy?.call(CaptureReceipt.t),
      orderByList: orderByList?.call(CaptureReceipt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CaptureReceipt] matching the given query parameters.
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
  Future<CaptureReceipt?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaptureReceiptTable>? where,
    int? offset,
    _is.OrderByBuilder<CaptureReceiptTable>? orderBy,
    _is.OrderByListBuilder<CaptureReceiptTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CaptureReceipt>(
      where: where?.call(CaptureReceipt.t),
      orderBy: orderBy?.call(CaptureReceipt.t),
      orderByList: orderByList?.call(CaptureReceipt.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CaptureReceipt] by its [id] or null if no such row exists.
  Future<CaptureReceipt?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CaptureReceipt>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CaptureReceipt]s in the list and returns the inserted rows.
  ///
  /// The returned [CaptureReceipt]s will have their `id` fields set.
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
  Future<List<CaptureReceipt>> insert(
    _is.DatabaseSession session,
    List<CaptureReceipt> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CaptureReceipt>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CaptureReceipt] and returns the inserted row.
  ///
  /// The returned [CaptureReceipt] will have its `id` field set.
  Future<CaptureReceipt> insertRow(
    _is.DatabaseSession session,
    CaptureReceipt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CaptureReceipt>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CaptureReceipt]s in the list and returns the resulting rows.
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
  /// The returned [CaptureReceipt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaptureReceipt>> upsert(
    _is.DatabaseSession session,
    List<CaptureReceipt> rows, {
    required _is.ColumnSelections<CaptureReceiptTable> conflictColumns,
    _is.ColumnSelections<CaptureReceiptTable>? updateColumns,
    _is.WhereExpressionBuilder<CaptureReceiptTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CaptureReceipt>(
      rows,
      conflictColumns: conflictColumns(CaptureReceipt.t),
      updateColumns: updateColumns?.call(CaptureReceipt.t),
      updateWhere: updateWhere?.call(CaptureReceipt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CaptureReceipt] and returns the resulting row.
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
  /// The returned [CaptureReceipt] will have its `id` field set.
  Future<CaptureReceipt?> upsertRow(
    _is.DatabaseSession session,
    CaptureReceipt row, {
    required _is.ColumnSelections<CaptureReceiptTable> conflictColumns,
    _is.ColumnSelections<CaptureReceiptTable>? updateColumns,
    _is.WhereExpressionBuilder<CaptureReceiptTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CaptureReceipt>(
      row,
      conflictColumns: conflictColumns(CaptureReceipt.t),
      updateColumns: updateColumns?.call(CaptureReceipt.t),
      updateWhere: updateWhere?.call(CaptureReceipt.t),
      transaction: transaction,
    );
  }

  /// Updates all [CaptureReceipt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaptureReceipt>> update(
    _is.DatabaseSession session,
    List<CaptureReceipt> rows, {
    _is.ColumnSelections<CaptureReceiptTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CaptureReceipt>(
      rows,
      columns: columns?.call(CaptureReceipt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CaptureReceipt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CaptureReceipt> updateRow(
    _is.DatabaseSession session,
    CaptureReceipt row, {
    _is.ColumnSelections<CaptureReceiptTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CaptureReceipt>(
      row,
      columns: columns?.call(CaptureReceipt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CaptureReceipt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CaptureReceipt?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CaptureReceiptUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CaptureReceipt>(
      id,
      columnValues: columnValues(CaptureReceipt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CaptureReceipt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaptureReceipt>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CaptureReceiptUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CaptureReceiptTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaptureReceiptTable>? orderBy,
    _is.OrderByListBuilder<CaptureReceiptTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CaptureReceipt>(
      columnValues: columnValues(CaptureReceipt.t.updateTable),
      where: where(CaptureReceipt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaptureReceipt.t),
      orderByList: orderByList?.call(CaptureReceipt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CaptureReceipt]s in the list and returns the deleted rows.
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
  Future<List<CaptureReceipt>> delete(
    _is.DatabaseSession session,
    List<CaptureReceipt> rows, {
    _is.OrderByBuilder<CaptureReceiptTable>? orderBy,
    _is.OrderByListBuilder<CaptureReceiptTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CaptureReceipt>(
      rows,
      orderBy: orderBy?.call(CaptureReceipt.t),
      orderByList: orderByList?.call(CaptureReceipt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CaptureReceipt].
  Future<CaptureReceipt> deleteRow(
    _is.DatabaseSession session,
    CaptureReceipt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CaptureReceipt>(
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
  Future<List<CaptureReceipt>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CaptureReceiptTable> where,
    _is.OrderByBuilder<CaptureReceiptTable>? orderBy,
    _is.OrderByListBuilder<CaptureReceiptTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CaptureReceipt>(
      where: where(CaptureReceipt.t),
      orderBy: orderBy?.call(CaptureReceipt.t),
      orderByList: orderByList?.call(CaptureReceipt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaptureReceiptTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CaptureReceipt>(
      where: where?.call(CaptureReceipt.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CaptureReceipt] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CaptureReceiptTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CaptureReceipt>(
      where: where(CaptureReceipt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
