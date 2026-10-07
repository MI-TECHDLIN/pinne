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

/// An occupied time read from a calendar: UTC, start inclusive, end
/// exclusive.
abstract class BusyInterval
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  BusyInterval._({
    required this.startAt,
    required this.endAt,
    required this.allDay,
    this.sessionUid,
  });

  factory BusyInterval({
    required DateTime startAt,
    required DateTime endAt,
    required bool allDay,
    String? sessionUid,
  }) = _BusyIntervalImpl;

  factory BusyInterval.fromJson(Map<String, dynamic> jsonSerialization) {
    return BusyInterval(
      startAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startAt'],
      ),
      endAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      allDay: _isc.BoolJsonExtension.fromJson(jsonSerialization['allDay']),
      sessionUid: jsonSerialization['sessionUid'] as String?,
    );
  }

  DateTime startAt;

  DateTime endAt;

  bool allDay;

  /// Set when the event is one Pinne wrote for a session.
  String? sessionUid;

  /// Returns a shallow copy of this [BusyInterval]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  BusyInterval copyWith({
    DateTime? startAt,
    DateTime? endAt,
    bool? allDay,
    String? sessionUid,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BusyInterval',
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'allDay': allDay,
      if (sessionUid != null) 'sessionUid': sessionUid,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BusyInterval',
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'allDay': allDay,
      if (sessionUid != null) 'sessionUid': sessionUid,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BusyIntervalImpl extends BusyInterval {
  _BusyIntervalImpl({
    required DateTime startAt,
    required DateTime endAt,
    required bool allDay,
    String? sessionUid,
  }) : super._(
         startAt: startAt,
         endAt: endAt,
         allDay: allDay,
         sessionUid: sessionUid,
       );

  /// Returns a shallow copy of this [BusyInterval]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  BusyInterval copyWith({
    DateTime? startAt,
    DateTime? endAt,
    bool? allDay,
    Object? sessionUid = _Undefined,
  }) {
    return BusyInterval(
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      allDay: allDay ?? this.allDay,
      sessionUid: sessionUid is String? ? sessionUid : this.sessionUid,
    );
  }
}
