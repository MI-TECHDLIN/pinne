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

/// A tag on an item. Both ends must share the row owner.
abstract class ItemTag
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ItemTag._({
    this.id,
    required this.ownerId,
    required this.itemId,
    required this.tagId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) : origin = origin ?? _i12d5boj.AssignmentOrigin.manual,
       manuallyLocked = manuallyLocked ?? false;

  factory ItemTag({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    required _is.UuidValue tagId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) = _ItemTagImpl;

  factory ItemTag.fromJson(Map<String, dynamic> jsonSerialization) {
    return ItemTag(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      tagId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['tagId']),
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

  static final t = ItemTagTable();

  static const db = ItemTagRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue itemId;

  _is.UuidValue tagId;

  _i12d5boj.AssignmentOrigin origin;

  /// True when the owner explicitly chose or protected this assignment.
  bool manuallyLocked;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ItemTag]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ItemTag copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    _is.UuidValue? tagId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ItemTag',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'tagId': tagId.toJson(),
      'origin': origin.toJson(),
      'manuallyLocked': manuallyLocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ItemTag',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'tagId': tagId.toJson(),
      'origin': origin.toJson(),
      'manuallyLocked': manuallyLocked,
    };
  }

  static ItemTagInclude include() {
    return ItemTagInclude._();
  }

  static ItemTagIncludeList includeList({
    _is.WhereExpressionBuilder<ItemTagTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemTagTable>? orderBy,
    _is.OrderByListBuilder<ItemTagTable>? orderByList,
    ItemTagInclude? include,
  }) {
    return ItemTagIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemTag.t),
      orderByList: orderByList?.call(ItemTag.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ItemTagImpl extends ItemTag {
  _ItemTagImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    required _is.UuidValue tagId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         tagId: tagId,
         origin: origin,
         manuallyLocked: manuallyLocked,
       );

  /// Returns a shallow copy of this [ItemTag]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ItemTag copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    _is.UuidValue? tagId,
    _i12d5boj.AssignmentOrigin? origin,
    bool? manuallyLocked,
  }) {
    return ItemTag(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      tagId: tagId ?? this.tagId,
      origin: origin ?? this.origin,
      manuallyLocked: manuallyLocked ?? this.manuallyLocked,
    );
  }
}

