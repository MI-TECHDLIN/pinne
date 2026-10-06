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
import '../planning/calendar_coverage.dart' as _ip3capvs;

/// One proposal of review sessions, with the availability it was based on.
abstract class ReviewPlan
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ReviewPlan._({
    this.id,
    required this.ownerId,
    DateTime? createdAt,
    required this.horizonStart,
    required this.horizonEnd,
    required this.timezone,
    required this.coverage,
    required this.availabilityVerified,
    this.commitOperationId,
    this.committedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ReviewPlan({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    DateTime? createdAt,
    required DateTime horizonStart,
    required DateTime horizonEnd,
    required String timezone,
    required List<_ip3capvs.CalendarCoverage> coverage,
    required bool availabilityVerified,
    _is.UuidValue? commitOperationId,
    DateTime? committedAt,
  }) = _ReviewPlanImpl;

  factory ReviewPlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewPlan(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      horizonStart: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['horizonStart'],
      ),
      horizonEnd: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['horizonEnd'],
      ),
      timezone: jsonSerialization['timezone'] as String,
      coverage: _i2yoimhd.Protocol()
          .deserialize<List<_ip3capvs.CalendarCoverage>>(
            jsonSerialization['coverage'],
          ),
      availabilityVerified: _is.BoolJsonExtension.fromJson(
        jsonSerialization['availabilityVerified'],
      ),
      commitOperationId: jsonSerialization['commitOperationId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['commitOperationId'],
            ),
      committedAt: jsonSerialization['committedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['committedAt'],
            ),
    );
  }

  static final t = ReviewPlanTable();

  static const db = ReviewPlanRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  DateTime createdAt;

  DateTime horizonStart;

  DateTime horizonEnd;

  String timezone;

  List<_ip3capvs.CalendarCoverage> coverage;

  /// True only when every conflict calendar was checked recently.
  bool availabilityVerified;

  /// Set once accepted; a retry with the same id replays the result.
  _is.UuidValue? commitOperationId;

  DateTime? committedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ReviewPlan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReviewPlan copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    DateTime? createdAt,
    DateTime? horizonStart,
    DateTime? horizonEnd,
    String? timezone,
    List<_ip3capvs.CalendarCoverage>? coverage,
    bool? availabilityVerified,
    _is.UuidValue? commitOperationId,
    DateTime? committedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewPlan',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'createdAt': createdAt.toJson(),
      'horizonStart': horizonStart.toJson(),
      'horizonEnd': horizonEnd.toJson(),
      'timezone': timezone,
      'coverage': coverage.toJson(valueToJson: (v) => v.toJson()),
      'availabilityVerified': availabilityVerified,
      if (commitOperationId != null)
        'commitOperationId': commitOperationId?.toJson(),
      if (committedAt != null) 'committedAt': committedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewPlan',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'createdAt': createdAt.toJson(),
      'horizonStart': horizonStart.toJson(),
      'horizonEnd': horizonEnd.toJson(),
      'timezone': timezone,
      'coverage': coverage.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'availabilityVerified': availabilityVerified,
      if (commitOperationId != null)
        'commitOperationId': commitOperationId?.toJson(),
      if (committedAt != null) 'committedAt': committedAt?.toJson(),
    };
  }

  static ReviewPlanInclude include() {
    return ReviewPlanInclude._();
  }

  static ReviewPlanIncludeList includeList({
    _is.WhereExpressionBuilder<ReviewPlanTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewPlanTable>? orderBy,
    _is.OrderByListBuilder<ReviewPlanTable>? orderByList,
    ReviewPlanInclude? include,
  }) {
    return ReviewPlanIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewPlan.t),
      orderByList: orderByList?.call(ReviewPlan.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewPlanImpl extends ReviewPlan {
  _ReviewPlanImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    DateTime? createdAt,
    required DateTime horizonStart,
    required DateTime horizonEnd,
    required String timezone,
    required List<_ip3capvs.CalendarCoverage> coverage,
    required bool availabilityVerified,
    _is.UuidValue? commitOperationId,
    DateTime? committedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         createdAt: createdAt,
         horizonStart: horizonStart,
         horizonEnd: horizonEnd,
         timezone: timezone,
         coverage: coverage,
         availabilityVerified: availabilityVerified,
         commitOperationId: commitOperationId,
         committedAt: committedAt,
       );

  /// Returns a shallow copy of this [ReviewPlan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReviewPlan copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    DateTime? createdAt,
    DateTime? horizonStart,
    DateTime? horizonEnd,
    String? timezone,
    List<_ip3capvs.CalendarCoverage>? coverage,
    bool? availabilityVerified,
    Object? commitOperationId = _Undefined,
    Object? committedAt = _Undefined,
  }) {
    return ReviewPlan(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      horizonStart: horizonStart ?? this.horizonStart,
      horizonEnd: horizonEnd ?? this.horizonEnd,
      timezone: timezone ?? this.timezone,
      coverage: coverage ?? this.coverage.map((e0) => e0.copyWith()).toList(),
      availabilityVerified: availabilityVerified ?? this.availabilityVerified,
      commitOperationId: commitOperationId is _is.UuidValue?
          ? commitOperationId
          : this.commitOperationId,
      committedAt: committedAt is DateTime? ? committedAt : this.committedAt,
    );
  }
}

