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
import 'package:pinne_server/src/generated/ai/ai_suggestion.dart' as _i9k1kmrj;
import 'package:pinne_server/src/generated/calendar/calendar_connection_view.dart'
    as _i0xb4k4o;
import 'package:pinne_server/src/generated/calendar/calendar_route_status.dart'
    as _ia8eyaw8;
import 'package:pinne_server/src/generated/calendar/calendar_selection_choice.dart'
    as _i396ixoa;
import 'package:pinne_server/src/generated/collections/collection.dart'
    as _is0jaro3;
import 'package:pinne_server/src/generated/items/item.dart' as _id0tr7gx;
import 'package:pinne_server/src/generated/planning/calendar_write.dart'
    as _ijx3xba9;
import 'package:pinne_server/src/generated/planning/calendar_write_result.dart'
    as _iaiz9j0d;
import 'package:pinne_server/src/generated/planning/session_view.dart'
    as _ie9b2ryt;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
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
import 'examples/example_saves_status.dart' as _inzv38yi;
import 'future_calls_generated_models/ai_organize_future_call_process_model.dart'
    as _is4ugn9t;
import 'future_calls_generated_models/link_preview_future_call_process_model.dart'
    as _ij9va9aa;
import 'health/server_health.dart' as _iozgwprg;
import 'items/access_state.dart' as _imhj9b3j;
import 'items/capture_draft.dart' as _idav3wwe;
import 'items/capture_receipt.dart' as _i6e75atc;
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
import 'progress/celebration_seen.dart' as _i4wj722g;
import 'progress/collection_progress.dart' as _ib4b75r3;
import 'progress/milestone_kind.dart' as _iz0l6k27;
import 'progress/progress_day.dart' as _iv86lxab;
import 'progress/progress_milestone.dart' as _ism40znx;
import 'progress/progress_period.dart' as _ick5xr48;
import 'progress/progress_query.dart' as _iox5xpz3;
import 'progress/progress_report.dart' as _i5135299;
import 'progress/progress_settings.dart' as _if1vui5d;
import 'progress/progress_settings_draft.dart' as _i19ehhj8;
import 'progress/weekly_goal_progress.dart' as _icoz9lvv;
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
export 'examples/example_saves_status.dart';
export 'health/server_health.dart';
export 'items/access_state.dart';
export 'items/capture_draft.dart';
export 'items/capture_receipt.dart';
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
export 'progress/celebration_seen.dart';
export 'progress/collection_progress.dart';
export 'progress/milestone_kind.dart';
export 'progress/progress_day.dart';
export 'progress/progress_milestone.dart';
export 'progress/progress_period.dart';
export 'progress/progress_query.dart';
export 'progress/progress_report.dart';
export 'progress/progress_settings.dart';
export 'progress/progress_settings_draft.dart';
export 'progress/weekly_goal_progress.dart';
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

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'ai_daily_usage',
      dartName: 'AiDailyUsage',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'dateKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'requestCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'ai_daily_usage_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'ai_daily_usage_owner_date_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'dateKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'ai_organize_task',
      dartName: 'AiOrganizeTask',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'state',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AiProcessingState',
          columnDefault: '\'queued\'',
        ),
        _isp.ColumnDefinition(
          name: 'requestedVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'processedVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'dailySlotClaimed',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'quotaDateKey',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'claimedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'completedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'provider',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'ai_organize_task_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'ai_organize_task_fk_1',
          columns: ['itemId'],
          referenceTable: 'item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'ai_organize_task_item_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'ai_organize_task_owner_state_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'state',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'ai_preference',
      dartName: 'AiPreference',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'enabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'ai_preference_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'ai_preference_owner_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'ai_suggestion',
      dartName: 'AiSuggestion',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AiSuggestionKind',
        ),
        _isp.ColumnDefinition(
          name: 'origin',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AssignmentOrigin',
          columnDefault: '\'ai\'',
        ),
        _isp.ColumnDefinition(
          name: 'collectionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'value',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'rationale',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'evidenceCoverage',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AiEvidenceCoverage',
          columnDefault: '\'metadataOnly\'',
        ),
        _isp.ColumnDefinition(
          name: 'uncertain',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AiSuggestionStatus',
          columnDefault: '\'pending\'',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'resolvedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'ai_suggestion_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'ai_suggestion_fk_1',
          columns: ['itemId'],
          referenceTable: 'item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'ai_suggestion_fk_2',
          columns: ['collectionId'],
          referenceTable: 'collection',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'ai_suggestion_owner_item_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'calendar_connection',
      dartName: 'CalendarConnection',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'route',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CalendarRoute',
        ),
        _isp.ColumnDefinition(
          name: 'accountKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'label',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'permission',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CalendarPermission',
        ),
        _isp.ColumnDefinition(
          name: 'tokenSecretRef',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'lastCheckedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'calendar_connection_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'calendar_connection_owner_account_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'route',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'accountKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'calendar_event_link',
      dartName: 'CalendarEventLink',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'sessionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'selectionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'eventUid',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'externalEventId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'providerRevision',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'syncState',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:EventSyncState',
        ),
        _isp.ColumnDefinition(
          name: 'operationId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'lastError',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'calendar_event_link_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'calendar_event_link_fk_1',
          columns: ['sessionId'],
          referenceTable: 'review_session',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'calendar_event_link_fk_2',
          columns: ['selectionId'],
          referenceTable: 'calendar_selection',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'calendar_event_link_session_selection_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'selectionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'calendar_event_link_owner_device_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'syncState',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'calendar_selection',
      dartName: 'CalendarSelection',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'connectionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'externalCalendarId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'accountName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'readOnly',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'useForConflicts',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'useForWrites',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'calendar_selection_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'calendar_selection_fk_1',
          columns: ['connectionId'],
          referenceTable: 'calendar_connection',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'calendar_selection_connection_calendar_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'connectionId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'externalCalendarId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'calendar_selection_owner_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'capture_receipt',
      dartName: 'CaptureReceipt',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'operationId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'clientItemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'requestHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'duplicate',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'receivedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'capture_receipt_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'capture_receipt_fk_1',
          columns: ['itemId'],
          referenceTable: 'item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'capture_receipt_owner_operation_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'operationId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'capture_receipt_owner_client_item_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clientItemId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'celebration_seen',
      dartName: 'CelebrationSeen',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'milestoneKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'seenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'celebration_seen_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'celebration_seen_owner_key_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'milestoneKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'collection',
      dartName: 'Collection',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'parentId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'coverSeed',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'paletteIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'isExample',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'collection_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'collection_fk_1',
          columns: ['parentId'],
          referenceTable: 'collection',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'collection_owner_parent_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'parentId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'item',
      dartName: 'Item',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'clientItemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'url',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'canonicalUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sourcePlatform',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SourcePlatform',
          columnDefault: '\'web\'',
        ),
        _isp.ColumnDefinition(
          name: 'sourceItemId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'titleManuallyLocked',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'noteText',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'contentType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ContentType',
          columnDefault: '\'other\'',
        ),
        _isp.ColumnDefinition(
          name: 'intention',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'summary',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'summaryOrigin',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:AssignmentOrigin?',
        ),
        _isp.ColumnDefinition(
          name: 'summaryManuallyLocked',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'priority',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'lifecycle',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ItemLifecycle',
          columnDefault: '\'active\'',
        ),
        _isp.ColumnDefinition(
          name: 'savedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'enrichmentState',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:EnrichmentState',
          columnDefault: '\'pending\'',
        ),
        _isp.ColumnDefinition(
          name: 'accessState',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AccessState',
          columnDefault: '\'unknown\'',
        ),
        _isp.ColumnDefinition(
          name: 'previewDescription',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'previewAuthor',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'previewSiteName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'previewProvider',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'thumbnailUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'durationSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'previewMetadataJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'previewUpdatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'previewStartedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'previewAttemptCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'isExample',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'revision',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'item_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'item_owner_saved_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'savedAt',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_owner_canonical_url_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'canonicalUrl',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_owner_source_item_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sourcePlatform',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sourceItemId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_owner_client_item_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clientItemId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_owner_lifecycle_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lifecycle',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'item_collection',
      dartName: 'ItemCollection',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'collectionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'origin',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AssignmentOrigin',
          columnDefault: '\'manual\'',
        ),
        _isp.ColumnDefinition(
          name: 'manuallyLocked',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'item_collection_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'item_collection_fk_1',
          columns: ['itemId'],
          referenceTable: 'item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'item_collection_fk_2',
          columns: ['collectionId'],
          referenceTable: 'collection',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'item_collection_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'collectionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_collection_owner_collection_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'collectionId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'item_note',
      dartName: 'ItemNote',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'body',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'item_note_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'item_note_fk_1',
          columns: ['itemId'],
          referenceTable: 'item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'item_note_owner_item_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'item_progress',
      dartName: 'ItemProgress',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'firstOpenedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'lastOpenedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'openCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'firstReviewedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'lastReviewedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'completedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'appliedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'rebuiltAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'item_progress_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'item_progress_fk_1',
          columns: ['itemId'],
          referenceTable: 'item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'item_progress_owner_item_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_progress_owner_reviewed_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'firstReviewedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'item_review_control',
      dartName: 'ItemReviewControl',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'snoozedUntil',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'remindersPaused',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'lastDismissedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'item_review_control_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'item_review_control_fk_1',
          columns: ['itemId'],
          referenceTable: 'item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'item_review_control_owner_item_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'item_tag',
      dartName: 'ItemTag',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'tagId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'origin',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AssignmentOrigin',
          columnDefault: '\'manual\'',
        ),
        _isp.ColumnDefinition(
          name: 'manuallyLocked',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'item_tag_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'item_tag_fk_1',
          columns: ['itemId'],
          referenceTable: 'item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'item_tag_fk_2',
          columns: ['tagId'],
          referenceTable: 'tag',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'item_tag_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tagId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'item_tag_owner_tag_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tagId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'pinne_profile',
      dartName: 'PinneProfile',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'avatarSeed',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'avatarPalette',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'pinne_profile_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'pinne_profile_owner_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'planner_preferences',
      dartName: 'PlannerPreferences',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'horizon',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:PlanHorizon',
        ),
        _isp.ColumnDefinition(
          name: 'weekdays',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<int>',
        ),
        _isp.ColumnDefinition(
          name: 'windowStartMinute',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'windowEndMinute',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'sessionMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'maxSessions',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'bufferMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'minLeadMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'timezone',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'approvalMode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ApprovalMode',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'planner_preferences_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'planner_preferences_owner_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'progress_settings',
      dartName: 'ProgressSettings',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'streakEnabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'weeklyGoalDays',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '3',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'progress_settings_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'progress_settings_owner_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'reminder_rule',
      dartName: 'ReminderRule',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'collectionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'delayHours',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '24',
        ),
        _isp.ColumnDefinition(
          name: 'deliveryWindows',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:ReminderWindow>?',
        ),
        _isp.ColumnDefinition(
          name: 'cap',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'enabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'reminder_rule_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'reminder_rule_fk_1',
          columns: ['collectionId'],
          referenceTable: 'collection',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'reminder_rule_owner_collection_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'collectionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          nullsDistinct: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'reminder_settings',
      dartName: 'ReminderSettings',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'delayHours',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '24',
        ),
        _isp.ColumnDefinition(
          name: 'timezone',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'UTC\'',
        ),
        _isp.ColumnDefinition(
          name: 'timezoneOffsetMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'quietStartMinute',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'quietEndMinute',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'dailyCap',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'remindersPaused',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'queueLimit',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '5',
        ),
        _isp.ColumnDefinition(
          name: 'dismissCooldownMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '120',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'reminder_settings_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'reminder_settings_owner_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'review_digest',
      dartName: 'ReviewDigest',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'digestKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'localDate',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'body',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'itemCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'review_digest_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'review_digest_owner_key_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'digestKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'review_digest_owner_created_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'review_event',
      dartName: 'ReviewEvent',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'clientEventId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'eventType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ReviewEventType',
        ),
        _isp.ColumnDefinition(
          name: 'occurredAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'receivedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'timezone',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'effectiveLocalDate',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'compensatesEventId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'review_event_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'review_event_fk_1',
          columns: ['itemId'],
          referenceTable: 'item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'review_event_fk_2',
          columns: ['compensatesEventId'],
          referenceTable: 'review_event',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'review_event_owner_client_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clientEventId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'review_event_owner_item_time_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'occurredAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'review_event_owner_date_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'effectiveLocalDate',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'review_plan',
      dartName: 'ReviewPlan',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'horizonStart',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'horizonEnd',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'timezone',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'coverage',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:CalendarCoverage>',
        ),
        _isp.ColumnDefinition(
          name: 'availabilityVerified',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'commitOperationId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'committedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'review_plan_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'review_plan_owner_created_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'review_plan_owner_operation_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'commitOperationId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'review_session',
      dartName: 'ReviewSession',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'planId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'startAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'endAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'timezone',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SessionStatus',
        ),
        _isp.ColumnDefinition(
          name: 'schedulingMode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ApprovalMode',
        ),
        _isp.ColumnDefinition(
          name: 'availabilityVerified',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'planRevision',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'lastOperationId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'review_session_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'review_session_fk_1',
          columns: ['planId'],
          referenceTable: 'review_plan',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'review_session_owner_start_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'startAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'review_session_plan_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'planId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'session_item',
      dartName: 'SessionItem',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'sessionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'position',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'plannedMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'estimated',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'session_item_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'session_item_fk_1',
          columns: ['sessionId'],
          referenceTable: 'review_session',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'session_item_fk_2',
          columns: ['itemId'],
          referenceTable: 'item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'session_item_session_position_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'position',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'session_item_session_item_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'tag',
      dartName: 'Tag',
      schema: 'public',
      module: 'pinne',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'normalizedName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'tag_fk_0',
          columns: ['ownerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'tag_owner_name_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'normalizedName',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _inzv38yi.ExampleSavesStatus) {
      return _inzv38yi.ExampleSavesStatus.fromJson(data) as T;
    }
    if (t == _is4ugn9t.AiOrganizeFutureCallProcessModel) {
      return _is4ugn9t.AiOrganizeFutureCallProcessModel.fromJson(data) as T;
    }
    if (t == _ij9va9aa.LinkPreviewFutureCallProcessModel) {
      return _ij9va9aa.LinkPreviewFutureCallProcessModel.fromJson(data) as T;
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
    if (t == _i6e75atc.CaptureReceipt) {
      return _i6e75atc.CaptureReceipt.fromJson(data) as T;
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
    if (t == _i4wj722g.CelebrationSeen) {
      return _i4wj722g.CelebrationSeen.fromJson(data) as T;
    }
    if (t == _ib4b75r3.CollectionProgress) {
      return _ib4b75r3.CollectionProgress.fromJson(data) as T;
    }
    if (t == _iz0l6k27.MilestoneKind) {
      return _iz0l6k27.MilestoneKind.fromJson(data) as T;
    }
    if (t == _iv86lxab.ProgressDay) {
      return _iv86lxab.ProgressDay.fromJson(data) as T;
    }
    if (t == _ism40znx.ProgressMilestone) {
      return _ism40znx.ProgressMilestone.fromJson(data) as T;
    }
    if (t == _ick5xr48.ProgressPeriod) {
      return _ick5xr48.ProgressPeriod.fromJson(data) as T;
    }
    if (t == _iox5xpz3.ProgressQuery) {
      return _iox5xpz3.ProgressQuery.fromJson(data) as T;
    }
    if (t == _i5135299.ProgressReport) {
      return _i5135299.ProgressReport.fromJson(data) as T;
    }
    if (t == _if1vui5d.ProgressSettings) {
      return _if1vui5d.ProgressSettings.fromJson(data) as T;
    }
    if (t == _i19ehhj8.ProgressSettingsDraft) {
      return _i19ehhj8.ProgressSettingsDraft.fromJson(data) as T;
    }
    if (t == _icoz9lvv.WeeklyGoalProgress) {
      return _icoz9lvv.WeeklyGoalProgress.fromJson(data) as T;
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
    if (t == _is.getType<_ieqt63qc.AiDailyUsage?>()) {
      return (data != null ? _ieqt63qc.AiDailyUsage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ike1rdmf.AiEvidenceCoverage?>()) {
      return (data != null ? _ike1rdmf.AiEvidenceCoverage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i3rayejx.AiOrganizeTask?>()) {
      return (data != null ? _i3rayejx.AiOrganizeTask.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irbaoatq.AiPreference?>()) {
      return (data != null ? _irbaoatq.AiPreference.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iuqfkn3x.AiProcessingState?>()) {
      return (data != null ? _iuqfkn3x.AiProcessingState.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8oswxfq.AiSettings?>()) {
      return (data != null ? _i8oswxfq.AiSettings.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ispfx06l.AiSuggestion?>()) {
      return (data != null ? _ispfx06l.AiSuggestion.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_il1lz8eg.AiSuggestionKind?>()) {
      return (data != null ? _il1lz8eg.AiSuggestionKind.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_it1ujq25.AiSuggestionStatus?>()) {
      return (data != null ? _it1ujq25.AiSuggestionStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iqtchur3.CalendarConnection?>()) {
      return (data != null ? _iqtchur3.CalendarConnection.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijwz5xp0.CalendarConnectionView?>()) {
      return (data != null
              ? _ijwz5xp0.CalendarConnectionView.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ily35bfr.CalendarEventLink?>()) {
      return (data != null ? _ily35bfr.CalendarEventLink.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ika1a9r5.CalendarPermission?>()) {
      return (data != null ? _ika1a9r5.CalendarPermission.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iq08ggdy.CalendarRoute?>()) {
      return (data != null ? _iq08ggdy.CalendarRoute.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igxvbit5.CalendarRouteException?>()) {
      return (data != null
              ? _igxvbit5.CalendarRouteException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i7yozl4b.CalendarRouteStatus?>()) {
      return (data != null
              ? _i7yozl4b.CalendarRouteStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i8v3said.CalendarSelection?>()) {
      return (data != null ? _i8v3said.CalendarSelection.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_intkkx3w.CalendarSelectionChoice?>()) {
      return (data != null
              ? _intkkx3w.CalendarSelectionChoice.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihue00wg.DeviceCalendarInfo?>()) {
      return (data != null ? _ihue00wg.DeviceCalendarInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i4awacjs.DeviceCalendarReport?>()) {
      return (data != null
              ? _i4awacjs.DeviceCalendarReport.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i1s71wt9.EventSyncState?>()) {
      return (data != null ? _i1s71wt9.EventSyncState.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iqfgge80.Collection?>()) {
      return (data != null ? _iqfgge80.Collection.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivby8odo.CollectionDraft?>()) {
      return (data != null ? _ivby8odo.CollectionDraft.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ingnmqw7.ItemCollection?>()) {
      return (data != null ? _ingnmqw7.ItemCollection.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izy6d885.AssignmentOrigin?>()) {
      return (data != null ? _izy6d885.AssignmentOrigin.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ilf890y8.RecordNotFoundException?>()) {
      return (data != null
              ? _ilf890y8.RecordNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ifwcmx8g.ValidationException?>()) {
      return (data != null
              ? _ifwcmx8g.ValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_inzv38yi.ExampleSavesStatus?>()) {
      return (data != null ? _inzv38yi.ExampleSavesStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_is4ugn9t.AiOrganizeFutureCallProcessModel?>()) {
      return (data != null
              ? _is4ugn9t.AiOrganizeFutureCallProcessModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ij9va9aa.LinkPreviewFutureCallProcessModel?>()) {
      return (data != null
              ? _ij9va9aa.LinkPreviewFutureCallProcessModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iozgwprg.ServerHealth?>()) {
      return (data != null ? _iozgwprg.ServerHealth.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imhj9b3j.AccessState?>()) {
      return (data != null ? _imhj9b3j.AccessState.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idav3wwe.CaptureDraft?>()) {
      return (data != null ? _idav3wwe.CaptureDraft.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6e75atc.CaptureReceipt?>()) {
      return (data != null ? _i6e75atc.CaptureReceipt.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_il5toi29.CaptureResult?>()) {
      return (data != null ? _il5toi29.CaptureResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itwlc5zp.ContentType?>()) {
      return (data != null ? _itwlc5zp.ContentType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_im2yqxlq.EnrichmentState?>()) {
      return (data != null ? _im2yqxlq.EnrichmentState.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iapziv9t.Item?>()) {
      return (data != null ? _iapziv9t.Item.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ip8cn60r.ItemDraft?>()) {
      return (data != null ? _ip8cn60r.ItemDraft.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iveh3zib.ItemLifecycle?>()) {
      return (data != null ? _iveh3zib.ItemLifecycle.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i072xpry.SourcePlatform?>()) {
      return (data != null ? _i072xpry.SourcePlatform.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_id2awq13.ApprovalMode?>()) {
      return (data != null ? _id2awq13.ApprovalMode.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1u9wvnf.AvailabilitySnapshot?>()) {
      return (data != null
              ? _i1u9wvnf.AvailabilitySnapshot.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_imvtil8c.BusyInterval?>()) {
      return (data != null ? _imvtil8c.BusyInterval.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iadysn2t.CalendarCoverage?>()) {
      return (data != null ? _iadysn2t.CalendarCoverage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i6oluk1v.CalendarWrite?>()) {
      return (data != null ? _i6oluk1v.CalendarWrite.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iyd6g2oi.CalendarWriteAction?>()) {
      return (data != null
              ? _iyd6g2oi.CalendarWriteAction.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i3u14n80.CalendarWriteOutcome?>()) {
      return (data != null
              ? _i3u14n80.CalendarWriteOutcome.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i5mmfzwl.CalendarWriteResult?>()) {
      return (data != null
              ? _i5mmfzwl.CalendarWriteResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_il89vgny.CoverageState?>()) {
      return (data != null ? _il89vgny.CoverageState.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ilaph13t.PlanCommitRequest?>()) {
      return (data != null ? _ilaph13t.PlanCommitRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixc6g37a.PlanCommitResult?>()) {
      return (data != null ? _ixc6g37a.PlanCommitResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ititmozf.PlanHorizon?>()) {
      return (data != null ? _ititmozf.PlanHorizon.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iv13hf9x.PlanProposal?>()) {
      return (data != null ? _iv13hf9x.PlanProposal.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idh5khlu.PlanRequest?>()) {
      return (data != null ? _idh5khlu.PlanRequest.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iw1c6zow.PlannerPreferences?>()) {
      return (data != null ? _iw1c6zow.PlannerPreferences.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i03liexf.PlannerPreferencesDraft?>()) {
      return (data != null
              ? _i03liexf.PlannerPreferencesDraft.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ityq5odj.PlanningErrorCode?>()) {
      return (data != null ? _ityq5odj.PlanningErrorCode.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iehth582.PlanningException?>()) {
      return (data != null ? _iehth582.PlanningException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_icv3lfjf.ReviewPlan?>()) {
      return (data != null ? _icv3lfjf.ReviewPlan.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_indyheef.ReviewSession?>()) {
      return (data != null ? _indyheef.ReviewSession.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_in0sx9zc.SessionChangeResult?>()) {
      return (data != null
              ? _in0sx9zc.SessionChangeResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i716ymk1.SessionItem?>()) {
      return (data != null ? _i716ymk1.SessionItem.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3pyieja.SessionItemView?>()) {
      return (data != null ? _i3pyieja.SessionItemView.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i91809id.SessionMoveRequest?>()) {
      return (data != null ? _i91809id.SessionMoveRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izbi9tiy.SessionStatus?>()) {
      return (data != null ? _izbi9tiy.SessionStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iyjcmdi4.SessionView?>()) {
      return (data != null ? _iyjcmdi4.SessionView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijguvy1g.PinneProfile?>()) {
      return (data != null ? _ijguvy1g.PinneProfile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ij8joe28.ProfileDraft?>()) {
      return (data != null ? _ij8joe28.ProfileDraft.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4wj722g.CelebrationSeen?>()) {
      return (data != null ? _i4wj722g.CelebrationSeen.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ib4b75r3.CollectionProgress?>()) {
      return (data != null ? _ib4b75r3.CollectionProgress.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iz0l6k27.MilestoneKind?>()) {
      return (data != null ? _iz0l6k27.MilestoneKind.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iv86lxab.ProgressDay?>()) {
      return (data != null ? _iv86lxab.ProgressDay.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ism40znx.ProgressMilestone?>()) {
      return (data != null ? _ism40znx.ProgressMilestone.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ick5xr48.ProgressPeriod?>()) {
      return (data != null ? _ick5xr48.ProgressPeriod.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iox5xpz3.ProgressQuery?>()) {
      return (data != null ? _iox5xpz3.ProgressQuery.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i5135299.ProgressReport?>()) {
      return (data != null ? _i5135299.ProgressReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_if1vui5d.ProgressSettings?>()) {
      return (data != null ? _if1vui5d.ProgressSettings.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i19ehhj8.ProgressSettingsDraft?>()) {
      return (data != null
              ? _i19ehhj8.ProgressSettingsDraft.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_icoz9lvv.WeeklyGoalProgress?>()) {
      return (data != null ? _icoz9lvv.WeeklyGoalProgress.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i6ljcdoh.ReminderRule?>()) {
      return (data != null ? _i6ljcdoh.ReminderRule.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0v594yd.ReminderSettings?>()) {
      return (data != null ? _i0v594yd.ReminderSettings.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2m53qgo.ReminderSettingsDraft?>()) {
      return (data != null
              ? _i2m53qgo.ReminderSettingsDraft.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iswi3gl6.ReminderWindow?>()) {
      return (data != null ? _iswi3gl6.ReminderWindow.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_isu905ko.ReviewDigest?>()) {
      return (data != null ? _isu905ko.ReviewDigest.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iv91gdem.ItemProgress?>()) {
      return (data != null ? _iv91gdem.ItemProgress.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_il1zbvt2.ItemReviewControl?>()) {
      return (data != null ? _il1zbvt2.ItemReviewControl.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i0pv2k4n.ReviewEvent?>()) {
      return (data != null ? _i0pv2k4n.ReviewEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4vpgh88.ReviewEventDraft?>()) {
      return (data != null ? _i4vpgh88.ReviewEventDraft.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i5hoegii.ReviewEventReceipt?>()) {
      return (data != null ? _i5hoegii.ReviewEventReceipt.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i5mz8id3.ReviewEventType?>()) {
      return (data != null ? _i5mz8id3.ReviewEventType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ia978e3v.ReviewQueueEntry?>()) {
      return (data != null ? _ia978e3v.ReviewQueueEntry.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igp65vp8.ReviewQueueResult?>()) {
      return (data != null ? _igp65vp8.ReviewQueueResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1podblr.ItemNote?>()) {
      return (data != null ? _i1podblr.ItemNote.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ive6le5b.ReviewStatusFilter?>()) {
      return (data != null ? _ive6le5b.ReviewStatusFilter.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igqcqr3d.SearchEvidence?>()) {
      return (data != null ? _igqcqr3d.SearchEvidence.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ic5aviky.SearchPage?>()) {
      return (data != null ? _ic5aviky.SearchPage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyyp88jv.SearchResult?>()) {
      return (data != null ? _iyyp88jv.SearchResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iv0vmssg.ItemTag?>()) {
      return (data != null ? _iv0vmssg.ItemTag.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iopagaq8.Tag?>()) {
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
    if (t == List<_is.UuidValue>) {
      return (data as List).map((e) => deserialize<_is.UuidValue>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<_is.UuidValue>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_is.UuidValue>(e))
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
    if (t == List<_iv86lxab.ProgressDay>) {
      return (data as List)
              .map((e) => deserialize<_iv86lxab.ProgressDay>(e))
              .toList()
          as T;
    }
    if (t == List<_ib4b75r3.CollectionProgress>) {
      return (data as List)
              .map((e) => deserialize<_ib4b75r3.CollectionProgress>(e))
              .toList()
          as T;
    }
    if (t == List<_ism40znx.ProgressMilestone>) {
      return (data as List)
              .map((e) => deserialize<_ism40znx.ProgressMilestone>(e))
              .toList()
          as T;
    }
    if (t == List<_iswi3gl6.ReminderWindow>) {
      return (data as List)
              .map((e) => deserialize<_iswi3gl6.ReminderWindow>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_iswi3gl6.ReminderWindow>?>()) {
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
    if (t == List<_i9k1kmrj.AiSuggestion>) {
      return (data as List)
              .map((e) => deserialize<_i9k1kmrj.AiSuggestion>(e))
              .toList()
          as T;
    }
    if (t == List<_ia8eyaw8.CalendarRouteStatus>) {
      return (data as List)
              .map((e) => deserialize<_ia8eyaw8.CalendarRouteStatus>(e))
              .toList()
          as T;
    }
    if (t == List<_i0xb4k4o.CalendarConnectionView>) {
      return (data as List)
              .map((e) => deserialize<_i0xb4k4o.CalendarConnectionView>(e))
              .toList()
          as T;
    }
    if (t == List<_i396ixoa.CalendarSelectionChoice>) {
      return (data as List)
              .map((e) => deserialize<_i396ixoa.CalendarSelectionChoice>(e))
              .toList()
          as T;
    }
    if (t == List<_is0jaro3.Collection>) {
      return (data as List)
              .map((e) => deserialize<_is0jaro3.Collection>(e))
              .toList()
          as T;
    }
    if (t == List<_id0tr7gx.Item>) {
      return (data as List).map((e) => deserialize<_id0tr7gx.Item>(e)).toList()
          as T;
    }
    if (t == List<_ie9b2ryt.SessionView>) {
      return (data as List)
              .map((e) => deserialize<_ie9b2ryt.SessionView>(e))
              .toList()
          as T;
    }
    if (t == List<_ijx3xba9.CalendarWrite>) {
      return (data as List)
              .map((e) => deserialize<_ijx3xba9.CalendarWrite>(e))
              .toList()
          as T;
    }
    if (t == List<_iaiz9j0d.CalendarWriteResult>) {
      return (data as List)
              .map((e) => deserialize<_iaiz9j0d.CalendarWriteResult>(e))
              .toList()
          as T;
    }
    if (t == List<_is.UuidValue>) {
      return (data as List).map((e) => deserialize<_is.UuidValue>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
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
      _inzv38yi.ExampleSavesStatus => 'ExampleSavesStatus',
      _is4ugn9t.AiOrganizeFutureCallProcessModel =>
        'AiOrganizeFutureCallProcessModel',
      _ij9va9aa.LinkPreviewFutureCallProcessModel =>
        'LinkPreviewFutureCallProcessModel',
      _iozgwprg.ServerHealth => 'ServerHealth',
      _imhj9b3j.AccessState => 'AccessState',
      _idav3wwe.CaptureDraft => 'CaptureDraft',
      _i6e75atc.CaptureReceipt => 'CaptureReceipt',
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
      _i4wj722g.CelebrationSeen => 'CelebrationSeen',
      _ib4b75r3.CollectionProgress => 'CollectionProgress',
      _iz0l6k27.MilestoneKind => 'MilestoneKind',
      _iv86lxab.ProgressDay => 'ProgressDay',
      _ism40znx.ProgressMilestone => 'ProgressMilestone',
      _ick5xr48.ProgressPeriod => 'ProgressPeriod',
      _iox5xpz3.ProgressQuery => 'ProgressQuery',
      _i5135299.ProgressReport => 'ProgressReport',
      _if1vui5d.ProgressSettings => 'ProgressSettings',
      _i19ehhj8.ProgressSettingsDraft => 'ProgressSettingsDraft',
      _icoz9lvv.WeeklyGoalProgress => 'WeeklyGoalProgress',
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
      case _inzv38yi.ExampleSavesStatus():
        return 'ExampleSavesStatus';
      case _is4ugn9t.AiOrganizeFutureCallProcessModel():
        return 'AiOrganizeFutureCallProcessModel';
      case _ij9va9aa.LinkPreviewFutureCallProcessModel():
        return 'LinkPreviewFutureCallProcessModel';
      case _iozgwprg.ServerHealth():
        return 'ServerHealth';
      case _imhj9b3j.AccessState():
        return 'AccessState';
      case _idav3wwe.CaptureDraft():
        return 'CaptureDraft';
      case _i6e75atc.CaptureReceipt():
        return 'CaptureReceipt';
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
      case _i4wj722g.CelebrationSeen():
        return 'CelebrationSeen';
      case _ib4b75r3.CollectionProgress():
        return 'CollectionProgress';
      case _iz0l6k27.MilestoneKind():
        return 'MilestoneKind';
      case _iv86lxab.ProgressDay():
        return 'ProgressDay';
      case _ism40znx.ProgressMilestone():
        return 'ProgressMilestone';
      case _ick5xr48.ProgressPeriod():
        return 'ProgressPeriod';
      case _iox5xpz3.ProgressQuery():
        return 'ProgressQuery';
      case _i5135299.ProgressReport():
        return 'ProgressReport';
      case _if1vui5d.ProgressSettings():
        return 'ProgressSettings';
      case _i19ehhj8.ProgressSettingsDraft():
        return 'ProgressSettingsDraft';
      case _icoz9lvv.WeeklyGoalProgress():
        return 'WeeklyGoalProgress';
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
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
    if (dataClassName == 'ExampleSavesStatus') {
      return deserialize<_inzv38yi.ExampleSavesStatus>(data['data']);
    }
    if (dataClassName == 'AiOrganizeFutureCallProcessModel') {
      return deserialize<_is4ugn9t.AiOrganizeFutureCallProcessModel>(
        data['data'],
      );
    }
    if (dataClassName == 'LinkPreviewFutureCallProcessModel') {
      return deserialize<_ij9va9aa.LinkPreviewFutureCallProcessModel>(
        data['data'],
      );
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
    if (dataClassName == 'CaptureReceipt') {
      return deserialize<_i6e75atc.CaptureReceipt>(data['data']);
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
    if (dataClassName == 'CelebrationSeen') {
      return deserialize<_i4wj722g.CelebrationSeen>(data['data']);
    }
    if (dataClassName == 'CollectionProgress') {
      return deserialize<_ib4b75r3.CollectionProgress>(data['data']);
    }
    if (dataClassName == 'MilestoneKind') {
      return deserialize<_iz0l6k27.MilestoneKind>(data['data']);
    }
    if (dataClassName == 'ProgressDay') {
      return deserialize<_iv86lxab.ProgressDay>(data['data']);
    }
    if (dataClassName == 'ProgressMilestone') {
      return deserialize<_ism40znx.ProgressMilestone>(data['data']);
    }
    if (dataClassName == 'ProgressPeriod') {
      return deserialize<_ick5xr48.ProgressPeriod>(data['data']);
    }
    if (dataClassName == 'ProgressQuery') {
      return deserialize<_iox5xpz3.ProgressQuery>(data['data']);
    }
    if (dataClassName == 'ProgressReport') {
      return deserialize<_i5135299.ProgressReport>(data['data']);
    }
    if (dataClassName == 'ProgressSettings') {
      return deserialize<_if1vui5d.ProgressSettings>(data['data']);
    }
    if (dataClassName == 'ProgressSettingsDraft') {
      return deserialize<_i19ehhj8.ProgressSettingsDraft>(data['data']);
    }
    if (dataClassName == 'WeeklyGoalProgress') {
      return deserialize<_icoz9lvv.WeeklyGoalProgress>(data['data']);
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
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('pinne', this);
    _iacs.Protocol().registerHostProtocol('pinne', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ieqt63qc.AiDailyUsage:
        return _ieqt63qc.AiDailyUsage.t;
      case _i3rayejx.AiOrganizeTask:
        return _i3rayejx.AiOrganizeTask.t;
      case _irbaoatq.AiPreference:
        return _irbaoatq.AiPreference.t;
      case _ispfx06l.AiSuggestion:
        return _ispfx06l.AiSuggestion.t;
      case _iqtchur3.CalendarConnection:
        return _iqtchur3.CalendarConnection.t;
      case _ily35bfr.CalendarEventLink:
        return _ily35bfr.CalendarEventLink.t;
      case _i8v3said.CalendarSelection:
        return _i8v3said.CalendarSelection.t;
      case _iqfgge80.Collection:
        return _iqfgge80.Collection.t;
      case _ingnmqw7.ItemCollection:
        return _ingnmqw7.ItemCollection.t;
      case _i6e75atc.CaptureReceipt:
        return _i6e75atc.CaptureReceipt.t;
      case _iapziv9t.Item:
        return _iapziv9t.Item.t;
      case _iw1c6zow.PlannerPreferences:
        return _iw1c6zow.PlannerPreferences.t;
      case _icv3lfjf.ReviewPlan:
        return _icv3lfjf.ReviewPlan.t;
      case _indyheef.ReviewSession:
        return _indyheef.ReviewSession.t;
      case _i716ymk1.SessionItem:
        return _i716ymk1.SessionItem.t;
      case _ijguvy1g.PinneProfile:
        return _ijguvy1g.PinneProfile.t;
      case _i4wj722g.CelebrationSeen:
        return _i4wj722g.CelebrationSeen.t;
      case _if1vui5d.ProgressSettings:
        return _if1vui5d.ProgressSettings.t;
      case _i6ljcdoh.ReminderRule:
        return _i6ljcdoh.ReminderRule.t;
      case _i0v594yd.ReminderSettings:
        return _i0v594yd.ReminderSettings.t;
      case _isu905ko.ReviewDigest:
        return _isu905ko.ReviewDigest.t;
      case _iv91gdem.ItemProgress:
        return _iv91gdem.ItemProgress.t;
      case _il1zbvt2.ItemReviewControl:
        return _il1zbvt2.ItemReviewControl.t;
      case _i0pv2k4n.ReviewEvent:
        return _i0pv2k4n.ReviewEvent.t;
      case _i1podblr.ItemNote:
        return _i1podblr.ItemNote.t;
      case _iv0vmssg.ItemTag:
        return _iv0vmssg.ItemTag.t;
      case _iopagaq8.Tag:
        return _iopagaq8.Tag.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
