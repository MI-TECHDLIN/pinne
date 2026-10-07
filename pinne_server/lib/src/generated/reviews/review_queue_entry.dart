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
import '../items/item.dart' as _ieep4ee2;

abstract class ReviewQueueEntry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ReviewQueueEntry._({
    required this.item,
    required this.dueAt,
    required this.overdueMinutes,
    required this.estimatedMinutes,
    required this.selectionReason,
  });

  factory ReviewQueueEntry({
    required _ieep4ee2.Item item,
    required DateTime dueAt,
    required int overdueMinutes,
    required int estimatedMinutes,
    required String selectionReason,
  }) = _ReviewQueueEntryImpl;

  factory ReviewQueueEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewQueueEntry(
      item: _i2yoimhd.Protocol().deserialize<_ieep4ee2.Item>(
        jsonSerialization['item'],
      ),
      dueAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      overdueMinutes: jsonSerialization['overdueMinutes'] as int,
      estimatedMinutes: jsonSerialization['estimatedMinutes'] as int,
      selectionReason: jsonSerialization['selectionReason'] as String,
    );
  }

  _ieep4ee2.Item item;

  DateTime dueAt;

  int overdueMinutes;

  int estimatedMinutes;

  String selectionReason;

  /// Returns a shallow copy of this [ReviewQueueEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReviewQueueEntry copyWith({
    _ieep4ee2.Item? item,
    DateTime? dueAt,
    int? overdueMinutes,
    int? estimatedMinutes,
    String? selectionReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewQueueEntry',
      'item': item.toJson(),
      'dueAt': dueAt.toJson(),
      'overdueMinutes': overdueMinutes,
      'estimatedMinutes': estimatedMinutes,
      'selectionReason': selectionReason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewQueueEntry',
      'item': item.toJsonForProtocol(),
      'dueAt': dueAt.toJson(),
      'overdueMinutes': overdueMinutes,
      'estimatedMinutes': estimatedMinutes,
      'selectionReason': selectionReason,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ReviewQueueEntryImpl extends ReviewQueueEntry {
  _ReviewQueueEntryImpl({
    required _ieep4ee2.Item item,
    required DateTime dueAt,
    required int overdueMinutes,
    required int estimatedMinutes,
    required String selectionReason,
  }) : super._(
         item: item,
         dueAt: dueAt,
         overdueMinutes: overdueMinutes,
         estimatedMinutes: estimatedMinutes,
         selectionReason: selectionReason,
       );

  /// Returns a shallow copy of this [ReviewQueueEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReviewQueueEntry copyWith({
    _ieep4ee2.Item? item,
    DateTime? dueAt,
    int? overdueMinutes,
    int? estimatedMinutes,
    String? selectionReason,
  }) {
    return ReviewQueueEntry(
      item: item ?? this.item.copyWith(),
      dueAt: dueAt ?? this.dueAt,
      overdueMinutes: overdueMinutes ?? this.overdueMinutes,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      selectionReason: selectionReason ?? this.selectionReason,
    );
  }
}
