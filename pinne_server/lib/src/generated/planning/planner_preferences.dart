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
import 'package:pinne_server/src/generated/protocol.dart' as _i2yoimhd;
import 'package:serverpod/serverpod.dart' as _is;
import '../planning/approval_mode.dart' as _i6o5tozv;
import '../planning/plan_horizon.dart' as _if2ouyp9;

/// The owner's planning rules. Times are local to `timezone`.
abstract class PlannerPreferences
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PlannerPreferences._({
    this.id,
    required this.ownerId,
    required this.horizon,
    required this.weekdays,
    required this.windowStartMinute,
    required this.windowEndMinute,
    required this.sessionMinutes,
    required this.maxSessions,
    required this.bufferMinutes,
    required this.minLeadMinutes,
    required this.timezone,
    required this.approvalMode,
  });

  factory PlannerPreferences({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _if2ouyp9.PlanHorizon horizon,
    required List<int> weekdays,
    required int windowStartMinute,
    required int windowEndMinute,
    required int sessionMinutes,
    required int maxSessions,
    required int bufferMinutes,
    required int minLeadMinutes,
    required String timezone,
    required _i6o5tozv.ApprovalMode approvalMode,
  }) = _PlannerPreferencesImpl;

  factory PlannerPreferences.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlannerPreferences(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      horizon: _if2ouyp9.PlanHorizon.fromJson(
        (jsonSerialization['horizon'] as String),
      ),
      weekdays: _i2yoimhd.Protocol().deserialize<List<int>>(
        jsonSerialization['weekdays'],
      ),
      windowStartMinute: jsonSerialization['windowStartMinute'] as int,
      windowEndMinute: jsonSerialization['windowEndMinute'] as int,
      sessionMinutes: jsonSerialization['sessionMinutes'] as int,
      maxSessions: jsonSerialization['maxSessions'] as int,
      bufferMinutes: jsonSerialization['bufferMinutes'] as int,
      minLeadMinutes: jsonSerialization['minLeadMinutes'] as int,
      timezone: jsonSerialization['timezone'] as String,
      approvalMode: _i6o5tozv.ApprovalMode.fromJson(
        (jsonSerialization['approvalMode'] as String),
      ),
    );
  }

  static final t = PlannerPreferencesTable();

  static const db = PlannerPreferencesRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _if2ouyp9.PlanHorizon horizon;

  /// ISO weekdays, 1 Monday to 7 Sunday.
  List<int> weekdays;

  /// Minutes after local midnight.
  int windowStartMinute;

  int windowEndMinute;

  int sessionMinutes;

  int maxSessions;

  int bufferMinutes;

  int minLeadMinutes;

  /// IANA time zone, such as Africa/Lagos.
  String timezone;

  _i6o5tozv.ApprovalMode approvalMode;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PlannerPreferences]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlannerPreferences copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _if2ouyp9.PlanHorizon? horizon,
    List<int>? weekdays,
    int? windowStartMinute,
    int? windowEndMinute,
    int? sessionMinutes,
    int? maxSessions,
    int? bufferMinutes,
    int? minLeadMinutes,
    String? timezone,
    _i6o5tozv.ApprovalMode? approvalMode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlannerPreferences',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'horizon': horizon.toJson(),
      'weekdays': weekdays.toJson(),
      'windowStartMinute': windowStartMinute,
      'windowEndMinute': windowEndMinute,
      'sessionMinutes': sessionMinutes,
      'maxSessions': maxSessions,
      'bufferMinutes': bufferMinutes,
      'minLeadMinutes': minLeadMinutes,
      'timezone': timezone,
      'approvalMode': approvalMode.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlannerPreferences',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'horizon': horizon.toJson(),
      'weekdays': weekdays.toJson(),
      'windowStartMinute': windowStartMinute,
      'windowEndMinute': windowEndMinute,
      'sessionMinutes': sessionMinutes,
      'maxSessions': maxSessions,
      'bufferMinutes': bufferMinutes,
      'minLeadMinutes': minLeadMinutes,
      'timezone': timezone,
      'approvalMode': approvalMode.toJson(),
    };
  }

  static PlannerPreferencesInclude include() {
    return PlannerPreferencesInclude._();
  }

  static PlannerPreferencesIncludeList includeList({
    _is.WhereExpressionBuilder<PlannerPreferencesTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlannerPreferencesTable>? orderBy,
    _is.OrderByListBuilder<PlannerPreferencesTable>? orderByList,
    PlannerPreferencesInclude? include,
  }) {
    return PlannerPreferencesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlannerPreferences.t),
      orderByList: orderByList?.call(PlannerPreferences.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlannerPreferencesImpl extends PlannerPreferences {
  _PlannerPreferencesImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _if2ouyp9.PlanHorizon horizon,
    required List<int> weekdays,
    required int windowStartMinute,
    required int windowEndMinute,
    required int sessionMinutes,
    required int maxSessions,
    required int bufferMinutes,
    required int minLeadMinutes,
    required String timezone,
    required _i6o5tozv.ApprovalMode approvalMode,
  }) : super._(
         id: id,
         ownerId: ownerId,
         horizon: horizon,
         weekdays: weekdays,
         windowStartMinute: windowStartMinute,
         windowEndMinute: windowEndMinute,
         sessionMinutes: sessionMinutes,
         maxSessions: maxSessions,
         bufferMinutes: bufferMinutes,
         minLeadMinutes: minLeadMinutes,
         timezone: timezone,
         approvalMode: approvalMode,
       );

  /// Returns a shallow copy of this [PlannerPreferences]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlannerPreferences copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _if2ouyp9.PlanHorizon? horizon,
    List<int>? weekdays,
    int? windowStartMinute,
    int? windowEndMinute,
    int? sessionMinutes,
    int? maxSessions,
    int? bufferMinutes,
    int? minLeadMinutes,
    String? timezone,
    _i6o5tozv.ApprovalMode? approvalMode,
  }) {
    return PlannerPreferences(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      horizon: horizon ?? this.horizon,
      weekdays: weekdays ?? this.weekdays.map((e0) => e0).toList(),
      windowStartMinute: windowStartMinute ?? this.windowStartMinute,
      windowEndMinute: windowEndMinute ?? this.windowEndMinute,
      sessionMinutes: sessionMinutes ?? this.sessionMinutes,
      maxSessions: maxSessions ?? this.maxSessions,
      bufferMinutes: bufferMinutes ?? this.bufferMinutes,
      minLeadMinutes: minLeadMinutes ?? this.minLeadMinutes,
      timezone: timezone ?? this.timezone,
      approvalMode: approvalMode ?? this.approvalMode,
    );
  }
}

