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
import '../progress/milestone_kind.dart' as _ijycivqz;

/// A milestone the owner has reached. `key` is stable, so each one
/// celebrates exactly once.
abstract class ProgressMilestone
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProgressMilestone._({
    required this.key,
    required this.kind,
    required this.value,
    required this.celebrated,
  });

  factory ProgressMilestone({
    required String key,
    required _ijycivqz.MilestoneKind kind,
    required int value,
    required bool celebrated,
  }) = _ProgressMilestoneImpl;

  factory ProgressMilestone.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProgressMilestone(
      key: jsonSerialization['key'] as String,
      kind: _ijycivqz.MilestoneKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      value: jsonSerialization['value'] as int,
      celebrated: _is.BoolJsonExtension.fromJson(
        jsonSerialization['celebrated'],
      ),
    );
  }

  String key;

  _ijycivqz.MilestoneKind kind;

  /// The number the milestone is about: reviews, goal days or items
  /// reviewed today.
  int value;

  bool celebrated;

  /// Returns a shallow copy of this [ProgressMilestone]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProgressMilestone copyWith({
    String? key,
    _ijycivqz.MilestoneKind? kind,
    int? value,
    bool? celebrated,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProgressMilestone',
      'key': key,
      'kind': kind.toJson(),
      'value': value,
      'celebrated': celebrated,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProgressMilestone',
      'key': key,
      'kind': kind.toJson(),
      'value': value,
      'celebrated': celebrated,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ProgressMilestoneImpl extends ProgressMilestone {
  _ProgressMilestoneImpl({
    required String key,
    required _ijycivqz.MilestoneKind kind,
    required int value,
    required bool celebrated,
  }) : super._(
         key: key,
         kind: kind,
         value: value,
         celebrated: celebrated,
       );

  /// Returns a shallow copy of this [ProgressMilestone]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProgressMilestone copyWith({
    String? key,
    _ijycivqz.MilestoneKind? kind,
    int? value,
    bool? celebrated,
  }) {
    return ProgressMilestone(
      key: key ?? this.key,
      kind: kind ?? this.kind,
      value: value ?? this.value,
      celebrated: celebrated ?? this.celebrated,
    );
  }
}
