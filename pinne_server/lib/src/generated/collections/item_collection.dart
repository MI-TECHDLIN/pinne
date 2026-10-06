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
import '../common/assignment_origin.dart' as _i12d5boj;

/// Membership of an item in a collection. Both ends must share the row owner.
abstract class ItemCollection
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ItemCollection._({
    this.id,
    required this.ownerId,
    required this.itemId,
    required this.collectionId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) : origin = origin ?? _i12d5boj.AssignmentOrigin.manual,
       manuallyLocked = manuallyLocked ?? false;

  factory ItemCollection({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    required _is.UuidValue collectionId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) = _ItemCollectionImpl;

  factory ItemCollection.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemCollection(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      collectionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['collectionId'],
      ),
      origin: jsonSerialization['origin'] == null
          ? null
          : _i12d5boj.AssignmentOrigin.fromJson(
              (jsonSerialization['origin'] as String),
            ),
      manuallyLocked: jsonSerialization['manuallyLocked'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['manuallyLocked']),
    );
  }

  static final t = ItemCollectionTable();

  static const db = ItemCollectionRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue itemId;

  _is.UuidValue collectionId;

  _i12d5boj.AssignmentOrigin origin;

  /// True when the user placed it by hand, so AI must not move it.
  bool manuallyLocked;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ItemCollection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ItemCollection copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    _is.UuidValue? collectionId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemCollection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'collectionId': collectionId.toJson(),
      'origin': origin.toJson(),
      'manuallyLocked': manuallyLocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemCollection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'collectionId': collectionId.toJson(),
      'origin': origin.toJson(),
      'manuallyLocked': manuallyLocked,
    };
  }

  static ItemCollectionInclude include() {
    return ItemCollectionInclude._();
  }

  static ItemCollectionIncludeList includeList({
    _is.WhereExpressionBuilder<ItemCollectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemCollectionTable>? orderBy,
    _is.OrderByListBuilder<ItemCollectionTable>? orderByList,
    ItemCollectionInclude? include,
  }) {
    return ItemCollectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemCollection.t),
      orderByList: orderByList?.call(ItemCollection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemCollectionImpl extends ItemCollection {
  _ItemCollectionImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    required _is.UuidValue collectionId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         collectionId: collectionId,
         origin: origin,
         manuallyLocked: manuallyLocked,
       );

  /// Returns a shallow copy of this [ItemCollection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ItemCollection copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    _is.UuidValue? collectionId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) {
    return ItemCollection(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      collectionId: collectionId ?? this.collectionId,
      origin: origin ?? this.origin,
      manuallyLocked: manuallyLocked ?? this.manuallyLocked,
    );
  }
}

class ItemCollectionUpdateTable extends _is.UpdateTable<ItemCollectionTable> {
  ItemCollectionUpdateTable(super.table);

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

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> collectionId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.collectionId,
    value,
  );

  _is.ColumnValue<_i12d5boj.AssignmentOrigin, _i12d5boj.AssignmentOrigin>
  origin(_i12d5boj.AssignmentOrigin value) => _is.ColumnValue(
    table.origin,
    value,
  );

  _is.ColumnValue<bool, bool> manuallyLocked(bool value) => _is.ColumnValue(
    table.manuallyLocked,
    value,
  );
}

class ItemCollectionTable extends _is.Table<_is.UuidValue?> {
  ItemCollectionTable({super.tableRelation})
    : super(tableName: 'item_collection') {
    updateTable = ItemCollectionUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    itemId = _is.ColumnUuid(
      'itemId',
      this,
    );
    collectionId = _is.ColumnUuid(
      'collectionId',
      this,
    );
    origin = _is.ColumnEnum(
      'origin',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    manuallyLocked = _is.ColumnBool(
      'manuallyLocked',
      this,
      hasDefault: true,
    );
  }

  late final ItemCollectionUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid itemId;

  late final _is.ColumnUuid collectionId;

  late final _is.ColumnEnum<_i12d5boj.AssignmentOrigin> origin;

  /// True when the user placed it by hand, so AI must not move it.
  late final _is.ColumnBool manuallyLocked;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    itemId,
    collectionId,
    origin,
    manuallyLocked,
  ];
}

class ItemCollectionInclude extends _is.IncludeObject {
  ItemCollectionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ItemCollection.t;
}

