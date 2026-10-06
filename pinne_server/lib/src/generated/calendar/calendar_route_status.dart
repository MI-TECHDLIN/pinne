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
import '../calendar/calendar_route.dart' as _iwvtbtmv;

/// What a route offers on this server, for the connections screen.
abstract class CalendarRouteStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CalendarRouteStatus._({
    required this.route,
    required this.label,
    required this.available,
    required this.liveSync,
    required this.canReadBusy,
    required this.canWrite,
    this.limitation,
  });

  factory CalendarRouteStatus({
    required _iwvtbtmv.CalendarRoute route,
    required String label,
    required bool available,
    required bool liveSync,
    required bool canReadBusy,
    required bool canWrite,
    String? limitation,
  }) = _CalendarRouteStatusImpl;

  factory CalendarRouteStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarRouteStatus(
      route: _iwvtbtmv.CalendarRoute.fromJson(
        (jsonSerialization['route'] as String),
      ),
      label: jsonSerialization['label'] as String,
      available: _is.BoolJsonExtension.fromJson(jsonSerialization['available']),
      liveSync: _is.BoolJsonExtension.fromJson(jsonSerialization['liveSync']),
      canReadBusy: _is.BoolJsonExtension.fromJson(
        jsonSerialization['canReadBusy'],
      ),
      canWrite: _is.BoolJsonExtension.fromJson(jsonSerialization['canWrite']),
      limitation: jsonSerialization['limitation'] as String?,
    );
  }

  _iwvtbtmv.CalendarRoute route;

  String label;

  /// False when the route cannot be used, such as missing configuration.
  bool available;

  /// Whether the route reads and writes a real calendar. False for export.
  bool liveSync;

  bool canReadBusy;

  bool canWrite;

  /// Plain-language limit to show next to the route.
  String? limitation;

  /// Returns a shallow copy of this [CalendarRouteStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CalendarRouteStatus copyWith({
    _iwvtbtmv.CalendarRoute? route,
    String? label,
    bool? available,
    bool? liveSync,
    bool? canReadBusy,
    bool? canWrite,
    String? limitation,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarRouteStatus',
      'route': route.toJson(),
      'label': label,
      'available': available,
      'liveSync': liveSync,
      'canReadBusy': canReadBusy,
      'canWrite': canWrite,
      if (limitation != null) 'limitation': limitation,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarRouteStatus',
      'route': route.toJson(),
      'label': label,
      'available': available,
      'liveSync': liveSync,
      'canReadBusy': canReadBusy,
      'canWrite': canWrite,
      if (limitation != null) 'limitation': limitation,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarRouteStatusImpl extends CalendarRouteStatus {
  _CalendarRouteStatusImpl({
    required _iwvtbtmv.CalendarRoute route,
    required String label,
    required bool available,
    required bool liveSync,
    required bool canReadBusy,
    required bool canWrite,
    String? limitation,
  }) : super._(
         route: route,
         label: label,
         available: available,
         liveSync: liveSync,
         canReadBusy: canReadBusy,
         canWrite: canWrite,
         limitation: limitation,
       );

  /// Returns a shallow copy of this [CalendarRouteStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CalendarRouteStatus copyWith({
    _iwvtbtmv.CalendarRoute? route,
    String? label,
    bool? available,
    bool? liveSync,
    bool? canReadBusy,
    bool? canWrite,
    Object? limitation = _Undefined,
  }) {
    return CalendarRouteStatus(
      route: route ?? this.route,
      label: label ?? this.label,
      available: available ?? this.available,
      liveSync: liveSync ?? this.liveSync,
      canReadBusy: canReadBusy ?? this.canReadBusy,
      canWrite: canWrite ?? this.canWrite,
      limitation: limitation is String? ? limitation : this.limitation,
    );
  }
}
