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
import '../reviews/review_event_type.dart' as _irtd71vd;

/// An immutable review fact. Progress is derived from these events; an undo is
/// a new event that points at the event it compensates.
abstract class ReviewEvent
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ReviewEvent._({
    this.id,
    required this.ownerId,
    required this.itemId,
    required this.eventType,
    required this.occurredAt,
    DateTime? receivedAt,
    required this.timezone,
    required this.effectiveLocalDate,
    this.compensatesEventId,
  }) : receivedAt = receivedAt ?? DateTime.now();

  factory ReviewEvent({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    required _irtd71vd.ReviewEventType eventType,
    required DateTime occurredAt,
    DateTime? receivedAt,
    required String timezone,
    required String effectiveLocalDate,
    _is.UuidValue? compensatesEventId,
  }) = _ReviewEventImpl;

  factory ReviewEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewEvent(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      eventType: _irtd71vd.ReviewEventType.fromJson(
        (jsonSerialization['eventType'] as String),
      ),
      occurredAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
      timezone: jsonSerialization['timezone'] as String,
      effectiveLocalDate: jsonSerialization['effectiveLocalDate'] as String,
      compensatesEventId: jsonSerialization['compensatesEventId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['compensatesEventId'],
            ),
    );
  }

  static final t = ReviewEventTable();

  static const db = ReviewEventRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue itemId;

  _irtd71vd.ReviewEventType eventType;

  /// When it happened on the device (UTC).
  DateTime occurredAt;

  /// When the server received it (UTC).
  DateTime receivedAt;

  /// IANA timezone of the user at the time of the event.
  String timezone;

  /// The user's local calendar date of the event, as yyyy-MM-dd.
  String effectiveLocalDate;

  _is.UuidValue? compensatesEventId;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ReviewEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReviewEvent copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    _irtd71vd.ReviewEventType? eventType,
    DateTime? occurredAt,
    DateTime? receivedAt,
    String? timezone,
    String? effectiveLocalDate,
    _is.UuidValue? compensatesEventId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewEvent',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'eventType': eventType.toJson(),
      'occurredAt': occurredAt.toJson(),
      'receivedAt': receivedAt.toJson(),
      'timezone': timezone,
      'effectiveLocalDate': effectiveLocalDate,
      if (compensatesEventId != null)
        'compensatesEventId': compensatesEventId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewEvent',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'eventType': eventType.toJson(),
      'occurredAt': occurredAt.toJson(),
      'receivedAt': receivedAt.toJson(),
      'timezone': timezone,
      'effectiveLocalDate': effectiveLocalDate,
      if (compensatesEventId != null)
        'compensatesEventId': compensatesEventId?.toJson(),
    };
  }

  static ReviewEventInclude include() {
    return ReviewEventInclude._();
  }

  static ReviewEventIncludeList includeList({
    _is.WhereExpressionBuilder<ReviewEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewEventTable>? orderBy,
    _is.OrderByListBuilder<ReviewEventTable>? orderByList,
    ReviewEventInclude? include,
  }) {
    return ReviewEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewEvent.t),
      orderByList: orderByList?.call(ReviewEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewEventImpl extends ReviewEvent {
  _ReviewEventImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    required _irtd71vd.ReviewEventType eventType,
    required DateTime occurredAt,
    DateTime? receivedAt,
    required String timezone,
    required String effectiveLocalDate,
    _is.UuidValue? compensatesEventId,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         eventType: eventType,
         occurredAt: occurredAt,
         receivedAt: receivedAt,
         timezone: timezone,
         effectiveLocalDate: effectiveLocalDate,
         compensatesEventId: compensatesEventId,
       );

  /// Returns a shallow copy of this [ReviewEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReviewEvent copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    _irtd71vd.ReviewEventType? eventType,
    DateTime? occurredAt,
    DateTime? receivedAt,
    String? timezone,
    String? effectiveLocalDate,
    Object? compensatesEventId = _Undefined,
  }) {
    return ReviewEvent(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      eventType: eventType ?? this.eventType,
      occurredAt: occurredAt ?? this.occurredAt,
      receivedAt: receivedAt ?? this.receivedAt,
      timezone: timezone ?? this.timezone,
      effectiveLocalDate: effectiveLocalDate ?? this.effectiveLocalDate,
      compensatesEventId: compensatesEventId is _is.UuidValue?
          ? compensatesEventId
          : this.compensatesEventId,
    );
  }
}