class PlannerPreferencesUpdateTable
    extends _is.UpdateTable<PlannerPreferencesTable> {
  PlannerPreferencesUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_if2ouyp9.PlanHorizon, _if2ouyp9.PlanHorizon> horizon(
    _if2ouyp9.PlanHorizon value,
  ) => _is.ColumnValue(
    table.horizon,
    value,
  );

  _is.ColumnValue<List<int>, List<int>> weekdays(List<int> value) =>
      _is.ColumnValue(
        table.weekdays,
        value,
      );

  _is.ColumnValue<int, int> windowStartMinute(int value) => _is.ColumnValue(
    table.windowStartMinute,
    value,
  );

  _is.ColumnValue<int, int> windowEndMinute(int value) => _is.ColumnValue(
    table.windowEndMinute,
    value,
  );

  _is.ColumnValue<int, int> sessionMinutes(int value) => _is.ColumnValue(
    table.sessionMinutes,
    value,
  );

  _is.ColumnValue<int, int> maxSessions(int value) => _is.ColumnValue(
    table.maxSessions,
    value,
  );

  _is.ColumnValue<int, int> bufferMinutes(int value) => _is.ColumnValue(
    table.bufferMinutes,
    value,
  );

  _is.ColumnValue<int, int> minLeadMinutes(int value) => _is.ColumnValue(
    table.minLeadMinutes,
    value,
  );

  _is.ColumnValue<String, String> timezone(String value) => _is.ColumnValue(
    table.timezone,
    value,
  );

  _is.ColumnValue<_i6o5tozv.ApprovalMode, _i6o5tozv.ApprovalMode> approvalMode(
    _i6o5tozv.ApprovalMode value,
  ) => _is.ColumnValue(
    table.approvalMode,
    value,
  );
}

