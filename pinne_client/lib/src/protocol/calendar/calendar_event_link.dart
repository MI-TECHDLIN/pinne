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
import '../calendar/event_sync_state.dart' as _ipxlzb0n;

/// Maps a review session to the event written for it. The remote event id
/// is stored only after the device or provider confirms it.
abstract class CalendarEventLink
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CalendarEventLink._({
    this.id,
    required this.ownerId,
    required this.sessionId,
    required this.selectionId,
    this.deviceId,
    required this.eventUid,
    this.externalEventId,
    this.providerRevision,
    required this.syncState,
    required this.operationId,
    this.lastError,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory CalendarEventLink({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue sessionId,
    required _isc.UuidValue selectionId,
    _isc.UuidValue? deviceId,
    required String eventUid,
    String? externalEventId,
    String? providerRevision,
    required _ipxlzb0n.EventSyncState syncState,
    required _isc.UuidValue operationId,
    String? lastError,
    DateTime? updatedAt,
  }) = _CalendarEventLinkImpl;

  factory CalendarEventLink.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarEventLink(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      sessionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['sessionId'],
      ),
      selectionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['selectionId'],
      ),
      deviceId: jsonSerialization['deviceId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
      eventUid: jsonSerialization['eventUid'] as String,
      externalEventId: jsonSerialization['externalEventId'] as String?,
      providerRevision: jsonSerialization['providerRevision'] as String?,
      syncState: _ipxlzb0n.EventSyncState.fromJson(
        (jsonSerialization['syncState'] as String),
      ),
      operationId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['operationId'],
      ),
      lastError: jsonSerialization['lastError'] as String?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ownerId;

  _isc.UuidValue sessionId;

  _isc.UuidValue selectionId;

  /// The install that writes the event, for device routes.
  _isc.UuidValue? deviceId;

  /// Stable for the session; stored in the event so a retry finds it.
  String eventUid;

  String? externalEventId;

  String? providerRevision;

  _ipxlzb0n.EventSyncState syncState;

  /// The commit, move or cancel that last changed this link.
  _isc.UuidValue operationId;

  String? lastError;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CalendarEventLink]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CalendarEventLink copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? sessionId,
    _isc.UuidValue? selectionId,
    _isc.UuidValue? deviceId,
    String? eventUid,
    String? externalEventId,
    String? providerRevision,
    _ipxlzb0n.EventSyncState? syncState,
    _isc.UuidValue? operationId,
    String? lastError,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarEventLink',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'sessionId': sessionId.toJson(),
      'selectionId': selectionId.toJson(),
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'eventUid': eventUid,
      if (externalEventId != null) 'externalEventId': externalEventId,
      if (providerRevision != null) 'providerRevision': providerRevision,
      'syncState': syncState.toJson(),
      'operationId': operationId.toJson(),
      if (lastError != null) 'lastError': lastError,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarEventLink',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'sessionId': sessionId.toJson(),
      'selectionId': selectionId.toJson(),
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      'eventUid': eventUid,
      if (externalEventId != null) 'externalEventId': externalEventId,
      if (providerRevision != null) 'providerRevision': providerRevision,
      'syncState': syncState.toJson(),
      'operationId': operationId.toJson(),
      if (lastError != null) 'lastError': lastError,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarEventLinkImpl extends CalendarEventLink {
  _CalendarEventLinkImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ownerId,
    required _isc.UuidValue sessionId,
    required _isc.UuidValue selectionId,
    _isc.UuidValue? deviceId,
    required String eventUid,
    String? externalEventId,
    String? providerRevision,
    required _ipxlzb0n.EventSyncState syncState,
    required _isc.UuidValue operationId,
    String? lastError,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         sessionId: sessionId,
         selectionId: selectionId,
         deviceId: deviceId,
         eventUid: eventUid,
         externalEventId: externalEventId,
         providerRevision: providerRevision,
         syncState: syncState,
         operationId: operationId,
         lastError: lastError,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CalendarEventLink]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CalendarEventLink copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    _isc.UuidValue? sessionId,
    _isc.UuidValue? selectionId,
    Object? deviceId = _Undefined,
    String? eventUid,
    Object? externalEventId = _Undefined,
    Object? providerRevision = _Undefined,
    _ipxlzb0n.EventSyncState? syncState,
    _isc.UuidValue? operationId,
    Object? lastError = _Undefined,
    DateTime? updatedAt,
  }) {
    return CalendarEventLink(
      id: id is _isc.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      sessionId: sessionId ?? this.sessionId,
      selectionId: selectionId ?? this.selectionId,
      deviceId: deviceId is _isc.UuidValue? ? deviceId : this.deviceId,
      eventUid: eventUid ?? this.eventUid,
      externalEventId: externalEventId is String?
          ? externalEventId
          : this.externalEventId,
      providerRevision: providerRevision is String?
          ? providerRevision
          : this.providerRevision,
      syncState: syncState ?? this.syncState,
      operationId: operationId ?? this.operationId,
      lastError: lastError is String? ? lastError : this.lastError,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
