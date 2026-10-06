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
import '../reminders/reminder_window.dart' as _i9bgfy5p;

/// When to remind the user about saved items. A null collection is the owner's
/// default rule; a collection rule overrides it.
abstract class ReminderRule
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ReminderRule._({
    this.id,
    required this.ownerId,
    this.collectionId,
    int? delayHours,
    this.deliveryWindows,
    this.cap,
    bool? enabled,
  }) : delayHours = delayHours ?? 24,
       enabled = enabled ?? true;

  factory ReminderRule({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    _is.UuidValue? collectionId,
    int? delayHours,
    List<_i9bgfy5p.ReminderWindow>? deliveryWindows,
    int? cap,
    bool? enabled,
  }) = _ReminderRuleImpl;

  factory ReminderRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReminderRule(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      collectionId: jsonSerialization['collectionId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['collectionId'],
            ),
      delayHours: jsonSerialization['delayHours'] as int?,
      deliveryWindows: jsonSerialization['deliveryWindows'] == null
          ? null
          : _i2yoimhd.Protocol().deserialize<List<_i9bgfy5p.ReminderWindow>>(
              jsonSerialization['deliveryWindows'],
            ),
      cap: jsonSerialization['cap'] as int?,
      enabled: jsonSerialization['enabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
    );
  }

  static final t = ReminderRuleTable();

  static const db = ReminderRuleRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue? collectionId;

  int delayHours;

  /// Null means reminders may arrive at any time outside quiet hours.
  List<_i9bgfy5p.ReminderWindow>? deliveryWindows;

  /// Maximum reminders per day; null means no cap.
  int? cap;

  bool enabled;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ReminderRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReminderRule copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? collectionId,
    int? delayHours,
    List<_i9bgfy5p.ReminderWindow>? deliveryWindows,
    int? cap,
    bool? enabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReminderRule',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      if (collectionId != null) 'collectionId': collectionId?.toJson(),
      'delayHours': delayHours,
      if (deliveryWindows != null)
        'deliveryWindows': deliveryWindows?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (cap != null) 'cap': cap,
      'enabled': enabled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReminderRule',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      if (collectionId != null) 'collectionId': collectionId?.toJson(),
      'delayHours': delayHours,
      if (deliveryWindows != null)
        'deliveryWindows': deliveryWindows?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (cap != null) 'cap': cap,
      'enabled': enabled,
    };
  }

  static ReminderRuleInclude include() {
    return ReminderRuleInclude._();
  }

  static ReminderRuleIncludeList includeList({
    _is.WhereExpressionBuilder<ReminderRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReminderRuleTable>? orderBy,
    _is.OrderByListBuilder<ReminderRuleTable>? orderByList,
    ReminderRuleInclude? include,
  }) {
    return ReminderRuleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReminderRule.t),
      orderByList: orderByList?.call(ReminderRule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderRuleImpl extends ReminderRule {
  _ReminderRuleImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    _is.UuidValue? collectionId,
    int? delayHours,
    List<_i9bgfy5p.ReminderWindow>? deliveryWindows,
    int? cap,
    bool? enabled,
  }) : super._(
         id: id,
         ownerId: ownerId,
         collectionId: collectionId,
         delayHours: delayHours,
         deliveryWindows: deliveryWindows,
         cap: cap,
         enabled: enabled,
       );

  /// Returns a shallow copy of this [ReminderRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReminderRule copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    Object? collectionId = _Undefined,
    int? delayHours,
    Object? deliveryWindows = _Undefined,
    Object? cap = _Undefined,
    bool? enabled,
  }) {
    return ReminderRule(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      collectionId: collectionId is _is.UuidValue?
          ? collectionId
          : this.collectionId,
      delayHours: delayHours ?? this.delayHours,
      deliveryWindows: deliveryWindows is List<_i9bgfy5p.ReminderWindow>?
          ? deliveryWindows
          : this.deliveryWindows?.map((e0) => e0.copyWith()).toList(),
      cap: cap is int? ? cap : this.cap,
      enabled: enabled ?? this.enabled,
    );
  }
}

class ReminderRuleUpdateTable extends _is.UpdateTable<ReminderRuleTable> {
  ReminderRuleUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> collectionId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.collectionId,
    value,
  );

  _is.ColumnValue<int, int> delayHours(int value) => _is.ColumnValue(
    table.delayHours,
    value,
  );

  _is.ColumnValue<
    List<_i9bgfy5p.ReminderWindow>,
    List<_i9bgfy5p.ReminderWindow>
  >
  deliveryWindows(List<_i9bgfy5p.ReminderWindow>? value) => _is.ColumnValue(
    table.deliveryWindows,
    value,
  );

  _is.ColumnValue<int, int> cap(int? value) => _is.ColumnValue(
    table.cap,
    value,
  );

  _is.ColumnValue<bool, bool> enabled(bool value) => _is.ColumnValue(
    table.enabled,
    value,
  );
}

class ReminderRuleTable extends _is.Table<_is.UuidValue?> {
  ReminderRuleTable({super.tableRelation}) : super(tableName: 'reminder_rule') {
    updateTable = ReminderRuleUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    collectionId = _is.ColumnUuid(
      'collectionId',
      this,
    );
    delayHours = _is.ColumnInt(
      'delayHours',
      this,
      hasDefault: true,
    );
    deliveryWindows = _is.ColumnSerializable<List<_i9bgfy5p.ReminderWindow>>(
      'deliveryWindows',
      this,
    );
    cap = _is.ColumnInt(
      'cap',
      this,
    );
    enabled = _is.ColumnBool(
      'enabled',
      this,
      hasDefault: true,
    );
  }

