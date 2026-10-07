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
import '../planning/calendar_write.dart' as _i1s6l3r3;
import '../planning/session_view.dart' as _ixtjx98l;

abstract class SessionChangeResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SessionChangeResult._({
    required this.session,
    required this.writes,
  });

  factory SessionChangeResult({
    required _ixtjx98l.SessionView session,
    required List<_i1s6l3r3.CalendarWrite> writes,
  }) = _SessionChangeResultImpl;

  factory SessionChangeResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionChangeResult(
      session: _i2yoimhd.Protocol().deserialize<_ixtjx98l.SessionView>(
        jsonSerialization['session'],
      ),
      writes: _i2yoimhd.Protocol().deserialize<List<_i1s6l3r3.CalendarWrite>>(
        jsonSerialization['writes'],
      ),
    );
  }

  _ixtjx98l.SessionView session;

  List<_i1s6l3r3.CalendarWrite> writes;

  /// Returns a shallow copy of this [SessionChangeResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionChangeResult copyWith({
    _ixtjx98l.SessionView? session,
    List<_i1s6l3r3.CalendarWrite>? writes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionChangeResult',
      'session': session.toJson(),
      'writes': writes.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionChangeResult',
      'session': session.toJsonForProtocol(),
      'writes': writes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SessionChangeResultImpl extends SessionChangeResult {
  _SessionChangeResultImpl({
    required _ixtjx98l.SessionView session,
    required List<_i1s6l3r3.CalendarWrite> writes,
  }) : super._(
         session: session,
         writes: writes,
       );

  /// Returns a shallow copy of this [SessionChangeResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionChangeResult copyWith({
    _ixtjx98l.SessionView? session,
    List<_i1s6l3r3.CalendarWrite>? writes,
  }) {
    return SessionChangeResult(
      session: session ?? this.session.copyWith(),
      writes: writes ?? this.writes.map((e0) => e0.copyWith()).toList(),
    );
  }
}