class ItemCollectionIncludeList extends _is.IncludeList {
  ItemCollectionIncludeList._({
    _is.WhereExpressionBuilder<ItemCollectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ItemCollection.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ItemCollection.t;
}

class ItemCollectionRepository {
  const ItemCollectionRepository._();

  /// Returns a list of [ItemCollection]s matching the given query parameters.
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
  Future<List<ItemCollection>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemCollectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemCollectionTable>? orderBy,
    _is.OrderByListBuilder<ItemCollectionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ItemCollection>(
      where: where?.call(ItemCollection.t),
      orderBy: orderBy?.call(ItemCollection.t),
      orderByList: orderByList?.call(ItemCollection.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ItemCollection] matching the given query parameters.
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
  Future<ItemCollection?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemCollectionTable>? where,
    int? offset,
    _is.OrderByBuilder<ItemCollectionTable>? orderBy,
    _is.OrderByListBuilder<ItemCollectionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ItemCollection>(
      where: where?.call(ItemCollection.t),
      orderBy: orderBy?.call(ItemCollection.t),
      orderByList: orderByList?.call(ItemCollection.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ItemCollection] by its [id] or null if no such row exists.
  Future<ItemCollection?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ItemCollection>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ItemCollection]s in the list and returns the inserted rows.
  ///
  /// The returned [ItemCollection]s will have their `id` fields set.
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
  Future<List<ItemCollection>> insert(
    _is.DatabaseSession session,
    List<ItemCollection> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ItemCollection>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ItemCollection] and returns the inserted row.
  ///
  /// The returned [ItemCollection] will have its `id` field set.
  Future<ItemCollection> insertRow(
    _is.DatabaseSession session,
    ItemCollection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ItemCollection>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ItemCollection]s in the list and returns the resulting rows.
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
  /// The returned [ItemCollection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemCollection>> upsert(
    _is.DatabaseSession session,
    List<ItemCollection> rows, {
    required _is.ColumnSelections<ItemCollectionTable> conflictColumns,
    _is.ColumnSelections<ItemCollectionTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemCollectionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ItemCollection>(
      rows,
      conflictColumns: conflictColumns(ItemCollection.t),
      updateColumns: updateColumns?.call(ItemCollection.t),
      updateWhere: updateWhere?.call(ItemCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ItemCollection] and returns the resulting row.
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
  /// The returned [ItemCollection] will have its `id` field set.
  Future<ItemCollection?> upsertRow(
    _is.DatabaseSession session,
    ItemCollection row, {
    required _is.ColumnSelections<ItemCollectionTable> conflictColumns,
    _is.ColumnSelections<ItemCollectionTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemCollectionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ItemCollection>(
      row,
      conflictColumns: conflictColumns(ItemCollection.t),
      updateColumns: updateColumns?.call(ItemCollection.t),
      updateWhere: updateWhere?.call(ItemCollection.t),
      transaction: transaction,
    );
  }

  /// Updates all [ItemCollection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemCollection>> update(
    _is.DatabaseSession session,
    List<ItemCollection> rows, {
    _is.ColumnSelections<ItemCollectionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ItemCollection>(
      rows,
      columns: columns?.call(ItemCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ItemCollection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ItemCollection> updateRow(
    _is.DatabaseSession session,
    ItemCollection row, {
    _is.ColumnSelections<ItemCollectionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ItemCollection>(
      row,
      columns: columns?.call(ItemCollection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ItemCollection] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ItemCollection?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ItemCollectionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ItemCollection>(
      id,
      columnValues: columnValues(ItemCollection.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ItemCollection]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemCollection>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ItemCollectionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ItemCollectionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemCollectionTable>? orderBy,
    _is.OrderByListBuilder<ItemCollectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ItemCollection>(
      columnValues: columnValues(ItemCollection.t.updateTable),
      where: where(ItemCollection.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemCollection.t),
      orderByList: orderByList?.call(ItemCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ItemCollection]s in the list and returns the deleted rows.
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
  Future<List<ItemCollection>> delete(
    _is.DatabaseSession session,
    List<ItemCollection> rows, {
    _is.OrderByBuilder<ItemCollectionTable>? orderBy,
    _is.OrderByListBuilder<ItemCollectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ItemCollection>(
      rows,
      orderBy: orderBy?.call(ItemCollection.t),
      orderByList: orderByList?.call(ItemCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ItemCollection].
  Future<ItemCollection> deleteRow(
    _is.DatabaseSession session,
    ItemCollection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ItemCollection>(
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
  Future<List<ItemCollection>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemCollectionTable> where,
    _is.OrderByBuilder<ItemCollectionTable>? orderBy,
    _is.OrderByListBuilder<ItemCollectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ItemCollection>(
      where: where(ItemCollection.t),
      orderBy: orderBy?.call(ItemCollection.t),
      orderByList: orderByList?.call(ItemCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemCollectionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ItemCollection>(
      where: where?.call(ItemCollection.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ItemCollection] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemCollectionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ItemCollection>(
      where: where(ItemCollection.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
