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

/// A calendar of a connection, with how the owner uses it. Device calendar
/// ids are only meaningful on the device in `deviceId`.
abstract class CalendarSelection
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CalendarSelection._({
    this.id,
    required this.ownerId,
    required this.connectionId,
    required this.externalCalendarId,
    this.deviceId,
    required this.name,
    this.accountName,
    required this.readOnly,
    bool? useForConflicts,
    bool? useForWrites,
  }) : useForConflicts = useForConflicts ?? false,
       useForWrites = useForWrites ?? false;

  factory CalendarSelection({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue connectionId,
    required String externalCalendarId,
    _is.UuidValue? deviceId,
    required String name,
    String? accountName,
    required bool readOnly,
    bool? useForConflicts,
    bool? useForWrites,
  }) = _CalendarSelectionImpl;

  factory CalendarSelection.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarSelection(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      connectionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['connectionId'],
      ),
      externalCalendarId: jsonSerialization['externalCalendarId'] as String,
      deviceId: jsonSerialization['deviceId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
      name: jsonSerialization['name'] as String,
      accountName: jsonSerialization['accountName'] as String?,
      readOnly: _is.BoolJsonExtension.fromJson(jsonSerialization['readOnly']),
      useForConflicts: jsonSerialization['useForConflicts'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['useForConflicts'],
            ),
      useForWrites: jsonSerialization['useForWrites'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['useForWrites']),
    );
  }

  static final t = CalendarSelectionTable();

  static const db = CalendarSelectionRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue connectionId;

  String externalCalendarId;

  _is.UuidValue? deviceId;

  String name;

  String? accountName;

  bool readOnly;

  /// Busy times in this calendar block sessions.
  bool useForConflicts;

  /// Sessions are written here. At most one per owner.
  bool useForWrites;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CalendarSelection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CalendarSelection copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? connectionId,
    String? externalCalendarId,
    _is.UuidValue? deviceId,
    String? name,
    String? accountName,
    bool? readOnly,
    bool? useForConflicts,
    bool? useForWrites,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarSelection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'connectionId': connectionId.toJson(),
      'externalCalendarId': externalCalendarId,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'name': name,
      if (accountName != null) 'accountName': accountName,
      'readOnly': readOnly,
      'useForConflicts': useForConflicts,
      'useForWrites': useForWrites,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarSelection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'connectionId': connectionId.toJson(),
      'externalCalendarId': externalCalendarId,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'name': name,
      if (accountName != null) 'accountName': accountName,
      'readOnly': readOnly,
      'useForConflicts': useForConflicts,
      'useForWrites': useForWrites,
    };
  }

  static CalendarSelectionInclude include() {
    return CalendarSelectionInclude._();
  }

  static CalendarSelectionIncludeList includeList({
    _is.WhereExpressionBuilder<CalendarSelectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CalendarSelectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarSelectionTable>? orderByList,
    CalendarSelectionInclude? include,
  }) {
    return CalendarSelectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarSelection.t),
      orderByList: orderByList?.call(CalendarSelection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarSelectionImpl extends CalendarSelection {
  _CalendarSelectionImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue connectionId,
    required String externalCalendarId,
    _is.UuidValue? deviceId,
    required String name,
    String? accountName,
    required bool readOnly,
    bool? useForConflicts,
    bool? useForWrites,
  }) : super._(
         id: id,
         ownerId: ownerId,
         connectionId: connectionId,
         externalCalendarId: externalCalendarId,
         deviceId: deviceId,
         name: name,
         accountName: accountName,
         readOnly: readOnly,
         useForConflicts: useForConflicts,
         useForWrites: useForWrites,
       );

  /// Returns a shallow copy of this [CalendarSelection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CalendarSelection copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? connectionId,
    String? externalCalendarId,
    Object? deviceId = _Undefined,
    String? name,
    Object? accountName = _Undefined,
    bool? readOnly,
    bool? useForConflicts,
    bool? useForWrites,
  }) {
    return CalendarSelection(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      connectionId: connectionId ?? this.connectionId,
      externalCalendarId: externalCalendarId ?? this.externalCalendarId,
      deviceId: deviceId is _is.UuidValue? ? deviceId : this.deviceId,
      name: name ?? this.name,
      accountName: accountName is String? ? accountName : this.accountName,
      readOnly: readOnly ?? this.readOnly,
      useForConflicts: useForConflicts ?? this.useForConflicts,
      useForWrites: useForWrites ?? this.useForWrites,
    );
  }
}

