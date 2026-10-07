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

/// Account-wide reminder preferences. Collection-specific delay overrides live
/// in ReminderRule and item controls take precedence over both.
abstract class ReminderSettings
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ReminderSettings._({
    this.id,
    required this.ownerId,
    int? delayHours,
    String? timezone,
    int? timezoneOffsetMinutes,
    this.quietStartMinute,
    this.quietEndMinute,
    int? dailyCap,
    bool? remindersPaused,
    int? queueLimit,
    int? dismissCooldownMinutes,
  }) : delayHours = delayHours ?? 24,
       timezone = timezone ?? 'UTC',
       timezoneOffsetMinutes = timezoneOffsetMinutes ?? 0,
       dailyCap = dailyCap ?? 1,
       remindersPaused = remindersPaused ?? false,
       queueLimit = queueLimit ?? 5,
       dismissCooldownMinutes = dismissCooldownMinutes ?? 120;

  factory ReminderSettings({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    int? delayHours,
    String? timezone,
    int? timezoneOffsetMinutes,
    int? quietStartMinute,
    int? quietEndMinute,
    int? dailyCap,
    bool? remindersPaused,
    int? queueLimit,
    int? dismissCooldownMinutes,
  }) = _ReminderSettingsImpl;

  factory ReminderSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReminderSettings(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      delayHours: jsonSerialization['delayHours'] as int?,
      timezone: jsonSerialization['timezone'] as String?,
      timezoneOffsetMinutes: jsonSerialization['timezoneOffsetMinutes'] as int?,
      quietStartMinute: jsonSerialization['quietStartMinute'] as int?,
      quietEndMinute: jsonSerialization['quietEndMinute'] as int?,
      dailyCap: jsonSerialization['dailyCap'] as int?,
      remindersPaused: jsonSerialization['remindersPaused'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['remindersPaused'],
            ),
      queueLimit: jsonSerialization['queueLimit'] as int?,
      dismissCooldownMinutes:
          jsonSerialization['dismissCooldownMinutes'] as int?,
    );
  }

  static final t = ReminderSettingsTable();

  static const db = ReminderSettingsRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  int delayHours;

  String timezone;

  /// Offset captured with the IANA timezone so quiet hours are deterministic
  /// even when a worker cannot load platform timezone data.
  int timezoneOffsetMinutes;

  int? quietStartMinute;

  int? quietEndMinute;

  int dailyCap;

  bool remindersPaused;

  int queueLimit;

  int dismissCooldownMinutes;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ReminderSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReminderSettings copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    int? delayHours,
    String? timezone,
    int? timezoneOffsetMinutes,
    int? quietStartMinute,
    int? quietEndMinute,
    int? dailyCap,
    bool? remindersPaused,
    int? queueLimit,
    int? dismissCooldownMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReminderSettings',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'delayHours': delayHours,
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
      if (quietStartMinute != null) 'quietStartMinute': quietStartMinute,
      if (quietEndMinute != null) 'quietEndMinute': quietEndMinute,
      'dailyCap': dailyCap,
      'remindersPaused': remindersPaused,
      'queueLimit': queueLimit,
      'dismissCooldownMinutes': dismissCooldownMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReminderSettings',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'delayHours': delayHours,
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
      if (quietStartMinute != null) 'quietStartMinute': quietStartMinute,
      if (quietEndMinute != null) 'quietEndMinute': quietEndMinute,
      'dailyCap': dailyCap,
      'remindersPaused': remindersPaused,
      'queueLimit': queueLimit,
      'dismissCooldownMinutes': dismissCooldownMinutes,
    };
  }

  static ReminderSettingsInclude include() {
    return ReminderSettingsInclude._();
  }

  static ReminderSettingsIncludeList includeList({
    _is.WhereExpressionBuilder<ReminderSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReminderSettingsTable>? orderBy,
    _is.OrderByListBuilder<ReminderSettingsTable>? orderByList,
    ReminderSettingsInclude? include,
  }) {
    return ReminderSettingsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReminderSettings.t),
      orderByList: orderByList?.call(ReminderSettings.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderSettingsImpl extends ReminderSettings {
  _ReminderSettingsImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    int? delayHours,
    String? timezone,
    int? timezoneOffsetMinutes,
    int? quietStartMinute,
    int? quietEndMinute,
    int? dailyCap,
    bool? remindersPaused,
    int? queueLimit,
    int? dismissCooldownMinutes,
  }) : super._(
         id: id,
         ownerId: ownerId,
         delayHours: delayHours,
         timezone: timezone,
         timezoneOffsetMinutes: timezoneOffsetMinutes,
         quietStartMinute: quietStartMinute,
         quietEndMinute: quietEndMinute,
         dailyCap: dailyCap,
         remindersPaused: remindersPaused,
         queueLimit: queueLimit,
         dismissCooldownMinutes: dismissCooldownMinutes,
       );

  /// Returns a shallow copy of this [ReminderSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReminderSettings copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    int? delayHours,
    String? timezone,
    int? timezoneOffsetMinutes,
    Object? quietStartMinute = _Undefined,
    Object? quietEndMinute = _Undefined,
    int? dailyCap,
    bool? remindersPaused,
    int? queueLimit,
    int? dismissCooldownMinutes,
  }) {
    return ReminderSettings(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      delayHours: delayHours ?? this.delayHours,
      timezone: timezone ?? this.timezone,
      timezoneOffsetMinutes:
          timezoneOffsetMinutes ?? this.timezoneOffsetMinutes,
      quietStartMinute: quietStartMinute is int?
          ? quietStartMinute
          : this.quietStartMinute,
      quietEndMinute: quietEndMinute is int?
          ? quietEndMinute
          : this.quietEndMinute,
      dailyCap: dailyCap ?? this.dailyCap,
      remindersPaused: remindersPaused ?? this.remindersPaused,
      queueLimit: queueLimit ?? this.queueLimit,
      dismissCooldownMinutes:
          dismissCooldownMinutes ?? this.dismissCooldownMinutes,
    );
  }
}

