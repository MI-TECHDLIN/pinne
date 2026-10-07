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

/// A structured refusal from a calendar route: the operation is unsupported,
/// not configured, not permitted, or the calendar is read-only or gone.
abstract class CalendarRouteException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  CalendarRouteException._({
    required this.route,
    required this.capability,
    required this.failure,
    required this.message,
  });

  factory CalendarRouteException({
    required _iwvtbtmv.CalendarRoute route,
    required String capability,
    required String failure,
    required String message,
  }) = _CalendarRouteExceptionImpl;

  factory CalendarRouteException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CalendarRouteException(
      route: _iwvtbtmv.CalendarRoute.fromJson(
        (jsonSerialization['route'] as String),
      ),
      capability: jsonSerialization['capability'] as String,
      failure: jsonSerialization['failure'] as String,
      message: jsonSerialization['message'] as String,
    );
  }

  _iwvtbtmv.CalendarRoute route;

  /// `CalendarCapability` name from pinne_calendar, such as `readBusy`.
  String capability;

  /// `CapabilityFailure` name from pinne_calendar, such as `notConfigured`.
  String failure;

  String message;

  /// Returns a shallow copy of this [CalendarRouteException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CalendarRouteException copyWith({
    _iwvtbtmv.CalendarRoute? route,
    String? capability,
    String? failure,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarRouteException',
      'route': route.toJson(),
      'capability': capability,
      'failure': failure,
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarRouteException',
      'route': route.toJson(),
      'capability': capability,
      'failure': failure,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'CalendarRouteException(route: $route, capability: $capability, failure: $failure, message: $message)';
  }
}

class _CalendarRouteExceptionImpl extends CalendarRouteException {
  _CalendarRouteExceptionImpl({
    required _iwvtbtmv.CalendarRoute route,
    required String capability,
    required String failure,
    required String message,
  }) : super._(
         route: route,
         capability: capability,
         failure: failure,
         message: message,
       );

  /// Returns a shallow copy of this [CalendarRouteException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CalendarRouteException copyWith({
    _iwvtbtmv.CalendarRoute? route,
    String? capability,
    String? failure,
    String? message,
  }) {
    return CalendarRouteException(
      route: route ?? this.route,
      capability: capability ?? this.capability,
      failure: failure ?? this.failure,
      message: message ?? this.message,
    );
  }
}
