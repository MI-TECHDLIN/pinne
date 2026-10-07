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
import '../planning/approval_mode.dart' as _i6o5tozv;
import '../planning/session_status.dart' as _ikijcapq;

/// A planned block of review time. Its calendar event is a separate link;
/// an elapsed session does not mean its items were reviewed.
abstract class ReviewSession
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ReviewSession._({
    this.id,
    required this.ownerId,
    this.planId,
    required this.startAt,
    required this.endAt,
    required this.timezone,
    required this.status,
    required this.schedulingMode,
    required this.availabilityVerified,
    int? planRevision,
    this.lastOperationId,
    DateTime? createdAt,
  }) : planRevision = planRevision ?? 1,
       createdAt = createdAt ?? DateTime.now();

  factory ReviewSession({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    _is.UuidValue? planId,
    required DateTime startAt,
    required DateTime endAt,
    required String timezone,
    required _ikijcapq.SessionStatus status,
    required _i6o5tozv.ApprovalMode schedulingMode,
    required bool availabilityVerified,
    int? planRevision,
    _is.UuidValue? lastOperationId,
    DateTime? createdAt,
  }) = _ReviewSessionImpl;

  factory ReviewSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewSession(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      planId: jsonSerialization['planId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['planId']),
      startAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['startAt']),
      endAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      timezone: jsonSerialization['timezone'] as String,
      status: _ikijcapq.SessionStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      schedulingMode: _i6o5tozv.ApprovalMode.fromJson(
        (jsonSerialization['schedulingMode'] as String),
      ),
      availabilityVerified: _is.BoolJsonExtension.fromJson(
        jsonSerialization['availabilityVerified'],
      ),
      planRevision: jsonSerialization['planRevision'] as int?,
      lastOperationId: jsonSerialization['lastOperationId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['lastOperationId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ReviewSessionTable();

  static const db = ReviewSessionRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue? planId;

  DateTime startAt;

  DateTime endAt;

  String timezone;

  _ikijcapq.SessionStatus status;

  _i6o5tozv.ApprovalMode schedulingMode;

  /// False when the user kept it without a calendar check.
  bool availabilityVerified;

  /// Bumped on every move.
  int planRevision;

  /// The last move or cancel, so a retry is answered without repeating it.
  _is.UuidValue? lastOperationId;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ReviewSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReviewSession copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? planId,
    DateTime? startAt,
    DateTime? endAt,
    String? timezone,
    _ikijcapq.SessionStatus? status,
    _i6o5tozv.ApprovalMode? schedulingMode,
    bool? availabilityVerified,
    int? planRevision,
    _is.UuidValue? lastOperationId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewSession',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      if (planId != null) 'planId': planId?.toJson(),
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'timezone': timezone,
      'status': status.toJson(),
      'schedulingMode': schedulingMode.toJson(),
      'availabilityVerified': availabilityVerified,
      'planRevision': planRevision,
      if (lastOperationId != null) 'lastOperationId': lastOperationId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewSession',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      if (planId != null) 'planId': planId?.toJson(),
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'timezone': timezone,
      'status': status.toJson(),
      'schedulingMode': schedulingMode.toJson(),
      'availabilityVerified': availabilityVerified,
      'planRevision': planRevision,
      if (lastOperationId != null) 'lastOperationId': lastOperationId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static ReviewSessionInclude include() {
    return ReviewSessionInclude._();
  }

  static ReviewSessionIncludeList includeList({
    _is.WhereExpressionBuilder<ReviewSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewSessionTable>? orderBy,
    _is.OrderByListBuilder<ReviewSessionTable>? orderByList,
    ReviewSessionInclude? include,
  }) {
    return ReviewSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewSession.t),
      orderByList: orderByList?.call(ReviewSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewSessionImpl extends ReviewSession {
  _ReviewSessionImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    _is.UuidValue? planId,
    required DateTime startAt,
    required DateTime endAt,
    required String timezone,
    required _ikijcapq.SessionStatus status,
    required _i6o5tozv.ApprovalMode schedulingMode,
    required bool availabilityVerified,
    int? planRevision,
    _is.UuidValue? lastOperationId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         planId: planId,
         startAt: startAt,
         endAt: endAt,
         timezone: timezone,
         status: status,
         schedulingMode: schedulingMode,
         availabilityVerified: availabilityVerified,
         planRevision: planRevision,
         lastOperationId: lastOperationId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReviewSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReviewSession copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    Object? planId = _Undefined,
    DateTime? startAt,
    DateTime? endAt,
    String? timezone,
    _ikijcapq.SessionStatus? status,
    _i6o5tozv.ApprovalMode? schedulingMode,
    bool? availabilityVerified,
    int? planRevision,
    Object? lastOperationId = _Undefined,
    DateTime? createdAt,
  }) {
    return ReviewSession(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      planId: planId is _is.UuidValue? ? planId : this.planId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      timezone: timezone ?? this.timezone,
      status: status ?? this.status,
      schedulingMode: schedulingMode ?? this.schedulingMode,
      availabilityVerified: availabilityVerified ?? this.availabilityVerified,
      planRevision: planRevision ?? this.planRevision,
      lastOperationId: lastOperationId is _is.UuidValue?
          ? lastOperationId
          : this.lastOperationId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReviewSessionUpdateTable extends _is.UpdateTable<ReviewSessionTable> {
  ReviewSessionUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> planId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.planId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> startAt(DateTime value) =>
      _is.ColumnValue(
        table.startAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endAt(DateTime value) => _is.ColumnValue(
    table.endAt,
    value,
  );

  _is.ColumnValue<String, String> timezone(String value) => _is.ColumnValue(
    table.timezone,
    value,
  );

  _is.ColumnValue<_ikijcapq.SessionStatus, _ikijcapq.SessionStatus> status(
    _ikijcapq.SessionStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<_i6o5tozv.ApprovalMode, _i6o5tozv.ApprovalMode>
  schedulingMode(_i6o5tozv.ApprovalMode value) => _is.ColumnValue(
    table.schedulingMode,
    value,
  );

  _is.ColumnValue<bool, bool> availabilityVerified(bool value) =>
      _is.ColumnValue(
        table.availabilityVerified,
        value,
      );

  _is.ColumnValue<int, int> planRevision(int value) => _is.ColumnValue(
    table.planRevision,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> lastOperationId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.lastOperationId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ReviewSessionTable extends _is.Table<_is.UuidValue?> {
  ReviewSessionTable({super.tableRelation})
    : super(tableName: 'review_session') {
    updateTable = ReviewSessionUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    planId = _is.ColumnUuid(
      'planId',
      this,
    );
    startAt = _is.ColumnDateTime(
      'startAt',
      this,
    );
    endAt = _is.ColumnDateTime(
      'endAt',
      this,
    );
    timezone = _is.ColumnString(
      'timezone',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    schedulingMode = _is.ColumnEnum(
      'schedulingMode',
      this,
      _is.EnumSerialization.byName,
    );
    availabilityVerified = _is.ColumnBool(
      'availabilityVerified',
      this,
    );
    planRevision = _is.ColumnInt(
      'planRevision',
      this,
      hasDefault: true,
    );
    lastOperationId = _is.ColumnUuid(
      'lastOperationId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ReviewSessionUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid planId;

  late final _is.ColumnDateTime startAt;

  late final _is.ColumnDateTime endAt;

  late final _is.ColumnString timezone;

  late final _is.ColumnEnum<_ikijcapq.SessionStatus> status;

  late final _is.ColumnEnum<_i6o5tozv.ApprovalMode> schedulingMode;

  /// False when the user kept it without a calendar check.
  late final _is.ColumnBool availabilityVerified;

  /// Bumped on every move.
  late final _is.ColumnInt planRevision;

  /// The last move or cancel, so a retry is answered without repeating it.
  late final _is.ColumnUuid lastOperationId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    planId,
    startAt,
    endAt,
    timezone,
    status,
    schedulingMode,
    availabilityVerified,
    planRevision,
    lastOperationId,
    createdAt,
  ];
}

class ReviewSessionInclude extends _is.IncludeObject {
  ReviewSessionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ReviewSession.t;
}

class ReviewSessionIncludeList extends _is.IncludeList {
  ReviewSessionIncludeList._({
    _is.WhereExpressionBuilder<ReviewSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReviewSession.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ReviewSession.t;
}

class ReviewSessionRepository {
  const ReviewSessionRepository._();

  /// Returns a list of [ReviewSession]s matching the given query parameters.
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
  Future<List<ReviewSession>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewSessionTable>? orderBy,
    _is.OrderByListBuilder<ReviewSessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReviewSession>(
      where: where?.call(ReviewSession.t),
      orderBy: orderBy?.call(ReviewSession.t),
      orderByList: orderByList?.call(ReviewSession.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReviewSession] matching the given query parameters.
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
  Future<ReviewSession?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewSessionTable>? where,
    int? offset,
    _is.OrderByBuilder<ReviewSessionTable>? orderBy,
    _is.OrderByListBuilder<ReviewSessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReviewSession>(
      where: where?.call(ReviewSession.t),
      orderBy: orderBy?.call(ReviewSession.t),
      orderByList: orderByList?.call(ReviewSession.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReviewSession] by its [id] or null if no such row exists.
  Future<ReviewSession?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReviewSession>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReviewSession]s in the list and returns the inserted rows.
  ///
  /// The returned [ReviewSession]s will have their `id` fields set.
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
  Future<List<ReviewSession>> insert(
    _is.DatabaseSession session,
    List<ReviewSession> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReviewSession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReviewSession] and returns the inserted row.
  ///
  /// The returned [ReviewSession] will have its `id` field set.
  Future<ReviewSession> insertRow(
    _is.DatabaseSession session,
    ReviewSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReviewSession>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReviewSession]s in the list and returns the resulting rows.
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
  /// The returned [ReviewSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewSession>> upsert(
    _is.DatabaseSession session,
    List<ReviewSession> rows, {
    required _is.ColumnSelections<ReviewSessionTable> conflictColumns,
    _is.ColumnSelections<ReviewSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<ReviewSessionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReviewSession>(
      rows,
      conflictColumns: conflictColumns(ReviewSession.t),
      updateColumns: updateColumns?.call(ReviewSession.t),
      updateWhere: updateWhere?.call(ReviewSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReviewSession] and returns the resulting row.
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
  /// The returned [ReviewSession] will have its `id` field set.
  Future<ReviewSession?> upsertRow(
    _is.DatabaseSession session,
    ReviewSession row, {
    required _is.ColumnSelections<ReviewSessionTable> conflictColumns,
    _is.ColumnSelections<ReviewSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<ReviewSessionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReviewSession>(
      row,
      conflictColumns: conflictColumns(ReviewSession.t),
      updateColumns: updateColumns?.call(ReviewSession.t),
      updateWhere: updateWhere?.call(ReviewSession.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewSession>> update(
    _is.DatabaseSession session,
    List<ReviewSession> rows, {
    _is.ColumnSelections<ReviewSessionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReviewSession>(
      rows,
      columns: columns?.call(ReviewSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReviewSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReviewSession> updateRow(
    _is.DatabaseSession session,
    ReviewSession row, {
    _is.ColumnSelections<ReviewSessionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReviewSession>(
      row,
      columns: columns?.call(ReviewSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReviewSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReviewSession?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ReviewSessionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReviewSession>(
      id,
      columnValues: columnValues(ReviewSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewSession>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReviewSessionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ReviewSessionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewSessionTable>? orderBy,
    _is.OrderByListBuilder<ReviewSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReviewSession>(
      columnValues: columnValues(ReviewSession.t.updateTable),
      where: where(ReviewSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewSession.t),
      orderByList: orderByList?.call(ReviewSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReviewSession]s in the list and returns the deleted rows.
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
  Future<List<ReviewSession>> delete(
    _is.DatabaseSession session,
    List<ReviewSession> rows, {
    _is.OrderByBuilder<ReviewSessionTable>? orderBy,
    _is.OrderByListBuilder<ReviewSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReviewSession>(
      rows,
      orderBy: orderBy?.call(ReviewSession.t),
      orderByList: orderByList?.call(ReviewSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReviewSession].
  Future<ReviewSession> deleteRow(
    _is.DatabaseSession session,
    ReviewSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReviewSession>(
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
  Future<List<ReviewSession>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReviewSessionTable> where,
    _is.OrderByBuilder<ReviewSessionTable>? orderBy,
    _is.OrderByListBuilder<ReviewSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReviewSession>(
      where: where(ReviewSession.t),
      orderBy: orderBy?.call(ReviewSession.t),
      orderByList: orderByList?.call(ReviewSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewSessionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReviewSession>(
      where: where?.call(ReviewSession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReviewSession] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReviewSessionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReviewSession>(
      where: where(ReviewSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