class ItemTagUpdateTable extends _is.UpdateTable<ItemTagTable> {
  ItemTagUpdateTable(super.table);

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

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tagId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.tagId,
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

class ItemTagTable extends _is.Table<_is.UuidValue?> {
  ItemTagTable({super.tableRelation}) : super(tableName: 'item_tag') {
    updateTable = ItemTagUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    itemId = _is.ColumnUuid(
      'itemId',
      this,
    );
    tagId = _is.ColumnUuid(
      'tagId',
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

  late final ItemTagUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid itemId;

  late final _is.ColumnUuid tagId;

  late final _is.ColumnEnum<_i12d5boj.AssignmentOrigin> origin;

  /// True when the owner explicitly chose or protected this assignment.
  late final _is.ColumnBool manuallyLocked;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    itemId,
    tagId,
    origin,
    manuallyLocked,
  ];
}

class ItemTagInclude extends _is.IncludeObject {
  ItemTagInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ItemTag.t;
}

class ItemTagIncludeList extends _is.IncludeList {
  ItemTagIncludeList._({
    _is.WhereExpressionBuilder<ItemTagTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ItemTag.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ItemTag.t;
}

class ItemTagRepository {
  const ItemTagRepository._();

  /// Returns a list of [ItemTag]s matching the given query parameters.
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
  Future<List<ItemTag>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemTagTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemTagTable>? orderBy,
    _is.OrderByListBuilder<ItemTagTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ItemTag>(
      where: where?.call(ItemTag.t),
      orderBy: orderBy?.call(ItemTag.t),
      orderByList: orderByList?.call(ItemTag.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ItemTag] matching the given query parameters.
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
  Future<ItemTag?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemTagTable>? where,
    int? offset,
    _is.OrderByBuilder<ItemTagTable>? orderBy,
    _is.OrderByListBuilder<ItemTagTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ItemTag>(
      where: where?.call(ItemTag.t),
      orderBy: orderBy?.call(ItemTag.t),
      orderByList: orderByList?.call(ItemTag.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ItemTag] by its [id] or null if no such row exists.
  Future<ItemTag?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ItemTag>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ItemTag]s in the list and returns the inserted rows.
  ///
  /// The returned [ItemTag]s will have their `id` fields set.
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
  Future<List<ItemTag>> insert(
    _is.DatabaseSession session,
    List<ItemTag> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ItemTag>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ItemTag] and returns the inserted row.
  ///
  /// The returned [ItemTag] will have its `id` field set.
  Future<ItemTag> insertRow(
    _is.DatabaseSession session,
    ItemTag row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ItemTag>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ItemTag]s in the list and returns the resulting rows.
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
  /// The returned [ItemTag]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemTag>> upsert(
    _is.DatabaseSession session,
    List<ItemTag> rows, {
    required _is.ColumnSelections<ItemTagTable> conflictColumns,
    _is.ColumnSelections<ItemTagTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemTagTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ItemTag>(
      rows,
      conflictColumns: conflictColumns(ItemTag.t),
      updateColumns: updateColumns?.call(ItemTag.t),
      updateWhere: updateWhere?.call(ItemTag.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ItemTag] and returns the resulting row.
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
  /// The returned [ItemTag] will have its `id` field set.
  Future<ItemTag?> upsertRow(
    _is.DatabaseSession session,
    ItemTag row, {
    required _is.ColumnSelections<ItemTagTable> conflictColumns,
    _is.ColumnSelections<ItemTagTable>? updateColumns,
    _is.WhereExpressionBuilder<ItemTagTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ItemTag>(
      row,
      conflictColumns: conflictColumns(ItemTag.t),
      updateColumns: updateColumns?.call(ItemTag.t),
      updateWhere: updateWhere?.call(ItemTag.t),
      transaction: transaction,
    );
  }

  /// Updates all [ItemTag]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemTag>> update(
    _is.DatabaseSession session,
    List<ItemTag> rows, {
    _is.ColumnSelections<ItemTagTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ItemTag>(
      rows,
      columns: columns?.call(ItemTag.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ItemTag]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ItemTag> updateRow(
    _is.DatabaseSession session,
    ItemTag row, {
    _is.ColumnSelections<ItemTagTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ItemTag>(
      row,
      columns: columns?.call(ItemTag.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ItemTag] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ItemTag?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ItemTagUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ItemTag>(
      id,
      columnValues: columnValues(ItemTag.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ItemTag]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ItemTag>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ItemTagUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ItemTagTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ItemTagTable>? orderBy,
    _is.OrderByListBuilder<ItemTagTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ItemTag>(
      columnValues: columnValues(ItemTag.t.updateTable),
      where: where(ItemTag.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ItemTag.t),
      orderByList: orderByList?.call(ItemTag.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ItemTag]s in the list and returns the deleted rows.
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
  Future<List<ItemTag>> delete(
    _is.DatabaseSession session,
    List<ItemTag> rows, {
    _is.OrderByBuilder<ItemTagTable>? orderBy,
    _is.OrderByListBuilder<ItemTagTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ItemTag>(
      rows,
      orderBy: orderBy?.call(ItemTag.t),
      orderByList: orderByList?.call(ItemTag.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ItemTag].
  Future<ItemTag> deleteRow(
    _is.DatabaseSession session,
    ItemTag row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ItemTag>(
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
  Future<List<ItemTag>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemTagTable> where,
    _is.OrderByBuilder<ItemTagTable>? orderBy,
    _is.OrderByListBuilder<ItemTagTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ItemTag>(
      where: where(ItemTag.t),
      orderBy: orderBy?.call(ItemTag.t),
      orderByList: orderByList?.call(ItemTag.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ItemTagTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ItemTag>(
      where: where?.call(ItemTag.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ItemTag] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ItemTagTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ItemTag>(
      where: where(ItemTag.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
