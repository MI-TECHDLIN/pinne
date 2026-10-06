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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../reviews/review_event_type.dart' as _irtd71vd;

/// An immutable review fact. Progress is derived from these events; an undo is
/// a new event that points at the event it compensates.
abstract class ReviewEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReviewEvent._({
    this.id,
    required this.ownerId,
    required this.itemId,
    required this.eventType,
    required this.occurredAt,
    DateTime? receivedAt,
    required this.timezone,
    required this.effectiveLocalDate,
    this.compensatesEventId,
  }) : receivedAt = receivedAt ?? DateTime.now();

  factory ReviewEvent({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    required _irtd71vd.ReviewEventType eventType,
    required DateTime occurredAt,
    DateTime? receivedAt,
    required String timezone,
    required String effectiveLocalDate,
    _isc.UuidValue? compensatesEventId,
  }) = _ReviewEventImpl;

  factory ReviewEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewEvent(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      itemId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      eventType: _irtd71vd.ReviewEventType.fromJson(
        (jsonSerialization['eventType'] as String),
      ),
      occurredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['receivedAt'],
            ),
      timezone: jsonSerialization['timezone'] as String,
      effectiveLocalDate: jsonSerialization['effectiveLocalDate'] as String,
      compensatesEventId: jsonSerialization['compensatesEventId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['compensatesEventId'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue itemId;

  _irtd71vd.ReviewEventType eventType;

  /// When it happened on the device (UTC).
  DateTime occurredAt;

  /// When the server received it (UTC).
  DateTime receivedAt;

  /// IANA timezone of the user at the time of the event.
  String timezone;

  /// The user's local calendar date of the event, as yyyy-MM-dd.
  String effectiveLocalDate;

  _isc.UuidValue? compensatesEventId;

  /// Returns a shallow copy of this [ReviewEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReviewEvent copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    _irtd71vd.ReviewEventType? eventType,
    DateTime? occurredAt,
    DateTime? receivedAt,
    String? timezone,
    String? effectiveLocalDate,
    _isc.UuidValue? compensatesEventId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewEvent',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'eventType': eventType.toJson(),
      'occurredAt': occurredAt.toJson(),
      'receivedAt': receivedAt.toJson(),
      'timezone': timezone,
      'effectiveLocalDate': effectiveLocalDate,
      if (compensatesEventId != null)
        'compensatesEventId': compensatesEventId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewEvent',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'itemId': itemId.toJson(),
      'eventType': eventType.toJson(),
      'occurredAt': occurredAt.toJson(),
      'receivedAt': receivedAt.toJson(),
      'timezone': timezone,
      'effectiveLocalDate': effectiveLocalDate,
      if (compensatesEventId != null)
        'compensatesEventId': compensatesEventId?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewEventImpl extends ReviewEvent {
  _ReviewEventImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue itemId,
    required _irtd71vd.ReviewEventType eventType,
    required DateTime occurredAt,
    DateTime? receivedAt,
    required String timezone,
    required String effectiveLocalDate,
    _isc.UuidValue? compensatesEventId,
  }) : super._(
         id: id,
         ownerId: ownerId,
         itemId: itemId,
         eventType: eventType,
         occurredAt: occurredAt,
         receivedAt: receivedAt,
         timezone: timezone,
         effectiveLocalDate: effectiveLocalDate,
         compensatesEventId: compensatesEventId,
       );

  /// Returns a shallow copy of this [ReviewEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReviewEvent copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? itemId,
    _irtd71vd.ReviewEventType? eventType,
    DateTime? occurredAt,
    DateTime? receivedAt,
    String? timezone,
    String? effectiveLocalDate,
    Object? compensatesEventId = _Undefined,
  }) {
    return ReviewEvent(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      itemId: itemId ?? this.itemId,
      eventType: eventType ?? this.eventType,
      occurredAt: occurredAt ?? this.occurredAt,
      receivedAt: receivedAt ?? this.receivedAt,
      timezone: timezone ?? this.timezone,
      effectiveLocalDate: effectiveLocalDate ?? this.effectiveLocalDate,
      compensatesEventId: compensatesEventId is _isc.UuidValue?
          ? compensatesEventId
          : this.compensatesEventId,
    );
  }
}
