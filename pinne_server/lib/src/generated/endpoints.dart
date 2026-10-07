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
import 'package:pinne_server/src/generated/calendar/calendar_selection_choice.dart'
    as _i396ixoa;
import 'package:pinne_server/src/generated/calendar/device_calendar_report.dart'
    as _ixwdetx3;
import 'package:pinne_server/src/generated/collections/collection.dart'
    as _is0jaro3;
import 'package:pinne_server/src/generated/collections/collection_draft.dart'
    as _imy5wtcu;
import 'package:pinne_server/src/generated/future_calls.dart' as _ifh9pad3;
import 'package:pinne_server/src/generated/items/capture_draft.dart'
    as _iushcgme;
import 'package:pinne_server/src/generated/items/content_type.dart'
    as _iyxjktn1;
import 'package:pinne_server/src/generated/items/item.dart' as _id0tr7gx;
import 'package:pinne_server/src/generated/items/item_draft.dart' as _ittgmzop;
import 'package:pinne_server/src/generated/items/source_platform.dart'
    as _i72i2l8c;
import 'package:pinne_server/src/generated/planning/calendar_write_result.dart'
    as _iaiz9j0d;
import 'package:pinne_server/src/generated/planning/plan_commit_request.dart'
    as _icuwwueq;
import 'package:pinne_server/src/generated/planning/plan_request.dart'
    as _i6zrjude;
import 'package:pinne_server/src/generated/planning/planner_preferences_draft.dart'
    as _iq9m58hd;
import 'package:pinne_server/src/generated/planning/session_move_request.dart'
    as _ijei0lg9;
import 'package:pinne_server/src/generated/profile/profile_draft.dart'
    as _i2c58fcj;
import 'package:pinne_server/src/generated/reminders/reminder_settings_draft.dart'
    as _if8nlr1i;
import 'package:pinne_server/src/generated/reviews/review_event_draft.dart'
    as _ikmeff8s;
import 'package:pinne_server/src/generated/search/review_status_filter.dart'
    as _i7xfwskj;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../ai/ai_organizing_endpoint.dart' as _icvqao4l;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/google_idp_endpoint.dart' as _i71axiz0;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../calendar/calendar_endpoint.dart' as _i7b5ov6a;
