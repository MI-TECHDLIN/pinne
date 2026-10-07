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
import '../ai/ai_processing_state.dart' as _isczc8jm;

/// Durable idempotency record for the at-least-once future call.
abstract class AiOrganizeTask
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AiOrganizeTask._({
    this.id,
    required this.ownerId,
    required this.itemId,
    _isczc8jm.AiProcessingState? state,
    int? requestedVersion,
    int? processedVersion,
    bool? dailySlotClaimed,
    this.quotaDateKey,
    this.claimedAt,
    this.completedAt,
    this.provider,
  }) : state = state ?? _isczc8jm.AiProcessingState.queued,
       requestedVersion = requestedVersion ?? 1,
       processedVersion = processedVersion ?? 0,
       dailySlotClaimed = dailySlotClaimed ?? false;

  factory AiOrganizeTask({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    _isczc8jm.AiProcessingState? state,
    int? requestedVersion,
    int? processedVersion,
    bool? dailySlotClaimed,
    String? quotaDateKey,
    DateTime? claimedAt,
    DateTime? completedAt,
    String? provider,
  }) = _AiOrganizeTaskImpl;

  factory AiOrganizeTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiOrganizeTask(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      state: jsonSerialization['state'] == null
          ? null
          : _isczc8jm.AiProcessingState.fromJson(
              (jsonSerialization['state'] as String),
            ),
      requestedVersion: jsonSerialization['requestedVersion'] as int?,
      processedVersion: jsonSerialization['processedVersion'] as int?,
      dailySlotClaimed: jsonSerialization['dailySlotClaimed'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['dailySlotClaimed'],
            ),
      quotaDateKey: jsonSerialization['quotaDateKey'] as String?,
      claimedAt: jsonSerialization['claimedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['claimedAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      provider: jsonSerialization['provider'] as String?,
    );
  }

  static final t = AiOrganizeTaskTable();

  static const db = AiOrganizeTaskRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue itemId;

  _isczc8jm.AiProcessingState state;

  int requestedVersion;

  int processedVersion;

  bool dailySlotClaimed;

  String? quotaDateKey;

  DateTime? claimedAt;

  DateTime? completedAt;

  String? provider;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AiOrganizeTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiOrganizeTask copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    _isczc8jm.AiProcessingState? state,
    int? requestedVersion,
    int? processedVersion,
    bool? dailySlotClaimed,
    String? quotaDateKey,
    DateTime? claimedAt,
    DateTime? completedAt,
    String? provider,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiOrganizeTask',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'state': state.toJson(),
      'requestedVersion': requestedVersion,
      'processedVersion': processedVersion,
      'dailySlotClaimed': dailySlotClaimed,
      if (quotaDateKey != null) 'quotaDateKey': quotaDateKey,
      if (claimedAt != null) 'claimedAt': claimedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (provider != null) 'provider': provider,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiOrganizeTask',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'state': state.toJson(),
      'requestedVersion': requestedVersion,
      'processedVersion': processedVersion,
      'dailySlotClaimed': dailySlotClaimed,
      if (quotaDateKey != null) 'quotaDateKey': quotaDateKey,
      if (claimedAt != null) 'claimedAt': claimedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (provider != null) 'provider': provider,
    };
  }

  static AiOrganizeTaskInclude include() {
    return AiOrganizeTaskInclude._();
  }

  static AiOrganizeTaskIncludeList includeList({
    _is.WhereExpressionBuilder<AiOrganizeTaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiOrganizeTaskTable>? orderBy,
    _is.OrderByListBuilder<AiOrganizeTaskTable>? orderByList,
    AiOrganizeTaskInclude? include,
  }) {
    return AiOrganizeTaskIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiOrganizeTask.t),
      orderByList: orderByList?.call(AiOrganizeTask.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiOrganizeTaskImpl extends AiOrganizeTask {
  _AiOrganizeTaskImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    _isczc8jm.AiProcessingState? state,
    int? requestedVersion,
    int? processedVersion,
    bool? dailySlotClaimed,
    String? quotaDateKey,
    DateTime? claimedAt,
    DateTime? completedAt,
    String? provider,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         state: state,
         requestedVersion: requestedVersion,
         processedVersion: processedVersion,
         dailySlotClaimed: dailySlotClaimed,
         quotaDateKey: quotaDateKey,
         claimedAt: claimedAt,
         completedAt: completedAt,
         provider: provider,
       );

  /// Returns a shallow copy of this [AiOrganizeTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiOrganizeTask copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    _isczc8jm.AiProcessingState? state,
    int? requestedVersion,
    int? processedVersion,
    bool? dailySlotClaimed,
    Object? quotaDateKey = _Undefined,
    Object? claimedAt = _Undefined,
    Object? completedAt = _Undefined,
    Object? provider = _Undefined,
  }) {
    return AiOrganizeTask(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      state: state ?? this.state,
      requestedVersion: requestedVersion ?? this.requestedVersion,
      processedVersion: processedVersion ?? this.processedVersion,
      dailySlotClaimed: dailySlotClaimed ?? this.dailySlotClaimed,
      quotaDateKey: quotaDateKey is String? ? quotaDateKey : this.quotaDateKey,
      claimedAt: claimedAt is DateTime? ? claimedAt : this.claimedAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      provider: provider is String? ? provider : this.provider,
    );
  }
}

