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

/// The owner's progress preferences. Streaks are opt-in.
abstract class ProgressSettings
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ProgressSettings._({
    this.id,
    required this.ownerId,
    bool? streakEnabled,
    int? weeklyGoalDays,
  }) : streakEnabled = streakEnabled ?? false,
       weeklyGoalDays = weeklyGoalDays ?? 3;

  factory ProgressSettings({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    bool? streakEnabled,
    int? weeklyGoalDays,
  }) = _ProgressSettingsImpl;

  factory ProgressSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProgressSettings(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      streakEnabled: jsonSerialization['streakEnabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['streakEnabled']),
      weeklyGoalDays: jsonSerialization['weeklyGoalDays'] as int?,
    );
  }

  static final t = ProgressSettingsTable();

  static const db = ProgressSettingsRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  bool streakEnabled;

  /// Distinct review days per week that count as the weekly goal.
  int weeklyGoalDays;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProgressSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProgressSettings copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    bool? streakEnabled,
    int? weeklyGoalDays,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProgressSettings',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'streakEnabled': streakEnabled,
      'weeklyGoalDays': weeklyGoalDays,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProgressSettings',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'streakEnabled': streakEnabled,
      'weeklyGoalDays': weeklyGoalDays,
    };
  }

  static ProgressSettingsInclude include() {
    return ProgressSettingsInclude._();
  }

  static ProgressSettingsIncludeList includeList({
    _is.WhereExpressionBuilder<ProgressSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProgressSettingsTable>? orderBy,
    _is.OrderByListBuilder<ProgressSettingsTable>? orderByList,
    ProgressSettingsInclude? include,
  }) {
    return ProgressSettingsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProgressSettings.t),
      orderByList: orderByList?.call(ProgressSettings.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProgressSettingsImpl extends ProgressSettings {
  _ProgressSettingsImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    bool? streakEnabled,
    int? weeklyGoalDays,
  }) : super._(
         id: id,
         ownerId: ownerId,
         streakEnabled: streakEnabled,
         weeklyGoalDays: weeklyGoalDays,
       );

  /// Returns a shallow copy of this [ProgressSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProgressSettings copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    bool? streakEnabled,
    int? weeklyGoalDays,
  }) {
    return ProgressSettings(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      streakEnabled: streakEnabled ?? this.streakEnabled,
      weeklyGoalDays: weeklyGoalDays ?? this.weeklyGoalDays,
    );
  }
}

class ProgressSettingsUpdateTable
    extends _is.UpdateTable<ProgressSettingsTable> {
  ProgressSettingsUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<bool, bool> streakEnabled(bool value) => _is.ColumnValue(
    table.streakEnabled,
    value,
  );

  _is.ColumnValue<int, int> weeklyGoalDays(int value) => _is.ColumnValue(
    table.weeklyGoalDays,
    value,
  );
}

class ProgressSettingsTable extends _is.Table<_is.UuidValue?> {
  ProgressSettingsTable({super.tableRelation})
    : super(tableName: 'progress_settings') {
    updateTable = ProgressSettingsUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    streakEnabled = _is.ColumnBool(
      'streakEnabled',
      this,
      hasDefault: true,
    );
    weeklyGoalDays = _is.ColumnInt(
      'weeklyGoalDays',
      this,
      hasDefault: true,
    );
  }

  late final ProgressSettingsUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnBool streakEnabled;

  /// Distinct review days per week that count as the weekly goal.
  late final _is.ColumnInt weeklyGoalDays;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    streakEnabled,
    weeklyGoalDays,
  ];
}

class ProgressSettingsInclude extends _is.IncludeObject {
  ProgressSettingsInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ProgressSettings.t;
}

