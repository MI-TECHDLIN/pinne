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
import '../calendar/calendar_permission.dart' as _if02ip72;
import '../calendar/calendar_route.dart' as _iwvtbtmv;

/// One calendar route for an owner, such as the calendars on one phone.
/// Provider secrets never live in this row.
abstract class CalendarConnection
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CalendarConnection._({
    this.id,
    required this.ownerId,
    required this.route,
    required this.accountKey,
    required this.label,
    this.deviceId,
    required this.permission,
    this.tokenSecretRef,
    this.lastCheckedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CalendarConnection({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _iwvtbtmv.CalendarRoute route,
    required String accountKey,
    required String label,
    _is.UuidValue? deviceId,
    required _if02ip72.CalendarPermission permission,
    String? tokenSecretRef,
    DateTime? lastCheckedAt,
    DateTime? createdAt,
  }) = _CalendarConnectionImpl;

  factory CalendarConnection.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarConnection(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      route: _iwvtbtmv.CalendarRoute.fromJson(
        (jsonSerialization['route'] as String),
      ),
      accountKey: jsonSerialization['accountKey'] as String,
      label: jsonSerialization['label'] as String,
      deviceId: jsonSerialization['deviceId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
      permission: _if02ip72.CalendarPermission.fromJson(
        (jsonSerialization['permission'] as String),
      ),
      tokenSecretRef: jsonSerialization['tokenSecretRef'] as String?,
      lastCheckedAt: jsonSerialization['lastCheckedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastCheckedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = CalendarConnectionTable();

  static const db = CalendarConnectionRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _iwvtbtmv.CalendarRoute route;

  /// For a device route, the id of the app install that holds the calendars.
  String accountKey;

  /// A name the user recognises, such as the phone model.
  String label;

  /// For device routes: only this install acts on the calendars.
  _is.UuidValue? deviceId;

  _if02ip72.CalendarPermission permission;

  /// Reference to a secret in the secret store; never the secret itself.
  String? tokenSecretRef;

  /// When the route last listed calendars or read busy times successfully.
  DateTime? lastCheckedAt;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CalendarConnection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CalendarConnection copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _iwvtbtmv.CalendarRoute? route,
    String? accountKey,
    String? label,
    _is.UuidValue? deviceId,
    _if02ip72.CalendarPermission? permission,
    String? tokenSecretRef,
    DateTime? lastCheckedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarConnection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'route': route.toJson(),
      'accountKey': accountKey,
      'label': label,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'permission': permission.toJson(),
      if (tokenSecretRef != null) 'tokenSecretRef': tokenSecretRef,
      if (lastCheckedAt != null) 'lastCheckedAt': lastCheckedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarConnection',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'route': route.toJson(),
      'accountKey': accountKey,
      'label': label,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'permission': permission.toJson(),
      if (lastCheckedAt != null) 'lastCheckedAt': lastCheckedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static CalendarConnectionInclude include() {
    return CalendarConnectionInclude._();
  }

  static CalendarConnectionIncludeList includeList({
    _is.WhereExpressionBuilder<CalendarConnectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CalendarConnectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarConnectionTable>? orderByList,
    CalendarConnectionInclude? include,
  }) {
    return CalendarConnectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarConnection.t),
      orderByList: orderByList?.call(CalendarConnection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarConnectionImpl extends CalendarConnection {
  _CalendarConnectionImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _iwvtbtmv.CalendarRoute route,
    required String accountKey,
    required String label,
    _is.UuidValue? deviceId,
    required _if02ip72.CalendarPermission permission,
    String? tokenSecretRef,
    DateTime? lastCheckedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         route: route,
         accountKey: accountKey,
         label: label,
         deviceId: deviceId,
         permission: permission,
         tokenSecretRef: tokenSecretRef,
         lastCheckedAt: lastCheckedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CalendarConnection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CalendarConnection copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _iwvtbtmv.CalendarRoute? route,
    String? accountKey,
    String? label,
    Object? deviceId = _Undefined,
    _if02ip72.CalendarPermission? permission,
    Object? tokenSecretRef = _Undefined,
    Object? lastCheckedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return CalendarConnection(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      route: route ?? this.route,
      accountKey: accountKey ?? this.accountKey,
      label: label ?? this.label,
      deviceId: deviceId is _is.UuidValue? ? deviceId : this.deviceId,
      permission: permission ?? this.permission,
      tokenSecretRef: tokenSecretRef is String?
          ? tokenSecretRef
          : this.tokenSecretRef,
      lastCheckedAt: lastCheckedAt is DateTime?
          ? lastCheckedAt
          : this.lastCheckedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CalendarConnectionUpdateTable
    extends _is.UpdateTable<CalendarConnectionTable> {
  CalendarConnectionUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_iwvtbtmv.CalendarRoute, _iwvtbtmv.CalendarRoute> route(
    _iwvtbtmv.CalendarRoute value,
  ) => _is.ColumnValue(
    table.route,
    value,
  );

  _is.ColumnValue<String, String> accountKey(String value) => _is.ColumnValue(
    table.accountKey,
    value,
  );

  _is.ColumnValue<String, String> label(String value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> deviceId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<_if02ip72.CalendarPermission, _if02ip72.CalendarPermission>
  permission(_if02ip72.CalendarPermission value) => _is.ColumnValue(
    table.permission,
    value,
  );

  _is.ColumnValue<String, String> tokenSecretRef(String? value) =>
      _is.ColumnValue(
        table.tokenSecretRef,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastCheckedAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastCheckedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class CalendarConnectionTable extends _is.Table<_is.UuidValue?> {
  CalendarConnectionTable({super.tableRelation})
    : super(tableName: 'calendar_connection') {
    updateTable = CalendarConnectionUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    route = _is.ColumnEnum(
      'route',
      this,
      _is.EnumSerialization.byName,
    );
    accountKey = _is.ColumnString(
      'accountKey',
      this,
    );
    label = _is.ColumnString(
      'label',
      this,
    );
    deviceId = _is.ColumnUuid(
      'deviceId',
      this,
    );
    permission = _is.ColumnEnum(
      'permission',
      this,
      _is.EnumSerialization.byName,
    );
    tokenSecretRef = _is.ColumnString(
      'tokenSecretRef',
      this,
    );
    lastCheckedAt = _is.ColumnDateTime(
      'lastCheckedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final CalendarConnectionUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnEnum<_iwvtbtmv.CalendarRoute> route;

  /// For a device route, the id of the app install that holds the calendars.
  late final _is.ColumnString accountKey;

  /// A name the user recognises, such as the phone model.
  late final _is.ColumnString label;

  /// For device routes: only this install acts on the calendars.
  late final _is.ColumnUuid deviceId;

  late final _is.ColumnEnum<_if02ip72.CalendarPermission> permission;

  /// Reference to a secret in the secret store; never the secret itself.
  late final _is.ColumnString tokenSecretRef;

  /// When the route last listed calendars or read busy times successfully.
  late final _is.ColumnDateTime lastCheckedAt;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    route,
    accountKey,
    label,
    deviceId,
    permission,
    tokenSecretRef,
    lastCheckedAt,
    createdAt,
  ];
}

class CalendarConnectionInclude extends _is.IncludeObject {
  CalendarConnectionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => CalendarConnection.t;
}

class CalendarConnectionIncludeList extends _is.IncludeList {
  CalendarConnectionIncludeList._({
    _is.WhereExpressionBuilder<CalendarConnectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CalendarConnection.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CalendarConnection.t;
}

class CalendarConnectionRepository {
  const CalendarConnectionRepository._();

  /// Returns a list of [CalendarConnection]s matching the given query parameters.
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
  Future<List<CalendarConnection>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CalendarConnectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CalendarConnectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarConnectionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CalendarConnection>(
      where: where?.call(CalendarConnection.t),
      orderBy: orderBy?.call(CalendarConnection.t),
      orderByList: orderByList?.call(CalendarConnection.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CalendarConnection] matching the given query parameters.
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
  Future<CalendarConnection?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CalendarConnectionTable>? where,
    int? offset,
    _is.OrderByBuilder<CalendarConnectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarConnectionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CalendarConnection>(
      where: where?.call(CalendarConnection.t),
      orderBy: orderBy?.call(CalendarConnection.t),
      orderByList: orderByList?.call(CalendarConnection.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CalendarConnection] by its [id] or null if no such row exists.
  Future<CalendarConnection?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CalendarConnection>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CalendarConnection]s in the list and returns the inserted rows.
  ///
  /// The returned [CalendarConnection]s will have their `id` fields set.
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
  Future<List<CalendarConnection>> insert(
    _is.DatabaseSession session,
    List<CalendarConnection> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CalendarConnection>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CalendarConnection] and returns the inserted row.
  ///
  /// The returned [CalendarConnection] will have its `id` field set.
  Future<CalendarConnection> insertRow(
    _is.DatabaseSession session,
    CalendarConnection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CalendarConnection>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CalendarConnection]s in the list and returns the resulting rows.
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
  /// The returned [CalendarConnection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CalendarConnection>> upsert(
    _is.DatabaseSession session,
    List<CalendarConnection> rows, {
    required _is.ColumnSelections<CalendarConnectionTable> conflictColumns,
    _is.ColumnSelections<CalendarConnectionTable>? updateColumns,
    _is.WhereExpressionBuilder<CalendarConnectionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CalendarConnection>(
      rows,
      conflictColumns: conflictColumns(CalendarConnection.t),
      updateColumns: updateColumns?.call(CalendarConnection.t),
      updateWhere: updateWhere?.call(CalendarConnection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CalendarConnection] and returns the resulting row.
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
  /// The returned [CalendarConnection] will have its `id` field set.
  Future<CalendarConnection?> upsertRow(
    _is.DatabaseSession session,
    CalendarConnection row, {
    required _is.ColumnSelections<CalendarConnectionTable> conflictColumns,
    _is.ColumnSelections<CalendarConnectionTable>? updateColumns,
    _is.WhereExpressionBuilder<CalendarConnectionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CalendarConnection>(
      row,
      conflictColumns: conflictColumns(CalendarConnection.t),
      updateColumns: updateColumns?.call(CalendarConnection.t),
      updateWhere: updateWhere?.call(CalendarConnection.t),
      transaction: transaction,
    );
  }

  /// Updates all [CalendarConnection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CalendarConnection>> update(
    _is.DatabaseSession session,
    List<CalendarConnection> rows, {
    _is.ColumnSelections<CalendarConnectionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CalendarConnection>(
      rows,
      columns: columns?.call(CalendarConnection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CalendarConnection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CalendarConnection> updateRow(
    _is.DatabaseSession session,
    CalendarConnection row, {
    _is.ColumnSelections<CalendarConnectionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CalendarConnection>(
      row,
      columns: columns?.call(CalendarConnection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CalendarConnection] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CalendarConnection?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CalendarConnectionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CalendarConnection>(
      id,
      columnValues: columnValues(CalendarConnection.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CalendarConnection]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CalendarConnection>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CalendarConnectionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CalendarConnectionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CalendarConnectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarConnectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CalendarConnection>(
      columnValues: columnValues(CalendarConnection.t.updateTable),
      where: where(CalendarConnection.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CalendarConnection.t),
      orderByList: orderByList?.call(CalendarConnection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CalendarConnection]s in the list and returns the deleted rows.
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
  Future<List<CalendarConnection>> delete(
    _is.DatabaseSession session,
    List<CalendarConnection> rows, {
    _is.OrderByBuilder<CalendarConnectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarConnectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CalendarConnection>(
      rows,
      orderBy: orderBy?.call(CalendarConnection.t),
      orderByList: orderByList?.call(CalendarConnection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CalendarConnection].
  Future<CalendarConnection> deleteRow(
    _is.DatabaseSession session,
    CalendarConnection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CalendarConnection>(
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
  Future<List<CalendarConnection>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CalendarConnectionTable> where,
    _is.OrderByBuilder<CalendarConnectionTable>? orderBy,
    _is.OrderByListBuilder<CalendarConnectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CalendarConnection>(
      where: where(CalendarConnection.t),
      orderBy: orderBy?.call(CalendarConnection.t),
      orderByList: orderByList?.call(CalendarConnection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CalendarConnectionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CalendarConnection>(
      where: where?.call(CalendarConnection.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CalendarConnection] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CalendarConnectionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CalendarConnection>(
      where: where(CalendarConnection.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
