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
import 'package:pinne_client/src/protocol/protocol.dart' as _iub9zyhg;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../reviews/review_queue_entry.dart' as _ir1viouo;

abstract class ReviewQueueResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReviewQueueResult._({
    required this.entries,
    required this.timeBudgetMinutes,
    int? eligibleCount,
    this.latestDueAt,
    this.digestText,
  }) : eligibleCount = eligibleCount ?? 0;

  factory ReviewQueueResult({
    required List<_ir1viouo.ReviewQueueEntry> entries,
    required int timeBudgetMinutes,
    int? eligibleCount,
    DateTime? latestDueAt,
    String? digestText,
  }) = _ReviewQueueResultImpl;

  factory ReviewQueueResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewQueueResult(
      entries: _iub9zyhg.Protocol()
          .deserialize<List<_ir1viouo.ReviewQueueEntry>>(
            jsonSerialization['entries'],
          ),
      timeBudgetMinutes: jsonSerialization['timeBudgetMinutes'] as int,
      eligibleCount: jsonSerialization['eligibleCount'] as int?,
      latestDueAt: jsonSerialization['latestDueAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['latestDueAt'],
            ),
      digestText: jsonSerialization['digestText'] as String?,
    );
  }

  List<_ir1viouo.ReviewQueueEntry> entries;

  int timeBudgetMinutes;

  /// All currently eligible items before queue-size and time-budget limits.
  int eligibleCount;

  /// Most recent eligibility instant, used to avoid repeat digests when
  /// nothing new became due.
  DateTime? latestDueAt;

  String? digestText;

  /// Returns a shallow copy of this [ReviewQueueResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReviewQueueResult copyWith({
    List<_ir1viouo.ReviewQueueEntry>? entries,
    int? timeBudgetMinutes,
    int? eligibleCount,
    DateTime? latestDueAt,
    String? digestText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewQueueResult',
      'entries': entries.toJson(valueToJson: (v) => v.toJson()),
      'timeBudgetMinutes': timeBudgetMinutes,
      'eligibleCount': eligibleCount,
      if (latestDueAt != null) 'latestDueAt': latestDueAt?.toJson(),
      if (digestText != null) 'digestText': digestText,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewQueueResult',
      'entries': entries.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'timeBudgetMinutes': timeBudgetMinutes,
      'eligibleCount': eligibleCount,
      if (latestDueAt != null) 'latestDueAt': latestDueAt?.toJson(),
      if (digestText != null) 'digestText': digestText,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewQueueResultImpl extends ReviewQueueResult {
  _ReviewQueueResultImpl({
    required List<_ir1viouo.ReviewQueueEntry> entries,
    required int timeBudgetMinutes,
    int? eligibleCount,
    DateTime? latestDueAt,
    String? digestText,
  }) : super._(
         entries: entries,
         timeBudgetMinutes: timeBudgetMinutes,
         eligibleCount: eligibleCount,
         latestDueAt: latestDueAt,
         digestText: digestText,
       );

  /// Returns a shallow copy of this [ReviewQueueResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReviewQueueResult copyWith({
    List<_ir1viouo.ReviewQueueEntry>? entries,
    int? timeBudgetMinutes,
    int? eligibleCount,
    Object? latestDueAt = _Undefined,
    Object? digestText = _Undefined,
  }) {
    return ReviewQueueResult(
      entries: entries ?? this.entries.map((e0) => e0.copyWith()).toList(),
      timeBudgetMinutes: timeBudgetMinutes ?? this.timeBudgetMinutes,
      eligibleCount: eligibleCount ?? this.eligibleCount,
      latestDueAt: latestDueAt is DateTime? ? latestDueAt : this.latestDueAt,
      digestText: digestText is String? ? digestText : this.digestText,
    );
  }
}
