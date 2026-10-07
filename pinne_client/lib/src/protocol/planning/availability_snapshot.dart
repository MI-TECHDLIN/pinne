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
import '../planning/busy_interval.dart' as _iduyz7du;

/// Busy times the device read from one selected calendar, and when.
abstract class AvailabilitySnapshot
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AvailabilitySnapshot._({
    required this.selectionId,
    required this.checkedAt,
    required this.windowStart,
    required this.windowEnd,
    required this.readable,
    this.problem,
    required this.intervals,
  });

  factory AvailabilitySnapshot({
    required _isc.UuidValue selectionId,
    required DateTime checkedAt,
    required DateTime windowStart,
    required DateTime windowEnd,
    required bool readable,
    String? problem,
    required List<_iduyz7du.BusyInterval> intervals,
  }) = _AvailabilitySnapshotImpl;

  factory AvailabilitySnapshot.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AvailabilitySnapshot(
      selectionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['selectionId'],
      ),
      checkedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['checkedAt'],
      ),
      windowStart: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['windowStart'],
      ),
      windowEnd: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['windowEnd'],
      ),
      readable: _isc.BoolJsonExtension.fromJson(jsonSerialization['readable']),
      problem: jsonSerialization['problem'] as String?,
      intervals: _iub9zyhg.Protocol().deserialize<List<_iduyz7du.BusyInterval>>(
        jsonSerialization['intervals'],
      ),
    );
  }

  _isc.UuidValue selectionId;

  DateTime checkedAt;

  DateTime windowStart;

  DateTime windowEnd;

  /// False when the calendar could not be read; intervals are then empty
  /// and the calendar counts as unknown, never as free.
  bool readable;

  String? problem;

  List<_iduyz7du.BusyInterval> intervals;

  /// Returns a shallow copy of this [AvailabilitySnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AvailabilitySnapshot copyWith({
    _isc.UuidValue? selectionId,
    DateTime? checkedAt,
    DateTime? windowStart,
    DateTime? windowEnd,
    bool? readable,
    String? problem,
    List<_iduyz7du.BusyInterval>? intervals,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AvailabilitySnapshot',
      'selectionId': selectionId.toJson(),
      'checkedAt': checkedAt.toJson(),
      'windowStart': windowStart.toJson(),
      'windowEnd': windowEnd.toJson(),
      'readable': readable,
      if (problem != null) 'problem': problem,
      'intervals': intervals.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AvailabilitySnapshot',
      'selectionId': selectionId.toJson(),
      'checkedAt': checkedAt.toJson(),
      'windowStart': windowStart.toJson(),
      'windowEnd': windowEnd.toJson(),
      'readable': readable,
      if (problem != null) 'problem': problem,
      'intervals': intervals.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AvailabilitySnapshotImpl extends AvailabilitySnapshot {
  _AvailabilitySnapshotImpl({
    required _isc.UuidValue selectionId,
    required DateTime checkedAt,
    required DateTime windowStart,
    required DateTime windowEnd,
    required bool readable,
    String? problem,
    required List<_iduyz7du.BusyInterval> intervals,
  }) : super._(
         selectionId: selectionId,
         checkedAt: checkedAt,
         windowStart: windowStart,
         windowEnd: windowEnd,
         readable: readable,
         problem: problem,
         intervals: intervals,
       );

  /// Returns a shallow copy of this [AvailabilitySnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AvailabilitySnapshot copyWith({
    _isc.UuidValue? selectionId,
    DateTime? checkedAt,
    DateTime? windowStart,
    DateTime? windowEnd,
    bool? readable,
    Object? problem = _Undefined,
    List<_iduyz7du.BusyInterval>? intervals,
  }) {
    return AvailabilitySnapshot(
      selectionId: selectionId ?? this.selectionId,
      checkedAt: checkedAt ?? this.checkedAt,
      windowStart: windowStart ?? this.windowStart,
      windowEnd: windowEnd ?? this.windowEnd,
      readable: readable ?? this.readable,
      problem: problem is String? ? problem : this.problem,
      intervals:
          intervals ?? this.intervals.map((e0) => e0.copyWith()).toList(),
    );
  }
}
