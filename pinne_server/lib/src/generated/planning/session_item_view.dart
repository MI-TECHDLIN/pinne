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

abstract class SessionItemView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SessionItemView._({
    required this.itemId,
    required this.title,
    required this.plannedMinutes,
    required this.estimated,
  });

  factory SessionItemView({
    required _is.UuidValue itemId,
    required String title,
    required int plannedMinutes,
    required bool estimated,
  }) = _SessionItemViewImpl;

  factory SessionItemView.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionItemView(
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      title: jsonSerialization['title'] as String,
      plannedMinutes: jsonSerialization['plannedMinutes'] as int,
      estimated: _is.BoolJsonExtension.fromJson(jsonSerialization['estimated']),
    );
  }

  _is.UuidValue itemId;

  String title;

  int plannedMinutes;

  bool estimated;

  /// Returns a shallow copy of this [SessionItemView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionItemView copyWith({
    _is.UuidValue? itemId,
    String? title,
    int? plannedMinutes,
    bool? estimated,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionItemView',
      'itemId': itemId.toJson(),
      'title': title,
      'plannedMinutes': plannedMinutes,
      'estimated': estimated,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionItemView',
      'itemId': itemId.toJson(),
      'title': title,
      'plannedMinutes': plannedMinutes,
      'estimated': estimated,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SessionItemViewImpl extends SessionItemView {
  _SessionItemViewImpl({
    required _is.UuidValue itemId,
    required String title,
    required int plannedMinutes,
    required bool estimated,
  }) : super._(
         itemId: itemId,
         title: title,
         plannedMinutes: plannedMinutes,
         estimated: estimated,
       );

  /// Returns a shallow copy of this [SessionItemView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionItemView copyWith({
    _is.UuidValue? itemId,
    String? title,
    int? plannedMinutes,
    bool? estimated,
  }) {
    return SessionItemView(
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      estimated: estimated ?? this.estimated,
    );
  }
}
