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

/// One avatar recipe and display name per signed-in owner.
abstract class PinneProfile
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PinneProfile._({
    this.id,
    required this.ownerId,
    required this.displayName,
    required this.avatarSeed,
    required this.avatarPalette,
  });

  factory PinneProfile({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String displayName,
    required int avatarSeed,
    required int avatarPalette,
  }) = _PinneProfileImpl;

  factory PinneProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return PinneProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      displayName: jsonSerialization['displayName'] as String,
      avatarSeed: jsonSerialization['avatarSeed'] as int,
      avatarPalette: jsonSerialization['avatarPalette'] as int,
    );
  }

  static final t = PinneProfileTable();

  static const db = PinneProfileRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  String displayName;

  int avatarSeed;

  int avatarPalette;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PinneProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PinneProfile copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    String? displayName,
    int? avatarSeed,
    int? avatarPalette,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PinneProfile',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'displayName': displayName,
      'avatarSeed': avatarSeed,
      'avatarPalette': avatarPalette,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PinneProfile',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'displayName': displayName,
      'avatarSeed': avatarSeed,
      'avatarPalette': avatarPalette,
    };
  }

  static PinneProfileInclude include() {
    return PinneProfileInclude._();
  }

  static PinneProfileIncludeList includeList({
    _is.WhereExpressionBuilder<PinneProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PinneProfileTable>? orderBy,
    _is.OrderByListBuilder<PinneProfileTable>? orderByList,
    PinneProfileInclude? include,
  }) {
    return PinneProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PinneProfile.t),
      orderByList: orderByList?.call(PinneProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PinneProfileImpl extends PinneProfile {
  _PinneProfileImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required String displayName,
    required int avatarSeed,
    required int avatarPalette,
  }) : super._(
         id: id,
         ownerId: ownerId,
         displayName: displayName,
         avatarSeed: avatarSeed,
         avatarPalette: avatarPalette,
       );

  /// Returns a shallow copy of this [PinneProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PinneProfile copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    String? displayName,
    int? avatarSeed,
    int? avatarPalette,
  }) {
    return PinneProfile(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      displayName: displayName ?? this.displayName,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      avatarPalette: avatarPalette ?? this.avatarPalette,
    );
  }
}

class PinneProfileUpdateTable extends _is.UpdateTable<PinneProfileTable> {
  PinneProfileUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<int, int> avatarSeed(int value) => _is.ColumnValue(
    table.avatarSeed,
    value,
  );

  _is.ColumnValue<int, int> avatarPalette(int value) => _is.ColumnValue(
    table.avatarPalette,
    value,
  );
}

class PinneProfileTable extends _is.Table<_is.UuidValue?> {
  PinneProfileTable({super.tableRelation}) : super(tableName: 'pinne_profile') {
    updateTable = PinneProfileUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    avatarSeed = _is.ColumnInt(
      'avatarSeed',
      this,
    );
    avatarPalette = _is.ColumnInt(
      'avatarPalette',
      this,
    );
  }

  late final PinneProfileUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnString displayName;

  late final _is.ColumnInt avatarSeed;

  late final _is.ColumnInt avatarPalette;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    displayName,
    avatarSeed,
    avatarPalette,
  ];
}

class PinneProfileInclude extends _is.IncludeObject {
  PinneProfileInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => PinneProfile.t;
}

