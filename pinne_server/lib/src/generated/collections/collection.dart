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

/// A user-defined group of items. Collections can nest; the parent must belong
/// to the same owner and must not create a cycle.
abstract class Collection
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Collection._({
    this.id,
    required this.ownerId,
    required this.name,
    this.description,
    this.parentId,
    int? coverSeed,
    int? paletteIndex,
    bool? isExample,
  }) : coverSeed = coverSeed ?? 0,
       paletteIndex = paletteIndex ?? 0,
       isExample = isExample ?? false;

  factory Collection({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String name,
    String? description,
    _is.UuidValue? parentId,
    int? coverSeed,
    int? paletteIndex,
    bool? isExample,
  }) = _CollectionImpl;

  factory Collection.fromJson(Map<String, dynamic> jsonSerialization) {
    return Collection(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
      coverSeed: jsonSerialization['coverSeed'] as int?,
      paletteIndex: jsonSerialization['paletteIndex'] as int?,
      isExample: jsonSerialization['isExample'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isExample']),
    );
  }

  static final t = CollectionTable();

  static const db = CollectionRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  String name;

  String? description;

  _is.UuidValue? parentId;

  int coverSeed;

  int paletteIndex;

  /// True only for opt-in starter collections created by ExampleSavesEndpoint.
  bool isExample;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Collection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Collection copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    String? name,
    String? description,
    _is.UuidValue? parentId,
    int? coverSeed,
    int? paletteIndex,
    bool? isExample,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Collection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parentId': parentId?.toJson(),
      'coverSeed': coverSeed,
      'paletteIndex': paletteIndex,
      'isExample': isExample,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Collection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parentId': parentId?.toJson(),
      'coverSeed': coverSeed,
      'paletteIndex': paletteIndex,
      'isExample': isExample,
    };
  }

  static CollectionInclude include() {
    return CollectionInclude._();
  }

  static CollectionIncludeList includeList({
    _is.WhereExpressionBuilder<CollectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CollectionTable>? orderBy,
    _is.OrderByListBuilder<CollectionTable>? orderByList,
    CollectionInclude? include,
  }) {
    return CollectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Collection.t),
      orderByList: orderByList?.call(Collection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CollectionImpl extends Collection {
  _CollectionImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String name,
    String? description,
    _is.UuidValue? parentId,
    int? coverSeed,
    int? paletteIndex,
    bool? isExample,
  }) : super._(
         id: id,
         ownerId: ownerId,
         name: name,
         description: description,
         parentId: parentId,
         coverSeed: coverSeed,
         paletteIndex: paletteIndex,
         isExample: isExample,
       );

  /// Returns a shallow copy of this [Collection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Collection copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    String? name,
    Object? description = _Undefined,
    Object? parentId = _Undefined,
    int? coverSeed,
    int? paletteIndex,
    bool? isExample,
  }) {
    return Collection(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      parentId: parentId is _is.UuidValue? ? parentId : this.parentId,
      coverSeed: coverSeed ?? this.coverSeed,
      paletteIndex: paletteIndex ?? this.paletteIndex,
      isExample: isExample ?? this.isExample,
    );
  }
}

class CollectionUpdateTable extends _is.UpdateTable<CollectionTable> {
  CollectionUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> parentId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.parentId,
    value,
  );

  _is.ColumnValue<int, int> coverSeed(int value) => _is.ColumnValue(
    table.coverSeed,
    value,
  );

  _is.ColumnValue<int, int> paletteIndex(int value) => _is.ColumnValue(
    table.paletteIndex,
    value,
  );

  _is.ColumnValue<bool, bool> isExample(bool value) => _is.ColumnValue(
    table.isExample,
    value,
  );
}

class CollectionTable extends _is.Table<_is.UuidValue?> {
  CollectionTable({super.tableRelation}) : super(tableName: 'collection') {
    updateTable = CollectionUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    parentId = _is.ColumnUuid(
      'parentId',
      this,
    );
    coverSeed = _is.ColumnInt(
      'coverSeed',
      this,
      hasDefault: true,
    );
    paletteIndex = _is.ColumnInt(
      'paletteIndex',
      this,
      hasDefault: true,
    );
    isExample = _is.ColumnBool(
      'isExample',
      this,
      hasDefault: true,
    );
  }

  late final CollectionUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnString name;

  late final _is.ColumnString description;

  late final _is.ColumnUuid parentId;

  late final _is.ColumnInt coverSeed;

  late final _is.ColumnInt paletteIndex;

