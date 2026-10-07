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
import '../reviews/review_event_type.dart' as _irtd71vd;

/// Client input for one immutable review fact. Ownership and effective local
/// date are derived and validated by the server.
abstract class ReviewEventDraft
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ReviewEventDraft._({
    required this.clientEventId,
    required this.itemId,
    required this.eventType,
    required this.occurredAt,
    required this.timezone,
    required this.timezoneOffsetMinutes,
    this.compensatesEventId,
  });

  factory ReviewEventDraft({
    required String clientEventId,
    required _is.UuidValue itemId,
    required _irtd71vd.ReviewEventType eventType,
    required DateTime occurredAt,
    required String timezone,
    required int timezoneOffsetMinutes,
    _is.UuidValue? compensatesEventId,
  }) = _ReviewEventDraftImpl;

  factory ReviewEventDraft.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewEventDraft(
      clientEventId: jsonSerialization['clientEventId'] as String,
      itemId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['itemId']),
      eventType: _irtd71vd.ReviewEventType.fromJson(
        (jsonSerialization['eventType'] as String),
      ),
      occurredAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
      timezone: jsonSerialization['timezone'] as String,
      timezoneOffsetMinutes: jsonSerialization['timezoneOffsetMinutes'] as int,
      compensatesEventId: jsonSerialization['compensatesEventId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['compensatesEventId'],
            ),
    );
  }

  String clientEventId;

  _is.UuidValue itemId;

  _irtd71vd.ReviewEventType eventType;

  DateTime occurredAt;

  String timezone;

  int timezoneOffsetMinutes;

  _is.UuidValue? compensatesEventId;

  /// Returns a shallow copy of this [ReviewEventDraft]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReviewEventDraft copyWith({
    String? clientEventId,
    _is.UuidValue? itemId,
    _irtd71vd.ReviewEventType? eventType,
    DateTime? occurredAt,
    String? timezone,
    int? timezoneOffsetMinutes,
    _is.UuidValue? compensatesEventId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewEventDraft',
      'clientEventId': clientEventId,
      'itemId': itemId.toJson(),
      'eventType': eventType.toJson(),
      'occurredAt': occurredAt.toJson(),
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
      if (compensatesEventId != null)
        'compensatesEventId': compensatesEventId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewEventDraft',
      'clientEventId': clientEventId,
      'itemId': itemId.toJson(),
      'eventType': eventType.toJson(),
      'occurredAt': occurredAt.toJson(),
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
      if (compensatesEventId != null)
        'compensatesEventId': compensatesEventId?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewEventDraftImpl extends ReviewEventDraft {
  _ReviewEventDraftImpl({
    required String clientEventId,
    required _is.UuidValue itemId,
    required _irtd71vd.ReviewEventType eventType,
    required DateTime occurredAt,
    required String timezone,
    required int timezoneOffsetMinutes,
    _is.UuidValue? compensatesEventId,
  }) : super._(
         clientEventId: clientEventId,
         itemId: itemId,
         eventType: eventType,
         occurredAt: occurredAt,
         timezone: timezone,
         timezoneOffsetMinutes: timezoneOffsetMinutes,
         compensatesEventId: compensatesEventId,
       );

  /// Returns a shallow copy of this [ReviewEventDraft]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReviewEventDraft copyWith({
    String? clientEventId,
    _is.UuidValue? itemId,
    _irtd71vd.ReviewEventType? eventType,
    DateTime? occurredAt,
    String? timezone,
    int? timezoneOffsetMinutes,
    Object? compensatesEventId = _Undefined,
  }) {
    return ReviewEventDraft(
      clientEventId: clientEventId ?? this.clientEventId,
      itemId: itemId ?? this.itemId,
      eventType: eventType ?? this.eventType,
      occurredAt: occurredAt ?? this.occurredAt,
      timezone: timezone ?? this.timezone,
      timezoneOffsetMinutes:
          timezoneOffsetMinutes ?? this.timezoneOffsetMinutes,
      compensatesEventId: compensatesEventId is _is.UuidValue?
          ? compensatesEventId
          : this.compensatesEventId,
    );
  }
}