class PinneProfileIncludeList extends _is.IncludeList {
  PinneProfileIncludeList._({
    _is.WhereExpressionBuilder<PinneProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PinneProfile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PinneProfile.t;
}

class PinneProfileRepository {
  const PinneProfileRepository._();

  /// Returns a list of [PinneProfile]s matching the given query parameters.
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
  Future<List<PinneProfile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PinneProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PinneProfileTable>? orderBy,
    _is.OrderByListBuilder<PinneProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PinneProfile>(
      where: where?.call(PinneProfile.t),
      orderBy: orderBy?.call(PinneProfile.t),
      orderByList: orderByList?.call(PinneProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PinneProfile] matching the given query parameters.
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
  Future<PinneProfile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PinneProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<PinneProfileTable>? orderBy,
    _is.OrderByListBuilder<PinneProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PinneProfile>(
      where: where?.call(PinneProfile.t),
      orderBy: orderBy?.call(PinneProfile.t),
      orderByList: orderByList?.call(PinneProfile.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PinneProfile] by its [id] or null if no such row exists.
  Future<PinneProfile?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PinneProfile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PinneProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [PinneProfile]s will have their `id` fields set.
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
  Future<List<PinneProfile>> insert(
    _is.DatabaseSession session,
    List<PinneProfile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PinneProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PinneProfile] and returns the inserted row.
  ///
  /// The returned [PinneProfile] will have its `id` field set.
  Future<PinneProfile> insertRow(
    _is.DatabaseSession session,
    PinneProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PinneProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PinneProfile]s in the list and returns the resulting rows.
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
  /// The returned [PinneProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PinneProfile>> upsert(
    _is.DatabaseSession session,
    List<PinneProfile> rows, {
    required _is.ColumnSelections<PinneProfileTable> conflictColumns,
    _is.ColumnSelections<PinneProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<PinneProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PinneProfile>(
      rows,
      conflictColumns: conflictColumns(PinneProfile.t),
      updateColumns: updateColumns?.call(PinneProfile.t),
      updateWhere: updateWhere?.call(PinneProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PinneProfile] and returns the resulting row.
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
  /// The returned [PinneProfile] will have its `id` field set.
  Future<PinneProfile?> upsertRow(
    _is.DatabaseSession session,
    PinneProfile row, {
    required _is.ColumnSelections<PinneProfileTable> conflictColumns,
    _is.ColumnSelections<PinneProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<PinneProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PinneProfile>(
      row,
      conflictColumns: conflictColumns(PinneProfile.t),
      updateColumns: updateColumns?.call(PinneProfile.t),
      updateWhere: updateWhere?.call(PinneProfile.t),
      transaction: transaction,
    );
  }

  /// Updates all [PinneProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PinneProfile>> update(
    _is.DatabaseSession session,
    List<PinneProfile> rows, {
    _is.ColumnSelections<PinneProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PinneProfile>(
      rows,
      columns: columns?.call(PinneProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PinneProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PinneProfile> updateRow(
    _is.DatabaseSession session,
    PinneProfile row, {
    _is.ColumnSelections<PinneProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PinneProfile>(
      row,
      columns: columns?.call(PinneProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PinneProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PinneProfile?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PinneProfileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PinneProfile>(
      id,
      columnValues: columnValues(PinneProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PinneProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PinneProfile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PinneProfileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PinneProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PinneProfileTable>? orderBy,
    _is.OrderByListBuilder<PinneProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PinneProfile>(
      columnValues: columnValues(PinneProfile.t.updateTable),
      where: where(PinneProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PinneProfile.t),
      orderByList: orderByList?.call(PinneProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PinneProfile]s in the list and returns the deleted rows.
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
  Future<List<PinneProfile>> delete(
    _is.DatabaseSession session,
    List<PinneProfile> rows, {
    _is.OrderByBuilder<PinneProfileTable>? orderBy,
    _is.OrderByListBuilder<PinneProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PinneProfile>(
      rows,
      orderBy: orderBy?.call(PinneProfile.t),
      orderByList: orderByList?.call(PinneProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PinneProfile].
  Future<PinneProfile> deleteRow(
    _is.DatabaseSession session,
    PinneProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PinneProfile>(
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
  Future<List<PinneProfile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PinneProfileTable> where,
    _is.OrderByBuilder<PinneProfileTable>? orderBy,
    _is.OrderByListBuilder<PinneProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PinneProfile>(
      where: where(PinneProfile.t),
      orderBy: orderBy?.call(PinneProfile.t),
      orderByList: orderByList?.call(PinneProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PinneProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PinneProfile>(
      where: where?.call(PinneProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PinneProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PinneProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PinneProfile>(
      where: where(PinneProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