class ReminderSettingsUpdateTable
    extends _is.UpdateTable<ReminderSettingsTable> {
  ReminderSettingsUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<int, int> delayHours(int value) => _is.ColumnValue(
    table.delayHours,
    value,
  );

  _is.ColumnValue<String, String> timezone(String value) => _is.ColumnValue(
    table.timezone,
    value,
  );

  _is.ColumnValue<int, int> timezoneOffsetMinutes(int value) => _is.ColumnValue(
    table.timezoneOffsetMinutes,
    value,
  );

  _is.ColumnValue<int, int> quietStartMinute(int? value) => _is.ColumnValue(
    table.quietStartMinute,
    value,
  );

  _is.ColumnValue<int, int> quietEndMinute(int? value) => _is.ColumnValue(
    table.quietEndMinute,
    value,
  );

  _is.ColumnValue<int, int> dailyCap(int value) => _is.ColumnValue(
    table.dailyCap,
    value,
  );

  _is.ColumnValue<bool, bool> remindersPaused(bool value) => _is.ColumnValue(
    table.remindersPaused,
    value,
  );

  _is.ColumnValue<int, int> queueLimit(int value) => _is.ColumnValue(
    table.queueLimit,
    value,
  );

  _is.ColumnValue<int, int> dismissCooldownMinutes(int value) =>
      _is.ColumnValue(
        table.dismissCooldownMinutes,
        value,
      );
}

class ReminderSettingsTable extends _is.Table<_is.UuidValue?> {
  ReminderSettingsTable({super.tableRelation})
    : super(tableName: 'reminder_settings') {
    updateTable = ReminderSettingsUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    delayHours = _is.ColumnInt(
      'delayHours',
      this,
      hasDefault: true,
    );
    timezone = _is.ColumnString(
      'timezone',
      this,
      hasDefault: true,
    );
    timezoneOffsetMinutes = _is.ColumnInt(
      'timezoneOffsetMinutes',
      this,
      hasDefault: true,
    );
    quietStartMinute = _is.ColumnInt(
      'quietStartMinute',
      this,
    );
    quietEndMinute = _is.ColumnInt(
      'quietEndMinute',
      this,
    );
    dailyCap = _is.ColumnInt(
      'dailyCap',
      this,
      hasDefault: true,
    );
    remindersPaused = _is.ColumnBool(
      'remindersPaused',
      this,
      hasDefault: true,
    );
    queueLimit = _is.ColumnInt(
      'queueLimit',
      this,
      hasDefault: true,
    );
    dismissCooldownMinutes = _is.ColumnInt(
      'dismissCooldownMinutes',
      this,
      hasDefault: true,
    );
  }

  late final ReminderSettingsUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnInt delayHours;

  late final _is.ColumnString timezone;

  /// Offset captured with the IANA timezone so quiet hours are deterministic
  /// even when a worker cannot load platform timezone data.
  late final _is.ColumnInt timezoneOffsetMinutes;

  late final _is.ColumnInt quietStartMinute;

  late final _is.ColumnInt quietEndMinute;

  late final _is.ColumnInt dailyCap;

  late final _is.ColumnBool remindersPaused;

  late final _is.ColumnInt queueLimit;

  late final _is.ColumnInt dismissCooldownMinutes;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    delayHours,
    timezone,
    timezoneOffsetMinutes,
    quietStartMinute,
    quietEndMinute,
    dailyCap,
    remindersPaused,
    queueLimit,
    dismissCooldownMinutes,
  ];
}

class ReminderSettingsInclude extends _is.IncludeObject {
  ReminderSettingsInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ReminderSettings.t;
}

