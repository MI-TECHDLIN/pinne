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

/// A daily window in which reminders may be delivered, in the user's local
/// time. Minutes are counted from local midnight.
abstract class ReminderWindow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReminderWindow._({
    required this.startMinute,
    required this.endMinute,
    required this.weekdays,
  });

  factory ReminderWindow({
    required int startMinute,
    required int endMinute,
    required List<int> weekdays,
  }) = _ReminderWindowImpl;

  factory ReminderWindow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReminderWindow(
      startMinute: jsonSerialization['startMinute'] as int,
      endMinute: jsonSerialization['endMinute'] as int,
      weekdays: _iub9zyhg.Protocol().deserialize<List<int>>(
        jsonSerialization['weekdays'],
      ),
    );
  }

  int startMinute;

  int endMinute;

  /// ISO weekdays 1 (Monday) to 7 (Sunday). Empty means every day.
  List<int> weekdays;

  /// Returns a shallow copy of this [ReminderWindow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReminderWindow copyWith({
    int? startMinute,
    int? endMinute,
    List<int>? weekdays,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReminderWindow',
      'startMinute': startMinute,
      'endMinute': endMinute,
      'weekdays': weekdays.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReminderWindow',
      'startMinute': startMinute,
      'endMinute': endMinute,
      'weekdays': weekdays.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ReminderWindowImpl extends ReminderWindow {
  _ReminderWindowImpl({
    required int startMinute,
    required int endMinute,
    required List<int> weekdays,
  }) : super._(
         startMinute: startMinute,
         endMinute: endMinute,
         weekdays: weekdays,
       );

  /// Returns a shallow copy of this [ReminderWindow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReminderWindow copyWith({
    int? startMinute,
    int? endMinute,
    List<int>? weekdays,
  }) {
    return ReminderWindow(
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      weekdays: weekdays ?? this.weekdays.map((e0) => e0).toList(),
    );
  }
}