class ProgressSettingsIncludeList extends _is.IncludeList {
  ProgressSettingsIncludeList._({
    _is.WhereExpressionBuilder<ProgressSettingsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProgressSettings.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ProgressSettings.t;
}

class ProgressSettingsRepository {
  const ProgressSettingsRepository._();

  /// Returns a list of [ProgressSettings]s matching the given query parameters.
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
  Future<List<ProgressSettings>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProgressSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProgressSettingsTable>? orderBy,
    _is.OrderByListBuilder<ProgressSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProgressSettings>(
      where: where?.call(ProgressSettings.t),
      orderBy: orderBy?.call(ProgressSettings.t),
      orderByList: orderByList?.call(ProgressSettings.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProgressSettings] matching the given query parameters.
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
  Future<ProgressSettings?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProgressSettingsTable>? where,
    int? offset,
    _is.OrderByBuilder<ProgressSettingsTable>? orderBy,
    _is.OrderByListBuilder<ProgressSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProgressSettings>(
      where: where?.call(ProgressSettings.t),
      orderBy: orderBy?.call(ProgressSettings.t),
      orderByList: orderByList?.call(ProgressSettings.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProgressSettings] by its [id] or null if no such row exists.
  Future<ProgressSettings?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProgressSettings>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProgressSettings]s in the list and returns the inserted rows.
  ///
  /// The returned [ProgressSettings]s will have their `id` fields set.
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
  Future<List<ProgressSettings>> insert(
    _is.DatabaseSession session,
    List<ProgressSettings> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProgressSettings>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProgressSettings] and returns the inserted row.
  ///
  /// The returned [ProgressSettings] will have its `id` field set.
  Future<ProgressSettings> insertRow(
    _is.DatabaseSession session,
    ProgressSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProgressSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProgressSettings]s in the list and returns the resulting rows.
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
  /// The returned [ProgressSettings]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProgressSettings>> upsert(
    _is.DatabaseSession session,
    List<ProgressSettings> rows, {
    required _is.ColumnSelections<ProgressSettingsTable> conflictColumns,
    _is.ColumnSelections<ProgressSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<ProgressSettingsTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProgressSettings>(
      rows,
      conflictColumns: conflictColumns(ProgressSettings.t),
      updateColumns: updateColumns?.call(ProgressSettings.t),
      updateWhere: updateWhere?.call(ProgressSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProgressSettings] and returns the resulting row.
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
  /// The returned [ProgressSettings] will have its `id` field set.
  Future<ProgressSettings?> upsertRow(
    _is.DatabaseSession session,
    ProgressSettings row, {
    required _is.ColumnSelections<ProgressSettingsTable> conflictColumns,
    _is.ColumnSelections<ProgressSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<ProgressSettingsTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProgressSettings>(
      row,
      conflictColumns: conflictColumns(ProgressSettings.t),
      updateColumns: updateColumns?.call(ProgressSettings.t),
      updateWhere: updateWhere?.call(ProgressSettings.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProgressSettings]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProgressSettings>> update(
    _is.DatabaseSession session,
    List<ProgressSettings> rows, {
    _is.ColumnSelections<ProgressSettingsTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProgressSettings>(
      rows,
      columns: columns?.call(ProgressSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProgressSettings]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProgressSettings> updateRow(
    _is.DatabaseSession session,
    ProgressSettings row, {
    _is.ColumnSelections<ProgressSettingsTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProgressSettings>(
      row,
      columns: columns?.call(ProgressSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProgressSettings] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProgressSettings?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProgressSettingsUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProgressSettings>(
      id,
      columnValues: columnValues(ProgressSettings.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProgressSettings]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProgressSettings>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProgressSettingsUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ProgressSettingsTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProgressSettingsTable>? orderBy,
    _is.OrderByListBuilder<ProgressSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProgressSettings>(
      columnValues: columnValues(ProgressSettings.t.updateTable),
      where: where(ProgressSettings.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProgressSettings.t),
      orderByList: orderByList?.call(ProgressSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProgressSettings]s in the list and returns the deleted rows.
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
  Future<List<ProgressSettings>> delete(
    _is.DatabaseSession session,
    List<ProgressSettings> rows, {
    _is.OrderByBuilder<ProgressSettingsTable>? orderBy,
    _is.OrderByListBuilder<ProgressSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProgressSettings>(
      rows,
      orderBy: orderBy?.call(ProgressSettings.t),
      orderByList: orderByList?.call(ProgressSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProgressSettings].
  Future<ProgressSettings> deleteRow(
    _is.DatabaseSession session,
    ProgressSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProgressSettings>(
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
  Future<List<ProgressSettings>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProgressSettingsTable> where,
    _is.OrderByBuilder<ProgressSettingsTable>? orderBy,
    _is.OrderByListBuilder<ProgressSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProgressSettings>(
      where: where(ProgressSettings.t),
      orderBy: orderBy?.call(ProgressSettings.t),
      orderByList: orderByList?.call(ProgressSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProgressSettingsTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProgressSettings>(
      where: where?.call(ProgressSettings.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProgressSettings] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProgressSettingsTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProgressSettings>(
      where: where(ProgressSettings.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
