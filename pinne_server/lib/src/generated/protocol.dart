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
import 'package:pinne_server/src/generated/collections/collection.dart'
    as _is0jaro3;
import 'package:pinne_server/src/generated/items/item.dart' as _id0tr7gx;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'collections/collection.dart' as _iqfgge80;
import 'collections/collection_draft.dart' as _ivby8odo;
import 'collections/item_collection.dart' as _ingnmqw7;
import 'common/assignment_origin.dart' as _izy6d885;
import 'common/record_not_found_exception.dart' as _ilf890y8;
import 'common/validation_exception.dart' as _ifwcmx8g;
import 'health/server_health.dart' as _iozgwprg;
import 'items/content_type.dart' as _itwlc5zp;
import 'items/item.dart' as _iapziv9t;
import 'items/item_draft.dart' as _ip8cn60r;
import 'items/item_lifecycle.dart' as _iveh3zib;
import 'items/source_platform.dart' as _i072xpry;
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
export 'items/content_type.dart';
export 'items/item.dart';
export 'items/item_draft.dart';
export 'items/item_lifecycle.dart';
export 'items/source_platform.dart';
export 'reminders/reminder_rule.dart';
export 'reminders/reminder_window.dart';
export 'reviews/review_event.dart';
export 'reviews/review_event_type.dart';
export 'tags/item_tag.dart';
export 'tags/tag.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
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
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
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
          isUnique: false,
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
    if (t == _itwlc5zp.ContentType) {
      return _itwlc5zp.ContentType.fromJson(data) as T;
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
    if (t == _is.getType<_iozgwprg.ServerHealth?>()) {
      return (data != null ? _iozgwprg.ServerHealth.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_itwlc5zp.ContentType?>()) {
      return (data != null ? _itwlc5zp.ContentType.fromJson(data) : null) as T;
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
    if (t == _is.getType<_i6ljcdoh.ReminderRule?>()) {
      return (data != null ? _i6ljcdoh.ReminderRule.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iswi3gl6.ReminderWindow?>()) {
      return (data != null ? _iswi3gl6.ReminderWindow.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i0pv2k4n.ReviewEvent?>()) {
      return (data != null ? _i0pv2k4n.ReviewEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5mz8id3.ReviewEventType?>()) {
      return (data != null ? _i5mz8id3.ReviewEventType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iv0vmssg.ItemTag?>()) {
      return (data != null ? _iv0vmssg.ItemTag.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iopagaq8.Tag?>()) {
      return (data != null ? _iopagaq8.Tag.fromJson(data) : null) as T;
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
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
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
      _iqfgge80.Collection => 'Collection',
      _ivby8odo.CollectionDraft => 'CollectionDraft',
      _ingnmqw7.ItemCollection => 'ItemCollection',
      _izy6d885.AssignmentOrigin => 'AssignmentOrigin',
      _ilf890y8.RecordNotFoundException => 'RecordNotFoundException',
      _ifwcmx8g.ValidationException => 'ValidationException',
      _iozgwprg.ServerHealth => 'ServerHealth',
      _itwlc5zp.ContentType => 'ContentType',
      _iapziv9t.Item => 'Item',
      _ip8cn60r.ItemDraft => 'ItemDraft',
      _iveh3zib.ItemLifecycle => 'ItemLifecycle',
      _i072xpry.SourcePlatform => 'SourcePlatform',
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
      case _itwlc5zp.ContentType():
        return 'ContentType';
      case _iapziv9t.Item():
        return 'Item';
      case _ip8cn60r.ItemDraft():
        return 'ItemDraft';
      case _iveh3zib.ItemLifecycle():
        return 'ItemLifecycle';
      case _i072xpry.SourcePlatform():
        return 'SourcePlatform';
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
    if (dataClassName == 'ContentType') {
      return deserialize<_itwlc5zp.ContentType>(data['data']);
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
      case _iqfgge80.Collection:
        return _iqfgge80.Collection.t;
      case _ingnmqw7.ItemCollection:
        return _ingnmqw7.ItemCollection.t;
      case _iapziv9t.Item:
        return _iapziv9t.Item.t;
      case _i6ljcdoh.ReminderRule:
        return _i6ljcdoh.ReminderRule.t;
      case _i0pv2k4n.ReviewEvent:
        return _i0pv2k4n.ReviewEvent.t;
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
