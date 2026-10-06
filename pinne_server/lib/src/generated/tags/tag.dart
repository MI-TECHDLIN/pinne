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

/// A label. Names are unique per owner after normalization.
abstract class Tag
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Tag._({
    this.id,
    required this.ownerId,
    required this.normalizedName,
    required this.displayName,
  });

  factory Tag({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String normalizedName,
    required String displayName,
  }) = _TagImpl;

  factory Tag.fromJson(Map<String, dynamic> jsonSerialization) {
    return Tag(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      normalizedName: jsonSerialization['normalizedName'] as String,
      displayName: jsonSerialization['displayName'] as String,
    );
  }

  static final t = TagTable();

  static const db = TagRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  String normalizedName;

  String displayName;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Tag]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Tag copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    String? normalizedName,
    String? displayName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Tag',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'normalizedName': normalizedName,
      'displayName': displayName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Tag',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'normalizedName': normalizedName,
      'displayName': displayName,
    };
  }

  static TagInclude include() {
    return TagInclude._();
  }

  static TagIncludeList includeList({
    _is.WhereExpressionBuilder<TagTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TagTable>? orderBy,
    _is.OrderByListBuilder<TagTable>? orderByList,
    TagInclude? include,
  }) {
    return TagIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Tag.t),
      orderByList: orderByList?.call(Tag.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TagImpl extends Tag {
  _TagImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String normalizedName,
    required String displayName,
  }) : super._(
         id: id,
         ownerId: ownerId,
         normalizedName: normalizedName,
         displayName: displayName,
       );

  /// Returns a shallow copy of this [Tag]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Tag copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    String? normalizedName,
    String? displayName,
  }) {
    return Tag(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      normalizedName: normalizedName ?? this.normalizedName,
      displayName: displayName ?? this.displayName,
    );
  }
}

class TagUpdateTable extends _is.UpdateTable<TagTable> {
  TagUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> normalizedName(String value) =>
      _is.ColumnValue(
        table.normalizedName,
        value,
      );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );
}

class TagTable extends _is.Table<_is.UuidValue?> {
  TagTable({super.tableRelation}) : super(tableName: 'tag') {
    updateTable = TagUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    normalizedName = _is.ColumnString(
      'normalizedName',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
  }

  late final TagUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnString normalizedName;

  late final _is.ColumnString displayName;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    normalizedName,
    displayName,
  ];
}

class TagInclude extends _is.IncludeObject {
  TagInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Tag.t;
}

class TagIncludeList extends _is.IncludeList {
  TagIncludeList._({
    _is.WhereExpressionBuilder<TagTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Tag.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Tag.t;
}

class TagRepository {
  const TagRepository._();

  /// Returns a list of [Tag]s matching the given query parameters.
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
  Future<List<Tag>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TagTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TagTable>? orderBy,
    _is.OrderByListBuilder<TagTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Tag>(
      where: where?.call(Tag.t),
      orderBy: orderBy?.call(Tag.t),
      orderByList: orderByList?.call(Tag.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Tag] matching the given query parameters.
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
  Future<Tag?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TagTable>? where,
    int? offset,
    _is.OrderByBuilder<TagTable>? orderBy,
    _is.OrderByListBuilder<TagTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Tag>(
      where: where?.call(Tag.t),
      orderBy: orderBy?.call(Tag.t),
      orderByList: orderByList?.call(Tag.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Tag] by its [id] or null if no such row exists.
  Future<Tag?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Tag>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Tag]s in the list and returns the inserted rows.
  ///
  /// The returned [Tag]s will have their `id` fields set.
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
  Future<List<Tag>> insert(
    _is.DatabaseSession session,
    List<Tag> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Tag>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Tag] and returns the inserted row.
  ///
  /// The returned [Tag] will have its `id` field set.
  Future<Tag> insertRow(
    _is.DatabaseSession session,
    Tag row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Tag>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Tag]s in the list and returns the resulting rows.
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
  /// The returned [Tag]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Tag>> upsert(
    _is.DatabaseSession session,
    List<Tag> rows, {
    required _is.ColumnSelections<TagTable> conflictColumns,
    _is.ColumnSelections<TagTable>? updateColumns,
    _is.WhereExpressionBuilder<TagTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Tag>(
      rows,
      conflictColumns: conflictColumns(Tag.t),
      updateColumns: updateColumns?.call(Tag.t),
      updateWhere: updateWhere?.call(Tag.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Tag] and returns the resulting row.
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
  /// The returned [Tag] will have its `id` field set.
  Future<Tag?> upsertRow(
    _is.DatabaseSession session,
    Tag row, {
    required _is.ColumnSelections<TagTable> conflictColumns,
    _is.ColumnSelections<TagTable>? updateColumns,
    _is.WhereExpressionBuilder<TagTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Tag>(
      row,
      conflictColumns: conflictColumns(Tag.t),
      updateColumns: updateColumns?.call(Tag.t),
      updateWhere: updateWhere?.call(Tag.t),
      transaction: transaction,
    );
  }

  /// Updates all [Tag]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Tag>> update(
    _is.DatabaseSession session,
    List<Tag> rows, {
    _is.ColumnSelections<TagTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Tag>(
      rows,
      columns: columns?.call(Tag.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Tag]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Tag> updateRow(
    _is.DatabaseSession session,
    Tag row, {
    _is.ColumnSelections<TagTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Tag>(
      row,
      columns: columns?.call(Tag.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Tag] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Tag?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TagUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Tag>(
      id,
      columnValues: columnValues(Tag.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Tag]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Tag>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TagUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TagTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TagTable>? orderBy,
    _is.OrderByListBuilder<TagTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Tag>(
      columnValues: columnValues(Tag.t.updateTable),
      where: where(Tag.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Tag.t),
      orderByList: orderByList?.call(Tag.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Tag]s in the list and returns the deleted rows.
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
  Future<List<Tag>> delete(
    _is.DatabaseSession session,
    List<Tag> rows, {
    _is.OrderByBuilder<TagTable>? orderBy,
    _is.OrderByListBuilder<TagTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Tag>(
      rows,
      orderBy: orderBy?.call(Tag.t),
      orderByList: orderByList?.call(Tag.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Tag].
  Future<Tag> deleteRow(
    _is.DatabaseSession session,
    Tag row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Tag>(
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
  Future<List<Tag>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TagTable> where,
    _is.OrderByBuilder<TagTable>? orderBy,
    _is.OrderByListBuilder<TagTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Tag>(
      where: where(Tag.t),
      orderBy: orderBy?.call(Tag.t),
      orderByList: orderByList?.call(Tag.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TagTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Tag>(
      where: where?.call(Tag.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Tag] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TagTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Tag>(
      where: where(Tag.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
