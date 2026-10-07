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
import '../ai/ai_evidence_coverage.dart' as _i2dlbls7;
import '../ai/ai_suggestion_kind.dart' as _i21092i4;
import '../ai/ai_suggestion_status.dart' as _i42gk45p;
import '../common/assignment_origin.dart' as _i12d5boj;

/// A proposed organization change. Suggestions remain separate from manual
/// collection memberships and tags until the owner accepts them.
abstract class AiSuggestion
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AiSuggestion._({
    this.id,
    required this.ownerId,
    required this.itemId,
    required this.kind,
    _i12d5boj.AssignmentOrigin? origin,
    this.collectionId,
    this.value,
    required this.rationale,
    _i2dlbls7.AiEvidenceCoverage? evidenceCoverage,
    bool? uncertain,
    _i42gk45p.AiSuggestionStatus? status,
    DateTime? createdAt,
    this.resolvedAt,
  }) : origin = origin ?? _i12d5boj.AssignmentOrigin.ai,
       evidenceCoverage =
           evidenceCoverage ?? _i2dlbls7.AiEvidenceCoverage.metadataOnly,
       uncertain = uncertain ?? false,
       status = status ?? _i42gk45p.AiSuggestionStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory AiSuggestion({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    required _i21092i4.AiSuggestionKind kind,
    _i12d5boj.AssignmentOrigin? origin,
    _is.UuidValue? collectionId,
    String? value,
    required String rationale,
    _i2dlbls7.AiEvidenceCoverage? evidenceCoverage,
    bool? uncertain,
    _i42gk45p.AiSuggestionStatus? status,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) = _AiSuggestionImpl;

  factory AiSuggestion.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiSuggestion(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      kind: _i21092i4.AiSuggestionKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      origin: jsonSerialization['origin'] == null
          ? null
          : _i12d5boj.AssignmentOrigin.fromJson(
              (jsonSerialization['origin'] as String),
            ),
      collectionId: jsonSerialization['collectionId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['collectionId'],
            ),
      value: jsonSerialization['value'] as String?,
      rationale: jsonSerialization['rationale'] as String,
      evidenceCoverage: jsonSerialization['evidenceCoverage'] == null
          ? null
          : _i2dlbls7.AiEvidenceCoverage.fromJson(
              (jsonSerialization['evidenceCoverage'] as String),
            ),
      uncertain: jsonSerialization['uncertain'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['uncertain']),
      status: jsonSerialization['status'] == null
          ? null
          : _i42gk45p.AiSuggestionStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
    );
  }

  static final t = AiSuggestionTable();

  static const db = AiSuggestionRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _is.UuidValue itemId;

  _i21092i4.AiSuggestionKind kind;

  _i12d5boj.AssignmentOrigin origin;

  _is.UuidValue? collectionId;

  String? value;

  String rationale;

  _i2dlbls7.AiEvidenceCoverage evidenceCoverage;

  bool uncertain;

  _i42gk45p.AiSuggestionStatus status;

  DateTime createdAt;

  DateTime? resolvedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AiSuggestion]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiSuggestion copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    _i21092i4.AiSuggestionKind? kind,
    _i12d5boj.AssignmentOrigin? origin,
    _is.UuidValue? collectionId,
    String? value,
    String? rationale,
    _i2dlbls7.AiEvidenceCoverage? evidenceCoverage,
    bool? uncertain,
    _i42gk45p.AiSuggestionStatus? status,
    DateTime? createdAt,
    DateTime? resolvedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiSuggestion',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'kind': kind.toJson(),
      'origin': origin.toJson(),
      if (collectionId != null) 'collectionId': collectionId?.toJson(),
      if (value != null) 'value': value,
      'rationale': rationale,
      'evidenceCoverage': evidenceCoverage.toJson(),
      'uncertain': uncertain,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiSuggestion',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'kind': kind.toJson(),
      'origin': origin.toJson(),
      if (collectionId != null) 'collectionId': collectionId?.toJson(),
      if (value != null) 'value': value,
      'rationale': rationale,
      'evidenceCoverage': evidenceCoverage.toJson(),
      'uncertain': uncertain,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  static AiSuggestionInclude include() {
    return AiSuggestionInclude._();
  }

  static AiSuggestionIncludeList includeList({
    _is.WhereExpressionBuilder<AiSuggestionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiSuggestionTable>? orderBy,
    _is.OrderByListBuilder<AiSuggestionTable>? orderByList,
    AiSuggestionInclude? include,
  }) {
    return AiSuggestionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiSuggestion.t),
      orderByList: orderByList?.call(AiSuggestion.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiSuggestionImpl extends AiSuggestion {
  _AiSuggestionImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _is.UuidValue itemId,
    required _i21092i4.AiSuggestionKind kind,
    _i12d5boj.AssignmentOrigin? origin,
    _is.UuidValue? collectionId,
    String? value,
    required String rationale,
    _i2dlbls7.AiEvidenceCoverage? evidenceCoverage,
    bool? uncertain,
    _i42gk45p.AiSuggestionStatus? status,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         kind: kind,
         origin: origin,
         collectionId: collectionId,
         value: value,
         rationale: rationale,
         evidenceCoverage: evidenceCoverage,
         uncertain: uncertain,
         status: status,
         createdAt: createdAt,
         resolvedAt: resolvedAt,
       );

  /// Returns a shallow copy of this [AiSuggestion]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiSuggestion copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _is.UuidValue? itemId,
    _i21092i4.AiSuggestionKind? kind,
    _i12d5boj.AssignmentOrigin? origin,
    Object? collectionId = _Undefined,
    Object? value = _Undefined,
    String? rationale,
    _i2dlbls7.AiEvidenceCoverage? evidenceCoverage,
    bool? uncertain,
    _i42gk45p.AiSuggestionStatus? status,
    DateTime? createdAt,
    Object? resolvedAt = _Undefined,
  }) {
    return AiSuggestion(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      kind: kind ?? this.kind,
      origin: origin ?? this.origin,
      collectionId: collectionId is _is.UuidValue?
          ? collectionId
          : this.collectionId,
      value: value is String? ? value : this.value,
      rationale: rationale ?? this.rationale,
      evidenceCoverage: evidenceCoverage ?? this.evidenceCoverage,
      uncertain: uncertain ?? this.uncertain,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
    );
  }
}