import '../collections/collection_endpoint.dart' as _i5j0184s;
import '../health/health_endpoint.dart' as _id9paj9q;
import '../items/item_endpoint.dart' as _i97sinw1;
import '../planning/planner_endpoint.dart' as _icn41d99;
import '../profile/profile_endpoint.dart' as _i6ky944g;
import '../reviews/review_endpoint.dart' as _i1vkl601;
import '../reviews/review_queue_endpoint.dart' as _il9fx142;
import '../search/search_endpoint.dart' as _i2f0v2ey;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'aiOrganizing': _icvqao4l.AiOrganizingEndpoint()
        ..initialize(
          server,
          'aiOrganizing',
          null,
        ),
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'googleIdp': _i71axiz0.GoogleIdpEndpoint()
        ..initialize(
          server,
          'googleIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'calendar': _i7b5ov6a.CalendarEndpoint()
        ..initialize(
          server,
          'calendar',
          null,
        ),
      'collection': _i5j0184s.CollectionEndpoint()
        ..initialize(
          server,
          'collection',
          null,
        ),
      'health': _id9paj9q.HealthEndpoint()
        ..initialize(
          server,
          'health',
          null,
        ),
      'item': _i97sinw1.ItemEndpoint()
        ..initialize(
          server,
          'item',
          null,
        ),
      'planner': _icn41d99.PlannerEndpoint()
        ..initialize(
          server,
          'planner',
          null,
        ),
      'profile': _i6ky944g.ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
      'review': _i1vkl601.ReviewEndpoint()
        ..initialize(
          server,
          'review',
          null,
        ),
      'reviewQueue': _il9fx142.ReviewQueueEndpoint()
        ..initialize(
          server,
          'reviewQueue',
          null,
        ),
      'search': _i2f0v2ey.SearchEndpoint()
        ..initialize(
          server,
          'search',
          null,
        ),
    };
    connectors['aiOrganizing'] = _is.EndpointConnector(
      name: 'aiOrganizing',
      endpoint: endpoints['aiOrganizing']!,
      methodConnectors: {
        'getSettings': _is.MethodConnector(
          name: 'getSettings',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['aiOrganizing'] as _icvqao4l.AiOrganizingEndpoint)
                      .getSettings(session),
        ),
        'setEnabled': _is.MethodConnector(
          name: 'setEnabled',
          params: {
            'enabled': _is.ParameterDescription(
              name: 'enabled',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['aiOrganizing'] as _icvqao4l.AiOrganizingEndpoint)
                      .setEnabled(
                        session,
                        params['enabled'],
                      ),
        ),
        'listSuggestions': _is.MethodConnector(
          name: 'listSuggestions',
          params: {
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['aiOrganizing'] as _icvqao4l.AiOrganizingEndpoint)
                      .listSuggestions(
                        session,
                        params['itemId'],
                      ),
        ),
        'reprocess': _is.MethodConnector(
          name: 'reprocess',
          params: {
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['aiOrganizing'] as _icvqao4l.AiOrganizingEndpoint)
                      .reprocess(
                        session,
                        params['itemId'],
                      ),
        ),
        'accept': _is.MethodConnector(
          name: 'accept',
          params: {
            'suggestionId': _is.ParameterDescription(
              name: 'suggestionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['aiOrganizing'] as _icvqao4l.AiOrganizingEndpoint)
                      .accept(
                        session,
                        params['suggestionId'],
                      ),
        ),
        'reject': _is.MethodConnector(
          name: 'reject',
          params: {
            'suggestionId': _is.ParameterDescription(
              name: 'suggestionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['aiOrganizing'] as _icvqao4l.AiOrganizingEndpoint)
                      .reject(
                        session,
                        params['suggestionId'],
                      ),
        ),
      },
    );
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['googleIdp'] = _is.EndpointConnector(
      name: 'googleIdp',
      endpoint: endpoints['googleIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'idToken': _is.ParameterDescription(
              name: 'idToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'accessToken': _is.ParameterDescription(
              name: 'accessToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleIdp'] as _i71axiz0.GoogleIdpEndpoint).login(
                    session,
                    idToken: params['idToken'],
                    accessToken: params['accessToken'],
                  ),
        ),
        'loginWithCode': _is.MethodConnector(
          name: 'loginWithCode',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'codeVerifier': _is.ParameterDescription(
              name: 'codeVerifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'redirectUri': _is.ParameterDescription(
              name: 'redirectUri',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['googleIdp'] as _i71axiz0.GoogleIdpEndpoint)
                  .loginWithCode(
                    session,
                    code: params['code'],
                    codeVerifier: params['codeVerifier'],
                    redirectUri: params['redirectUri'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['googleIdp'] as _i71axiz0.GoogleIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['calendar'] = _is.EndpointConnector(
      name: 'calendar',
      endpoint: endpoints['calendar']!,
      methodConnectors: {
        'routes': _is.MethodConnector(
          name: 'routes',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i7b5ov6a.CalendarEndpoint)
                  .routes(session),
        ),
        'authorizeGoogle': _is.MethodConnector(
          name: 'authorizeGoogle',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i7b5ov6a.CalendarEndpoint)
                  .authorizeGoogle(session),
        ),
        'connections': _is.MethodConnector(
          name: 'connections',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i7b5ov6a.CalendarEndpoint)
                  .connections(session),
        ),
        'syncDeviceCalendars': _is.MethodConnector(
          name: 'syncDeviceCalendars',
          params: {
            'report': _is.ParameterDescription(
              name: 'report',
              type: _is.getType<_ixwdetx3.DeviceCalendarReport>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i7b5ov6a.CalendarEndpoint)
                  .syncDeviceCalendars(
                    session,
                    params['report'],
                  ),
        ),
        'setSelections': _is.MethodConnector(
          name: 'setSelections',
          params: {
            'connectionId': _is.ParameterDescription(
              name: 'connectionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'choices': _is.ParameterDescription(
              name: 'choices',
              type: _is.getType<List<_i396ixoa.CalendarSelectionChoice>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i7b5ov6a.CalendarEndpoint)
                  .setSelections(
                    session,
                    params['connectionId'],
                    params['choices'],
                  ),
        ),
        'disconnect': _is.MethodConnector(
          name: 'disconnect',
          params: {
            'connectionId': _is.ParameterDescription(
              name: 'connectionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i7b5ov6a.CalendarEndpoint)
                  .disconnect(
                    session,
                    params['connectionId'],
                  ),
        ),
      },
    );
    connectors['collection'] = _is.EndpointConnector(
      name: 'collection',
      endpoint: endpoints['collection']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['collection'] as _i5j0184s.CollectionEndpoint)
                      .list(session),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['collection'] as _i5j0184s.CollectionEndpoint).get(
                    session,
                    params['id'],
                  ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'draft': _is.ParameterDescription(
              name: 'draft',
              type: _is.getType<_imy5wtcu.CollectionDraft>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['collection'] as _i5j0184s.CollectionEndpoint)
                      .create(
                        session,
                        params['draft'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'collection': _is.ParameterDescription(
              name: 'collection',
              type: _is.getType<_is0jaro3.Collection>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['collection'] as _i5j0184s.CollectionEndpoint)
                      .update(
                        session,
                        params['collection'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['collection'] as _i5j0184s.CollectionEndpoint)
                      .delete(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['health'] = _is.EndpointConnector(
      name: 'health',
      endpoint: endpoints['health']!,
      methodConnectors: {
        'check': _is.MethodConnector(
          name: 'check',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['health'] as _id9paj9q.HealthEndpoint)
                  .check(session),
        ),
      },
    );
    connectors['item'] = _is.EndpointConnector(
      name: 'item',
      endpoint: endpoints['item']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'before': _is.ParameterDescription(
              name: 'before',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['item'] as _i97sinw1.ItemEndpoint).list(
                session,
                limit: params['limit'],
                before: params['before'],
              ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['item'] as _i97sinw1.ItemEndpoint).get(
                session,
                params['id'],
              ),
        ),
        'capture': _is.MethodConnector(
          name: 'capture',
          params: {
            'draft': _is.ParameterDescription(
              name: 'draft',
              type: _is.getType<_iushcgme.CaptureDraft>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['item'] as _i97sinw1.ItemEndpoint).capture(
                session,
                params['draft'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'draft': _is.ParameterDescription(
              name: 'draft',
              type: _is.getType<_ittgmzop.ItemDraft>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['item'] as _i97sinw1.ItemEndpoint).create(
                session,
                params['draft'],
              ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'item': _is.ParameterDescription(
              name: 'item',
              type: _is.getType<_id0tr7gx.Item>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['item'] as _i97sinw1.ItemEndpoint).update(
                session,
                params['item'],
              ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['item'] as _i97sinw1.ItemEndpoint).delete(
                session,
                params['id'],
              ),
        ),
      },
    );
    connectors['planner'] = _is.EndpointConnector(
      name: 'planner',
      endpoint: endpoints['planner']!,
      methodConnectors: {
        'preferences': _is.MethodConnector(
          name: 'preferences',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['planner'] as _icn41d99.PlannerEndpoint)
                  .preferences(session),
        ),
        'savePreferences': _is.MethodConnector(
          name: 'savePreferences',
          params: {
            'draft': _is.ParameterDescription(
              name: 'draft',
              type: _is.getType<_iq9m58hd.PlannerPreferencesDraft>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['planner'] as _icn41d99.PlannerEndpoint)
                  .savePreferences(
                    session,
                    params['draft'],
                  ),
        ),
        'propose': _is.MethodConnector(
          name: 'propose',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i6zrjude.PlanRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['planner'] as _icn41d99.PlannerEndpoint).propose(
                    session,
                    params['request'],
                  ),
        ),
        'currentProposal': _is.MethodConnector(
          name: 'currentProposal',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['planner'] as _icn41d99.PlannerEndpoint)
                  .currentProposal(session),
        ),
        'commit': _is.MethodConnector(
          name: 'commit',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_icuwwueq.PlanCommitRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['planner'] as _icn41d99.PlannerEndpoint).commit(
                    session,
                    params['request'],
                  ),
        ),
        'sessions': _is.MethodConnector(
          name: 'sessions',
          params: {
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['planner'] as _icn41d99.PlannerEndpoint).sessions(
                    session,
                    params['from'],
                    params['to'],
                  ),
        ),
        'moveSession': _is.MethodConnector(
          name: 'moveSession',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_ijei0lg9.SessionMoveRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['planner'] as _icn41d99.PlannerEndpoint)
                  .moveSession(
                    session,
                    params['request'],
                  ),
        ),
        'cancelSession': _is.MethodConnector(
          name: 'cancelSession',
          params: {
            'sessionId': _is.ParameterDescription(
              name: 'sessionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'operationId': _is.ParameterDescription(
              name: 'operationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['planner'] as _icn41d99.PlannerEndpoint)
                  .cancelSession(
                    session,
                    params['sessionId'],
                    params['operationId'],
                    params['deviceId'],
                  ),
        ),
        'deviceWork': _is.MethodConnector(
          name: 'deviceWork',
          params: {
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['planner'] as _icn41d99.PlannerEndpoint)
                  .deviceWork(
                    session,
                    params['deviceId'],
                  ),
        ),
        'reportWrites': _is.MethodConnector(
          name: 'reportWrites',
          params: {
            'results': _is.ParameterDescription(
              name: 'results',
              type: _is.getType<List<_iaiz9j0d.CalendarWriteResult>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['planner'] as _icn41d99.PlannerEndpoint)
                  .reportWrites(
                    session,
                    params['results'],
                  ),
        ),
        'exportIcs': _is.MethodConnector(
          name: 'exportIcs',
          params: {
            'sessionIds': _is.ParameterDescription(
              name: 'sessionIds',
              type: _is.getType<List<_is.UuidValue>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['planner'] as _icn41d99.PlannerEndpoint).exportIcs(
                    session,
                    params['sessionIds'],
                  ),
        ),
      },
    );
    connectors['profile'] = _is.EndpointConnector(
      name: 'profile',
      endpoint: endpoints['profile']!,
      methodConnectors: {
        'get': _is.MethodConnector(
          name: 'get',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i6ky944g.ProfileEndpoint)
                  .get(session),
        ),
        'upsert': _is.MethodConnector(
          name: 'upsert',
          params: {
            'draft': _is.ParameterDescription(
              name: 'draft',
              type: _is.getType<_i2c58fcj.ProfileDraft>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profile'] as _i6ky944g.ProfileEndpoint).upsert(
                    session,
                    params['draft'],
                  ),
        ),
      },
    );
    connectors['review'] = _is.EndpointConnector(
      name: 'review',
      endpoint: endpoints['review']!,
      methodConnectors: {
        'record': _is.MethodConnector(
          name: 'record',
          params: {
            'draft': _is.ParameterDescription(
              name: 'draft',
              type: _is.getType<_ikmeff8s.ReviewEventDraft>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['review'] as _i1vkl601.ReviewEndpoint).record(
                    session,
                    params['draft'],
                  ),
        ),
        'progress': _is.MethodConnector(
          name: 'progress',
          params: {
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['review'] as _i1vkl601.ReviewEndpoint).progress(
                    session,
                    params['itemId'],
                  ),
        ),
      },
    );
    connectors['reviewQueue'] = _is.EndpointConnector(
      name: 'reviewQueue',
      endpoint: endpoints['reviewQueue']!,
      methodConnectors: {
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'timeBudgetMinutes': _is.ParameterDescription(
              name: 'timeBudgetMinutes',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reviewQueue'] as _il9fx142.ReviewQueueEndpoint)
                      .get(
                        session,
                        timeBudgetMinutes: params['timeBudgetMinutes'],
                      ),
        ),
        'snooze': _is.MethodConnector(
          name: 'snooze',
          params: {
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'until': _is.ParameterDescription(
              name: 'until',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reviewQueue'] as _il9fx142.ReviewQueueEndpoint)
                      .snooze(
                        session,
                        params['itemId'],
                        params['until'],
                      ),
        ),
        'pause': _is.MethodConnector(
          name: 'pause',
          params: {
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'paused': _is.ParameterDescription(
              name: 'paused',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reviewQueue'] as _il9fx142.ReviewQueueEndpoint)
                      .pause(
                        session,
                        params['itemId'],
                        params['paused'],
                      ),
        ),
        'archive': _is.MethodConnector(
          name: 'archive',
          params: {
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reviewQueue'] as _il9fx142.ReviewQueueEndpoint)
                      .archive(
                        session,
                        params['itemId'],
                      ),
        ),
        'settings': _is.MethodConnector(
          name: 'settings',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reviewQueue'] as _il9fx142.ReviewQueueEndpoint)
                      .settings(session),
        ),
        'updateSettings': _is.MethodConnector(
          name: 'updateSettings',
          params: {
            'draft': _is.ParameterDescription(
              name: 'draft',
              type: _is.getType<_if8nlr1i.ReminderSettingsDraft>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reviewQueue'] as _il9fx142.ReviewQueueEndpoint)
                      .updateSettings(
                        session,
                        params['draft'],
                      ),
        ),
      },
    );
    connectors['search'] = _is.EndpointConnector(
      name: 'search',
      endpoint: endpoints['search']!,
      methodConnectors: {
        'keyword': _is.MethodConnector(
          name: 'keyword',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<_i72i2l8c.SourcePlatform?>(),
              nullable: true,
            ),
            'contentType': _is.ParameterDescription(
              name: 'contentType',
              type: _is.getType<_iyxjktn1.ContentType?>(),
              nullable: true,
            ),
            'collectionId': _is.ParameterDescription(
              name: 'collectionId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'reviewStatus': _is.ParameterDescription(
              name: 'reviewStatus',
              type: _is.getType<_i7xfwskj.ReviewStatusFilter?>(),
              nullable: true,
            ),
            'cursor': _is.ParameterDescription(
              name: 'cursor',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['search'] as _i2f0v2ey.SearchEndpoint).keyword(
                    session,
                    query: params['query'],
                    source: params['source'],
                    contentType: params['contentType'],
                    collectionId: params['collectionId'],
                    reviewStatus: params['reviewStatus'],
                    cursor: params['cursor'],
                    limit: params['limit'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _ifh9pad3.FutureCalls();
  }
}