class PlannerPreferencesTable extends _is.Table<_is.UuidValue?> {
  PlannerPreferencesTable({super.tableRelation})
    : super(tableName: 'planner_preferences') {
    updateTable = PlannerPreferencesUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    horizon = _is.ColumnEnum(
      'horizon',
      this,
      _is.EnumSerialization.byName,
    );
    weekdays = _is.ColumnSerializable<List<int>>(
      'weekdays',
      this,
    );
    windowStartMinute = _is.ColumnInt(
      'windowStartMinute',
      this,
    );
    windowEndMinute = _is.ColumnInt(
      'windowEndMinute',
      this,
    );
    sessionMinutes = _is.ColumnInt(
      'sessionMinutes',
      this,
    );
    maxSessions = _is.ColumnInt(
      'maxSessions',
      this,
    );
    bufferMinutes = _is.ColumnInt(
      'bufferMinutes',
      this,
    );
    minLeadMinutes = _is.ColumnInt(
      'minLeadMinutes',
      this,
    );
    timezone = _is.ColumnString(
      'timezone',
      this,
    );
    approvalMode = _is.ColumnEnum(
      'approvalMode',
      this,
      _is.EnumSerialization.byName,
    );
  }

  late final PlannerPreferencesUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnEnum<_if2ouyp9.PlanHorizon> horizon;

  /// ISO weekdays, 1 Monday to 7 Sunday.
  late final _is.ColumnSerializable<List<int>> weekdays;

  /// Minutes after local midnight.
  late final _is.ColumnInt windowStartMinute;

  late final _is.ColumnInt windowEndMinute;

  late final _is.ColumnInt sessionMinutes;

  late final _is.ColumnInt maxSessions;

  late final _is.ColumnInt bufferMinutes;

  late final _is.ColumnInt minLeadMinutes;

  /// IANA time zone, such as Africa/Lagos.
  late final _is.ColumnString timezone;

  late final _is.ColumnEnum<_i6o5tozv.ApprovalMode> approvalMode;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    horizon,
    weekdays,
    windowStartMinute,
    windowEndMinute,
    sessionMinutes,
    maxSessions,
    bufferMinutes,
    minLeadMinutes,
    timezone,
    approvalMode,
  ];
}

class PlannerPreferencesInclude extends _is.IncludeObject {
  PlannerPreferencesInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => PlannerPreferences.t;
}