class AiSuggestionUpdateTable extends _is.UpdateTable<AiSuggestionTable> {
  AiSuggestionUpdateTable(super.table);

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

  _is.ColumnValue<_i21092i4.AiSuggestionKind, _i21092i4.AiSuggestionKind> kind(
    _i21092i4.AiSuggestionKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<_i12d5boj.AssignmentOrigin, _i12d5boj.AssignmentOrigin>
  origin(_i12d5boj.AssignmentOrigin value) => _is.ColumnValue(
    table.origin,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> collectionId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.collectionId,
    value,
  );

  _is.ColumnValue<String, String> value(String? value) => _is.ColumnValue(
    table.value,
    value,
  );

  _is.ColumnValue<String, String> rationale(String value) => _is.ColumnValue(
    table.rationale,
    value,
  );

  _is.ColumnValue<_i2dlbls7.AiEvidenceCoverage, _i2dlbls7.AiEvidenceCoverage>
  evidenceCoverage(_i2dlbls7.AiEvidenceCoverage value) => _is.ColumnValue(
    table.evidenceCoverage,
    value,
  );

  _is.ColumnValue<bool, bool> uncertain(bool value) => _is.ColumnValue(
    table.uncertain,
    value,
  );

  _is.ColumnValue<_i42gk45p.AiSuggestionStatus, _i42gk45p.AiSuggestionStatus>
  status(_i42gk45p.AiSuggestionStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _is.ColumnValue(
        table.resolvedAt,
        value,
      );
}

class AiSuggestionTable extends _is.Table<_is.UuidValue?> {
  AiSuggestionTable({super.tableRelation}) : super(tableName: 'ai_suggestion') {
    updateTable = AiSuggestionUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    itemId = _is.ColumnUuid(
      'itemId',
      this,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    origin = _is.ColumnEnum(
      'origin',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    collectionId = _is.ColumnUuid(
      'collectionId',
      this,
    );
    value = _is.ColumnString(
      'value',
      this,
    );
    rationale = _is.ColumnString(
      'rationale',
      this,
    );
    evidenceCoverage = _is.ColumnEnum(
      'evidenceCoverage',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    uncertain = _is.ColumnBool(
      'uncertain',
      this,
      hasDefault: true,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    resolvedAt = _is.ColumnDateTime(
      'resolvedAt',
      this,
    );
  }

  late final AiSuggestionUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid itemId;

  late final _is.ColumnEnum<_i21092i4.AiSuggestionKind> kind;

  late final _is.ColumnEnum<_i12d5boj.AssignmentOrigin> origin;

  late final _is.ColumnUuid collectionId;

  late final _is.ColumnString value;

  late final _is.ColumnString rationale;

  late final _is.ColumnEnum<_i2dlbls7.AiEvidenceCoverage> evidenceCoverage;

  late final _is.ColumnBool uncertain;

  late final _is.ColumnEnum<_i42gk45p.AiSuggestionStatus> status;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime resolvedAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    itemId,
    kind,
    origin,
    collectionId,
    value,
    rationale,
    evidenceCoverage,
    uncertain,
    status,
    createdAt,
    resolvedAt,
  ];
}

class AiSuggestionInclude extends _is.IncludeObject {
  AiSuggestionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => AiSuggestion.t;
}

class AiSuggestionIncludeList extends _is.IncludeList {
  AiSuggestionIncludeList._({
    _is.WhereExpressionBuilder<AiSuggestionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AiSuggestion.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AiSuggestion.t;
}

class AiSuggestionRepository {
  const AiSuggestionRepository._();

  /// Returns a list of [AiSuggestion]s matching the given query parameters.
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
  Future<List<AiSuggestion>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiSuggestionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiSuggestionTable>? orderBy,
    _is.OrderByListBuilder<AiSuggestionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AiSuggestion>(
      where: where?.call(AiSuggestion.t),
      orderBy: orderBy?.call(AiSuggestion.t),
      orderByList: orderByList?.call(AiSuggestion.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AiSuggestion] matching the given query parameters.
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
  Future<AiSuggestion?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiSuggestionTable>? where,
    int? offset,
    _is.OrderByBuilder<AiSuggestionTable>? orderBy,
    _is.OrderByListBuilder<AiSuggestionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AiSuggestion>(
      where: where?.call(AiSuggestion.t),
      orderBy: orderBy?.call(AiSuggestion.t),
      orderByList: orderByList?.call(AiSuggestion.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AiSuggestion] by its [id] or null if no such row exists.
  Future<AiSuggestion?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AiSuggestion>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AiSuggestion]s in the list and returns the inserted rows.
  ///
  /// The returned [AiSuggestion]s will have their `id` fields set.
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
  Future<List<AiSuggestion>> insert(
    _is.DatabaseSession session,
    List<AiSuggestion> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AiSuggestion>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AiSuggestion] and returns the inserted row.
  ///
  /// The returned [AiSuggestion] will have its `id` field set.
  Future<AiSuggestion> insertRow(
    _is.DatabaseSession session,
    AiSuggestion row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AiSuggestion>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AiSuggestion]s in the list and returns the resulting rows.
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
  /// The returned [AiSuggestion]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiSuggestion>> upsert(
    _is.DatabaseSession session,
    List<AiSuggestion> rows, {
    required _is.ColumnSelections<AiSuggestionTable> conflictColumns,
    _is.ColumnSelections<AiSuggestionTable>? updateColumns,
    _is.WhereExpressionBuilder<AiSuggestionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AiSuggestion>(
      rows,
      conflictColumns: conflictColumns(AiSuggestion.t),
      updateColumns: updateColumns?.call(AiSuggestion.t),
      updateWhere: updateWhere?.call(AiSuggestion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AiSuggestion] and returns the resulting row.
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
  /// The returned [AiSuggestion] will have its `id` field set.
  Future<AiSuggestion?> upsertRow(
    _is.DatabaseSession session,
    AiSuggestion row, {
    required _is.ColumnSelections<AiSuggestionTable> conflictColumns,
    _is.ColumnSelections<AiSuggestionTable>? updateColumns,
    _is.WhereExpressionBuilder<AiSuggestionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AiSuggestion>(
      row,
      conflictColumns: conflictColumns(AiSuggestion.t),
      updateColumns: updateColumns?.call(AiSuggestion.t),
      updateWhere: updateWhere?.call(AiSuggestion.t),
      transaction: transaction,
    );
  }

  /// Updates all [AiSuggestion]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiSuggestion>> update(
    _is.DatabaseSession session,
    List<AiSuggestion> rows, {
    _is.ColumnSelections<AiSuggestionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AiSuggestion>(
      rows,
      columns: columns?.call(AiSuggestion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AiSuggestion]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AiSuggestion> updateRow(
    _is.DatabaseSession session,
    AiSuggestion row, {
    _is.ColumnSelections<AiSuggestionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AiSuggestion>(
      row,
      columns: columns?.call(AiSuggestion.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiSuggestion] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AiSuggestion?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AiSuggestionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AiSuggestion>(
      id,
      columnValues: columnValues(AiSuggestion.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AiSuggestion]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiSuggestion>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AiSuggestionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AiSuggestionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiSuggestionTable>? orderBy,
    _is.OrderByListBuilder<AiSuggestionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AiSuggestion>(
      columnValues: columnValues(AiSuggestion.t.updateTable),
      where: where(AiSuggestion.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiSuggestion.t),
      orderByList: orderByList?.call(AiSuggestion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AiSuggestion]s in the list and returns the deleted rows.
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
  Future<List<AiSuggestion>> delete(
    _is.DatabaseSession session,
    List<AiSuggestion> rows, {
    _is.OrderByBuilder<AiSuggestionTable>? orderBy,
    _is.OrderByListBuilder<AiSuggestionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AiSuggestion>(
      rows,
      orderBy: orderBy?.call(AiSuggestion.t),
      orderByList: orderByList?.call(AiSuggestion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AiSuggestion].
  Future<AiSuggestion> deleteRow(
    _is.DatabaseSession session,
    AiSuggestion row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AiSuggestion>(
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
  Future<List<AiSuggestion>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiSuggestionTable> where,
    _is.OrderByBuilder<AiSuggestionTable>? orderBy,
    _is.OrderByListBuilder<AiSuggestionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AiSuggestion>(
      where: where(AiSuggestion.t),
      orderBy: orderBy?.call(AiSuggestion.t),
      orderByList: orderByList?.call(AiSuggestion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiSuggestionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AiSuggestion>(
      where: where?.call(AiSuggestion.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AiSuggestion] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiSuggestionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AiSuggestion>(
      where: where(AiSuggestion.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
