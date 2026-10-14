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
import '../progress/progress_day.dart' as _invmshpc;
import '../progress/streak_goal_period.dart' as _iln0fvkl;

/// Review-day progress inside the owner's chosen streak-goal window.
abstract class StreakGoalProgress
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StreakGoalProgress._({
    required this.period,
    required this.periodDays,
    required this.periodStartDate,
    required this.reviewDaysGoal,
    required this.reviewDayCount,
    required this.reached,
    required this.days,
  });

  factory StreakGoalProgress({
    required _iln0fvkl.StreakGoalPeriod period,
    required int periodDays,
    required String periodStartDate,
    required int reviewDaysGoal,
    required int reviewDayCount,
    required bool reached,
    required List<_invmshpc.ProgressDay> days,
  }) = _StreakGoalProgressImpl;

  factory StreakGoalProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return StreakGoalProgress(
      period: _iln0fvkl.StreakGoalPeriod.fromJson(
        (jsonSerialization['period'] as String),
      ),
      periodDays: jsonSerialization['periodDays'] as int,
      periodStartDate: jsonSerialization['periodStartDate'] as String,
      reviewDaysGoal: jsonSerialization['reviewDaysGoal'] as int,
      reviewDayCount: jsonSerialization['reviewDayCount'] as int,
      reached: _isc.BoolJsonExtension.fromJson(jsonSerialization['reached']),
      days: _iub9zyhg.Protocol().deserialize<List<_invmshpc.ProgressDay>>(
        jsonSerialization['days'],
      ),
    );
  }

  _iln0fvkl.StreakGoalPeriod period;

  /// The number of calendar days in this goal window.
  int periodDays;

  /// First local date in the current window, yyyy-MM-dd.
  String periodStartDate;

  /// Distinct review days needed to complete the goal.
  int reviewDaysGoal;

  int reviewDayCount;

  bool reached;

  /// Calendar days in the current window, oldest first.
  List<_invmshpc.ProgressDay> days;

  /// Returns a shallow copy of this [StreakGoalProgress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StreakGoalProgress copyWith({
    _iln0fvkl.StreakGoalPeriod? period,
    int? periodDays,
    String? periodStartDate,
    int? reviewDaysGoal,
    int? reviewDayCount,
    bool? reached,
    List<_invmshpc.ProgressDay>? days,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StreakGoalProgress',
      'period': period.toJson(),
      'periodDays': periodDays,
      'periodStartDate': periodStartDate,
      'reviewDaysGoal': reviewDaysGoal,
      'reviewDayCount': reviewDayCount,
      'reached': reached,
      'days': days.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StreakGoalProgress',
      'period': period.toJson(),
      'periodDays': periodDays,
      'periodStartDate': periodStartDate,
      'reviewDaysGoal': reviewDaysGoal,
      'reviewDayCount': reviewDayCount,
      'reached': reached,
      'days': days.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _StreakGoalProgressImpl extends StreakGoalProgress {
  _StreakGoalProgressImpl({
    required _iln0fvkl.StreakGoalPeriod period,
    required int periodDays,
    required String periodStartDate,
    required int reviewDaysGoal,
    required int reviewDayCount,
    required bool reached,
    required List<_invmshpc.ProgressDay> days,
  }) : super._(
         period: period,
         periodDays: periodDays,
         periodStartDate: periodStartDate,
         reviewDaysGoal: reviewDaysGoal,
         reviewDayCount: reviewDayCount,
         reached: reached,
         days: days,
       );

  /// Returns a shallow copy of this [StreakGoalProgress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StreakGoalProgress copyWith({
    _iln0fvkl.StreakGoalPeriod? period,
    int? periodDays,
    String? periodStartDate,
    int? reviewDaysGoal,
    int? reviewDayCount,
    bool? reached,
    List<_invmshpc.ProgressDay>? days,
  }) {
    return StreakGoalProgress(
      period: period ?? this.period,
      periodDays: periodDays ?? this.periodDays,
      periodStartDate: periodStartDate ?? this.periodStartDate,
      reviewDaysGoal: reviewDaysGoal ?? this.reviewDaysGoal,
      reviewDayCount: reviewDayCount ?? this.reviewDayCount,
      reached: reached ?? this.reached,
      days: days ?? this.days.map((e0) => e0.copyWith()).toList(),
    );
  }
}