  /// True only for opt-in starter collections created by ExampleSavesEndpoint.
  late final _is.ColumnBool isExample;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    name,
    description,
    parentId,
    coverSeed,
    paletteIndex,
    isExample,
  ];
}

class CollectionInclude extends _is.IncludeObject {
  CollectionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Collection.t;
}

class CollectionIncludeList extends _is.IncludeList {
  CollectionIncludeList._({
    _is.WhereExpressionBuilder<CollectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Collection.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Collection.t;
}

class CollectionRepository {
  const CollectionRepository._();

  /// Returns a list of [Collection]s matching the given query parameters.
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
  Future<List<Collection>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CollectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CollectionTable>? orderBy,
    _is.OrderByListBuilder<CollectionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Collection>(
      where: where?.call(Collection.t),
      orderBy: orderBy?.call(Collection.t),
      orderByList: orderByList?.call(Collection.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Collection] matching the given query parameters.
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
  Future<Collection?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CollectionTable>? where,
    int? offset,
    _is.OrderByBuilder<CollectionTable>? orderBy,
    _is.OrderByListBuilder<CollectionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Collection>(
      where: where?.call(Collection.t),
      orderBy: orderBy?.call(Collection.t),
      orderByList: orderByList?.call(Collection.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Collection] by its [id] or null if no such row exists.
  Future<Collection?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Collection>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Collection]s in the list and returns the inserted rows.
  ///
  /// The returned [Collection]s will have their `id` fields set.
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
  Future<List<Collection>> insert(
    _is.DatabaseSession session,
    List<Collection> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Collection>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Collection] and returns the inserted row.
  ///
  /// The returned [Collection] will have its `id` field set.
  Future<Collection> insertRow(
    _is.DatabaseSession session,
    Collection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Collection>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Collection]s in the list and returns the resulting rows.
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
  /// The returned [Collection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Collection>> upsert(
    _is.DatabaseSession session,
    List<Collection> rows, {
    required _is.ColumnSelections<CollectionTable> conflictColumns,
    _is.ColumnSelections<CollectionTable>? updateColumns,
    _is.WhereExpressionBuilder<CollectionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Collection>(
      rows,
      conflictColumns: conflictColumns(Collection.t),
      updateColumns: updateColumns?.call(Collection.t),
      updateWhere: updateWhere?.call(Collection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Collection] and returns the resulting row.
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
  /// The returned [Collection] will have its `id` field set.
  Future<Collection?> upsertRow(
    _is.DatabaseSession session,
    Collection row, {
    required _is.ColumnSelections<CollectionTable> conflictColumns,
    _is.ColumnSelections<CollectionTable>? updateColumns,
    _is.WhereExpressionBuilder<CollectionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Collection>(
      row,
      conflictColumns: conflictColumns(Collection.t),
      updateColumns: updateColumns?.call(Collection.t),
      updateWhere: updateWhere?.call(Collection.t),
      transaction: transaction,
    );
  }

  /// Updates all [Collection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Collection>> update(
    _is.DatabaseSession session,
    List<Collection> rows, {
    _is.ColumnSelections<CollectionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Collection>(
      rows,
      columns: columns?.call(Collection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Collection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Collection> updateRow(
    _is.DatabaseSession session,
    Collection row, {
    _is.ColumnSelections<CollectionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Collection>(
      row,
      columns: columns?.call(Collection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Collection] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Collection?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CollectionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Collection>(
      id,
      columnValues: columnValues(Collection.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Collection]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Collection>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CollectionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CollectionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CollectionTable>? orderBy,
    _is.OrderByListBuilder<CollectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Collection>(
      columnValues: columnValues(Collection.t.updateTable),
      where: where(Collection.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Collection.t),
      orderByList: orderByList?.call(Collection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Collection]s in the list and returns the deleted rows.
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
  Future<List<Collection>> delete(
    _is.DatabaseSession session,
    List<Collection> rows, {
    _is.OrderByBuilder<CollectionTable>? orderBy,
    _is.OrderByListBuilder<CollectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Collection>(
      rows,
      orderBy: orderBy?.call(Collection.t),
      orderByList: orderByList?.call(Collection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Collection].
  Future<Collection> deleteRow(
    _is.DatabaseSession session,
    Collection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Collection>(
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
  Future<List<Collection>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CollectionTable> where,
    _is.OrderByBuilder<CollectionTable>? orderBy,
    _is.OrderByListBuilder<CollectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Collection>(
      where: where(Collection.t),
      orderBy: orderBy?.call(Collection.t),
      orderByList: orderByList?.call(Collection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CollectionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Collection>(
      where: where?.call(Collection.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Collection] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CollectionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Collection>(
      where: where(Collection.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
