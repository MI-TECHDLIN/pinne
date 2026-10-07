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

/// A delivery-ready grouped in-app digest. A later integration may deliver it
/// as push; this worker only records the durable, deduplicated message.
abstract class ReviewDigest
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ReviewDigest._({
    this.id,
    required this.ownerId,
    required this.digestKey,
    required this.localDate,
    required this.body,
    required this.itemCount,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ReviewDigest({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String digestKey,
    required String localDate,
    required String body,
    required int itemCount,
    DateTime? createdAt,
  }) = _ReviewDigestImpl;

  factory ReviewDigest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewDigest(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      digestKey: jsonSerialization['digestKey'] as String,
      localDate: jsonSerialization['localDate'] as String,
      body: jsonSerialization['body'] as String,
      itemCount: jsonSerialization['itemCount'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ReviewDigestTable();

  static const db = ReviewDigestRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  String digestKey;

  String localDate;

  String body;

  int itemCount;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ReviewDigest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReviewDigest copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    String? digestKey,
    String? localDate,
    String? body,
    int? itemCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewDigest',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'digestKey': digestKey,
      'localDate': localDate,
      'body': body,
      'itemCount': itemCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewDigest',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'digestKey': digestKey,
      'localDate': localDate,
      'body': body,
      'itemCount': itemCount,
      'createdAt': createdAt.toJson(),
    };
  }

  static ReviewDigestInclude include() {
    return ReviewDigestInclude._();
  }

  static ReviewDigestIncludeList includeList({
    _is.WhereExpressionBuilder<ReviewDigestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewDigestTable>? orderBy,
    _is.OrderByListBuilder<ReviewDigestTable>? orderByList,
    ReviewDigestInclude? include,
  }) {
    return ReviewDigestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewDigest.t),
      orderByList: orderByList?.call(ReviewDigest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewDigestImpl extends ReviewDigest {
  _ReviewDigestImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String digestKey,
    required String localDate,
    required String body,
    required int itemCount,
    DateTime? createdAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         digestKey: digestKey,
         localDate: localDate,
         body: body,
         itemCount: itemCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReviewDigest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReviewDigest copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    String? digestKey,
    String? localDate,
    String? body,
    int? itemCount,
    DateTime? createdAt,
  }) {
    return ReviewDigest(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      digestKey: digestKey ?? this.digestKey,
      localDate: localDate ?? this.localDate,
      body: body ?? this.body,
      itemCount: itemCount ?? this.itemCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReviewDigestUpdateTable extends _is.UpdateTable<ReviewDigestTable> {
  ReviewDigestUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> digestKey(String value) => _is.ColumnValue(
    table.digestKey,
    value,
  );

  _is.ColumnValue<String, String> localDate(String value) => _is.ColumnValue(
    table.localDate,
    value,
  );

  _is.ColumnValue<String, String> body(String value) => _is.ColumnValue(
    table.body,
    value,
  );

  _is.ColumnValue<int, int> itemCount(int value) => _is.ColumnValue(
    table.itemCount,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ReviewDigestTable extends _is.Table<_is.UuidValue?> {
  ReviewDigestTable({super.tableRelation}) : super(tableName: 'review_digest') {
    updateTable = ReviewDigestUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    digestKey = _is.ColumnString(
      'digestKey',
      this,
    );
    localDate = _is.ColumnString(
      'localDate',
      this,
    );
    body = _is.ColumnString(
      'body',
      this,
    );
    itemCount = _is.ColumnInt(
      'itemCount',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ReviewDigestUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnString digestKey;

  late final _is.ColumnString localDate;

  late final _is.ColumnString body;

  late final _is.ColumnInt itemCount;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    digestKey,
    localDate,
    body,
    itemCount,
    createdAt,
  ];
}

class ReviewDigestInclude extends _is.IncludeObject {
  ReviewDigestInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ReviewDigest.t;
}

class ReviewDigestIncludeList extends _is.IncludeList {
  ReviewDigestIncludeList._({
    _is.WhereExpressionBuilder<ReviewDigestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReviewDigest.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ReviewDigest.t;
}

class ReviewDigestRepository {
  const ReviewDigestRepository._();

  /// Returns a list of [ReviewDigest]s matching the given query parameters.
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
  Future<List<ReviewDigest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewDigestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewDigestTable>? orderBy,
    _is.OrderByListBuilder<ReviewDigestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReviewDigest>(
      where: where?.call(ReviewDigest.t),
      orderBy: orderBy?.call(ReviewDigest.t),
      orderByList: orderByList?.call(ReviewDigest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReviewDigest] matching the given query parameters.
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
  Future<ReviewDigest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewDigestTable>? where,
    int? offset,
    _is.OrderByBuilder<ReviewDigestTable>? orderBy,
    _is.OrderByListBuilder<ReviewDigestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReviewDigest>(
      where: where?.call(ReviewDigest.t),
      orderBy: orderBy?.call(ReviewDigest.t),
      orderByList: orderByList?.call(ReviewDigest.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReviewDigest] by its [id] or null if no such row exists.
  Future<ReviewDigest?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReviewDigest>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReviewDigest]s in the list and returns the inserted rows.
  ///
  /// The returned [ReviewDigest]s will have their `id` fields set.
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
  Future<List<ReviewDigest>> insert(
    _is.DatabaseSession session,
    List<ReviewDigest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReviewDigest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReviewDigest] and returns the inserted row.
  ///
  /// The returned [ReviewDigest] will have its `id` field set.
  Future<ReviewDigest> insertRow(
    _is.DatabaseSession session,
    ReviewDigest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReviewDigest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReviewDigest]s in the list and returns the resulting rows.
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
  /// The returned [ReviewDigest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewDigest>> upsert(
    _is.DatabaseSession session,
    List<ReviewDigest> rows, {
    required _is.ColumnSelections<ReviewDigestTable> conflictColumns,
    _is.ColumnSelections<ReviewDigestTable>? updateColumns,
    _is.WhereExpressionBuilder<ReviewDigestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReviewDigest>(
      rows,
      conflictColumns: conflictColumns(ReviewDigest.t),
      updateColumns: updateColumns?.call(ReviewDigest.t),
      updateWhere: updateWhere?.call(ReviewDigest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReviewDigest] and returns the resulting row.
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
  /// The returned [ReviewDigest] will have its `id` field set.
  Future<ReviewDigest?> upsertRow(
    _is.DatabaseSession session,
    ReviewDigest row, {
    required _is.ColumnSelections<ReviewDigestTable> conflictColumns,
    _is.ColumnSelections<ReviewDigestTable>? updateColumns,
    _is.WhereExpressionBuilder<ReviewDigestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReviewDigest>(
      row,
      conflictColumns: conflictColumns(ReviewDigest.t),
      updateColumns: updateColumns?.call(ReviewDigest.t),
      updateWhere: updateWhere?.call(ReviewDigest.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewDigest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewDigest>> update(
    _is.DatabaseSession session,
    List<ReviewDigest> rows, {
    _is.ColumnSelections<ReviewDigestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReviewDigest>(
      rows,
      columns: columns?.call(ReviewDigest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReviewDigest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReviewDigest> updateRow(
    _is.DatabaseSession session,
    ReviewDigest row, {
    _is.ColumnSelections<ReviewDigestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReviewDigest>(
      row,
      columns: columns?.call(ReviewDigest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReviewDigest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReviewDigest?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ReviewDigestUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReviewDigest>(
      id,
      columnValues: columnValues(ReviewDigest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewDigest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewDigest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReviewDigestUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ReviewDigestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewDigestTable>? orderBy,
    _is.OrderByListBuilder<ReviewDigestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReviewDigest>(
      columnValues: columnValues(ReviewDigest.t.updateTable),
      where: where(ReviewDigest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewDigest.t),
      orderByList: orderByList?.call(ReviewDigest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReviewDigest]s in the list and returns the deleted rows.
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
  Future<List<ReviewDigest>> delete(
    _is.DatabaseSession session,
    List<ReviewDigest> rows, {
    _is.OrderByBuilder<ReviewDigestTable>? orderBy,
    _is.OrderByListBuilder<ReviewDigestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReviewDigest>(
      rows,
      orderBy: orderBy?.call(ReviewDigest.t),
      orderByList: orderByList?.call(ReviewDigest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReviewDigest].
  Future<ReviewDigest> deleteRow(
    _is.DatabaseSession session,
    ReviewDigest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReviewDigest>(
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
  Future<List<ReviewDigest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReviewDigestTable> where,
    _is.OrderByBuilder<ReviewDigestTable>? orderBy,
    _is.OrderByListBuilder<ReviewDigestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReviewDigest>(
      where: where(ReviewDigest.t),
      orderBy: orderBy?.call(ReviewDigest.t),
      orderByList: orderByList?.call(ReviewDigest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewDigestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReviewDigest>(
      where: where?.call(ReviewDigest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReviewDigest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReviewDigestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReviewDigest>(
      where: where(ReviewDigest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
