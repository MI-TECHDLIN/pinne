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
import '../reminders/reminder_window.dart' as _i9bgfy5p;

/// When to remind the user about saved items. A null collection is the owner's
/// default rule; a collection rule overrides it.
abstract class ReminderRule
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReminderRule._({
    this.id,
    required this.ownerId,
    this.collectionId,
    int? delayHours,
    this.deliveryWindows,
    this.cap,
    bool? enabled,
  }) : delayHours = delayHours ?? 24,
       enabled = enabled ?? true;

  factory ReminderRule({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    _isc.UuidValue? collectionId,
    int? delayHours,
    List<_i9bgfy5p.ReminderWindow>? deliveryWindows,
    int? cap,
    bool? enabled,
  }) = _ReminderRuleImpl;

  factory ReminderRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReminderRule(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      collectionId: jsonSerialization['collectionId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['collectionId'],
            ),
      delayHours: jsonSerialization['delayHours'] as int?,
      deliveryWindows: jsonSerialization['deliveryWindows'] == null
          ? null
          : _iub9zyhg.Protocol().deserialize<List<_i9bgfy5p.ReminderWindow>>(
              jsonSerialization['deliveryWindows'],
            ),
      cap: jsonSerialization['cap'] as int?,
      enabled: jsonSerialization['enabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue? collectionId;

  int delayHours;

  /// Null means reminders may arrive at any time outside quiet hours.
  List<_i9bgfy5p.ReminderWindow>? deliveryWindows;

  /// Maximum reminders per day; null means no cap.
  int? cap;

  bool enabled;

  /// Returns a shallow copy of this [ReminderRule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReminderRule copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? collectionId,
    int? delayHours,
    List<_i9bgfy5p.ReminderWindow>? deliveryWindows,
    int? cap,
    bool? enabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReminderRule',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      if (collectionId != null) 'collectionId': collectionId?.toJson(),
      'delayHours': delayHours,
      if (deliveryWindows != null)
        'deliveryWindows': deliveryWindows?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (cap != null) 'cap': cap,
      'enabled': enabled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReminderRule',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      if (collectionId != null) 'collectionId': collectionId?.toJson(),
      'delayHours': delayHours,
      if (deliveryWindows != null)
        'deliveryWindows': deliveryWindows?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (cap != null) 'cap': cap,
      'enabled': enabled,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderRuleImpl extends ReminderRule {
  _ReminderRuleImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    _isc.UuidValue? collectionId,
    int? delayHours,
    List<_i9bgfy5p.ReminderWindow>? deliveryWindows,
    int? cap,
    bool? enabled,
  }) : super._(
         id: id,
         ownerId: ownerId,
         collectionId: collectionId,
         delayHours: delayHours,
         deliveryWindows: deliveryWindows,
         cap: cap,
         enabled: enabled,
       );

  /// Returns a shallow copy of this [ReminderRule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReminderRule copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    Object? collectionId = _Undefined,
    int? delayHours,
    Object? deliveryWindows = _Undefined,
    Object? cap = _Undefined,
    bool? enabled,
  }) {
    return ReminderRule(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      collectionId: collectionId is _isc.UuidValue?
          ? collectionId
          : this.collectionId,
      delayHours: delayHours ?? this.delayHours,
      deliveryWindows: deliveryWindows is List<_i9bgfy5p.ReminderWindow>?
          ? deliveryWindows
          : this.deliveryWindows?.map((e0) => e0.copyWith()).toList(),
      cap: cap is int? ? cap : this.cap,
      enabled: enabled ?? this.enabled,
    );
  }
}