class ReviewPlanUpdateTable extends _is.UpdateTable<ReviewPlanTable> {
  ReviewPlanUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> horizonStart(DateTime value) =>
      _is.ColumnValue(
        table.horizonStart,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> horizonEnd(DateTime value) =>
      _is.ColumnValue(
        table.horizonEnd,
        value,
      );

  _is.ColumnValue<String, String> timezone(String value) => _is.ColumnValue(
    table.timezone,
    value,
  );

  _is.ColumnValue<
    List<_ip3capvs.CalendarCoverage>,
    List<_ip3capvs.CalendarCoverage>
  >
  coverage(List<_ip3capvs.CalendarCoverage> value) => _is.ColumnValue(
    table.coverage,
    value,
  );

  _is.ColumnValue<bool, bool> availabilityVerified(bool value) =>
      _is.ColumnValue(
        table.availabilityVerified,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> commitOperationId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.commitOperationId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> committedAt(DateTime? value) =>
      _is.ColumnValue(
        table.committedAt,
        value,
      );
}

class ReviewPlanTable extends _is.Table<_is.UuidValue?> {
  ReviewPlanTable({super.tableRelation}) : super(tableName: 'review_plan') {
    updateTable = ReviewPlanUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    horizonStart = _is.ColumnDateTime(
      'horizonStart',
      this,
    );
    horizonEnd = _is.ColumnDateTime(
      'horizonEnd',
      this,
    );
    timezone = _is.ColumnString(
      'timezone',
      this,
    );
    coverage = _is.ColumnSerializable<List<_ip3capvs.CalendarCoverage>>(
      'coverage',
      this,
    );
    availabilityVerified = _is.ColumnBool(
      'availabilityVerified',
      this,
    );
    commitOperationId = _is.ColumnUuid(
      'commitOperationId',
      this,
    );
    committedAt = _is.ColumnDateTime(
      'committedAt',
      this,
    );
  }

  late final ReviewPlanUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime horizonStart;

  late final _is.ColumnDateTime horizonEnd;

  late final _is.ColumnString timezone;

  late final _is.ColumnSerializable<List<_ip3capvs.CalendarCoverage>> coverage;

  /// True only when every conflict calendar was checked recently.
  late final _is.ColumnBool availabilityVerified;

  /// Set once accepted; a retry with the same id replays the result.
  late final _is.ColumnUuid commitOperationId;

  late final _is.ColumnDateTime committedAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    createdAt,
    horizonStart,
    horizonEnd,
    timezone,
    coverage,
    availabilityVerified,
    commitOperationId,
    committedAt,
  ];
}

class ReviewPlanInclude extends _is.IncludeObject {
  ReviewPlanInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ReviewPlan.t;
}

class ReviewPlanIncludeList extends _is.IncludeList {
  ReviewPlanIncludeList._({
    _is.WhereExpressionBuilder<ReviewPlanTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReviewPlan.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ReviewPlan.t;
}

class ReviewPlanRepository {
  const ReviewPlanRepository._();

  /// Returns a list of [ReviewPlan]s matching the given query parameters.
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
  Future<List<ReviewPlan>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewPlanTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewPlanTable>? orderBy,
    _is.OrderByListBuilder<ReviewPlanTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReviewPlan>(
      where: where?.call(ReviewPlan.t),
      orderBy: orderBy?.call(ReviewPlan.t),
      orderByList: orderByList?.call(ReviewPlan.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReviewPlan] matching the given query parameters.
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
  Future<ReviewPlan?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewPlanTable>? where,
    int? offset,
    _is.OrderByBuilder<ReviewPlanTable>? orderBy,
    _is.OrderByListBuilder<ReviewPlanTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReviewPlan>(
      where: where?.call(ReviewPlan.t),
      orderBy: orderBy?.call(ReviewPlan.t),
      orderByList: orderByList?.call(ReviewPlan.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReviewPlan] by its [id] or null if no such row exists.
  Future<ReviewPlan?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReviewPlan>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReviewPlan]s in the list and returns the inserted rows.
  ///
  /// The returned [ReviewPlan]s will have their `id` fields set.
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
  Future<List<ReviewPlan>> insert(
    _is.DatabaseSession session,
    List<ReviewPlan> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReviewPlan>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReviewPlan] and returns the inserted row.
  ///
  /// The returned [ReviewPlan] will have its `id` field set.
  Future<ReviewPlan> insertRow(
    _is.DatabaseSession session,
    ReviewPlan row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReviewPlan>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReviewPlan]s in the list and returns the resulting rows.
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
  /// The returned [ReviewPlan]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewPlan>> upsert(
    _is.DatabaseSession session,
    List<ReviewPlan> rows, {
    required _is.ColumnSelections<ReviewPlanTable> conflictColumns,
    _is.ColumnSelections<ReviewPlanTable>? updateColumns,
    _is.WhereExpressionBuilder<ReviewPlanTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReviewPlan>(
      rows,
      conflictColumns: conflictColumns(ReviewPlan.t),
      updateColumns: updateColumns?.call(ReviewPlan.t),
      updateWhere: updateWhere?.call(ReviewPlan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReviewPlan] and returns the resulting row.
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
  /// The returned [ReviewPlan] will have its `id` field set.
  Future<ReviewPlan?> upsertRow(
    _is.DatabaseSession session,
    ReviewPlan row, {
    required _is.ColumnSelections<ReviewPlanTable> conflictColumns,
    _is.ColumnSelections<ReviewPlanTable>? updateColumns,
    _is.WhereExpressionBuilder<ReviewPlanTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReviewPlan>(
      row,
      conflictColumns: conflictColumns(ReviewPlan.t),
      updateColumns: updateColumns?.call(ReviewPlan.t),
      updateWhere: updateWhere?.call(ReviewPlan.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewPlan]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewPlan>> update(
    _is.DatabaseSession session,
    List<ReviewPlan> rows, {
    _is.ColumnSelections<ReviewPlanTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReviewPlan>(
      rows,
      columns: columns?.call(ReviewPlan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReviewPlan]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReviewPlan> updateRow(
    _is.DatabaseSession session,
    ReviewPlan row, {
    _is.ColumnSelections<ReviewPlanTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReviewPlan>(
      row,
      columns: columns?.call(ReviewPlan.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReviewPlan] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReviewPlan?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ReviewPlanUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReviewPlan>(
      id,
      columnValues: columnValues(ReviewPlan.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewPlan]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewPlan>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReviewPlanUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ReviewPlanTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewPlanTable>? orderBy,
    _is.OrderByListBuilder<ReviewPlanTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReviewPlan>(
      columnValues: columnValues(ReviewPlan.t.updateTable),
      where: where(ReviewPlan.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewPlan.t),
      orderByList: orderByList?.call(ReviewPlan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReviewPlan]s in the list and returns the deleted rows.
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
  Future<List<ReviewPlan>> delete(
    _is.DatabaseSession session,
    List<ReviewPlan> rows, {
    _is.OrderByBuilder<ReviewPlanTable>? orderBy,
    _is.OrderByListBuilder<ReviewPlanTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReviewPlan>(
      rows,
      orderBy: orderBy?.call(ReviewPlan.t),
      orderByList: orderByList?.call(ReviewPlan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReviewPlan].
  Future<ReviewPlan> deleteRow(
    _is.DatabaseSession session,
    ReviewPlan row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReviewPlan>(
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
  Future<List<ReviewPlan>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReviewPlanTable> where,
    _is.OrderByBuilder<ReviewPlanTable>? orderBy,
    _is.OrderByListBuilder<ReviewPlanTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReviewPlan>(
      where: where(ReviewPlan.t),
      orderBy: orderBy?.call(ReviewPlan.t),
      orderByList: orderByList?.call(ReviewPlan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewPlanTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReviewPlan>(
      where: where?.call(ReviewPlan.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReviewPlan] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReviewPlanTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReviewPlan>(
      where: where(ReviewPlan.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
