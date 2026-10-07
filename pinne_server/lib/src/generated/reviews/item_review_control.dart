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

/// Item-specific reminder controls. Snooze and pause override broader rules.
abstract class ItemReviewControl
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ItemReviewControl._({
    this.id,
    required this.ownerId,
    required this.itemId,
    this.snoozedUntil,
    bool? remindersPaused,
    this.lastDismissedAt,
  }) : remindersPaused = remindersPaused ?? false;

  factory ItemReviewControl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    DateTime? snoozedUntil,
    bool? remindersPaused,
    DateTime? lastDismissedAt,
  }) = _ItemReviewControlImpl;

  factory ItemReviewControl.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemReviewControl(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      snoozedUntil: jsonSerialization['snoozedUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['snoozedUntil'],
            ),
      remindersPaused: jsonSerialization['remindersPaused'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['remindersPaused'],
            ),
      lastDismissedAt: jsonSerialization['lastDismissedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastDismissedAt'],
            ),
    );
  }

  static final t = ItemReviewControlTable();

  static const db = ItemReviewControlRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue itemId;

  DateTime? snoozedUntil;

  bool remindersPaused;

  DateTime? lastDismissedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ItemReviewControl]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ItemReviewControl copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    DateTime? snoozedUntil,
    bool? remindersPaused,
    DateTime? lastDismissedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemReviewControl',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      if (snoozedUntil != null) 'snoozedUntil': snoozedUntil?.toJson(),
      'remindersPaused': remindersPaused,
      if (lastDismissedAt != null) 'lastDismissedAt': lastDismissedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemReviewControl',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      if (snoozedUntil != null) 'snoozedUntil': snoozedUntil?.toJson(),
      'remindersPaused': remindersPaused,
      if (lastDismissedAt != null) 'lastDismissedAt': lastDismissedAt?.toJson(),
    };
  }

  static ItemReviewControlInclude include() {
    return ItemReviewControlInclude._();
  }

  static ItemReviewControlIncludeList includeList({
    _is.WhereExpressionBuilder<ItemReviewControlTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemReviewControlTable>? orderBy,
    _is.OrderByListBuilder<ItemReviewControlTable>? orderByList,
    ItemReviewControlInclude? include,
  }) {
    return ItemReviewControlIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemReviewControl.t),
      orderByList: orderByList?.call(ItemReviewControl.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemReviewControlImpl extends ItemReviewControl {
  _ItemReviewControlImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    DateTime? snoozedUntil,
    bool? remindersPaused,
    DateTime? lastDismissedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         snoozedUntil: snoozedUntil,
         remindersPaused: remindersPaused,
         lastDismissedAt: lastDismissedAt,
       );

  /// Returns a shallow copy of this [ItemReviewControl]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ItemReviewControl copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    Object? snoozedUntil = _Undefined,
    bool? remindersPaused,
    Object? lastDismissedAt = _Undefined,
  }) {
    return ItemReviewControl(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      snoozedUntil: snoozedUntil is DateTime?
          ? snoozedUntil
          : this.snoozedUntil,
      remindersPaused: remindersPaused ?? this.remindersPaused,
      lastDismissedAt: lastDismissedAt is DateTime?
          ? lastDismissedAt
          : this.lastDismissedAt,
    );
  }
}

class ItemReviewControlUpdateTable
    extends _is.UpdateTable<ItemReviewControlTable> {
  ItemReviewControlUpdateTable(super.table);

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

  _is.ColumnValue<DateTime, DateTime> snoozedUntil(DateTime? value) =>
      _is.ColumnValue(
        table.snoozedUntil,
        value,
      );

  _is.ColumnValue<bool, bool> remindersPaused(bool value) => _is.ColumnValue(
    table.remindersPaused,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastDismissedAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastDismissedAt,
        value,
      );
}

class ItemReviewControlTable extends _is.Table<_is.UuidValue?> {
  ItemReviewControlTable({super.tableRelation})
    : super(tableName: 'item_review_control') {
    updateTable = ItemReviewControlUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    itemId = _is.ColumnUuid(
      'itemId',
      this,
    );
    snoozedUntil = _is.ColumnDateTime(
      'snoozedUntil',
      this,
    );
    remindersPaused = _is.ColumnBool(
      'remindersPaused',
      this,
      hasDefault: true,
    );
    lastDismissedAt = _is.ColumnDateTime(
      'lastDismissedAt',
      this,
    );
  }

  late final ItemReviewControlUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid itemId;

  late final _is.ColumnDateTime snoozedUntil;

  late final _is.ColumnBool remindersPaused;

  late final _is.ColumnDateTime lastDismissedAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    itemId,
    snoozedUntil,
    remindersPaused,
    lastDismissedAt,
  ];
}

class ItemReviewControlInclude extends _is.IncludeObject {
  ItemReviewControlInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ItemReviewControl.t;
}

