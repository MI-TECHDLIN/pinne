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
import '../calendar/calendar_connection.dart' as _i2w0t5s0;
import '../calendar/calendar_selection.dart' as _iwh5oal1;

/// A connection with its calendars.
abstract class CalendarConnectionView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CalendarConnectionView._({
    required this.connection,
    required this.selections,
  });

  factory CalendarConnectionView({
    required _i2w0t5s0.CalendarConnection connection,
    required List<_iwh5oal1.CalendarSelection> selections,
  }) = _CalendarConnectionViewImpl;

  factory CalendarConnectionView.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CalendarConnectionView(
      connection: _i2yoimhd.Protocol()
          .deserialize<_i2w0t5s0.CalendarConnection>(
            jsonSerialization['connection'],
          ),
      selections: _i2yoimhd.Protocol()
          .deserialize<List<_iwh5oal1.CalendarSelection>>(
            jsonSerialization['selections'],
          ),
    );
  }

  _i2w0t5s0.CalendarConnection connection;

  List<_iwh5oal1.CalendarSelection> selections;

  /// Returns a shallow copy of this [CalendarConnectionView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CalendarConnectionView copyWith({
    _i2w0t5s0.CalendarConnection? connection,
    List<_iwh5oal1.CalendarSelection>? selections,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarConnectionView',
      'connection': connection.toJson(),
      'selections': selections.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarConnectionView',
      'connection': connection.toJsonForProtocol(),
      'selections': selections.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CalendarConnectionViewImpl extends CalendarConnectionView {
  _CalendarConnectionViewImpl({
    required _i2w0t5s0.CalendarConnection connection,
    required List<_iwh5oal1.CalendarSelection> selections,
  }) : super._(
         connection: connection,
         selections: selections,
       );

  /// Returns a shallow copy of this [CalendarConnectionView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CalendarConnectionView copyWith({
    _i2w0t5s0.CalendarConnection? connection,
    List<_iwh5oal1.CalendarSelection>? selections,
  }) {
    return CalendarConnectionView(
      connection: connection ?? this.connection.copyWith(),
      selections:
          selections ?? this.selections.map((e0) => e0.copyWith()).toList(),
    );
  }
}