class CalendarSelectionUpdateTable
    extends _is.UpdateTable<CalendarSelectionTable> {
  CalendarSelectionUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> connectionId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.connectionId,
    value,
  );

  _is.ColumnValue<String, String> externalCalendarId(String value) =>
      _is.ColumnValue(
        table.externalCalendarId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> deviceId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> accountName(String? value) => _is.ColumnValue(
    table.accountName,
    value,
  );

  _is.ColumnValue<bool, bool> readOnly(bool value) => _is.ColumnValue(
    table.readOnly,
    value,
  );

  _is.ColumnValue<bool, bool> useForConflicts(bool value) => _is.ColumnValue(
    table.useForConflicts,
    value,
  );

  _is.ColumnValue<bool, bool> useForWrites(bool value) => _is.ColumnValue(
    table.useForWrites,
    value,
  );
}

class CalendarSelectionTable extends _is.Table<_is.UuidValue?> {
  CalendarSelectionTable({super.tableRelation})
    : super(tableName: 'calendar_selection') {
    updateTable = CalendarSelectionUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    connectionId = _is.ColumnUuid(
      'connectionId',
      this,
    );
    externalCalendarId = _is.ColumnString(
      'externalCalendarId',
      this,
    );
    deviceId = _is.ColumnUuid(
      'deviceId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    accountName = _is.ColumnString(
      'accountName',
      this,
    );
    readOnly = _is.ColumnBool(
      'readOnly',
      this,
    );
    useForConflicts = _is.ColumnBool(
      'useForConflicts',
      this,
      hasDefault: true,
    );
    useForWrites = _is.ColumnBool(
      'useForWrites',
      this,
      hasDefault: true,
    );
  }

  late final CalendarSelectionUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid connectionId;

  late final _is.ColumnString externalCalendarId;

  late final _is.ColumnUuid deviceId;

  late final _is.ColumnString name;

  late final _is.ColumnString accountName;

  late final _is.ColumnBool readOnly;

  /// Busy times in this calendar block sessions.
  late final _is.ColumnBool useForConflicts;

  /// Sessions are written here. At most one per owner.
  late final _is.ColumnBool useForWrites;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    connectionId,
    externalCalendarId,
    deviceId,
    name,
    accountName,
    readOnly,
    useForConflicts,
    useForWrites,
  ];
}

class CalendarSelectionInclude extends _is.IncludeObject {
  CalendarSelectionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => CalendarSelection.t;
}