class ItemReviewControlIncludeList extends _is.IncludeList {
  ItemReviewControlIncludeList._({
    _is.WhereExpressionBuilder<ItemReviewControlTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ItemReviewControl.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ItemReviewControl.t;
}

class ItemReviewControlRepository {
  const ItemReviewControlRepository._();

  /// Returns a list of [ItemReviewControl]s matching the given query parameters.
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
  Future<List<ItemReviewControl>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemReviewControlTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemReviewControlTable>? orderBy,
    _is.OrderByListBuilder<ItemReviewControlTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ItemReviewControl>(
      where: where?.call(ItemReviewControl.t),
      orderBy: orderBy?.call(ItemReviewControl.t),
      orderByList: orderByList?.call(ItemReviewControl.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ItemReviewControl] matching the given query parameters.
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
  Future<ItemReviewControl?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemReviewControlTable>? where,
    int? offset,
    _is.OrderByBuilder<ItemReviewControlTable>? orderBy,
    _is.OrderByListBuilder<ItemReviewControlTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ItemReviewControl>(
      where: where?.call(ItemReviewControl.t),
      orderBy: orderBy?.call(ItemReviewControl.t),
      orderByList: orderByList?.call(ItemReviewControl.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ItemReviewControl] by its [id] or null if no such row exists.
  Future<ItemReviewControl?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ItemReviewControl>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ItemReviewControl]s in the list and returns the inserted rows.
  ///
  /// The returned [ItemReviewControl]s will have their `id` fields set.
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
  Future<List<ItemReviewControl>> insert(
    _is.DatabaseSession session,
    List<ItemReviewControl> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ItemReviewControl>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ItemReviewControl] and returns the inserted row.
  ///
  /// The returned [ItemReviewControl] will have its `id` field set.
  Future<ItemReviewControl> insertRow(
    _is.DatabaseSession session,
    ItemReviewControl row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ItemReviewControl>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ItemReviewControl]s in the list and returns the resulting rows.
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
  /// The returned [ItemReviewControl]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemReviewControl>> upsert(
    _is.DatabaseSession session,
    List<ItemReviewControl> rows, {
    required _is.ColumnSelections<ItemReviewControlTable> conflictColumns,
    _is.ColumnSelections<ItemReviewControlTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemReviewControlTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ItemReviewControl>(
      rows,
      conflictColumns: conflictColumns(ItemReviewControl.t),
      updateColumns: updateColumns?.call(ItemReviewControl.t),
      updateWhere: updateWhere?.call(ItemReviewControl.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ItemReviewControl] and returns the resulting row.
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
  /// The returned [ItemReviewControl] will have its `id` field set.
  Future<ItemReviewControl?> upsertRow(
    _is.DatabaseSession session,
    ItemReviewControl row, {
    required _is.ColumnSelections<ItemReviewControlTable> conflictColumns,
    _is.ColumnSelections<ItemReviewControlTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemReviewControlTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ItemReviewControl>(
      row,
      conflictColumns: conflictColumns(ItemReviewControl.t),
      updateColumns: updateColumns?.call(ItemReviewControl.t),
      updateWhere: updateWhere?.call(ItemReviewControl.t),
      transaction: transaction,
    );
  }

  /// Updates all [ItemReviewControl]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemReviewControl>> update(
    _is.DatabaseSession session,
    List<ItemReviewControl> rows, {
    _is.ColumnSelections<ItemReviewControlTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ItemReviewControl>(
      rows,
      columns: columns?.call(ItemReviewControl.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ItemReviewControl]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ItemReviewControl> updateRow(
    _is.DatabaseSession session,
    ItemReviewControl row, {
    _is.ColumnSelections<ItemReviewControlTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ItemReviewControl>(
      row,
      columns: columns?.call(ItemReviewControl.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ItemReviewControl] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ItemReviewControl?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ItemReviewControlUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ItemReviewControl>(
      id,
      columnValues: columnValues(ItemReviewControl.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ItemReviewControl]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemReviewControl>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ItemReviewControlUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ItemReviewControlTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemReviewControlTable>? orderBy,
    _is.OrderByListBuilder<ItemReviewControlTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ItemReviewControl>(
      columnValues: columnValues(ItemReviewControl.t.updateTable),
      where: where(ItemReviewControl.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemReviewControl.t),
      orderByList: orderByList?.call(ItemReviewControl.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ItemReviewControl]s in the list and returns the deleted rows.
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
  Future<List<ItemReviewControl>> delete(
    _is.DatabaseSession session,
    List<ItemReviewControl> rows, {
    _is.OrderByBuilder<ItemReviewControlTable>? orderBy,
    _is.OrderByListBuilder<ItemReviewControlTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ItemReviewControl>(
      rows,
      orderBy: orderBy?.call(ItemReviewControl.t),
      orderByList: orderByList?.call(ItemReviewControl.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ItemReviewControl].
  Future<ItemReviewControl> deleteRow(
    _is.DatabaseSession session,
    ItemReviewControl row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ItemReviewControl>(
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
  Future<List<ItemReviewControl>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemReviewControlTable> where,
    _is.OrderByBuilder<ItemReviewControlTable>? orderBy,
    _is.OrderByListBuilder<ItemReviewControlTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ItemReviewControl>(
      where: where(ItemReviewControl.t),
      orderBy: orderBy?.call(ItemReviewControl.t),
      orderByList: orderByList?.call(ItemReviewControl.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemReviewControlTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ItemReviewControl>(
      where: where?.call(ItemReviewControl.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ItemReviewControl] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemReviewControlTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ItemReviewControl>(
      where: where(ItemReviewControl.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
