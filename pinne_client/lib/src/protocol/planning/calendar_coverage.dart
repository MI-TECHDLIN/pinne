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
import '../calendar/calendar_route.dart' as _iwvtbtmv;
import '../planning/coverage_state.dart' as _iqiuxh8l;

/// Which calendar was checked for a plan, and how well.
abstract class CalendarCoverage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CalendarCoverage._({
    required this.selectionId,
    required this.calendarName,
    required this.route,
    required this.state,
    this.checkedAt,
  });

  factory CalendarCoverage({
    required _isc.UuidValue selectionId,
    required String calendarName,
    required _iwvtbtmv.CalendarRoute route,
    required _iqiuxh8l.CoverageState state,
    DateTime? checkedAt,
  }) = _CalendarCoverageImpl;

  factory CalendarCoverage.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarCoverage(
      selectionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['selectionId'],
      ),
      calendarName: jsonSerialization['calendarName'] as String,
      route: _iwvtbtmv.CalendarRoute.fromJson(
        (jsonSerialization['route'] as String),
      ),
      state: _iqiuxh8l.CoverageState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      checkedAt: jsonSerialization['checkedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['checkedAt']),
    );
  }

  _isc.UuidValue selectionId;

  String calendarName;

  _iwvtbtmv.CalendarRoute route;

  _iqiuxh8l.CoverageState state;

  DateTime? checkedAt;

  /// Returns a shallow copy of this [CalendarCoverage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CalendarCoverage copyWith({
    _isc.UuidValue? selectionId,
    String? calendarName,
    _iwvtbtmv.CalendarRoute? route,
    _iqiuxh8l.CoverageState? state,
    DateTime? checkedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarCoverage',
      'selectionId': selectionId.toJson(),
      'calendarName': calendarName,
      'route': route.toJson(),
      'state': state.toJson(),
      if (checkedAt != null) 'checkedAt': checkedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarCoverage',
      'selectionId': selectionId.toJson(),
      'calendarName': calendarName,
      'route': route.toJson(),
      'state': state.toJson(),
      if (checkedAt != null) 'checkedAt': checkedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarCoverageImpl extends CalendarCoverage {
  _CalendarCoverageImpl({
    required _isc.UuidValue selectionId,
    required String calendarName,
    required _iwvtbtmv.CalendarRoute route,
    required _iqiuxh8l.CoverageState state,
    DateTime? checkedAt,
  }) : super._(
         selectionId: selectionId,
         calendarName: calendarName,
         route: route,
         state: state,
         checkedAt: checkedAt,
       );

  /// Returns a shallow copy of this [CalendarCoverage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CalendarCoverage copyWith({
    _isc.UuidValue? selectionId,
    String? calendarName,
    _iwvtbtmv.CalendarRoute? route,
    _iqiuxh8l.CoverageState? state,
    Object? checkedAt = _Undefined,
  }) {
    return CalendarCoverage(
      selectionId: selectionId ?? this.selectionId,
      calendarName: calendarName ?? this.calendarName,
      route: route ?? this.route,
      state: state ?? this.state,
      checkedAt: checkedAt is DateTime? ? checkedAt : this.checkedAt,
    );
  }
}
