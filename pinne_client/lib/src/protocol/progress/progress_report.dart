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
import '../progress/collection_progress.dart' as _i1jt95qi;
import '../progress/progress_day.dart' as _invmshpc;
import '../progress/progress_milestone.dart' as _ikqw46tl;
import '../progress/progress_period.dart' as _ibqwo0mh;
import '../progress/weekly_goal_progress.dart' as _i8cu4i77;

/// Honest progress for one save cohort: the items saved from `startDate`
/// (inclusive) to `endDate` (exclusive), local to the query's offset.
/// Archived items stay in the cohort.
abstract class ProgressReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProgressReport._({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.today,
    required this.savedCount,
    required this.reviewedCount,
    required this.firstReviewedTodayCount,
    required this.remainingCount,
    required this.appliedCount,
    this.reviewRate,
    required this.reviewedInPeriodCount,
    required this.totalReviewedCount,
    required this.days,
    this.bestDayDate,
    required this.collections,
    required this.weeklyGoal,
    required this.streakEnabled,
    this.currentStreakDays,
    required this.milestones,
  });

  factory ProgressReport({
    required _ibqwo0mh.ProgressPeriod period,
    required String startDate,
    required String endDate,
    required String today,
    required int savedCount,
    required int reviewedCount,
    required int firstReviewedTodayCount,
    required int remainingCount,
    required int appliedCount,
    double? reviewRate,
    required int reviewedInPeriodCount,
    required int totalReviewedCount,
    required List<_invmshpc.ProgressDay> days,
    String? bestDayDate,
    required List<_i1jt95qi.CollectionProgress> collections,
    required _i8cu4i77.WeeklyGoalProgress weeklyGoal,
    required bool streakEnabled,
    int? currentStreakDays,
    required List<_ikqw46tl.ProgressMilestone> milestones,
  }) = _ProgressReportImpl;

  factory ProgressReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProgressReport(
      period: _ibqwo0mh.ProgressPeriod.fromJson(
        (jsonSerialization['period'] as String),
      ),
      startDate: jsonSerialization['startDate'] as String,
      endDate: jsonSerialization['endDate'] as String,
      today: jsonSerialization['today'] as String,
      savedCount: jsonSerialization['savedCount'] as int,
      reviewedCount: jsonSerialization['reviewedCount'] as int,
      firstReviewedTodayCount:
          jsonSerialization['firstReviewedTodayCount'] as int,
      remainingCount: jsonSerialization['remainingCount'] as int,
      appliedCount: jsonSerialization['appliedCount'] as int,
      reviewRate: (jsonSerialization['reviewRate'] as num?)?.toDouble(),
      reviewedInPeriodCount: jsonSerialization['reviewedInPeriodCount'] as int,
      totalReviewedCount: jsonSerialization['totalReviewedCount'] as int,
      days: _iub9zyhg.Protocol().deserialize<List<_invmshpc.ProgressDay>>(
        jsonSerialization['days'],
      ),
      bestDayDate: jsonSerialization['bestDayDate'] as String?,
      collections: _iub9zyhg.Protocol()
          .deserialize<List<_i1jt95qi.CollectionProgress>>(
            jsonSerialization['collections'],
          ),
      weeklyGoal: _iub9zyhg.Protocol()
          .deserialize<_i8cu4i77.WeeklyGoalProgress>(
            jsonSerialization['weeklyGoal'],
          ),
      streakEnabled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['streakEnabled'],
      ),
      currentStreakDays: jsonSerialization['currentStreakDays'] as int?,
      milestones: _iub9zyhg.Protocol()
          .deserialize<List<_ikqw46tl.ProgressMilestone>>(
            jsonSerialization['milestones'],
          ),
    );
  }

  _ibqwo0mh.ProgressPeriod period;

  String startDate;

  String endDate;

  String today;

  /// Cohort size.
  int savedCount;

  /// Cohort items reviewed at least once, to date.
  int reviewedCount;

  /// Cohort items whose first review happened today.
  int firstReviewedTodayCount;

  /// Cohort items not reviewed yet.
  int remainingCount;

  /// Cohort items marked applied.
  int appliedCount;

  /// reviewedCount / savedCount. Null for an empty cohort, never 0%.
  double? reviewRate;

  /// Distinct items, from any cohort, reviewed during the period.
  int reviewedInPeriodCount;

  /// Distinct items reviewed ever.
  int totalReviewedCount;

  List<_invmshpc.ProgressDay> days;

  /// The period day with the most reviews so far (earliest wins a tie).
  String? bestDayDate;

  List<_i1jt95qi.CollectionProgress> collections;

  _i8cu4i77.WeeklyGoalProgress weeklyGoal;

  bool streakEnabled;

  /// Consecutive local review days up to today, or up to yesterday while
  /// today is still open. Null unless streaks are enabled.
  int? currentStreakDays;

  List<_ikqw46tl.ProgressMilestone> milestones;

  /// Returns a shallow copy of this [ProgressReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProgressReport copyWith({
    _ibqwo0mh.ProgressPeriod? period,
    String? startDate,
    String? endDate,
    String? today,
    int? savedCount,
    int? reviewedCount,
    int? firstReviewedTodayCount,
    int? remainingCount,
    int? appliedCount,
    double? reviewRate,
    int? reviewedInPeriodCount,
    int? totalReviewedCount,
    List<_invmshpc.ProgressDay>? days,
    String? bestDayDate,
    List<_i1jt95qi.CollectionProgress>? collections,
    _i8cu4i77.WeeklyGoalProgress? weeklyGoal,
    bool? streakEnabled,
    int? currentStreakDays,
    List<_ikqw46tl.ProgressMilestone>? milestones,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProgressReport',
      'period': period.toJson(),
      'startDate': startDate,
      'endDate': endDate,
      'today': today,
      'savedCount': savedCount,
      'reviewedCount': reviewedCount,
      'firstReviewedTodayCount': firstReviewedTodayCount,
      'remainingCount': remainingCount,
      'appliedCount': appliedCount,
      if (reviewRate != null) 'reviewRate': reviewRate,
      'reviewedInPeriodCount': reviewedInPeriodCount,
      'totalReviewedCount': totalReviewedCount,
      'days': days.toJson(valueToJson: (v) => v.toJson()),
      if (bestDayDate != null) 'bestDayDate': bestDayDate,
      'collections': collections.toJson(valueToJson: (v) => v.toJson()),
      'weeklyGoal': weeklyGoal.toJson(),
      'streakEnabled': streakEnabled,
      if (currentStreakDays != null) 'currentStreakDays': currentStreakDays,
      'milestones': milestones.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProgressReport',
      'period': period.toJson(),
      'startDate': startDate,
      'endDate': endDate,
      'today': today,
      'savedCount': savedCount,
      'reviewedCount': reviewedCount,
      'firstReviewedTodayCount': firstReviewedTodayCount,
      'remainingCount': remainingCount,
      'appliedCount': appliedCount,
      if (reviewRate != null) 'reviewRate': reviewRate,
      'reviewedInPeriodCount': reviewedInPeriodCount,
      'totalReviewedCount': totalReviewedCount,
      'days': days.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (bestDayDate != null) 'bestDayDate': bestDayDate,
      'collections': collections.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'weeklyGoal': weeklyGoal.toJsonForProtocol(),
      'streakEnabled': streakEnabled,
      if (currentStreakDays != null) 'currentStreakDays': currentStreakDays,
      'milestones': milestones.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProgressReportImpl extends ProgressReport {
  _ProgressReportImpl({
    required _ibqwo0mh.ProgressPeriod period,
    required String startDate,
    required String endDate,
    required String today,
    required int savedCount,
    required int reviewedCount,
    required int firstReviewedTodayCount,
    required int remainingCount,
    required int appliedCount,
    double? reviewRate,
    required int reviewedInPeriodCount,
    required int totalReviewedCount,
    required List<_invmshpc.ProgressDay> days,
    String? bestDayDate,
    required List<_i1jt95qi.CollectionProgress> collections,
    required _i8cu4i77.WeeklyGoalProgress weeklyGoal,
    required bool streakEnabled,
    int? currentStreakDays,
    required List<_ikqw46tl.ProgressMilestone> milestones,
  }) : super._(
         period: period,
         startDate: startDate,
         endDate: endDate,
         today: today,
         savedCount: savedCount,
         reviewedCount: reviewedCount,
         firstReviewedTodayCount: firstReviewedTodayCount,
         remainingCount: remainingCount,
         appliedCount: appliedCount,
         reviewRate: reviewRate,
         reviewedInPeriodCount: reviewedInPeriodCount,
         totalReviewedCount: totalReviewedCount,
         days: days,
         bestDayDate: bestDayDate,
         collections: collections,
         weeklyGoal: weeklyGoal,
         streakEnabled: streakEnabled,
         currentStreakDays: currentStreakDays,
         milestones: milestones,
       );

  /// Returns a shallow copy of this [ProgressReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProgressReport copyWith({
    _ibqwo0mh.ProgressPeriod? period,
    String? startDate,
    String? endDate,
    String? today,
    int? savedCount,
    int? reviewedCount,
    int? firstReviewedTodayCount,
    int? remainingCount,
    int? appliedCount,
    Object? reviewRate = _Undefined,
    int? reviewedInPeriodCount,
    int? totalReviewedCount,
    List<_invmshpc.ProgressDay>? days,
    Object? bestDayDate = _Undefined,
    List<_i1jt95qi.CollectionProgress>? collections,
    _i8cu4i77.WeeklyGoalProgress? weeklyGoal,
    bool? streakEnabled,
    Object? currentStreakDays = _Undefined,
    List<_ikqw46tl.ProgressMilestone>? milestones,
  }) {
    return ProgressReport(
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      today: today ?? this.today,
      savedCount: savedCount ?? this.savedCount,
      reviewedCount: reviewedCount ?? this.reviewedCount,
      firstReviewedTodayCount:
          firstReviewedTodayCount ?? this.firstReviewedTodayCount,
      remainingCount: remainingCount ?? this.remainingCount,
      appliedCount: appliedCount ?? this.appliedCount,
      reviewRate: reviewRate is double? ? reviewRate : this.reviewRate,
      reviewedInPeriodCount:
          reviewedInPeriodCount ?? this.reviewedInPeriodCount,
      totalReviewedCount: totalReviewedCount ?? this.totalReviewedCount,
      days: days ?? this.days.map((e0) => e0.copyWith()).toList(),
      bestDayDate: bestDayDate is String? ? bestDayDate : this.bestDayDate,
      collections:
          collections ?? this.collections.map((e0) => e0.copyWith()).toList(),
      weeklyGoal: weeklyGoal ?? this.weeklyGoal.copyWith(),
      streakEnabled: streakEnabled ?? this.streakEnabled,
      currentStreakDays: currentStreakDays is int?
          ? currentStreakDays
          : this.currentStreakDays,
      milestones:
          milestones ?? this.milestones.map((e0) => e0.copyWith()).toList(),
    );
  }
}
