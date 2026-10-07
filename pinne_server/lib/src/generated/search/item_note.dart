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

/// User-authored notes are searchable independently of enrichment text.
abstract class ItemNote
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ItemNote._({
    this.id,
    required this.ownerId,
    required this.itemId,
    required this.body,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ItemNote({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    required String body,
    DateTime? createdAt,
  }) = _ItemNoteImpl;

  factory ItemNote.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemNote(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      body: jsonSerialization['body'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ItemNoteTable();

  static const db = ItemNoteRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue itemId;

  String body;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ItemNote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ItemNote copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    String? body,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemNote',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'body': body,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemNote',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'body': body,
      'createdAt': createdAt.toJson(),
    };
  }

  static ItemNoteInclude include() {
    return ItemNoteInclude._();
  }

  static ItemNoteIncludeList includeList({
    _is.WhereExpressionBuilder<ItemNoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemNoteTable>? orderBy,
    _is.OrderByListBuilder<ItemNoteTable>? orderByList,
    ItemNoteInclude? include,
  }) {
    return ItemNoteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemNote.t),
      orderByList: orderByList?.call(ItemNote.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemNoteImpl extends ItemNote {
  _ItemNoteImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    required String body,
    DateTime? createdAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         body: body,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ItemNote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ItemNote copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    String? body,
    DateTime? createdAt,
  }) {
    return ItemNote(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ItemNoteUpdateTable extends _is.UpdateTable<ItemNoteTable> {
  ItemNoteUpdateTable(super.table);

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

  _is.ColumnValue<String, String> body(String value) => _is.ColumnValue(
    table.body,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ItemNoteTable extends _is.Table<_is.UuidValue?> {
  ItemNoteTable({super.tableRelation}) : super(tableName: 'item_note') {
    updateTable = ItemNoteUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    itemId = _is.ColumnUuid(
      'itemId',
      this,
    );
    body = _is.ColumnString(
      'body',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ItemNoteUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid itemId;

  late final _is.ColumnString body;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    itemId,
    body,
    createdAt,
  ];
}

class ItemNoteInclude extends _is.IncludeObject {
  ItemNoteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ItemNote.t;
}

class ItemNoteIncludeList extends _is.IncludeList {
  ItemNoteIncludeList._({
    _is.WhereExpressionBuilder<ItemNoteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ItemNote.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ItemNote.t;
}

class ItemNoteRepository {
  const ItemNoteRepository._();

  /// Returns a list of [ItemNote]s matching the given query parameters.
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
  Future<List<ItemNote>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemNoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemNoteTable>? orderBy,
    _is.OrderByListBuilder<ItemNoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ItemNote>(
      where: where?.call(ItemNote.t),
      orderBy: orderBy?.call(ItemNote.t),
      orderByList: orderByList?.call(ItemNote.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ItemNote] matching the given query parameters.
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
  Future<ItemNote?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemNoteTable>? where,
    int? offset,
    _is.OrderByBuilder<ItemNoteTable>? orderBy,
    _is.OrderByListBuilder<ItemNoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ItemNote>(
      where: where?.call(ItemNote.t),
      orderBy: orderBy?.call(ItemNote.t),
      orderByList: orderByList?.call(ItemNote.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ItemNote] by its [id] or null if no such row exists.
  Future<ItemNote?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ItemNote>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ItemNote]s in the list and returns the inserted rows.
  ///
  /// The returned [ItemNote]s will have their `id` fields set.
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
  Future<List<ItemNote>> insert(
    _is.DatabaseSession session,
    List<ItemNote> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ItemNote>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ItemNote] and returns the inserted row.
  ///
  /// The returned [ItemNote] will have its `id` field set.
  Future<ItemNote> insertRow(
    _is.DatabaseSession session,
    ItemNote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ItemNote>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ItemNote]s in the list and returns the resulting rows.
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
  /// The returned [ItemNote]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemNote>> upsert(
    _is.DatabaseSession session,
    List<ItemNote> rows, {
    required _is.ColumnSelections<ItemNoteTable> conflictColumns,
    _is.ColumnSelections<ItemNoteTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemNoteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ItemNote>(
      rows,
      conflictColumns: conflictColumns(ItemNote.t),
      updateColumns: updateColumns?.call(ItemNote.t),
      updateWhere: updateWhere?.call(ItemNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ItemNote] and returns the resulting row.
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
  /// The returned [ItemNote] will have its `id` field set.
  Future<ItemNote?> upsertRow(
    _is.DatabaseSession session,
    ItemNote row, {
    required _is.ColumnSelections<ItemNoteTable> conflictColumns,
    _is.ColumnSelections<ItemNoteTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemNoteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ItemNote>(
      row,
      conflictColumns: conflictColumns(ItemNote.t),
      updateColumns: updateColumns?.call(ItemNote.t),
      updateWhere: updateWhere?.call(ItemNote.t),
      transaction: transaction,
    );
  }

  /// Updates all [ItemNote]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemNote>> update(
    _is.DatabaseSession session,
    List<ItemNote> rows, {
    _is.ColumnSelections<ItemNoteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ItemNote>(
      rows,
      columns: columns?.call(ItemNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ItemNote]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ItemNote> updateRow(
    _is.DatabaseSession session,
    ItemNote row, {
    _is.ColumnSelections<ItemNoteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ItemNote>(
      row,
      columns: columns?.call(ItemNote.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ItemNote] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ItemNote?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ItemNoteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ItemNote>(
      id,
      columnValues: columnValues(ItemNote.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ItemNote]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemNote>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ItemNoteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ItemNoteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemNoteTable>? orderBy,
    _is.OrderByListBuilder<ItemNoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ItemNote>(
      columnValues: columnValues(ItemNote.t.updateTable),
      where: where(ItemNote.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemNote.t),
      orderByList: orderByList?.call(ItemNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ItemNote]s in the list and returns the deleted rows.
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
  Future<List<ItemNote>> delete(
    _is.DatabaseSession session,
    List<ItemNote> rows, {
    _is.OrderByBuilder<ItemNoteTable>? orderBy,
    _is.OrderByListBuilder<ItemNoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ItemNote>(
      rows,
      orderBy: orderBy?.call(ItemNote.t),
      orderByList: orderByList?.call(ItemNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ItemNote].
  Future<ItemNote> deleteRow(
    _is.DatabaseSession session,
    ItemNote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ItemNote>(
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
  Future<List<ItemNote>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemNoteTable> where,
    _is.OrderByBuilder<ItemNoteTable>? orderBy,
    _is.OrderByListBuilder<ItemNoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ItemNote>(
      where: where(ItemNote.t),
      orderBy: orderBy?.call(ItemNote.t),
      orderByList: orderByList?.call(ItemNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemNoteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ItemNote>(
      where: where?.call(ItemNote.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ItemNote] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemNoteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ItemNote>(
      where: where(ItemNote.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
