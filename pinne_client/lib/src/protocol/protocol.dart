/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:pinne_client/src/protocol/collections/collection.dart'
    as _i9zrdvr8;
import 'package:pinne_client/src/protocol/items/item.dart' as _itiiwgx0;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'collections/collection.dart' as _iqfgge80;
import 'collections/collection_draft.dart' as _ivby8odo;
import 'collections/item_collection.dart' as _ingnmqw7;
import 'common/assignment_origin.dart' as _izy6d885;
import 'common/record_not_found_exception.dart' as _ilf890y8;
import 'common/validation_exception.dart' as _ifwcmx8g;
import 'health/server_health.dart' as _iozgwprg;
import 'items/access_state.dart' as _imhj9b3j;
import 'items/capture_draft.dart' as _idav3wwe;
import 'items/capture_result.dart' as _il5toi29;
import 'items/content_type.dart' as _itwlc5zp;
import 'items/enrichment_state.dart' as _im2yqxlq;
import 'items/item.dart' as _iapziv9t;
import 'items/item_draft.dart' as _ip8cn60r;
import 'items/item_lifecycle.dart' as _iveh3zib;
import 'items/source_platform.dart' as _i072xpry;
import 'profile/pinne_profile.dart' as _ijguvy1g;
import 'profile/profile_draft.dart' as _ij8joe28;
import 'reminders/reminder_rule.dart' as _i6ljcdoh;
import 'reminders/reminder_window.dart' as _iswi3gl6;
import 'reviews/review_event.dart' as _i0pv2k4n;
import 'reviews/review_event_type.dart' as _i5mz8id3;
import 'tags/item_tag.dart' as _iv0vmssg;
import 'tags/tag.dart' as _iopagaq8;
export 'collections/collection.dart';
export 'collections/collection_draft.dart';
export 'collections/item_collection.dart';
export 'common/assignment_origin.dart';
export 'common/record_not_found_exception.dart';
export 'common/validation_exception.dart';
export 'health/server_health.dart';
export 'items/access_state.dart';
export 'items/capture_draft.dart';
export 'items/capture_result.dart';
export 'items/content_type.dart';
export 'items/enrichment_state.dart';
export 'items/item.dart';
export 'items/item_draft.dart';
export 'items/item_lifecycle.dart';
export 'items/source_platform.dart';
export 'profile/pinne_profile.dart';
export 'profile/profile_draft.dart';
export 'reminders/reminder_rule.dart';
export 'reminders/reminder_window.dart';
export 'reviews/review_event.dart';
export 'reviews/review_event_type.dart';
export 'tags/item_tag.dart';
export 'tags/tag.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iqfgge80.Collection) {
      return _iqfgge80.Collection.fromJson(data) as T;
    }
    if (t == _ivby8odo.CollectionDraft) {
      return _ivby8odo.CollectionDraft.fromJson(data) as T;
    }
    if (t == _ingnmqw7.ItemCollection) {
      return _ingnmqw7.ItemCollection.fromJson(data) as T;
    }
    if (t == _izy6d885.AssignmentOrigin) {
      return _izy6d885.AssignmentOrigin.fromJson(data) as T;
    }
    if (t == _ilf890y8.RecordNotFoundException) {
      return _ilf890y8.RecordNotFoundException.fromJson(data) as T;
    }
    if (t == _ifwcmx8g.ValidationException) {
      return _ifwcmx8g.ValidationException.fromJson(data) as T;
    }
    if (t == _iozgwprg.ServerHealth) {
      return _iozgwprg.ServerHealth.fromJson(data) as T;
    }
    if (t == _imhj9b3j.AccessState) {
      return _imhj9b3j.AccessState.fromJson(data) as T;
    }
    if (t == _idav3wwe.CaptureDraft) {
      return _idav3wwe.CaptureDraft.fromJson(data) as T;
    }
    if (t == _il5toi29.CaptureResult) {
      return _il5toi29.CaptureResult.fromJson(data) as T;
    }
    if (t == _itwlc5zp.ContentType) {
      return _itwlc5zp.ContentType.fromJson(data) as T;
    }
    if (t == _im2yqxlq.EnrichmentState) {
      return _im2yqxlq.EnrichmentState.fromJson(data) as T;
    }
    if (t == _iapziv9t.Item) {
      return _iapziv9t.Item.fromJson(data) as T;
    }
    if (t == _ip8cn60r.ItemDraft) {
      return _ip8cn60r.ItemDraft.fromJson(data) as T;
    }
    if (t == _iveh3zib.ItemLifecycle) {
      return _iveh3zib.ItemLifecycle.fromJson(data) as T;
    }
    if (t == _i072xpry.SourcePlatform) {
      return _i072xpry.SourcePlatform.fromJson(data) as T;
    }
    if (t == _ijguvy1g.PinneProfile) {
      return _ijguvy1g.PinneProfile.fromJson(data) as T;
    }
    if (t == _ij8joe28.ProfileDraft) {
      return _ij8joe28.ProfileDraft.fromJson(data) as T;
    }
    if (t == _i6ljcdoh.ReminderRule) {
      return _i6ljcdoh.ReminderRule.fromJson(data) as T;
    }
    if (t == _iswi3gl6.ReminderWindow) {
      return _iswi3gl6.ReminderWindow.fromJson(data) as T;
    }
    if (t == _i0pv2k4n.ReviewEvent) {
      return _i0pv2k4n.ReviewEvent.fromJson(data) as T;
    }
    if (t == _i5mz8id3.ReviewEventType) {
      return _i5mz8id3.ReviewEventType.fromJson(data) as T;
    }
    if (t == _iv0vmssg.ItemTag) {
      return _iv0vmssg.ItemTag.fromJson(data) as T;
    }
    if (t == _iopagaq8.Tag) {
      return _iopagaq8.Tag.fromJson(data) as T;
    }
    if (t == _isc.getType<_iqfgge80.Collection?>()) {
      return (data != null ? _iqfgge80.Collection.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivby8odo.CollectionDraft?>()) {
      return (data != null ? _ivby8odo.CollectionDraft.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ingnmqw7.ItemCollection?>()) {
      return (data != null ? _ingnmqw7.ItemCollection.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izy6d885.AssignmentOrigin?>()) {
      return (data != null ? _izy6d885.AssignmentOrigin.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ilf890y8.RecordNotFoundException?>()) {
      return (data != null
              ? _ilf890y8.RecordNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ifwcmx8g.ValidationException?>()) {
      return (data != null
              ? _ifwcmx8g.ValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iozgwprg.ServerHealth?>()) {
      return (data != null ? _iozgwprg.ServerHealth.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_imhj9b3j.AccessState?>()) {
      return (data != null ? _imhj9b3j.AccessState.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idav3wwe.CaptureDraft?>()) {
      return (data != null ? _idav3wwe.CaptureDraft.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_il5toi29.CaptureResult?>()) {
      return (data != null ? _il5toi29.CaptureResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_itwlc5zp.ContentType?>()) {
      return (data != null ? _itwlc5zp.ContentType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_im2yqxlq.EnrichmentState?>()) {
      return (data != null ? _im2yqxlq.EnrichmentState.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iapziv9t.Item?>()) {
      return (data != null ? _iapziv9t.Item.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ip8cn60r.ItemDraft?>()) {
      return (data != null ? _ip8cn60r.ItemDraft.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iveh3zib.ItemLifecycle?>()) {
      return (data != null ? _iveh3zib.ItemLifecycle.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i072xpry.SourcePlatform?>()) {
      return (data != null ? _i072xpry.SourcePlatform.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijguvy1g.PinneProfile?>()) {
      return (data != null ? _ijguvy1g.PinneProfile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ij8joe28.ProfileDraft?>()) {
      return (data != null ? _ij8joe28.ProfileDraft.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6ljcdoh.ReminderRule?>()) {
      return (data != null ? _i6ljcdoh.ReminderRule.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iswi3gl6.ReminderWindow?>()) {
      return (data != null ? _iswi3gl6.ReminderWindow.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0pv2k4n.ReviewEvent?>()) {
      return (data != null ? _i0pv2k4n.ReviewEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5mz8id3.ReviewEventType?>()) {
      return (data != null ? _i5mz8id3.ReviewEventType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv0vmssg.ItemTag?>()) {
      return (data != null ? _iv0vmssg.ItemTag.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iopagaq8.Tag?>()) {
      return (data != null ? _iopagaq8.Tag.fromJson(data) : null) as T;
    }
    if (t == List<_isc.UuidValue>) {
      return (data as List).map((e) => deserialize<_isc.UuidValue>(e)).toList()
          as T;
    }
    if (t == _isc.getType<List<_isc.UuidValue>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_isc.UuidValue>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iswi3gl6.ReminderWindow>) {
      return (data as List)
              .map((e) => deserialize<_iswi3gl6.ReminderWindow>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_iswi3gl6.ReminderWindow>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iswi3gl6.ReminderWindow>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i9zrdvr8.Collection>) {
      return (data as List)
              .map((e) => deserialize<_i9zrdvr8.Collection>(e))
              .toList()
          as T;
    }
    if (t == List<_itiiwgx0.Item>) {
      return (data as List).map((e) => deserialize<_itiiwgx0.Item>(e)).toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iqfgge80.Collection => 'Collection',
      _ivby8odo.CollectionDraft => 'CollectionDraft',
      _ingnmqw7.ItemCollection => 'ItemCollection',
      _izy6d885.AssignmentOrigin => 'AssignmentOrigin',
      _ilf890y8.RecordNotFoundException => 'RecordNotFoundException',
      _ifwcmx8g.ValidationException => 'ValidationException',
      _iozgwprg.ServerHealth => 'ServerHealth',
      _imhj9b3j.AccessState => 'AccessState',
      _idav3wwe.CaptureDraft => 'CaptureDraft',
      _il5toi29.CaptureResult => 'CaptureResult',
      _itwlc5zp.ContentType => 'ContentType',
      _im2yqxlq.EnrichmentState => 'EnrichmentState',
      _iapziv9t.Item => 'Item',
      _ip8cn60r.ItemDraft => 'ItemDraft',
      _iveh3zib.ItemLifecycle => 'ItemLifecycle',
      _i072xpry.SourcePlatform => 'SourcePlatform',
      _ijguvy1g.PinneProfile => 'PinneProfile',
      _ij8joe28.ProfileDraft => 'ProfileDraft',
      _i6ljcdoh.ReminderRule => 'ReminderRule',
      _iswi3gl6.ReminderWindow => 'ReminderWindow',
      _i0pv2k4n.ReviewEvent => 'ReviewEvent',
      _i5mz8id3.ReviewEventType => 'ReviewEventType',
      _iv0vmssg.ItemTag => 'ItemTag',
      _iopagaq8.Tag => 'Tag',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('pinne.', '');
    }

    switch (data) {
      case _iqfgge80.Collection():
        return 'Collection';
      case _ivby8odo.CollectionDraft():
        return 'CollectionDraft';
      case _ingnmqw7.ItemCollection():
        return 'ItemCollection';
      case _izy6d885.AssignmentOrigin():
        return 'AssignmentOrigin';
      case _ilf890y8.RecordNotFoundException():
        return 'RecordNotFoundException';
      case _ifwcmx8g.ValidationException():
        return 'ValidationException';
      case _iozgwprg.ServerHealth():
        return 'ServerHealth';
      case _imhj9b3j.AccessState():
        return 'AccessState';
      case _idav3wwe.CaptureDraft():
        return 'CaptureDraft';
      case _il5toi29.CaptureResult():
        return 'CaptureResult';
      case _itwlc5zp.ContentType():
        return 'ContentType';
      case _im2yqxlq.EnrichmentState():
        return 'EnrichmentState';
      case _iapziv9t.Item():
        return 'Item';
      case _ip8cn60r.ItemDraft():
        return 'ItemDraft';
      case _iveh3zib.ItemLifecycle():
        return 'ItemLifecycle';
      case _i072xpry.SourcePlatform():
        return 'SourcePlatform';
      case _ijguvy1g.PinneProfile():
        return 'PinneProfile';
      case _ij8joe28.ProfileDraft():
        return 'ProfileDraft';
      case _i6ljcdoh.ReminderRule():
        return 'ReminderRule';
      case _iswi3gl6.ReminderWindow():
        return 'ReminderWindow';
      case _i0pv2k4n.ReviewEvent():
        return 'ReviewEvent';
      case _i5mz8id3.ReviewEventType():
        return 'ReviewEventType';
      case _iv0vmssg.ItemTag():
        return 'ItemTag';
      case _iopagaq8.Tag():
        return 'Tag';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Collection') {
      return deserialize<_iqfgge80.Collection>(data['data']);
    }
    if (dataClassName == 'CollectionDraft') {
      return deserialize<_ivby8odo.CollectionDraft>(data['data']);
    }
    if (dataClassName == 'ItemCollection') {
      return deserialize<_ingnmqw7.ItemCollection>(data['data']);
    }
    if (dataClassName == 'AssignmentOrigin') {
      return deserialize<_izy6d885.AssignmentOrigin>(data['data']);
    }
    if (dataClassName == 'RecordNotFoundException') {
      return deserialize<_ilf890y8.RecordNotFoundException>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_ifwcmx8g.ValidationException>(data['data']);
    }
    if (dataClassName == 'ServerHealth') {
      return deserialize<_iozgwprg.ServerHealth>(data['data']);
    }
    if (dataClassName == 'AccessState') {
      return deserialize<_imhj9b3j.AccessState>(data['data']);
    }
    if (dataClassName == 'CaptureDraft') {
      return deserialize<_idav3wwe.CaptureDraft>(data['data']);
    }
    if (dataClassName == 'CaptureResult') {
      return deserialize<_il5toi29.CaptureResult>(data['data']);
    }
    if (dataClassName == 'ContentType') {
      return deserialize<_itwlc5zp.ContentType>(data['data']);
    }
    if (dataClassName == 'EnrichmentState') {
      return deserialize<_im2yqxlq.EnrichmentState>(data['data']);
    }
    if (dataClassName == 'Item') {
      return deserialize<_iapziv9t.Item>(data['data']);
    }
    if (dataClassName == 'ItemDraft') {
      return deserialize<_ip8cn60r.ItemDraft>(data['data']);
    }
    if (dataClassName == 'ItemLifecycle') {
      return deserialize<_iveh3zib.ItemLifecycle>(data['data']);
    }
    if (dataClassName == 'SourcePlatform') {
      return deserialize<_i072xpry.SourcePlatform>(data['data']);
    }
    if (dataClassName == 'PinneProfile') {
      return deserialize<_ijguvy1g.PinneProfile>(data['data']);
    }
    if (dataClassName == 'ProfileDraft') {
      return deserialize<_ij8joe28.ProfileDraft>(data['data']);
    }
    if (dataClassName == 'ReminderRule') {
      return deserialize<_i6ljcdoh.ReminderRule>(data['data']);
    }
    if (dataClassName == 'ReminderWindow') {
      return deserialize<_iswi3gl6.ReminderWindow>(data['data']);
    }
    if (dataClassName == 'ReviewEvent') {
      return deserialize<_i0pv2k4n.ReviewEvent>(data['data']);
    }
    if (dataClassName == 'ReviewEventType') {
      return deserialize<_i5mz8id3.ReviewEventType>(data['data']);
    }
    if (dataClassName == 'ItemTag') {
      return deserialize<_iv0vmssg.ItemTag>(data['data']);
    }
    if (dataClassName == 'Tag') {
      return deserialize<_iopagaq8.Tag>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('pinne', this);
    _iacc.Protocol().registerHostProtocol('pinne', this);
  }

  @override
  String getModuleName() => 'pinne';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