class CalendarSelectionIncludeList extends _is.IncludeList {
  CalendarSelectionIncludeList._({
    _is.WhereExpressionBuilder<CalendarSelectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CalendarSelection.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CalendarSelection.t;
}

class CalendarSelectionRepository {
  const CalendarSelectionRepository._();

  /// Returns a list of [CalendarSelection]s matching the given query parameters.
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
  Future<List<CalendarSelection>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CalendarSelectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CalendarSelectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarSelectionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CalendarSelection>(
      where: where?.call(CalendarSelection.t),
      orderBy: orderBy?.call(CalendarSelection.t),
      orderByList: orderByList?.call(CalendarSelection.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CalendarSelection] matching the given query parameters.
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
  Future<CalendarSelection?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CalendarSelectionTable>? where,
    int? offset,
    _is.OrderByBuilder<CalendarSelectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarSelectionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CalendarSelection>(
      where: where?.call(CalendarSelection.t),
      orderBy: orderBy?.call(CalendarSelection.t),
      orderByList: orderByList?.call(CalendarSelection.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CalendarSelection] by its [id] or null if no such row exists.
  Future<CalendarSelection?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CalendarSelection>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CalendarSelection]s in the list and returns the inserted rows.
  ///
  /// The returned [CalendarSelection]s will have their `id` fields set.
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
  Future<List<CalendarSelection>> insert(
    _is.DatabaseSession session,
    List<CalendarSelection> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CalendarSelection>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CalendarSelection] and returns the inserted row.
  ///
  /// The returned [CalendarSelection] will have its `id` field set.
  Future<CalendarSelection> insertRow(
    _is.DatabaseSession session,
    CalendarSelection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CalendarSelection>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CalendarSelection]s in the list and returns the resulting rows.
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
  /// The returned [CalendarSelection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CalendarSelection>> upsert(
    _is.DatabaseSession session,
    List<CalendarSelection> rows, {
    required _is.ColumnSelections<CalendarSelectionTable> conflictColumns,
    _is.ColumnSelections<CalendarSelectionTable>? updateColumns,
    _is.WhereExpressionBuilder<CalendarSelectionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CalendarSelection>(
      rows,
      conflictColumns: conflictColumns(CalendarSelection.t),
      updateColumns: updateColumns?.call(CalendarSelection.t),
      updateWhere: updateWhere?.call(CalendarSelection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CalendarSelection] and returns the resulting row.
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
  /// The returned [CalendarSelection] will have its `id` field set.
  Future<CalendarSelection?> upsertRow(
    _is.DatabaseSession session,
    CalendarSelection row, {
    required _is.ColumnSelections<CalendarSelectionTable> conflictColumns,
    _is.ColumnSelections<CalendarSelectionTable>? updateColumns,
    _is.WhereExpressionBuilder<CalendarSelectionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CalendarSelection>(
      row,
      conflictColumns: conflictColumns(CalendarSelection.t),
      updateColumns: updateColumns?.call(CalendarSelection.t),
      updateWhere: updateWhere?.call(CalendarSelection.t),
      transaction: transaction,
    );
  }

  /// Updates all [CalendarSelection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CalendarSelection>> update(
    _is.DatabaseSession session,
    List<CalendarSelection> rows, {
    _is.ColumnSelections<CalendarSelectionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CalendarSelection>(
      rows,
      columns: columns?.call(CalendarSelection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CalendarSelection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CalendarSelection> updateRow(
    _is.DatabaseSession session,
    CalendarSelection row, {
    _is.ColumnSelections<CalendarSelectionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CalendarSelection>(
      row,
      columns: columns?.call(CalendarSelection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CalendarSelection] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CalendarSelection?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CalendarSelectionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CalendarSelection>(
      id,
      columnValues: columnValues(CalendarSelection.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CalendarSelection]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CalendarSelection>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CalendarSelectionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CalendarSelectionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CalendarSelectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarSelectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CalendarSelection>(
      columnValues: columnValues(CalendarSelection.t.updateTable),
      where: where(CalendarSelection.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarSelection.t),
      orderByList: orderByList?.call(CalendarSelection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CalendarSelection]s in the list and returns the deleted rows.
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
  Future<List<CalendarSelection>> delete(
    _is.DatabaseSession session,
    List<CalendarSelection> rows, {
    _is.OrderByBuilder<CalendarSelectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarSelectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CalendarSelection>(
      rows,
      orderBy: orderBy?.call(CalendarSelection.t),
      orderByList: orderByList?.call(CalendarSelection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CalendarSelection].
  Future<CalendarSelection> deleteRow(
    _is.DatabaseSession session,
    CalendarSelection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CalendarSelection>(
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
  Future<List<CalendarSelection>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CalendarSelectionTable> where,
    _is.OrderByBuilder<CalendarSelectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarSelectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CalendarSelection>(
      where: where(CalendarSelection.t),
      orderBy: orderBy?.call(CalendarSelection.t),
      orderByList: orderByList?.call(CalendarSelection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CalendarSelectionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CalendarSelection>(
      where: where?.call(CalendarSelection.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CalendarSelection] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CalendarSelectionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CalendarSelection>(
      where: where(CalendarSelection.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