class AiOrganizeTaskUpdateTable extends _is.UpdateTable<AiOrganizeTaskTable> {
  AiOrganizeTaskUpdateTable(super.table);

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

  _is.ColumnValue<_isczc8jm.AiProcessingState, _isczc8jm.AiProcessingState>
  state(_isczc8jm.AiProcessingState value) => _is.ColumnValue(
    table.state,
    value,
  );

  _is.ColumnValue<int, int> requestedVersion(int value) => _is.ColumnValue(
    table.requestedVersion,
    value,
  );

  _is.ColumnValue<int, int> processedVersion(int value) => _is.ColumnValue(
    table.processedVersion,
    value,
  );

  _is.ColumnValue<bool, bool> dailySlotClaimed(bool value) => _is.ColumnValue(
    table.dailySlotClaimed,
    value,
  );

  _is.ColumnValue<String, String> quotaDateKey(String? value) =>
      _is.ColumnValue(
        table.quotaDateKey,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> claimedAt(DateTime? value) =>
      _is.ColumnValue(
        table.claimedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _is.ColumnValue(
        table.completedAt,
        value,
      );

  _is.ColumnValue<String, String> provider(String? value) => _is.ColumnValue(
    table.provider,
    value,
  );
}

class AiOrganizeTaskTable extends _is.Table<_is.UuidValue?> {
  AiOrganizeTaskTable({super.tableRelation})
    : super(tableName: 'ai_organize_task') {
    updateTable = AiOrganizeTaskUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    itemId = _is.ColumnUuid(
      'itemId',
      this,
    );
    state = _is.ColumnEnum(
      'state',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    requestedVersion = _is.ColumnInt(
      'requestedVersion',
      this,
      hasDefault: true,
    );
    processedVersion = _is.ColumnInt(
      'processedVersion',
      this,
      hasDefault: true,
    );
    dailySlotClaimed = _is.ColumnBool(
      'dailySlotClaimed',
      this,
      hasDefault: true,
    );
    quotaDateKey = _is.ColumnString(
      'quotaDateKey',
      this,
    );
    claimedAt = _is.ColumnDateTime(
      'claimedAt',
      this,
    );
    completedAt = _is.ColumnDateTime(
      'completedAt',
      this,
    );
    provider = _is.ColumnString(
      'provider',
      this,
    );
  }

  late final AiOrganizeTaskUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid itemId;

  late final _is.ColumnEnum<_isczc8jm.AiProcessingState> state;

  late final _is.ColumnInt requestedVersion;

  late final _is.ColumnInt processedVersion;

  late final _is.ColumnBool dailySlotClaimed;

  late final _is.ColumnString quotaDateKey;

  late final _is.ColumnDateTime claimedAt;

  late final _is.ColumnDateTime completedAt;

  late final _is.ColumnString provider;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    itemId,
    state,
    requestedVersion,
    processedVersion,
    dailySlotClaimed,
    quotaDateKey,
    claimedAt,
    completedAt,
    provider,
  ];
}

class AiOrganizeTaskInclude extends _is.IncludeObject {
  AiOrganizeTaskInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => AiOrganizeTask.t;
}

class AiOrganizeTaskIncludeList extends _is.IncludeList {
  AiOrganizeTaskIncludeList._({
    _is.WhereExpressionBuilder<AiOrganizeTaskTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AiOrganizeTask.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AiOrganizeTask.t;
}

class AiOrganizeTaskRepository {
  const AiOrganizeTaskRepository._();

  /// Returns a list of [AiOrganizeTask]s matching the given query parameters.
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
  Future<List<AiOrganizeTask>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiOrganizeTaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiOrganizeTaskTable>? orderBy,
    _is.OrderByListBuilder<AiOrganizeTaskTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AiOrganizeTask>(
      where: where?.call(AiOrganizeTask.t),
      orderBy: orderBy?.call(AiOrganizeTask.t),
      orderByList: orderByList?.call(AiOrganizeTask.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AiOrganizeTask] matching the given query parameters.
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
  Future<AiOrganizeTask?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiOrganizeTaskTable>? where,
    int? offset,
    _is.OrderByBuilder<AiOrganizeTaskTable>? orderBy,
    _is.OrderByListBuilder<AiOrganizeTaskTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AiOrganizeTask>(
      where: where?.call(AiOrganizeTask.t),
      orderBy: orderBy?.call(AiOrganizeTask.t),
      orderByList: orderByList?.call(AiOrganizeTask.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AiOrganizeTask] by its [id] or null if no such row exists.
  Future<AiOrganizeTask?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AiOrganizeTask>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AiOrganizeTask]s in the list and returns the inserted rows.
  ///
  /// The returned [AiOrganizeTask]s will have their `id` fields set.
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
  Future<List<AiOrganizeTask>> insert(
    _is.DatabaseSession session,
    List<AiOrganizeTask> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AiOrganizeTask>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AiOrganizeTask] and returns the inserted row.
  ///
  /// The returned [AiOrganizeTask] will have its `id` field set.
  Future<AiOrganizeTask> insertRow(
    _is.DatabaseSession session,
    AiOrganizeTask row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AiOrganizeTask>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AiOrganizeTask]s in the list and returns the resulting rows.
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
  /// The returned [AiOrganizeTask]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiOrganizeTask>> upsert(
    _is.DatabaseSession session,
    List<AiOrganizeTask> rows, {
    required _is.ColumnSelections<AiOrganizeTaskTable> conflictColumns,
    _is.ColumnSelections<AiOrganizeTaskTable>? updateColumns,
    _is.WhereExpressionBuilder<AiOrganizeTaskTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AiOrganizeTask>(
      rows,
      conflictColumns: conflictColumns(AiOrganizeTask.t),
      updateColumns: updateColumns?.call(AiOrganizeTask.t),
      updateWhere: updateWhere?.call(AiOrganizeTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AiOrganizeTask] and returns the resulting row.
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
  /// The returned [AiOrganizeTask] will have its `id` field set.
  Future<AiOrganizeTask?> upsertRow(
    _is.DatabaseSession session,
    AiOrganizeTask row, {
    required _is.ColumnSelections<AiOrganizeTaskTable> conflictColumns,
    _is.ColumnSelections<AiOrganizeTaskTable>? updateColumns,
    _is.WhereExpressionBuilder<AiOrganizeTaskTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AiOrganizeTask>(
      row,
      conflictColumns: conflictColumns(AiOrganizeTask.t),
      updateColumns: updateColumns?.call(AiOrganizeTask.t),
      updateWhere: updateWhere?.call(AiOrganizeTask.t),
      transaction: transaction,
    );
  }

  /// Updates all [AiOrganizeTask]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiOrganizeTask>> update(
    _is.DatabaseSession session,
    List<AiOrganizeTask> rows, {
    _is.ColumnSelections<AiOrganizeTaskTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AiOrganizeTask>(
      rows,
      columns: columns?.call(AiOrganizeTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AiOrganizeTask]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AiOrganizeTask> updateRow(
    _is.DatabaseSession session,
    AiOrganizeTask row, {
    _is.ColumnSelections<AiOrganizeTaskTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AiOrganizeTask>(
      row,
      columns: columns?.call(AiOrganizeTask.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiOrganizeTask] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AiOrganizeTask?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AiOrganizeTaskUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AiOrganizeTask>(
      id,
      columnValues: columnValues(AiOrganizeTask.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AiOrganizeTask]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiOrganizeTask>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AiOrganizeTaskUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AiOrganizeTaskTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiOrganizeTaskTable>? orderBy,
    _is.OrderByListBuilder<AiOrganizeTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AiOrganizeTask>(
      columnValues: columnValues(AiOrganizeTask.t.updateTable),
      where: where(AiOrganizeTask.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiOrganizeTask.t),
      orderByList: orderByList?.call(AiOrganizeTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AiOrganizeTask]s in the list and returns the deleted rows.
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
  Future<List<AiOrganizeTask>> delete(
    _is.DatabaseSession session,
    List<AiOrganizeTask> rows, {
    _is.OrderByBuilder<AiOrganizeTaskTable>? orderBy,
    _is.OrderByListBuilder<AiOrganizeTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AiOrganizeTask>(
      rows,
      orderBy: orderBy?.call(AiOrganizeTask.t),
      orderByList: orderByList?.call(AiOrganizeTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AiOrganizeTask].
  Future<AiOrganizeTask> deleteRow(
    _is.DatabaseSession session,
    AiOrganizeTask row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AiOrganizeTask>(
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
  Future<List<AiOrganizeTask>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiOrganizeTaskTable> where,
    _is.OrderByBuilder<AiOrganizeTaskTable>? orderBy,
    _is.OrderByListBuilder<AiOrganizeTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AiOrganizeTask>(
      where: where(AiOrganizeTask.t),
      orderBy: orderBy?.call(AiOrganizeTask.t),
      orderByList: orderByList?.call(AiOrganizeTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiOrganizeTaskTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AiOrganizeTask>(
      where: where?.call(AiOrganizeTask.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AiOrganizeTask] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiOrganizeTaskTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AiOrganizeTask>(
      where: where(AiOrganizeTask.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
