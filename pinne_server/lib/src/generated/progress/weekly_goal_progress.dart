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
import '../progress/progress_day.dart' as _invmshpc;

/// Distinct local review days in the current Monday-to-Sunday week.
abstract class WeeklyGoalProgress
    implements _is.SerializableModel, _is.ProtocolSerialization {
  WeeklyGoalProgress._({
    required this.weekStartDate,
    required this.goalDays,
    required this.reviewDayCount,
    required this.reached,
    required this.days,
  });

  factory WeeklyGoalProgress({
    required String weekStartDate,
    required int goalDays,
    required int reviewDayCount,
    required bool reached,
    required List<_invmshpc.ProgressDay> days,
  }) = _WeeklyGoalProgressImpl;

  factory WeeklyGoalProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return WeeklyGoalProgress(
      weekStartDate: jsonSerialization['weekStartDate'] as String,
      goalDays: jsonSerialization['goalDays'] as int,
      reviewDayCount: jsonSerialization['reviewDayCount'] as int,
      reached: _is.BoolJsonExtension.fromJson(jsonSerialization['reached']),
      days: _i2yoimhd.Protocol().deserialize<List<_invmshpc.ProgressDay>>(
        jsonSerialization['days'],
      ),
    );
  }

  /// Local Monday, yyyy-MM-dd.
  String weekStartDate;

  int goalDays;

  int reviewDayCount;

  bool reached;

  /// The seven days of the week, Monday first.
  List<_invmshpc.ProgressDay> days;

  /// Returns a shallow copy of this [WeeklyGoalProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WeeklyGoalProgress copyWith({
    String? weekStartDate,
    int? goalDays,
    int? reviewDayCount,
    bool? reached,
    List<_invmshpc.ProgressDay>? days,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WeeklyGoalProgress',
      'weekStartDate': weekStartDate,
      'goalDays': goalDays,
      'reviewDayCount': reviewDayCount,
      'reached': reached,
      'days': days.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WeeklyGoalProgress',
      'weekStartDate': weekStartDate,
      'goalDays': goalDays,
      'reviewDayCount': reviewDayCount,
      'reached': reached,
      'days': days.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _WeeklyGoalProgressImpl extends WeeklyGoalProgress {
  _WeeklyGoalProgressImpl({
    required String weekStartDate,
    required int goalDays,
    required int reviewDayCount,
    required bool reached,
    required List<_invmshpc.ProgressDay> days,
  }) : super._(
         weekStartDate: weekStartDate,
         goalDays: goalDays,
         reviewDayCount: reviewDayCount,
         reached: reached,
         days: days,
       );

  /// Returns a shallow copy of this [WeeklyGoalProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WeeklyGoalProgress copyWith({
    String? weekStartDate,
    int? goalDays,
    int? reviewDayCount,
    bool? reached,
    List<_invmshpc.ProgressDay>? days,
  }) {
    return WeeklyGoalProgress(
      weekStartDate: weekStartDate ?? this.weekStartDate,
      goalDays: goalDays ?? this.goalDays,
      reviewDayCount: reviewDayCount ?? this.reviewDayCount,
      reached: reached ?? this.reached,
      days: days ?? this.days.map((e0) => e0.copyWith()).toList(),
    );
  }
}