class ReminderSettingsIncludeList extends _is.IncludeList {
  ReminderSettingsIncludeList._({
    _is.WhereExpressionBuilder<ReminderSettingsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReminderSettings.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ReminderSettings.t;
}

class ReminderSettingsRepository {
  const ReminderSettingsRepository._();

  /// Returns a list of [ReminderSettings]s matching the given query parameters.
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
  Future<List<ReminderSettings>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReminderSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReminderSettingsTable>? orderBy,
    _is.OrderByListBuilder<ReminderSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReminderSettings>(
      where: where?.call(ReminderSettings.t),
      orderBy: orderBy?.call(ReminderSettings.t),
      orderByList: orderByList?.call(ReminderSettings.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReminderSettings] matching the given query parameters.
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
  Future<ReminderSettings?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReminderSettingsTable>? where,
    int? offset,
    _is.OrderByBuilder<ReminderSettingsTable>? orderBy,
    _is.OrderByListBuilder<ReminderSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReminderSettings>(
      where: where?.call(ReminderSettings.t),
      orderBy: orderBy?.call(ReminderSettings.t),
      orderByList: orderByList?.call(ReminderSettings.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReminderSettings] by its [id] or null if no such row exists.
  Future<ReminderSettings?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReminderSettings>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReminderSettings]s in the list and returns the inserted rows.
  ///
  /// The returned [ReminderSettings]s will have their `id` fields set.
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
  Future<List<ReminderSettings>> insert(
    _is.DatabaseSession session,
    List<ReminderSettings> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReminderSettings>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReminderSettings] and returns the inserted row.
  ///
  /// The returned [ReminderSettings] will have its `id` field set.
  Future<ReminderSettings> insertRow(
    _is.DatabaseSession session,
    ReminderSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReminderSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReminderSettings]s in the list and returns the resulting rows.
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
  /// The returned [ReminderSettings]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReminderSettings>> upsert(
    _is.DatabaseSession session,
    List<ReminderSettings> rows, {
    required _is.ColumnSelections<ReminderSettingsTable> conflictColumns,
    _is.ColumnSelections<ReminderSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<ReminderSettingsTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReminderSettings>(
      rows,
      conflictColumns: conflictColumns(ReminderSettings.t),
      updateColumns: updateColumns?.call(ReminderSettings.t),
      updateWhere: updateWhere?.call(ReminderSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReminderSettings] and returns the resulting row.
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
  /// The returned [ReminderSettings] will have its `id` field set.
  Future<ReminderSettings?> upsertRow(
    _is.DatabaseSession session,
    ReminderSettings row, {
    required _is.ColumnSelections<ReminderSettingsTable> conflictColumns,
    _is.ColumnSelections<ReminderSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<ReminderSettingsTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReminderSettings>(
      row,
      conflictColumns: conflictColumns(ReminderSettings.t),
      updateColumns: updateColumns?.call(ReminderSettings.t),
      updateWhere: updateWhere?.call(ReminderSettings.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReminderSettings]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReminderSettings>> update(
    _is.DatabaseSession session,
    List<ReminderSettings> rows, {
    _is.ColumnSelections<ReminderSettingsTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReminderSettings>(
      rows,
      columns: columns?.call(ReminderSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReminderSettings]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReminderSettings> updateRow(
    _is.DatabaseSession session,
    ReminderSettings row, {
    _is.ColumnSelections<ReminderSettingsTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReminderSettings>(
      row,
      columns: columns?.call(ReminderSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReminderSettings] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReminderSettings?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ReminderSettingsUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReminderSettings>(
      id,
      columnValues: columnValues(ReminderSettings.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReminderSettings]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReminderSettings>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReminderSettingsUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ReminderSettingsTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReminderSettingsTable>? orderBy,
    _is.OrderByListBuilder<ReminderSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReminderSettings>(
      columnValues: columnValues(ReminderSettings.t.updateTable),
      where: where(ReminderSettings.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReminderSettings.t),
      orderByList: orderByList?.call(ReminderSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReminderSettings]s in the list and returns the deleted rows.
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
  Future<List<ReminderSettings>> delete(
    _is.DatabaseSession session,
    List<ReminderSettings> rows, {
    _is.OrderByBuilder<ReminderSettingsTable>? orderBy,
    _is.OrderByListBuilder<ReminderSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReminderSettings>(
      rows,
      orderBy: orderBy?.call(ReminderSettings.t),
      orderByList: orderByList?.call(ReminderSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReminderSettings].
  Future<ReminderSettings> deleteRow(
    _is.DatabaseSession session,
    ReminderSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReminderSettings>(
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
  Future<List<ReminderSettings>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReminderSettingsTable> where,
    _is.OrderByBuilder<ReminderSettingsTable>? orderBy,
    _is.OrderByListBuilder<ReminderSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReminderSettings>(
      where: where(ReminderSettings.t),
      orderBy: orderBy?.call(ReminderSettings.t),
      orderByList: orderByList?.call(ReminderSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReminderSettingsTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReminderSettings>(
      where: where?.call(ReminderSettings.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReminderSettings] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReminderSettingsTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReminderSettings>(
      where: where(ReminderSettings.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
