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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// One local day of a progress report.
abstract class ProgressDay
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProgressDay._({
    required this.date,
    required this.reviewedCount,
    this.cohortRate,
    required this.isToday,
    required this.isFuture,
  });

  factory ProgressDay({
    required String date,
    required int reviewedCount,
    double? cohortRate,
    required bool isToday,
    required bool isFuture,
  }) = _ProgressDayImpl;

  factory ProgressDay.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProgressDay(
      date: jsonSerialization['date'] as String,
      reviewedCount: jsonSerialization['reviewedCount'] as int,
      cohortRate: (jsonSerialization['cohortRate'] as num?)?.toDouble(),
      isToday: _isc.BoolJsonExtension.fromJson(jsonSerialization['isToday']),
      isFuture: _isc.BoolJsonExtension.fromJson(jsonSerialization['isFuture']),
    );
  }

  /// Local date, yyyy-MM-dd.
  String date;

  /// Distinct items with a valid review that day. Opens never count.
  int reviewedCount;

  /// Review rate of the items in the cohort saved by the end of this day.
  /// Null before anything was saved, and for days still to come.
  double? cohortRate;

  bool isToday;

  bool isFuture;

  /// Returns a shallow copy of this [ProgressDay]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProgressDay copyWith({
    String? date,
    int? reviewedCount,
    double? cohortRate,
    bool? isToday,
    bool? isFuture,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProgressDay',
      'date': date,
      'reviewedCount': reviewedCount,
      if (cohortRate != null) 'cohortRate': cohortRate,
      'isToday': isToday,
      'isFuture': isFuture,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProgressDay',
      'date': date,
      'reviewedCount': reviewedCount,
      if (cohortRate != null) 'cohortRate': cohortRate,
      'isToday': isToday,
      'isFuture': isFuture,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProgressDayImpl extends ProgressDay {
  _ProgressDayImpl({
    required String date,
    required int reviewedCount,
    double? cohortRate,
    required bool isToday,
    required bool isFuture,
  }) : super._(
         date: date,
         reviewedCount: reviewedCount,
         cohortRate: cohortRate,
         isToday: isToday,
         isFuture: isFuture,
       );

  /// Returns a shallow copy of this [ProgressDay]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProgressDay copyWith({
    String? date,
    int? reviewedCount,
    Object? cohortRate = _Undefined,
    bool? isToday,
    bool? isFuture,
  }) {
    return ProgressDay(
      date: date ?? this.date,
      reviewedCount: reviewedCount ?? this.reviewedCount,
      cohortRate: cohortRate is double? ? cohortRate : this.cohortRate,
      isToday: isToday ?? this.isToday,
      isFuture: isFuture ?? this.isFuture,
    );
  }
}