  late final ReminderRuleUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid collectionId;

  late final _is.ColumnInt delayHours;

  /// Null means reminders may arrive at any time outside quiet hours.
  late final _is.ColumnSerializable<List<_i9bgfy5p.ReminderWindow>>
  deliveryWindows;

  /// Maximum reminders per day; null means no cap.
  late final _is.ColumnInt cap;

  late final _is.ColumnBool enabled;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    collectionId,
    delayHours,
    deliveryWindows,
    cap,
    enabled,
  ];
}

class ReminderRuleInclude extends _is.IncludeObject {
  ReminderRuleInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ReminderRule.t;
}

class ReminderRuleIncludeList extends _is.IncludeList {
  ReminderRuleIncludeList._({
    _is.WhereExpressionBuilder<ReminderRuleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReminderRule.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ReminderRule.t;
}

class ReminderRuleRepository {
  const ReminderRuleRepository._();

  /// Returns a list of [ReminderRule]s matching the given query parameters.
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
  Future<List<ReminderRule>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReminderRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReminderRuleTable>? orderBy,
    _is.OrderByListBuilder<ReminderRuleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReminderRule>(
      where: where?.call(ReminderRule.t),
      orderBy: orderBy?.call(ReminderRule.t),
      orderByList: orderByList?.call(ReminderRule.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReminderRule] matching the given query parameters.
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
  Future<ReminderRule?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReminderRuleTable>? where,
    int? offset,
    _is.OrderByBuilder<ReminderRuleTable>? orderBy,
    _is.OrderByListBuilder<ReminderRuleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReminderRule>(
      where: where?.call(ReminderRule.t),
      orderBy: orderBy?.call(ReminderRule.t),
      orderByList: orderByList?.call(ReminderRule.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReminderRule] by its [id] or null if no such row exists.
  Future<ReminderRule?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReminderRule>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReminderRule]s in the list and returns the inserted rows.
  ///
  /// The returned [ReminderRule]s will have their `id` fields set.
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
  Future<List<ReminderRule>> insert(
    _is.DatabaseSession session,
    List<ReminderRule> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReminderRule>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReminderRule] and returns the inserted row.
  ///
  /// The returned [ReminderRule] will have its `id` field set.
  Future<ReminderRule> insertRow(
    _is.DatabaseSession session,
    ReminderRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReminderRule>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReminderRule]s in the list and returns the resulting rows.
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
  /// The returned [ReminderRule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReminderRule>> upsert(
    _is.DatabaseSession session,
    List<ReminderRule> rows, {
    required _is.ColumnSelections<ReminderRuleTable> conflictColumns,
    _is.ColumnSelections<ReminderRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<ReminderRuleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReminderRule>(
      rows,
      conflictColumns: conflictColumns(ReminderRule.t),
      updateColumns: updateColumns?.call(ReminderRule.t),
      updateWhere: updateWhere?.call(ReminderRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReminderRule] and returns the resulting row.
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
  /// The returned [ReminderRule] will have its `id` field set.
  Future<ReminderRule?> upsertRow(
    _is.DatabaseSession session,
    ReminderRule row, {
    required _is.ColumnSelections<ReminderRuleTable> conflictColumns,
    _is.ColumnSelections<ReminderRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<ReminderRuleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReminderRule>(
      row,
      conflictColumns: conflictColumns(ReminderRule.t),
      updateColumns: updateColumns?.call(ReminderRule.t),
      updateWhere: updateWhere?.call(ReminderRule.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReminderRule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReminderRule>> update(
    _is.DatabaseSession session,
    List<ReminderRule> rows, {
    _is.ColumnSelections<ReminderRuleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReminderRule>(
      rows,
      columns: columns?.call(ReminderRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReminderRule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReminderRule> updateRow(
    _is.DatabaseSession session,
    ReminderRule row, {
    _is.ColumnSelections<ReminderRuleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReminderRule>(
      row,
      columns: columns?.call(ReminderRule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReminderRule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReminderRule?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ReminderRuleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReminderRule>(
      id,
      columnValues: columnValues(ReminderRule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReminderRule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReminderRule>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReminderRuleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ReminderRuleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReminderRuleTable>? orderBy,
    _is.OrderByListBuilder<ReminderRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReminderRule>(
      columnValues: columnValues(ReminderRule.t.updateTable),
      where: where(ReminderRule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReminderRule.t),
      orderByList: orderByList?.call(ReminderRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReminderRule]s in the list and returns the deleted rows.
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
  Future<List<ReminderRule>> delete(
    _is.DatabaseSession session,
    List<ReminderRule> rows, {
    _is.OrderByBuilder<ReminderRuleTable>? orderBy,
    _is.OrderByListBuilder<ReminderRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReminderRule>(
      rows,
      orderBy: orderBy?.call(ReminderRule.t),
      orderByList: orderByList?.call(ReminderRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReminderRule].
  Future<ReminderRule> deleteRow(
    _is.DatabaseSession session,
    ReminderRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReminderRule>(
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
  Future<List<ReminderRule>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReminderRuleTable> where,
    _is.OrderByBuilder<ReminderRuleTable>? orderBy,
    _is.OrderByListBuilder<ReminderRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReminderRule>(
      where: where(ReminderRule.t),
      orderBy: orderBy?.call(ReminderRule.t),
      orderByList: orderByList?.call(ReminderRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReminderRuleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReminderRule>(
      where: where?.call(ReminderRule.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReminderRule] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReminderRuleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReminderRule>(
      where: where(ReminderRule.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