class ReviewEventUpdateTable extends _is.UpdateTable<ReviewEventTable> {
  ReviewEventUpdateTable(super.table);

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

  _is.ColumnValue<_irtd71vd.ReviewEventType, _irtd71vd.ReviewEventType>
  eventType(_irtd71vd.ReviewEventType value) => _is.ColumnValue(
    table.eventType,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> occurredAt(DateTime value) =>
      _is.ColumnValue(
        table.occurredAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> receivedAt(DateTime value) =>
      _is.ColumnValue(
        table.receivedAt,
        value,
      );

  _is.ColumnValue<String, String> timezone(String value) => _is.ColumnValue(
    table.timezone,
    value,
  );

  _is.ColumnValue<String, String> effectiveLocalDate(String value) =>
      _is.ColumnValue(
        table.effectiveLocalDate,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> compensatesEventId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.compensatesEventId,
    value,
  );
}

class ReviewEventTable extends _is.Table<_is.UuidValue?> {
  ReviewEventTable({super.tableRelation}) : super(tableName: 'review_event') {
    updateTable = ReviewEventUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    itemId = _is.ColumnUuid(
      'itemId',
      this,
    );
    eventType = _is.ColumnEnum(
      'eventType',
      this,
      _is.EnumSerialization.byName,
    );
    occurredAt = _is.ColumnDateTime(
      'occurredAt',
      this,
    );
    receivedAt = _is.ColumnDateTime(
      'receivedAt',
      this,
      hasDefault: true,
    );
    timezone = _is.ColumnString(
      'timezone',
      this,
    );
    effectiveLocalDate = _is.ColumnString(
      'effectiveLocalDate',
      this,
    );
    compensatesEventId = _is.ColumnUuid(
      'compensatesEventId',
      this,
    );
  }

  late final ReviewEventUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid itemId;

  late final _is.ColumnEnum<_irtd71vd.ReviewEventType> eventType;

  /// When it happened on the device (UTC).
  late final _is.ColumnDateTime occurredAt;

  /// When the server received it (UTC).
  late final _is.ColumnDateTime receivedAt;

  /// IANA timezone of the user at the time of the event.
  late final _is.ColumnString timezone;

  /// The user's local calendar date of the event, as yyyy-MM-dd.
  late final _is.ColumnString effectiveLocalDate;

  late final _is.ColumnUuid compensatesEventId;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    itemId,
    eventType,
    occurredAt,
    receivedAt,
    timezone,
    effectiveLocalDate,
    compensatesEventId,
  ];
}

class ReviewEventInclude extends _is.IncludeObject {
  ReviewEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ReviewEvent.t;
}

class ReviewEventIncludeList extends _is.IncludeList {
  ReviewEventIncludeList._({
    _is.WhereExpressionBuilder<ReviewEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReviewEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ReviewEvent.t;
}

class ReviewEventRepository {
  const ReviewEventRepository._();

  /// Returns a list of [ReviewEvent]s matching the given query parameters.
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
  Future<List<ReviewEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewEventTable>? orderBy,
    _is.OrderByListBuilder<ReviewEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReviewEvent>(
      where: where?.call(ReviewEvent.t),
      orderBy: orderBy?.call(ReviewEvent.t),
      orderByList: orderByList?.call(ReviewEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReviewEvent] matching the given query parameters.
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
  Future<ReviewEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewEventTable>? where,
    int? offset,
    _is.OrderByBuilder<ReviewEventTable>? orderBy,
    _is.OrderByListBuilder<ReviewEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReviewEvent>(
      where: where?.call(ReviewEvent.t),
      orderBy: orderBy?.call(ReviewEvent.t),
      orderByList: orderByList?.call(ReviewEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReviewEvent] by its [id] or null if no such row exists.
  Future<ReviewEvent?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReviewEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReviewEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [ReviewEvent]s will have their `id` fields set.
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
  Future<List<ReviewEvent>> insert(
    _is.DatabaseSession session,
    List<ReviewEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReviewEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReviewEvent] and returns the inserted row.
  ///
  /// The returned [ReviewEvent] will have its `id` field set.
  Future<ReviewEvent> insertRow(
    _is.DatabaseSession session,
    ReviewEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReviewEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReviewEvent]s in the list and returns the resulting rows.
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
  /// The returned [ReviewEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewEvent>> upsert(
    _is.DatabaseSession session,
    List<ReviewEvent> rows, {
    required _is.ColumnSelections<ReviewEventTable> conflictColumns,
    _is.ColumnSelections<ReviewEventTable>? updateColumns,
    _is.WhereExpressionBuilder<ReviewEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReviewEvent>(
      rows,
      conflictColumns: conflictColumns(ReviewEvent.t),
      updateColumns: updateColumns?.call(ReviewEvent.t),
      updateWhere: updateWhere?.call(ReviewEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReviewEvent] and returns the resulting row.
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
  /// The returned [ReviewEvent] will have its `id` field set.
  Future<ReviewEvent?> upsertRow(
    _is.DatabaseSession session,
    ReviewEvent row, {
    required _is.ColumnSelections<ReviewEventTable> conflictColumns,
    _is.ColumnSelections<ReviewEventTable>? updateColumns,
    _is.WhereExpressionBuilder<ReviewEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReviewEvent>(
      row,
      conflictColumns: conflictColumns(ReviewEvent.t),
      updateColumns: updateColumns?.call(ReviewEvent.t),
      updateWhere: updateWhere?.call(ReviewEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewEvent>> update(
    _is.DatabaseSession session,
    List<ReviewEvent> rows, {
    _is.ColumnSelections<ReviewEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReviewEvent>(
      rows,
      columns: columns?.call(ReviewEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReviewEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReviewEvent> updateRow(
    _is.DatabaseSession session,
    ReviewEvent row, {
    _is.ColumnSelections<ReviewEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReviewEvent>(
      row,
      columns: columns?.call(ReviewEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReviewEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReviewEvent?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ReviewEventUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReviewEvent>(
      id,
      columnValues: columnValues(ReviewEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReviewEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReviewEventUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ReviewEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReviewEventTable>? orderBy,
    _is.OrderByListBuilder<ReviewEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReviewEvent>(
      columnValues: columnValues(ReviewEvent.t.updateTable),
      where: where(ReviewEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewEvent.t),
      orderByList: orderByList?.call(ReviewEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReviewEvent]s in the list and returns the deleted rows.
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
  Future<List<ReviewEvent>> delete(
    _is.DatabaseSession session,
    List<ReviewEvent> rows, {
    _is.OrderByBuilder<ReviewEventTable>? orderBy,
    _is.OrderByListBuilder<ReviewEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReviewEvent>(
      rows,
      orderBy: orderBy?.call(ReviewEvent.t),
      orderByList: orderByList?.call(ReviewEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReviewEvent].
  Future<ReviewEvent> deleteRow(
    _is.DatabaseSession session,
    ReviewEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReviewEvent>(
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
  Future<List<ReviewEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReviewEventTable> where,
    _is.OrderByBuilder<ReviewEventTable>? orderBy,
    _is.OrderByListBuilder<ReviewEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReviewEvent>(
      where: where(ReviewEvent.t),
      orderBy: orderBy?.call(ReviewEvent.t),
      orderByList: orderByList?.call(ReviewEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReviewEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReviewEvent>(
      where: where?.call(ReviewEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReviewEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReviewEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReviewEvent>(
      where: where(ReviewEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
