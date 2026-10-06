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
import '../planning/approval_mode.dart' as _i6o5tozv;
import '../planning/review_plan.dart' as _i05x0ngt;
import '../planning/session_view.dart' as _ixtjx98l;

/// Sessions that are not committed yet, with the availability coverage
/// behind them.
abstract class PlanProposal
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlanProposal._({
    required this.plan,
    required this.sessions,
    required this.approvalMode,
    required this.canCommit,
    this.commitBlockedReason,
    this.shortfall,
    this.writeCalendarName,
  });

  factory PlanProposal({
    required _i05x0ngt.ReviewPlan plan,
    required List<_ixtjx98l.SessionView> sessions,
    required _i6o5tozv.ApprovalMode approvalMode,
    required bool canCommit,
    String? commitBlockedReason,
    String? shortfall,
    String? writeCalendarName,
  }) = _PlanProposalImpl;

  factory PlanProposal.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlanProposal(
      plan: _iub9zyhg.Protocol().deserialize<_i05x0ngt.ReviewPlan>(
        jsonSerialization['plan'],
      ),
      sessions: _iub9zyhg.Protocol().deserialize<List<_ixtjx98l.SessionView>>(
        jsonSerialization['sessions'],
      ),
      approvalMode: _i6o5tozv.ApprovalMode.fromJson(
        (jsonSerialization['approvalMode'] as String),
      ),
      canCommit: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['canCommit'],
      ),
      commitBlockedReason: jsonSerialization['commitBlockedReason'] as String?,
      shortfall: jsonSerialization['shortfall'] as String?,
      writeCalendarName: jsonSerialization['writeCalendarName'] as String?,
    );
  }

  _i05x0ngt.ReviewPlan plan;

  List<_ixtjx98l.SessionView> sessions;

  _i6o5tozv.ApprovalMode approvalMode;

  /// Whether the user may accept this plan as checked.
  bool canCommit;

  /// Why not, in plain language.
  String? commitBlockedReason;

  /// Why fewer sessions than asked, if so.
  String? shortfall;

  /// Where accepted sessions will be written, if anywhere.
  String? writeCalendarName;

  /// Returns a shallow copy of this [PlanProposal]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlanProposal copyWith({
    _i05x0ngt.ReviewPlan? plan,
    List<_ixtjx98l.SessionView>? sessions,
    _i6o5tozv.ApprovalMode? approvalMode,
    bool? canCommit,
    String? commitBlockedReason,
    String? shortfall,
    String? writeCalendarName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlanProposal',
      'plan': plan.toJson(),
      'sessions': sessions.toJson(valueToJson: (v) => v.toJson()),
      'approvalMode': approvalMode.toJson(),
      'canCommit': canCommit,
      if (commitBlockedReason != null)
        'commitBlockedReason': commitBlockedReason,
      if (shortfall != null) 'shortfall': shortfall,
      if (writeCalendarName != null) 'writeCalendarName': writeCalendarName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlanProposal',
      'plan': plan.toJsonForProtocol(),
      'sessions': sessions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'approvalMode': approvalMode.toJson(),
      'canCommit': canCommit,
      if (commitBlockedReason != null)
        'commitBlockedReason': commitBlockedReason,
      if (shortfall != null) 'shortfall': shortfall,
      if (writeCalendarName != null) 'writeCalendarName': writeCalendarName,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlanProposalImpl extends PlanProposal {
  _PlanProposalImpl({
    required _i05x0ngt.ReviewPlan plan,
    required List<_ixtjx98l.SessionView> sessions,
    required _i6o5tozv.ApprovalMode approvalMode,
    required bool canCommit,
    String? commitBlockedReason,
    String? shortfall,
    String? writeCalendarName,
  }) : super._(
         plan: plan,
         sessions: sessions,
         approvalMode: approvalMode,
         canCommit: canCommit,
         commitBlockedReason: commitBlockedReason,
         shortfall: shortfall,
         writeCalendarName: writeCalendarName,
       );

  /// Returns a shallow copy of this [PlanProposal]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlanProposal copyWith({
    _i05x0ngt.ReviewPlan? plan,
    List<_ixtjx98l.SessionView>? sessions,
    _i6o5tozv.ApprovalMode? approvalMode,
    bool? canCommit,
    Object? commitBlockedReason = _Undefined,
    Object? shortfall = _Undefined,
    Object? writeCalendarName = _Undefined,
  }) {
    return PlanProposal(
      plan: plan ?? this.plan.copyWith(),
      sessions: sessions ?? this.sessions.map((e0) => e0.copyWith()).toList(),
      approvalMode: approvalMode ?? this.approvalMode,
      canCommit: canCommit ?? this.canCommit,
      commitBlockedReason: commitBlockedReason is String?
          ? commitBlockedReason
          : this.commitBlockedReason,
      shortfall: shortfall is String? ? shortfall : this.shortfall,
      writeCalendarName: writeCalendarName is String?
          ? writeCalendarName
          : this.writeCalendarName,
    );
  }
}
