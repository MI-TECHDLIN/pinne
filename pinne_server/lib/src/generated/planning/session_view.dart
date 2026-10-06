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
import '../calendar/event_sync_state.dart' as _ipxlzb0n;
import '../planning/review_session.dart' as _iudifq2v;
import '../planning/session_item_view.dart' as _i54lk8gs;

/// A session with what it holds and where its event lives.
abstract class SessionView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SessionView._({
    required this.session,
    required this.items,
    this.calendarName,
    this.syncState,
  });

  factory SessionView({
    required _iudifq2v.ReviewSession session,
    required List<_i54lk8gs.SessionItemView> items,
    String? calendarName,
    _ipxlzb0n.EventSyncState? syncState,
  }) = _SessionViewImpl;

  factory SessionView.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionView(
      session: _i2yoimhd.Protocol().deserialize<_iudifq2v.ReviewSession>(
        jsonSerialization['session'],
      ),
      items: _i2yoimhd.Protocol().deserialize<List<_i54lk8gs.SessionItemView>>(
        jsonSerialization['items'],
      ),
      calendarName: jsonSerialization['calendarName'] as String?,
      syncState: jsonSerialization['syncState'] == null
          ? null
          : _ipxlzb0n.EventSyncState.fromJson(
              (jsonSerialization['syncState'] as String),
            ),
    );
  }

  _iudifq2v.ReviewSession session;

  List<_i54lk8gs.SessionItemView> items;

  /// The calendar the event is written to, if any.
  String? calendarName;

  _ipxlzb0n.EventSyncState? syncState;

  /// Returns a shallow copy of this [SessionView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionView copyWith({
    _iudifq2v.ReviewSession? session,
    List<_i54lk8gs.SessionItemView>? items,
    String? calendarName,
    _ipxlzb0n.EventSyncState? syncState,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionView',
      'session': session.toJson(),
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      if (calendarName != null) 'calendarName': calendarName,
      if (syncState != null) 'syncState': syncState?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionView',
      'session': session.toJsonForProtocol(),
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (calendarName != null) 'calendarName': calendarName,
      if (syncState != null) 'syncState': syncState?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionViewImpl extends SessionView {
  _SessionViewImpl({
    required _iudifq2v.ReviewSession session,
    required List<_i54lk8gs.SessionItemView> items,
    String? calendarName,
    _ipxlzb0n.EventSyncState? syncState,
  }) : super._(
         session: session,
         items: items,
         calendarName: calendarName,
         syncState: syncState,
       );

  /// Returns a shallow copy of this [SessionView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionView copyWith({
    _iudifq2v.ReviewSession? session,
    List<_i54lk8gs.SessionItemView>? items,
    Object? calendarName = _Undefined,
    Object? syncState = _Undefined,
  }) {
    return SessionView(
      session: session ?? this.session.copyWith(),
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      calendarName: calendarName is String? ? calendarName : this.calendarName,
      syncState: syncState is _ipxlzb0n.EventSyncState?
          ? syncState
          : this.syncState,
    );
  }
}