class PlannerPreferencesIncludeList extends _is.IncludeList {
  PlannerPreferencesIncludeList._({
    _is.WhereExpressionBuilder<PlannerPreferencesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PlannerPreferences.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PlannerPreferences.t;
}

class PlannerPreferencesRepository {
  const PlannerPreferencesRepository._();

  /// Returns a list of [PlannerPreferences]s matching the given query parameters.
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
  Future<List<PlannerPreferences>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlannerPreferencesTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlannerPreferencesTable>? orderBy,
    _is.OrderByListBuilder<PlannerPreferencesTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PlannerPreferences>(
      where: where?.call(PlannerPreferences.t),
      orderBy: orderBy?.call(PlannerPreferences.t),
      orderByList: orderByList?.call(PlannerPreferences.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PlannerPreferences] matching the given query parameters.
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
  Future<PlannerPreferences?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlannerPreferencesTable>? where,
    int? offset,
    _is.OrderByBuilder<PlannerPreferencesTable>? orderBy,
    _is.OrderByListBuilder<PlannerPreferencesTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PlannerPreferences>(
      where: where?.call(PlannerPreferences.t),
      orderBy: orderBy?.call(PlannerPreferences.t),
      orderByList: orderByList?.call(PlannerPreferences.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PlannerPreferences] by its [id] or null if no such row exists.
  Future<PlannerPreferences?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PlannerPreferences>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PlannerPreferences]s in the list and returns the inserted rows.
  ///
  /// The returned [PlannerPreferences]s will have their `id` fields set.
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
  Future<List<PlannerPreferences>> insert(
    _is.DatabaseSession session,
    List<PlannerPreferences> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PlannerPreferences>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PlannerPreferences] and returns the inserted row.
  ///
  /// The returned [PlannerPreferences] will have its `id` field set.
  Future<PlannerPreferences> insertRow(
    _is.DatabaseSession session,
    PlannerPreferences row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PlannerPreferences>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PlannerPreferences]s in the list and returns the resulting rows.
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
  /// The returned [PlannerPreferences]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlannerPreferences>> upsert(
    _is.DatabaseSession session,
    List<PlannerPreferences> rows, {
    required _is.ColumnSelections<PlannerPreferencesTable> conflictColumns,
    _is.ColumnSelections<PlannerPreferencesTable>? updateColumns,
    _is.WhereExpressionBuilder<PlannerPreferencesTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PlannerPreferences>(
      rows,
      conflictColumns: conflictColumns(PlannerPreferences.t),
      updateColumns: updateColumns?.call(PlannerPreferences.t),
      updateWhere: updateWhere?.call(PlannerPreferences.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PlannerPreferences] and returns the resulting row.
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
  /// The returned [PlannerPreferences] will have its `id` field set.
  Future<PlannerPreferences?> upsertRow(
    _is.DatabaseSession session,
    PlannerPreferences row, {
    required _is.ColumnSelections<PlannerPreferencesTable> conflictColumns,
    _is.ColumnSelections<PlannerPreferencesTable>? updateColumns,
    _is.WhereExpressionBuilder<PlannerPreferencesTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PlannerPreferences>(
      row,
      conflictColumns: conflictColumns(PlannerPreferences.t),
      updateColumns: updateColumns?.call(PlannerPreferences.t),
      updateWhere: updateWhere?.call(PlannerPreferences.t),
      transaction: transaction,
    );
  }

  /// Updates all [PlannerPreferences]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlannerPreferences>> update(
    _is.DatabaseSession session,
    List<PlannerPreferences> rows, {
    _is.ColumnSelections<PlannerPreferencesTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PlannerPreferences>(
      rows,
      columns: columns?.call(PlannerPreferences.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PlannerPreferences]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PlannerPreferences> updateRow(
    _is.DatabaseSession session,
    PlannerPreferences row, {
    _is.ColumnSelections<PlannerPreferencesTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PlannerPreferences>(
      row,
      columns: columns?.call(PlannerPreferences.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PlannerPreferences] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PlannerPreferences?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PlannerPreferencesUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PlannerPreferences>(
      id,
      columnValues: columnValues(PlannerPreferences.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PlannerPreferences]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlannerPreferences>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PlannerPreferencesUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<PlannerPreferencesTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlannerPreferencesTable>? orderBy,
    _is.OrderByListBuilder<PlannerPreferencesTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PlannerPreferences>(
      columnValues: columnValues(PlannerPreferences.t.updateTable),
      where: where(PlannerPreferences.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlannerPreferences.t),
      orderByList: orderByList?.call(PlannerPreferences.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PlannerPreferences]s in the list and returns the deleted rows.
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
  Future<List<PlannerPreferences>> delete(
    _is.DatabaseSession session,
    List<PlannerPreferences> rows, {
    _is.OrderByBuilder<PlannerPreferencesTable>? orderBy,
    _is.OrderByListBuilder<PlannerPreferencesTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PlannerPreferences>(
      rows,
      orderBy: orderBy?.call(PlannerPreferences.t),
      orderByList: orderByList?.call(PlannerPreferences.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PlannerPreferences].
  Future<PlannerPreferences> deleteRow(
    _is.DatabaseSession session,
    PlannerPreferences row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PlannerPreferences>(
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
  Future<List<PlannerPreferences>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PlannerPreferencesTable> where,
    _is.OrderByBuilder<PlannerPreferencesTable>? orderBy,
    _is.OrderByListBuilder<PlannerPreferencesTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PlannerPreferences>(
      where: where(PlannerPreferences.t),
      orderBy: orderBy?.call(PlannerPreferences.t),
      orderByList: orderByList?.call(PlannerPreferences.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlannerPreferencesTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PlannerPreferences>(
      where: where?.call(PlannerPreferences.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PlannerPreferences] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PlannerPreferencesTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PlannerPreferences>(
      where: where(PlannerPreferences.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
