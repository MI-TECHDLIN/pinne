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
import '../planning/calendar_write.dart' as _i1s6l3r3;
import '../planning/session_view.dart' as _ixtjx98l;

abstract class PlanCommitResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlanCommitResult._({
    required this.sessions,
    required this.writes,
  });

  factory PlanCommitResult({
    required List<_ixtjx98l.SessionView> sessions,
    required List<_i1s6l3r3.CalendarWrite> writes,
  }) = _PlanCommitResultImpl;

  factory PlanCommitResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlanCommitResult(
      sessions: _iub9zyhg.Protocol().deserialize<List<_ixtjx98l.SessionView>>(
        jsonSerialization['sessions'],
      ),
      writes: _iub9zyhg.Protocol().deserialize<List<_i1s6l3r3.CalendarWrite>>(
        jsonSerialization['writes'],
      ),
    );
  }

  List<_ixtjx98l.SessionView> sessions;

  /// Calendar events this device should write now.
  List<_i1s6l3r3.CalendarWrite> writes;

  /// Returns a shallow copy of this [PlanCommitResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlanCommitResult copyWith({
    List<_ixtjx98l.SessionView>? sessions,
    List<_i1s6l3r3.CalendarWrite>? writes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlanCommitResult',
      'sessions': sessions.toJson(valueToJson: (v) => v.toJson()),
      'writes': writes.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlanCommitResult',
      'sessions': sessions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'writes': writes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _PlanCommitResultImpl extends PlanCommitResult {
  _PlanCommitResultImpl({
    required List<_ixtjx98l.SessionView> sessions,
    required List<_i1s6l3r3.CalendarWrite> writes,
  }) : super._(
         sessions: sessions,
         writes: writes,
       );

  /// Returns a shallow copy of this [PlanCommitResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlanCommitResult copyWith({
    List<_ixtjx98l.SessionView>? sessions,
    List<_i1s6l3r3.CalendarWrite>? writes,
  }) {
    return PlanCommitResult(
      sessions: sessions ?? this.sessions.map((e0) => e0.copyWith()).toList(),
      writes: writes ?? this.writes.map((e0) => e0.copyWith()).toList(),
    );
  }
}
