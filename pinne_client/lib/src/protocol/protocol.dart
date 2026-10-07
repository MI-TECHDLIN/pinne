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
import 'package:pinne_client/src/protocol/ai/ai_suggestion.dart' as _iq5krdy3;
import 'package:pinne_client/src/protocol/calendar/calendar_connection_view.dart'
    as _i0t8t4zu;
import 'package:pinne_client/src/protocol/calendar/calendar_route_status.dart'
    as _ig4e8y15;
import 'package:pinne_client/src/protocol/calendar/calendar_selection_choice.dart'
    as _im02fgk3;
import 'package:pinne_client/src/protocol/collections/collection.dart'
    as _i9zrdvr8;
import 'package:pinne_client/src/protocol/items/item.dart' as _itiiwgx0;
import 'package:pinne_client/src/protocol/planning/calendar_write.dart'
    as _i4bu6rte;
import 'package:pinne_client/src/protocol/planning/calendar_write_result.dart'
    as _ivswpuyg;
import 'package:pinne_client/src/protocol/planning/session_view.dart'
    as _i2af9p8a;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'ai/ai_daily_usage.dart' as _ieqt63qc;
import 'ai/ai_evidence_coverage.dart' as _ike1rdmf;
import 'ai/ai_organize_task.dart' as _i3rayejx;
import 'ai/ai_preference.dart' as _irbaoatq;
import 'ai/ai_processing_state.dart' as _iuqfkn3x;
import 'ai/ai_settings.dart' as _i8oswxfq;
import 'ai/ai_suggestion.dart' as _ispfx06l;
import 'ai/ai_suggestion_kind.dart' as _il1lz8eg;
import 'ai/ai_suggestion_status.dart' as _it1ujq25;
import 'calendar/calendar_connection.dart' as _iqtchur3;
import 'calendar/calendar_connection_view.dart' as _ijwz5xp0;
import 'calendar/calendar_event_link.dart' as _ily35bfr;
import 'calendar/calendar_permission.dart' as _ika1a9r5;
import 'calendar/calendar_route.dart' as _iq08ggdy;
import 'calendar/calendar_route_exception.dart' as _igxvbit5;
import 'calendar/calendar_route_status.dart' as _i7yozl4b;
import 'calendar/calendar_selection.dart' as _i8v3said;
import 'calendar/calendar_selection_choice.dart' as _intkkx3w;
import 'calendar/device_calendar_info.dart' as _ihue00wg;
import 'calendar/device_calendar_report.dart' as _i4awacjs;
import 'calendar/event_sync_state.dart' as _i1s71wt9;
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
import 'planning/approval_mode.dart' as _id2awq13;
import 'planning/availability_snapshot.dart' as _i1u9wvnf;
import 'planning/busy_interval.dart' as _imvtil8c;
import 'planning/calendar_coverage.dart' as _iadysn2t;
import 'planning/calendar_write.dart' as _i6oluk1v;
import 'planning/calendar_write_action.dart' as _iyd6g2oi;
import 'planning/calendar_write_outcome.dart' as _i3u14n80;
import 'planning/calendar_write_result.dart' as _i5mmfzwl;
import 'planning/coverage_state.dart' as _il89vgny;
import 'planning/plan_commit_request.dart' as _ilaph13t;
import 'planning/plan_commit_result.dart' as _ixc6g37a;
import 'planning/plan_horizon.dart' as _ititmozf;
import 'planning/plan_proposal.dart' as _iv13hf9x;
import 'planning/plan_request.dart' as _idh5khlu;
import 'planning/planner_preferences.dart' as _iw1c6zow;
import 'planning/planner_preferences_draft.dart' as _i03liexf;
import 'planning/planning_error_code.dart' as _ityq5odj;
import 'planning/planning_exception.dart' as _iehth582;
import 'planning/review_plan.dart' as _icv3lfjf;
import 'planning/review_session.dart' as _indyheef;
import 'planning/session_change_result.dart' as _in0sx9zc;
import 'planning/session_item.dart' as _i716ymk1;
import 'planning/session_item_view.dart' as _i3pyieja;
import 'planning/session_move_request.dart' as _i91809id;
import 'planning/session_status.dart' as _izbi9tiy;
import 'planning/session_view.dart' as _iyjcmdi4;
import 'profile/pinne_profile.dart' as _ijguvy1g;
import 'profile/profile_draft.dart' as _ij8joe28;
import 'reminders/reminder_rule.dart' as _i6ljcdoh;
import 'reminders/reminder_settings.dart' as _i0v594yd;
import 'reminders/reminder_settings_draft.dart' as _i2m53qgo;
import 'reminders/reminder_window.dart' as _iswi3gl6;
import 'reminders/review_digest.dart' as _isu905ko;
import 'reviews/item_progress.dart' as _iv91gdem;
import 'reviews/item_review_control.dart' as _il1zbvt2;
import 'reviews/review_event.dart' as _i0pv2k4n;
import 'reviews/review_event_draft.dart' as _i4vpgh88;
import 'reviews/review_event_receipt.dart' as _i5hoegii;
import 'reviews/review_event_type.dart' as _i5mz8id3;
import 'reviews/review_queue_entry.dart' as _ia978e3v;
import 'reviews/review_queue_result.dart' as _igp65vp8;
import 'search/item_note.dart' as _i1podblr;
import 'search/review_status_filter.dart' as _ive6le5b;
import 'search/search_evidence.dart' as _igqcqr3d;
import 'search/search_page.dart' as _ic5aviky;
import 'search/search_result.dart' as _iyyp88jv;
import 'tags/item_tag.dart' as _iv0vmssg;
import 'tags/tag.dart' as _iopagaq8;
export 'ai/ai_daily_usage.dart';
export 'ai/ai_evidence_coverage.dart';
export 'ai/ai_organize_task.dart';
export 'ai/ai_preference.dart';
export 'ai/ai_processing_state.dart';
export 'ai/ai_settings.dart';
export 'ai/ai_suggestion.dart';
export 'ai/ai_suggestion_kind.dart';
export 'ai/ai_suggestion_status.dart';
export 'calendar/calendar_connection.dart';
export 'calendar/calendar_connection_view.dart';
export 'calendar/calendar_event_link.dart';
export 'calendar/calendar_permission.dart';
export 'calendar/calendar_route.dart';
export 'calendar/calendar_route_exception.dart';
export 'calendar/calendar_route_status.dart';
export 'calendar/calendar_selection.dart';
export 'calendar/calendar_selection_choice.dart';
export 'calendar/device_calendar_info.dart';
export 'calendar/device_calendar_report.dart';
export 'calendar/event_sync_state.dart';
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
export 'planning/approval_mode.dart';
export 'planning/availability_snapshot.dart';
export 'planning/busy_interval.dart';
export 'planning/calendar_coverage.dart';
export 'planning/calendar_write.dart';
export 'planning/calendar_write_action.dart';
export 'planning/calendar_write_outcome.dart';
export 'planning/calendar_write_result.dart';
export 'planning/coverage_state.dart';
export 'planning/plan_commit_request.dart';
export 'planning/plan_commit_result.dart';
export 'planning/plan_horizon.dart';
export 'planning/plan_proposal.dart';
export 'planning/plan_request.dart';
export 'planning/planner_preferences.dart';
export 'planning/planner_preferences_draft.dart';
export 'planning/planning_error_code.dart';
export 'planning/planning_exception.dart';
export 'planning/review_plan.dart';
export 'planning/review_session.dart';
export 'planning/session_change_result.dart';
export 'planning/session_item.dart';
export 'planning/session_item_view.dart';
export 'planning/session_move_request.dart';
export 'planning/session_status.dart';
export 'planning/session_view.dart';
export 'profile/pinne_profile.dart';
export 'profile/profile_draft.dart';
export 'reminders/reminder_rule.dart';
export 'reminders/reminder_settings.dart';
export 'reminders/reminder_settings_draft.dart';
export 'reminders/reminder_window.dart';
export 'reminders/review_digest.dart';
export 'reviews/item_progress.dart';
export 'reviews/item_review_control.dart';
export 'reviews/review_event.dart';
export 'reviews/review_event_draft.dart';
export 'reviews/review_event_receipt.dart';
export 'reviews/review_event_type.dart';
export 'reviews/review_queue_entry.dart';
export 'reviews/review_queue_result.dart';
export 'search/item_note.dart';
export 'search/review_status_filter.dart';
export 'search/search_evidence.dart';
export 'search/search_page.dart';
export 'search/search_result.dart';
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

    if (t == _ieqt63qc.AiDailyUsage) {
      return _ieqt63qc.AiDailyUsage.fromJson(data) as T;
    }
    if (t == _ike1rdmf.AiEvidenceCoverage) {
      return _ike1rdmf.AiEvidenceCoverage.fromJson(data) as T;
    }
    if (t == _i3rayejx.AiOrganizeTask) {
      return _i3rayejx.AiOrganizeTask.fromJson(data) as T;
    }
    if (t == _irbaoatq.AiPreference) {
      return _irbaoatq.AiPreference.fromJson(data) as T;
    }
    if (t == _iuqfkn3x.AiProcessingState) {
      return _iuqfkn3x.AiProcessingState.fromJson(data) as T;
    }
    if (t == _i8oswxfq.AiSettings) {
      return _i8oswxfq.AiSettings.fromJson(data) as T;
    }
    if (t == _ispfx06l.AiSuggestion) {
      return _ispfx06l.AiSuggestion.fromJson(data) as T;
    }
    if (t == _il1lz8eg.AiSuggestionKind) {
      return _il1lz8eg.AiSuggestionKind.fromJson(data) as T;
    }
    if (t == _it1ujq25.AiSuggestionStatus) {
      return _it1ujq25.AiSuggestionStatus.fromJson(data) as T;
    }
    if (t == _iqtchur3.CalendarConnection) {
      return _iqtchur3.CalendarConnection.fromJson(data) as T;
    }
    if (t == _ijwz5xp0.CalendarConnectionView) {
      return _ijwz5xp0.CalendarConnectionView.fromJson(data) as T;
    }
    if (t == _ily35bfr.CalendarEventLink) {
      return _ily35bfr.CalendarEventLink.fromJson(data) as T;
    }
    if (t == _ika1a9r5.CalendarPermission) {
      return _ika1a9r5.CalendarPermission.fromJson(data) as T;
    }
    if (t == _iq08ggdy.CalendarRoute) {
      return _iq08ggdy.CalendarRoute.fromJson(data) as T;
    }
    if (t == _igxvbit5.CalendarRouteException) {
      return _igxvbit5.CalendarRouteException.fromJson(data) as T;
    }
    if (t == _i7yozl4b.CalendarRouteStatus) {
      return _i7yozl4b.CalendarRouteStatus.fromJson(data) as T;
    }
    if (t == _i8v3said.CalendarSelection) {
      return _i8v3said.CalendarSelection.fromJson(data) as T;
    }
    if (t == _intkkx3w.CalendarSelectionChoice) {
      return _intkkx3w.CalendarSelectionChoice.fromJson(data) as T;
    }
    if (t == _ihue00wg.DeviceCalendarInfo) {
      return _ihue00wg.DeviceCalendarInfo.fromJson(data) as T;
    }
    if (t == _i4awacjs.DeviceCalendarReport) {
      return _i4awacjs.DeviceCalendarReport.fromJson(data) as T;
    }
    if (t == _i1s71wt9.EventSyncState) {
      return _i1s71wt9.EventSyncState.fromJson(data) as T;
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
    if (t == _id2awq13.ApprovalMode) {
      return _id2awq13.ApprovalMode.fromJson(data) as T;
    }
    if (t == _i1u9wvnf.AvailabilitySnapshot) {
      return _i1u9wvnf.AvailabilitySnapshot.fromJson(data) as T;
    }
    if (t == _imvtil8c.BusyInterval) {
      return _imvtil8c.BusyInterval.fromJson(data) as T;
    }
    if (t == _iadysn2t.CalendarCoverage) {
      return _iadysn2t.CalendarCoverage.fromJson(data) as T;
    }
    if (t == _i6oluk1v.CalendarWrite) {
      return _i6oluk1v.CalendarWrite.fromJson(data) as T;
    }
    if (t == _iyd6g2oi.CalendarWriteAction) {
      return _iyd6g2oi.CalendarWriteAction.fromJson(data) as T;
    }
    if (t == _i3u14n80.CalendarWriteOutcome) {
      return _i3u14n80.CalendarWriteOutcome.fromJson(data) as T;
    }
    if (t == _i5mmfzwl.CalendarWriteResult) {
      return _i5mmfzwl.CalendarWriteResult.fromJson(data) as T;
    }
    if (t == _il89vgny.CoverageState) {
      return _il89vgny.CoverageState.fromJson(data) as T;
    }
    if (t == _ilaph13t.PlanCommitRequest) {
      return _ilaph13t.PlanCommitRequest.fromJson(data) as T;
    }
    if (t == _ixc6g37a.PlanCommitResult) {
      return _ixc6g37a.PlanCommitResult.fromJson(data) as T;
    }
    if (t == _ititmozf.PlanHorizon) {
      return _ititmozf.PlanHorizon.fromJson(data) as T;
    }
    if (t == _iv13hf9x.PlanProposal) {
      return _iv13hf9x.PlanProposal.fromJson(data) as T;
    }
    if (t == _idh5khlu.PlanRequest) {
      return _idh5khlu.PlanRequest.fromJson(data) as T;
    }
    if (t == _iw1c6zow.PlannerPreferences) {
      return _iw1c6zow.PlannerPreferences.fromJson(data) as T;
    }
    if (t == _i03liexf.PlannerPreferencesDraft) {
      return _i03liexf.PlannerPreferencesDraft.fromJson(data) as T;
    }
    if (t == _ityq5odj.PlanningErrorCode) {
      return _ityq5odj.PlanningErrorCode.fromJson(data) as T;
    }
    if (t == _iehth582.PlanningException) {
      return _iehth582.PlanningException.fromJson(data) as T;
    }
    if (t == _icv3lfjf.ReviewPlan) {
      return _icv3lfjf.ReviewPlan.fromJson(data) as T;
    }
    if (t == _indyheef.ReviewSession) {
      return _indyheef.ReviewSession.fromJson(data) as T;
    }
    if (t == _in0sx9zc.SessionChangeResult) {
      return _in0sx9zc.SessionChangeResult.fromJson(data) as T;
    }
    if (t == _i716ymk1.SessionItem) {
      return _i716ymk1.SessionItem.fromJson(data) as T;
    }
    if (t == _i3pyieja.SessionItemView) {
      return _i3pyieja.SessionItemView.fromJson(data) as T;
    }
    if (t == _i91809id.SessionMoveRequest) {
      return _i91809id.SessionMoveRequest.fromJson(data) as T;
    }
    if (t == _izbi9tiy.SessionStatus) {
      return _izbi9tiy.SessionStatus.fromJson(data) as T;
    }
    if (t == _iyjcmdi4.SessionView) {
      return _iyjcmdi4.SessionView.fromJson(data) as T;
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
    if (t == _i0v594yd.ReminderSettings) {
      return _i0v594yd.ReminderSettings.fromJson(data) as T;
    }
    if (t == _i2m53qgo.ReminderSettingsDraft) {
      return _i2m53qgo.ReminderSettingsDraft.fromJson(data) as T;
    }
    if (t == _iswi3gl6.ReminderWindow) {
      return _iswi3gl6.ReminderWindow.fromJson(data) as T;
    }
    if (t == _isu905ko.ReviewDigest) {
      return _isu905ko.ReviewDigest.fromJson(data) as T;
    }
    if (t == _iv91gdem.ItemProgress) {
      return _iv91gdem.ItemProgress.fromJson(data) as T;
    }
    if (t == _il1zbvt2.ItemReviewControl) {
      return _il1zbvt2.ItemReviewControl.fromJson(data) as T;
    }
    if (t == _i0pv2k4n.ReviewEvent) {
      return _i0pv2k4n.ReviewEvent.fromJson(data) as T;
    }
    if (t == _i4vpgh88.ReviewEventDraft) {
      return _i4vpgh88.ReviewEventDraft.fromJson(data) as T;
    }
    if (t == _i5hoegii.ReviewEventReceipt) {
      return _i5hoegii.ReviewEventReceipt.fromJson(data) as T;
    }
    if (t == _i5mz8id3.ReviewEventType) {
      return _i5mz8id3.ReviewEventType.fromJson(data) as T;
    }
    if (t == _ia978e3v.ReviewQueueEntry) {
      return _ia978e3v.ReviewQueueEntry.fromJson(data) as T;
    }
    if (t == _igp65vp8.ReviewQueueResult) {
      return _igp65vp8.ReviewQueueResult.fromJson(data) as T;
    }
    if (t == _i1podblr.ItemNote) {
      return _i1podblr.ItemNote.fromJson(data) as T;
    }
    if (t == _ive6le5b.ReviewStatusFilter) {
      return _ive6le5b.ReviewStatusFilter.fromJson(data) as T;
    }
    if (t == _igqcqr3d.SearchEvidence) {
      return _igqcqr3d.SearchEvidence.fromJson(data) as T;
    }
    if (t == _ic5aviky.SearchPage) {
      return _ic5aviky.SearchPage.fromJson(data) as T;
    }
    if (t == _iyyp88jv.SearchResult) {
      return _iyyp88jv.SearchResult.fromJson(data) as T;
    }
    if (t == _iv0vmssg.ItemTag) {
      return _iv0vmssg.ItemTag.fromJson(data) as T;
    }
    if (t == _iopagaq8.Tag) {
      return _iopagaq8.Tag.fromJson(data) as T;
    }
    if (t == _isc.getType<_ieqt63qc.AiDailyUsage?>()) {
      return (data != null ? _ieqt63qc.AiDailyUsage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ike1rdmf.AiEvidenceCoverage?>()) {
      return (data != null ? _ike1rdmf.AiEvidenceCoverage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i3rayejx.AiOrganizeTask?>()) {
      return (data != null ? _i3rayejx.AiOrganizeTask.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_irbaoatq.AiPreference?>()) {
      return (data != null ? _irbaoatq.AiPreference.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iuqfkn3x.AiProcessingState?>()) {
      return (data != null ? _iuqfkn3x.AiProcessingState.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8oswxfq.AiSettings?>()) {
      return (data != null ? _i8oswxfq.AiSettings.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ispfx06l.AiSuggestion?>()) {
      return (data != null ? _ispfx06l.AiSuggestion.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_il1lz8eg.AiSuggestionKind?>()) {
      return (data != null ? _il1lz8eg.AiSuggestionKind.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_it1ujq25.AiSuggestionStatus?>()) {
      return (data != null ? _it1ujq25.AiSuggestionStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iqtchur3.CalendarConnection?>()) {
      return (data != null ? _iqtchur3.CalendarConnection.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijwz5xp0.CalendarConnectionView?>()) {
      return (data != null
              ? _ijwz5xp0.CalendarConnectionView.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ily35bfr.CalendarEventLink?>()) {
      return (data != null ? _ily35bfr.CalendarEventLink.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ika1a9r5.CalendarPermission?>()) {
      return (data != null ? _ika1a9r5.CalendarPermission.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iq08ggdy.CalendarRoute?>()) {
      return (data != null ? _iq08ggdy.CalendarRoute.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igxvbit5.CalendarRouteException?>()) {
      return (data != null
              ? _igxvbit5.CalendarRouteException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i7yozl4b.CalendarRouteStatus?>()) {
      return (data != null
              ? _i7yozl4b.CalendarRouteStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i8v3said.CalendarSelection?>()) {
      return (data != null ? _i8v3said.CalendarSelection.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_intkkx3w.CalendarSelectionChoice?>()) {
      return (data != null
              ? _intkkx3w.CalendarSelectionChoice.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ihue00wg.DeviceCalendarInfo?>()) {
      return (data != null ? _ihue00wg.DeviceCalendarInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4awacjs.DeviceCalendarReport?>()) {
      return (data != null
              ? _i4awacjs.DeviceCalendarReport.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i1s71wt9.EventSyncState?>()) {
      return (data != null ? _i1s71wt9.EventSyncState.fromJson(data) : null)
          as T;
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
    if (t == _isc.getType<_id2awq13.ApprovalMode?>()) {
      return (data != null ? _id2awq13.ApprovalMode.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1u9wvnf.AvailabilitySnapshot?>()) {
      return (data != null
              ? _i1u9wvnf.AvailabilitySnapshot.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_imvtil8c.BusyInterval?>()) {
      return (data != null ? _imvtil8c.BusyInterval.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iadysn2t.CalendarCoverage?>()) {
      return (data != null ? _iadysn2t.CalendarCoverage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i6oluk1v.CalendarWrite?>()) {
      return (data != null ? _i6oluk1v.CalendarWrite.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iyd6g2oi.CalendarWriteAction?>()) {
      return (data != null
              ? _iyd6g2oi.CalendarWriteAction.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i3u14n80.CalendarWriteOutcome?>()) {
      return (data != null
              ? _i3u14n80.CalendarWriteOutcome.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i5mmfzwl.CalendarWriteResult?>()) {
      return (data != null
              ? _i5mmfzwl.CalendarWriteResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_il89vgny.CoverageState?>()) {
      return (data != null ? _il89vgny.CoverageState.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ilaph13t.PlanCommitRequest?>()) {
      return (data != null ? _ilaph13t.PlanCommitRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixc6g37a.PlanCommitResult?>()) {
      return (data != null ? _ixc6g37a.PlanCommitResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ititmozf.PlanHorizon?>()) {
      return (data != null ? _ititmozf.PlanHorizon.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iv13hf9x.PlanProposal?>()) {
      return (data != null ? _iv13hf9x.PlanProposal.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idh5khlu.PlanRequest?>()) {
      return (data != null ? _idh5khlu.PlanRequest.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iw1c6zow.PlannerPreferences?>()) {
      return (data != null ? _iw1c6zow.PlannerPreferences.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i03liexf.PlannerPreferencesDraft?>()) {
      return (data != null
              ? _i03liexf.PlannerPreferencesDraft.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ityq5odj.PlanningErrorCode?>()) {
      return (data != null ? _ityq5odj.PlanningErrorCode.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iehth582.PlanningException?>()) {
      return (data != null ? _iehth582.PlanningException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_icv3lfjf.ReviewPlan?>()) {
      return (data != null ? _icv3lfjf.ReviewPlan.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_indyheef.ReviewSession?>()) {
      return (data != null ? _indyheef.ReviewSession.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_in0sx9zc.SessionChangeResult?>()) {
      return (data != null
              ? _in0sx9zc.SessionChangeResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i716ymk1.SessionItem?>()) {
      return (data != null ? _i716ymk1.SessionItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3pyieja.SessionItemView?>()) {
      return (data != null ? _i3pyieja.SessionItemView.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i91809id.SessionMoveRequest?>()) {
      return (data != null ? _i91809id.SessionMoveRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izbi9tiy.SessionStatus?>()) {
      return (data != null ? _izbi9tiy.SessionStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iyjcmdi4.SessionView?>()) {
      return (data != null ? _iyjcmdi4.SessionView.fromJson(data) : null) as T;
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
    if (t == _isc.getType<_i0v594yd.ReminderSettings?>()) {
      return (data != null ? _i0v594yd.ReminderSettings.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2m53qgo.ReminderSettingsDraft?>()) {
      return (data != null
              ? _i2m53qgo.ReminderSettingsDraft.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iswi3gl6.ReminderWindow?>()) {
      return (data != null ? _iswi3gl6.ReminderWindow.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_isu905ko.ReviewDigest?>()) {
      return (data != null ? _isu905ko.ReviewDigest.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iv91gdem.ItemProgress?>()) {
      return (data != null ? _iv91gdem.ItemProgress.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_il1zbvt2.ItemReviewControl?>()) {
      return (data != null ? _il1zbvt2.ItemReviewControl.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0pv2k4n.ReviewEvent?>()) {
      return (data != null ? _i0pv2k4n.ReviewEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4vpgh88.ReviewEventDraft?>()) {
      return (data != null ? _i4vpgh88.ReviewEventDraft.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i5hoegii.ReviewEventReceipt?>()) {
      return (data != null ? _i5hoegii.ReviewEventReceipt.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i5mz8id3.ReviewEventType?>()) {
      return (data != null ? _i5mz8id3.ReviewEventType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ia978e3v.ReviewQueueEntry?>()) {
      return (data != null ? _ia978e3v.ReviewQueueEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igp65vp8.ReviewQueueResult?>()) {
      return (data != null ? _igp65vp8.ReviewQueueResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1podblr.ItemNote?>()) {
      return (data != null ? _i1podblr.ItemNote.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ive6le5b.ReviewStatusFilter?>()) {
      return (data != null ? _ive6le5b.ReviewStatusFilter.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igqcqr3d.SearchEvidence?>()) {
      return (data != null ? _igqcqr3d.SearchEvidence.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ic5aviky.SearchPage?>()) {
      return (data != null ? _ic5aviky.SearchPage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iyyp88jv.SearchResult?>()) {
      return (data != null ? _iyyp88jv.SearchResult.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iv0vmssg.ItemTag?>()) {
      return (data != null ? _iv0vmssg.ItemTag.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iopagaq8.Tag?>()) {
      return (data != null ? _iopagaq8.Tag.fromJson(data) : null) as T;
    }
    if (t == List<_i8v3said.CalendarSelection>) {
      return (data as List)
              .map((e) => deserialize<_i8v3said.CalendarSelection>(e))
              .toList()
          as T;
    }
    if (t == List<_ihue00wg.DeviceCalendarInfo>) {
      return (data as List)
              .map((e) => deserialize<_ihue00wg.DeviceCalendarInfo>(e))
              .toList()
          as T;
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
    if (t == List<_imvtil8c.BusyInterval>) {
      return (data as List)
              .map((e) => deserialize<_imvtil8c.BusyInterval>(e))
              .toList()
          as T;
    }
    if (t == List<_i1u9wvnf.AvailabilitySnapshot>) {
      return (data as List)
              .map((e) => deserialize<_i1u9wvnf.AvailabilitySnapshot>(e))
              .toList()
          as T;
    }
    if (t == List<_iyjcmdi4.SessionView>) {
      return (data as List)
              .map((e) => deserialize<_iyjcmdi4.SessionView>(e))
              .toList()
          as T;
    }
    if (t == List<_i6oluk1v.CalendarWrite>) {
      return (data as List)
              .map((e) => deserialize<_i6oluk1v.CalendarWrite>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_iadysn2t.CalendarCoverage>) {
      return (data as List)
              .map((e) => deserialize<_iadysn2t.CalendarCoverage>(e))
              .toList()
          as T;
    }
    if (t == List<_i3pyieja.SessionItemView>) {
      return (data as List)
              .map((e) => deserialize<_i3pyieja.SessionItemView>(e))
              .toList()
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
    if (t == List<_ia978e3v.ReviewQueueEntry>) {
      return (data as List)
              .map((e) => deserialize<_ia978e3v.ReviewQueueEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_iyyp88jv.SearchResult>) {
      return (data as List)
              .map((e) => deserialize<_iyyp88jv.SearchResult>(e))
              .toList()
          as T;
    }
    if (t == List<_igqcqr3d.SearchEvidence>) {
      return (data as List)
              .map((e) => deserialize<_igqcqr3d.SearchEvidence>(e))
              .toList()
          as T;
    }
    if (t == List<_iq5krdy3.AiSuggestion>) {
      return (data as List)
              .map((e) => deserialize<_iq5krdy3.AiSuggestion>(e))
              .toList()
          as T;
    }
    if (t == List<_ig4e8y15.CalendarRouteStatus>) {
      return (data as List)
              .map((e) => deserialize<_ig4e8y15.CalendarRouteStatus>(e))
              .toList()
          as T;
    }
    if (t == List<_i0t8t4zu.CalendarConnectionView>) {
      return (data as List)
              .map((e) => deserialize<_i0t8t4zu.CalendarConnectionView>(e))
              .toList()
          as T;
    }
    if (t == List<_im02fgk3.CalendarSelectionChoice>) {
      return (data as List)
              .map((e) => deserialize<_im02fgk3.CalendarSelectionChoice>(e))
              .toList()
          as T;
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
    if (t == List<_i2af9p8a.SessionView>) {
      return (data as List)
              .map((e) => deserialize<_i2af9p8a.SessionView>(e))
              .toList()
          as T;
    }
    if (t == List<_i4bu6rte.CalendarWrite>) {
      return (data as List)
              .map((e) => deserialize<_i4bu6rte.CalendarWrite>(e))
              .toList()
          as T;
    }
    if (t == List<_ivswpuyg.CalendarWriteResult>) {
      return (data as List)
              .map((e) => deserialize<_ivswpuyg.CalendarWriteResult>(e))
              .toList()
          as T;
    }
    if (t == List<_isc.UuidValue>) {
      return (data as List).map((e) => deserialize<_isc.UuidValue>(e)).toList()
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
      _ieqt63qc.AiDailyUsage => 'AiDailyUsage',
      _ike1rdmf.AiEvidenceCoverage => 'AiEvidenceCoverage',
      _i3rayejx.AiOrganizeTask => 'AiOrganizeTask',
      _irbaoatq.AiPreference => 'AiPreference',
      _iuqfkn3x.AiProcessingState => 'AiProcessingState',
      _i8oswxfq.AiSettings => 'AiSettings',
      _ispfx06l.AiSuggestion => 'AiSuggestion',
      _il1lz8eg.AiSuggestionKind => 'AiSuggestionKind',
      _it1ujq25.AiSuggestionStatus => 'AiSuggestionStatus',
      _iqtchur3.CalendarConnection => 'CalendarConnection',
      _ijwz5xp0.CalendarConnectionView => 'CalendarConnectionView',
      _ily35bfr.CalendarEventLink => 'CalendarEventLink',
      _ika1a9r5.CalendarPermission => 'CalendarPermission',
      _iq08ggdy.CalendarRoute => 'CalendarRoute',
      _igxvbit5.CalendarRouteException => 'CalendarRouteException',
      _i7yozl4b.CalendarRouteStatus => 'CalendarRouteStatus',
      _i8v3said.CalendarSelection => 'CalendarSelection',
      _intkkx3w.CalendarSelectionChoice => 'CalendarSelectionChoice',
      _ihue00wg.DeviceCalendarInfo => 'DeviceCalendarInfo',
      _i4awacjs.DeviceCalendarReport => 'DeviceCalendarReport',
      _i1s71wt9.EventSyncState => 'EventSyncState',
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
      _id2awq13.ApprovalMode => 'ApprovalMode',
      _i1u9wvnf.AvailabilitySnapshot => 'AvailabilitySnapshot',
      _imvtil8c.BusyInterval => 'BusyInterval',
      _iadysn2t.CalendarCoverage => 'CalendarCoverage',
      _i6oluk1v.CalendarWrite => 'CalendarWrite',
      _iyd6g2oi.CalendarWriteAction => 'CalendarWriteAction',
      _i3u14n80.CalendarWriteOutcome => 'CalendarWriteOutcome',
      _i5mmfzwl.CalendarWriteResult => 'CalendarWriteResult',
      _il89vgny.CoverageState => 'CoverageState',
      _ilaph13t.PlanCommitRequest => 'PlanCommitRequest',
      _ixc6g37a.PlanCommitResult => 'PlanCommitResult',
      _ititmozf.PlanHorizon => 'PlanHorizon',
      _iv13hf9x.PlanProposal => 'PlanProposal',
      _idh5khlu.PlanRequest => 'PlanRequest',
      _iw1c6zow.PlannerPreferences => 'PlannerPreferences',
      _i03liexf.PlannerPreferencesDraft => 'PlannerPreferencesDraft',
      _ityq5odj.PlanningErrorCode => 'PlanningErrorCode',
      _iehth582.PlanningException => 'PlanningException',
      _icv3lfjf.ReviewPlan => 'ReviewPlan',
      _indyheef.ReviewSession => 'ReviewSession',
      _in0sx9zc.SessionChangeResult => 'SessionChangeResult',
      _i716ymk1.SessionItem => 'SessionItem',
      _i3pyieja.SessionItemView => 'SessionItemView',
      _i91809id.SessionMoveRequest => 'SessionMoveRequest',
      _izbi9tiy.SessionStatus => 'SessionStatus',
      _iyjcmdi4.SessionView => 'SessionView',
      _ijguvy1g.PinneProfile => 'PinneProfile',
      _ij8joe28.ProfileDraft => 'ProfileDraft',
      _i6ljcdoh.ReminderRule => 'ReminderRule',
      _i0v594yd.ReminderSettings => 'ReminderSettings',
      _i2m53qgo.ReminderSettingsDraft => 'ReminderSettingsDraft',
      _iswi3gl6.ReminderWindow => 'ReminderWindow',
      _isu905ko.ReviewDigest => 'ReviewDigest',
      _iv91gdem.ItemProgress => 'ItemProgress',
      _il1zbvt2.ItemReviewControl => 'ItemReviewControl',
      _i0pv2k4n.ReviewEvent => 'ReviewEvent',
      _i4vpgh88.ReviewEventDraft => 'ReviewEventDraft',
      _i5hoegii.ReviewEventReceipt => 'ReviewEventReceipt',
      _i5mz8id3.ReviewEventType => 'ReviewEventType',
      _ia978e3v.ReviewQueueEntry => 'ReviewQueueEntry',
      _igp65vp8.ReviewQueueResult => 'ReviewQueueResult',
      _i1podblr.ItemNote => 'ItemNote',
      _ive6le5b.ReviewStatusFilter => 'ReviewStatusFilter',
      _igqcqr3d.SearchEvidence => 'SearchEvidence',
      _ic5aviky.SearchPage => 'SearchPage',
      _iyyp88jv.SearchResult => 'SearchResult',
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
      case _ieqt63qc.AiDailyUsage():
        return 'AiDailyUsage';
      case _ike1rdmf.AiEvidenceCoverage():
        return 'AiEvidenceCoverage';
      case _i3rayejx.AiOrganizeTask():
        return 'AiOrganizeTask';
      case _irbaoatq.AiPreference():
        return 'AiPreference';
      case _iuqfkn3x.AiProcessingState():
        return 'AiProcessingState';
      case _i8oswxfq.AiSettings():
        return 'AiSettings';
      case _ispfx06l.AiSuggestion():
        return 'AiSuggestion';
      case _il1lz8eg.AiSuggestionKind():
        return 'AiSuggestionKind';
      case _it1ujq25.AiSuggestionStatus():
        return 'AiSuggestionStatus';
      case _iqtchur3.CalendarConnection():
        return 'CalendarConnection';
      case _ijwz5xp0.CalendarConnectionView():
        return 'CalendarConnectionView';
      case _ily35bfr.CalendarEventLink():
        return 'CalendarEventLink';
      case _ika1a9r5.CalendarPermission():
        return 'CalendarPermission';
      case _iq08ggdy.CalendarRoute():
        return 'CalendarRoute';
      case _igxvbit5.CalendarRouteException():
        return 'CalendarRouteException';
      case _i7yozl4b.CalendarRouteStatus():
        return 'CalendarRouteStatus';
      case _i8v3said.CalendarSelection():
        return 'CalendarSelection';
      case _intkkx3w.CalendarSelectionChoice():
        return 'CalendarSelectionChoice';
      case _ihue00wg.DeviceCalendarInfo():
        return 'DeviceCalendarInfo';
      case _i4awacjs.DeviceCalendarReport():
        return 'DeviceCalendarReport';
      case _i1s71wt9.EventSyncState():
        return 'EventSyncState';
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
      case _id2awq13.ApprovalMode():
        return 'ApprovalMode';
      case _i1u9wvnf.AvailabilitySnapshot():
        return 'AvailabilitySnapshot';
      case _imvtil8c.BusyInterval():
        return 'BusyInterval';
      case _iadysn2t.CalendarCoverage():
        return 'CalendarCoverage';
      case _i6oluk1v.CalendarWrite():
        return 'CalendarWrite';
      case _iyd6g2oi.CalendarWriteAction():
        return 'CalendarWriteAction';
      case _i3u14n80.CalendarWriteOutcome():
        return 'CalendarWriteOutcome';
      case _i5mmfzwl.CalendarWriteResult():
        return 'CalendarWriteResult';
      case _il89vgny.CoverageState():
        return 'CoverageState';
      case _ilaph13t.PlanCommitRequest():
        return 'PlanCommitRequest';
      case _ixc6g37a.PlanCommitResult():
        return 'PlanCommitResult';
      case _ititmozf.PlanHorizon():
        return 'PlanHorizon';
      case _iv13hf9x.PlanProposal():
        return 'PlanProposal';
      case _idh5khlu.PlanRequest():
        return 'PlanRequest';
      case _iw1c6zow.PlannerPreferences():
        return 'PlannerPreferences';
      case _i03liexf.PlannerPreferencesDraft():
        return 'PlannerPreferencesDraft';
      case _ityq5odj.PlanningErrorCode():
        return 'PlanningErrorCode';
      case _iehth582.PlanningException():
        return 'PlanningException';
      case _icv3lfjf.ReviewPlan():
        return 'ReviewPlan';
      case _indyheef.ReviewSession():
        return 'ReviewSession';
      case _in0sx9zc.SessionChangeResult():
        return 'SessionChangeResult';
      case _i716ymk1.SessionItem():
        return 'SessionItem';
      case _i3pyieja.SessionItemView():
        return 'SessionItemView';
      case _i91809id.SessionMoveRequest():
        return 'SessionMoveRequest';
      case _izbi9tiy.SessionStatus():
        return 'SessionStatus';
      case _iyjcmdi4.SessionView():
        return 'SessionView';
      case _ijguvy1g.PinneProfile():
        return 'PinneProfile';
      case _ij8joe28.ProfileDraft():
        return 'ProfileDraft';
      case _i6ljcdoh.ReminderRule():
        return 'ReminderRule';
      case _i0v594yd.ReminderSettings():
        return 'ReminderSettings';
      case _i2m53qgo.ReminderSettingsDraft():
        return 'ReminderSettingsDraft';
      case _iswi3gl6.ReminderWindow():
        return 'ReminderWindow';
      case _isu905ko.ReviewDigest():
        return 'ReviewDigest';
      case _iv91gdem.ItemProgress():
        return 'ItemProgress';
      case _il1zbvt2.ItemReviewControl():
        return 'ItemReviewControl';
      case _i0pv2k4n.ReviewEvent():
        return 'ReviewEvent';
      case _i4vpgh88.ReviewEventDraft():
        return 'ReviewEventDraft';
      case _i5hoegii.ReviewEventReceipt():
        return 'ReviewEventReceipt';
      case _i5mz8id3.ReviewEventType():
        return 'ReviewEventType';
      case _ia978e3v.ReviewQueueEntry():
        return 'ReviewQueueEntry';
      case _igp65vp8.ReviewQueueResult():
        return 'ReviewQueueResult';
      case _i1podblr.ItemNote():
        return 'ItemNote';
      case _ive6le5b.ReviewStatusFilter():
        return 'ReviewStatusFilter';
      case _igqcqr3d.SearchEvidence():
        return 'SearchEvidence';
      case _ic5aviky.SearchPage():
        return 'SearchPage';
      case _iyyp88jv.SearchResult():
        return 'SearchResult';
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
    if (dataClassName == 'AiDailyUsage') {
      return deserialize<_ieqt63qc.AiDailyUsage>(data['data']);
    }
    if (dataClassName == 'AiEvidenceCoverage') {
      return deserialize<_ike1rdmf.AiEvidenceCoverage>(data['data']);
    }
    if (dataClassName == 'AiOrganizeTask') {
      return deserialize<_i3rayejx.AiOrganizeTask>(data['data']);
    }
    if (dataClassName == 'AiPreference') {
      return deserialize<_irbaoatq.AiPreference>(data['data']);
    }
    if (dataClassName == 'AiProcessingState') {
      return deserialize<_iuqfkn3x.AiProcessingState>(data['data']);
    }
    if (dataClassName == 'AiSettings') {
      return deserialize<_i8oswxfq.AiSettings>(data['data']);
    }
    if (dataClassName == 'AiSuggestion') {
      return deserialize<_ispfx06l.AiSuggestion>(data['data']);
    }
    if (dataClassName == 'AiSuggestionKind') {
      return deserialize<_il1lz8eg.AiSuggestionKind>(data['data']);
    }
    if (dataClassName == 'AiSuggestionStatus') {
      return deserialize<_it1ujq25.AiSuggestionStatus>(data['data']);
    }
    if (dataClassName == 'CalendarConnection') {
      return deserialize<_iqtchur3.CalendarConnection>(data['data']);
    }
    if (dataClassName == 'CalendarConnectionView') {
      return deserialize<_ijwz5xp0.CalendarConnectionView>(data['data']);
    }
    if (dataClassName == 'CalendarEventLink') {
      return deserialize<_ily35bfr.CalendarEventLink>(data['data']);
    }
    if (dataClassName == 'CalendarPermission') {
      return deserialize<_ika1a9r5.CalendarPermission>(data['data']);
    }
    if (dataClassName == 'CalendarRoute') {
      return deserialize<_iq08ggdy.CalendarRoute>(data['data']);
    }
    if (dataClassName == 'CalendarRouteException') {
      return deserialize<_igxvbit5.CalendarRouteException>(data['data']);
    }
    if (dataClassName == 'CalendarRouteStatus') {
      return deserialize<_i7yozl4b.CalendarRouteStatus>(data['data']);
    }
    if (dataClassName == 'CalendarSelection') {
      return deserialize<_i8v3said.CalendarSelection>(data['data']);
    }
    if (dataClassName == 'CalendarSelectionChoice') {
      return deserialize<_intkkx3w.CalendarSelectionChoice>(data['data']);
    }
    if (dataClassName == 'DeviceCalendarInfo') {
      return deserialize<_ihue00wg.DeviceCalendarInfo>(data['data']);
    }
    if (dataClassName == 'DeviceCalendarReport') {
      return deserialize<_i4awacjs.DeviceCalendarReport>(data['data']);
    }
    if (dataClassName == 'EventSyncState') {
      return deserialize<_i1s71wt9.EventSyncState>(data['data']);
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
    if (dataClassName == 'ApprovalMode') {
      return deserialize<_id2awq13.ApprovalMode>(data['data']);
    }
    if (dataClassName == 'AvailabilitySnapshot') {
      return deserialize<_i1u9wvnf.AvailabilitySnapshot>(data['data']);
    }
    if (dataClassName == 'BusyInterval') {
      return deserialize<_imvtil8c.BusyInterval>(data['data']);
    }
    if (dataClassName == 'CalendarCoverage') {
      return deserialize<_iadysn2t.CalendarCoverage>(data['data']);
    }
    if (dataClassName == 'CalendarWrite') {
      return deserialize<_i6oluk1v.CalendarWrite>(data['data']);
    }
    if (dataClassName == 'CalendarWriteAction') {
      return deserialize<_iyd6g2oi.CalendarWriteAction>(data['data']);
    }
    if (dataClassName == 'CalendarWriteOutcome') {
      return deserialize<_i3u14n80.CalendarWriteOutcome>(data['data']);
    }
    if (dataClassName == 'CalendarWriteResult') {
      return deserialize<_i5mmfzwl.CalendarWriteResult>(data['data']);
    }
    if (dataClassName == 'CoverageState') {
      return deserialize<_il89vgny.CoverageState>(data['data']);
    }
    if (dataClassName == 'PlanCommitRequest') {
      return deserialize<_ilaph13t.PlanCommitRequest>(data['data']);
    }
    if (dataClassName == 'PlanCommitResult') {
      return deserialize<_ixc6g37a.PlanCommitResult>(data['data']);
    }
    if (dataClassName == 'PlanHorizon') {
      return deserialize<_ititmozf.PlanHorizon>(data['data']);
    }
    if (dataClassName == 'PlanProposal') {
      return deserialize<_iv13hf9x.PlanProposal>(data['data']);
    }
    if (dataClassName == 'PlanRequest') {
      return deserialize<_idh5khlu.PlanRequest>(data['data']);
    }
    if (dataClassName == 'PlannerPreferences') {
      return deserialize<_iw1c6zow.PlannerPreferences>(data['data']);
    }
    if (dataClassName == 'PlannerPreferencesDraft') {
      return deserialize<_i03liexf.PlannerPreferencesDraft>(data['data']);
    }
    if (dataClassName == 'PlanningErrorCode') {
      return deserialize<_ityq5odj.PlanningErrorCode>(data['data']);
    }
    if (dataClassName == 'PlanningException') {
      return deserialize<_iehth582.PlanningException>(data['data']);
    }
    if (dataClassName == 'ReviewPlan') {
      return deserialize<_icv3lfjf.ReviewPlan>(data['data']);
    }
    if (dataClassName == 'ReviewSession') {
      return deserialize<_indyheef.ReviewSession>(data['data']);
    }
    if (dataClassName == 'SessionChangeResult') {
      return deserialize<_in0sx9zc.SessionChangeResult>(data['data']);
    }
    if (dataClassName == 'SessionItem') {
      return deserialize<_i716ymk1.SessionItem>(data['data']);
    }
    if (dataClassName == 'SessionItemView') {
      return deserialize<_i3pyieja.SessionItemView>(data['data']);
    }
    if (dataClassName == 'SessionMoveRequest') {
      return deserialize<_i91809id.SessionMoveRequest>(data['data']);
    }
    if (dataClassName == 'SessionStatus') {
      return deserialize<_izbi9tiy.SessionStatus>(data['data']);
    }
    if (dataClassName == 'SessionView') {
      return deserialize<_iyjcmdi4.SessionView>(data['data']);
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
    if (dataClassName == 'ReminderSettings') {
      return deserialize<_i0v594yd.ReminderSettings>(data['data']);
    }
    if (dataClassName == 'ReminderSettingsDraft') {
      return deserialize<_i2m53qgo.ReminderSettingsDraft>(data['data']);
    }
    if (dataClassName == 'ReminderWindow') {
      return deserialize<_iswi3gl6.ReminderWindow>(data['data']);
    }
    if (dataClassName == 'ReviewDigest') {
      return deserialize<_isu905ko.ReviewDigest>(data['data']);
    }
    if (dataClassName == 'ItemProgress') {
      return deserialize<_iv91gdem.ItemProgress>(data['data']);
    }
    if (dataClassName == 'ItemReviewControl') {
      return deserialize<_il1zbvt2.ItemReviewControl>(data['data']);
    }
    if (dataClassName == 'ReviewEvent') {
      return deserialize<_i0pv2k4n.ReviewEvent>(data['data']);
    }
    if (dataClassName == 'ReviewEventDraft') {
      return deserialize<_i4vpgh88.ReviewEventDraft>(data['data']);
    }
    if (dataClassName == 'ReviewEventReceipt') {
      return deserialize<_i5hoegii.ReviewEventReceipt>(data['data']);
    }
    if (dataClassName == 'ReviewEventType') {
      return deserialize<_i5mz8id3.ReviewEventType>(data['data']);
    }
    if (dataClassName == 'ReviewQueueEntry') {
      return deserialize<_ia978e3v.ReviewQueueEntry>(data['data']);
    }
    if (dataClassName == 'ReviewQueueResult') {
      return deserialize<_igp65vp8.ReviewQueueResult>(data['data']);
    }
    if (dataClassName == 'ItemNote') {
      return deserialize<_i1podblr.ItemNote>(data['data']);
    }
    if (dataClassName == 'ReviewStatusFilter') {
      return deserialize<_ive6le5b.ReviewStatusFilter>(data['data']);
    }
    if (dataClassName == 'SearchEvidence') {
      return deserialize<_igqcqr3d.SearchEvidence>(data['data']);
    }
    if (dataClassName == 'SearchPage') {
      return deserialize<_ic5aviky.SearchPage>(data['data']);
    }
    if (dataClassName == 'SearchResult') {
      return deserialize<_iyyp88jv.SearchResult>(data['data']);
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
