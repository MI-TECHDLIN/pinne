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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:pinne_client/src/protocol/calendar/calendar_connection_view.dart'
    as _i0t8t4zu;
import 'package:pinne_client/src/protocol/calendar/calendar_route_status.dart'
    as _ig4e8y15;
import 'package:pinne_client/src/protocol/calendar/calendar_selection_choice.dart'
    as _im02fgk3;
import 'package:pinne_client/src/protocol/calendar/device_calendar_report.dart'
    as _icb9y8st;
import 'package:pinne_client/src/protocol/collections/collection.dart'
    as _i9zrdvr8;
import 'package:pinne_client/src/protocol/collections/collection_draft.dart'
    as _iqvt7ot6;
import 'package:pinne_client/src/protocol/health/server_health.dart'
    as _ibqesezf;
import 'package:pinne_client/src/protocol/items/capture_draft.dart'
    as _ium6vjfl;
import 'package:pinne_client/src/protocol/items/capture_result.dart'
    as _ibc30ndw;
import 'package:pinne_client/src/protocol/items/item.dart' as _itiiwgx0;
import 'package:pinne_client/src/protocol/items/item_draft.dart' as _ixoujeet;
import 'package:pinne_client/src/protocol/planning/calendar_write.dart'
    as _i4bu6rte;
import 'package:pinne_client/src/protocol/planning/calendar_write_result.dart'
    as _ivswpuyg;
import 'package:pinne_client/src/protocol/planning/plan_commit_request.dart'
    as _imjid542;
import 'package:pinne_client/src/protocol/planning/plan_commit_result.dart'
    as _ijkqk6e6;
import 'package:pinne_client/src/protocol/planning/plan_proposal.dart'
    as _i2np8a84;
import 'package:pinne_client/src/protocol/planning/plan_request.dart'
    as _iztxi4r1;
import 'package:pinne_client/src/protocol/planning/planner_preferences.dart'
    as _i47tswj4;
import 'package:pinne_client/src/protocol/planning/planner_preferences_draft.dart'
    as _isn8u3xd;
import 'package:pinne_client/src/protocol/planning/session_change_result.dart'
    as _ia2d415f;
import 'package:pinne_client/src/protocol/planning/session_move_request.dart'
    as _ildvggxs;
import 'package:pinne_client/src/protocol/planning/session_view.dart'
    as _i2af9p8a;
import 'package:pinne_client/src/protocol/profile/pinne_profile.dart'
    as _i1myizpd;
import 'package:pinne_client/src/protocol/profile/profile_draft.dart'
    as _iyve154t;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// Exposes Google sign-in. It only works once `googleClientSecret` is set in
/// `config/passwords.yaml`; see `config/passwords.yaml.example`.
/// {@category Endpoint}
class EndpointGoogleIdp extends _iaic.EndpointGoogleIdpBase {
  EndpointGoogleIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleIdp';

  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'googleIdp',
    'login',
    {
      'idToken': idToken,
      'accessToken': accessToken,
    },
  );

  /// Validates a Google authorization code from the web OAuth2 PKCE flow and
  /// either logs in the associated user or creates a new account.
  ///
  /// This is the web counterpart of [login], which accepts an ID token directly
  /// (used on native platforms via the `google_sign_in` package).
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _ida.Future<_iacc.AuthSuccess> loginWithCode({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'googleIdp',
    'loginWithCode',
    {
      'code': code,
      'codeVerifier': codeVerifier,
      'redirectUri': redirectUri,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'googleIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Calendar routes, connections and the owner's choice of conflict and write
/// calendars. Device calendars are read and written on the phone; the server
/// keeps only which calendars to use and when they were last read.
/// {@category Endpoint}
class EndpointCalendar extends _isc.EndpointRef {
  EndpointCalendar(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'calendar';

  /// Every route and what it can do on this server right now.
  _ida.Future<List<_ig4e8y15.CalendarRouteStatus>> routes() =>
      caller.callServerEndpoint<List<_ig4e8y15.CalendarRouteStatus>>(
        'calendar',
        'routes',
        {},
      );

  /// Starts the Google Calendar consent flow. Refused with a structured
  /// error until the route is configured and built.
  _ida.Future<void> authorizeGoogle() => caller.callServerEndpoint<void>(
    'calendar',
    'authorizeGoogle',
    {},
  );

  _ida.Future<List<_i0t8t4zu.CalendarConnectionView>> connections() =>
      caller.callServerEndpoint<List<_i0t8t4zu.CalendarConnectionView>>(
        'calendar',
        'connections',
        {},
      );

  /// Records what a device can see: its permission and calendars. Existing
  /// choices are kept; new calendars are checked for conflicts by default,
  /// because checking more calendars can only avoid clashes. No calendar is
  /// chosen for writing until the owner picks one.
  _ida.Future<_i0t8t4zu.CalendarConnectionView> syncDeviceCalendars(
    _icb9y8st.DeviceCalendarReport report,
  ) => caller.callServerEndpoint<_i0t8t4zu.CalendarConnectionView>(
    'calendar',
    'syncDeviceCalendars',
    {'report': report},
  );

  /// Applies the owner's choices for a connection's calendars. At most one
  /// calendar of the owner takes writes; choosing one clears the others.
  _ida.Future<List<_i0t8t4zu.CalendarConnectionView>> setSelections(
    _isc.UuidValue connectionId,
    List<_im02fgk3.CalendarSelectionChoice> choices,
  ) => caller.callServerEndpoint<List<_i0t8t4zu.CalendarConnectionView>>(
    'calendar',
    'setSelections',
    {
      'connectionId': connectionId,
      'choices': choices,
    },
  );

  /// Stops using a connection. Sessions already scheduled stay in Pinne and
  /// events already written stay in the calendar; nothing is deleted there.
  _ida.Future<bool> disconnect(_isc.UuidValue connectionId) =>
      caller.callServerEndpoint<bool>(
        'calendar',
        'disconnect',
        {'connectionId': connectionId},
      );
}

/// Owner-scoped CRUD for collections. A parent must belong to the same owner
/// and must not make the tree cyclic.
/// {@category Endpoint}
class EndpointCollection extends _isc.EndpointRef {
  EndpointCollection(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'collection';

  _ida.Future<List<_i9zrdvr8.Collection>> list() =>
      caller.callServerEndpoint<List<_i9zrdvr8.Collection>>(
        'collection',
        'list',
        {},
      );

  _ida.Future<_i9zrdvr8.Collection?> get(_isc.UuidValue id) =>
      caller.callServerEndpoint<_i9zrdvr8.Collection?>(
        'collection',
        'get',
        {'id': id},
      );

  _ida.Future<_i9zrdvr8.Collection> create(_iqvt7ot6.CollectionDraft draft) =>
      caller.callServerEndpoint<_i9zrdvr8.Collection>(
        'collection',
        'create',
        {'draft': draft},
      );

  _ida.Future<_i9zrdvr8.Collection> update(_i9zrdvr8.Collection collection) =>
      caller.callServerEndpoint<_i9zrdvr8.Collection>(
        'collection',
        'update',
        {'collection': collection},
      );

  _ida.Future<bool> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<bool>(
        'collection',
        'delete',
        {'id': id},
      );
}

/// Public liveness check that the app can call before sign-in.
/// {@category Endpoint}
class EndpointHealth extends _isc.EndpointRef {
  EndpointHealth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'health';

  _ida.Future<_ibqesezf.ServerHealth> check() =>
      caller.callServerEndpoint<_ibqesezf.ServerHealth>(
        'health',
        'check',
        {},
      );
}

/// Owner-scoped CRUD for saved items. Every query filters on the signed-in
/// owner, so another user's ids behave exactly like missing ids.
///
/// Enrichment and search are later features.
/// {@category Endpoint}
class EndpointItem extends _isc.EndpointRef {
  EndpointItem(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'item';

  /// Newest first. [before] is the `savedAt` of the last item on the previous
  /// page.
  _ida.Future<List<_itiiwgx0.Item>> list({
    int? limit,
    DateTime? before,
  }) => caller.callServerEndpoint<List<_itiiwgx0.Item>>(
    'item',
    'list',
    {
      'limit': limit,
      'before': before,
    },
  );

  _ida.Future<_itiiwgx0.Item?> get(_isc.UuidValue id) =>
      caller.callServerEndpoint<_itiiwgx0.Item?>(
        'item',
        'get',
        {'id': id},
      );

  /// Saves a shared or pasted link or note. Safe to retry with the same
  /// operation id. A recognised duplicate returns the existing item with
  /// `duplicate` set; its notes, collections and first `savedAt` are kept.
  /// The answer never waits for enrichment, which starts as `pending`.
  _ida.Future<_ibc30ndw.CaptureResult> capture(_ium6vjfl.CaptureDraft draft) =>
      caller.callServerEndpoint<_ibc30ndw.CaptureResult>(
        'item',
        'capture',
        {'draft': draft},
      );

  _ida.Future<_itiiwgx0.Item> create(_ixoujeet.ItemDraft draft) =>
      caller.callServerEndpoint<_itiiwgx0.Item>(
        'item',
        'create',
        {'draft': draft},
      );

  /// Applies the user-editable fields of [item]. The stored owner, saved time
  /// and canonical URL are kept. Fails when [item] carries a stale revision.
  _ida.Future<_itiiwgx0.Item> update(_itiiwgx0.Item item) =>
      caller.callServerEndpoint<_itiiwgx0.Item>(
        'item',
        'update',
        {'item': item},
      );

  /// Returns false when there was nothing of the owner's to delete.
  _ida.Future<bool> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<bool>(
        'item',
        'delete',
        {'id': id},
      );
}

/// Review-session planning: preferences, propose, commit, move, cancel,
/// device calendar work and iCalendar export. See [Planner] for the rules.
/// {@category Endpoint}
class EndpointPlanner extends _isc.EndpointRef {
  EndpointPlanner(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'planner';

  /// The owner's planning rules; defaults have a null id until saved.
  _ida.Future<_i47tswj4.PlannerPreferences> preferences() =>
      caller.callServerEndpoint<_i47tswj4.PlannerPreferences>(
        'planner',
        'preferences',
        {},
      );

  _ida.Future<_i47tswj4.PlannerPreferences> savePreferences(
    _isn8u3xd.PlannerPreferencesDraft draft,
  ) => caller.callServerEndpoint<_i47tswj4.PlannerPreferences>(
    'planner',
    'savePreferences',
    {'draft': draft},
  );

  /// Proposes sessions in free time. Nothing is scheduled or written.
  _ida.Future<_i2np8a84.PlanProposal> propose(_iztxi4r1.PlanRequest request) =>
      caller.callServerEndpoint<_i2np8a84.PlanProposal>(
        'planner',
        'propose',
        {'request': request},
      );

  _ida.Future<_i2np8a84.PlanProposal?> currentProposal() =>
      caller.callServerEndpoint<_i2np8a84.PlanProposal?>(
        'planner',
        'currentProposal',
        {},
      );

  /// Accepts a plan after checking availability again. Safe to retry with
  /// the same operation id.
  _ida.Future<_ijkqk6e6.PlanCommitResult> commit(
    _imjid542.PlanCommitRequest request,
  ) => caller.callServerEndpoint<_ijkqk6e6.PlanCommitResult>(
    'planner',
    'commit',
    {'request': request},
  );

  /// Scheduled sessions overlapping `[from, to)`.
  _ida.Future<List<_i2af9p8a.SessionView>> sessions(
    DateTime from,
    DateTime to,
  ) => caller.callServerEndpoint<List<_i2af9p8a.SessionView>>(
    'planner',
    'sessions',
    {
      'from': from,
      'to': to,
    },
  );

  _ida.Future<_ia2d415f.SessionChangeResult> moveSession(
    _ildvggxs.SessionMoveRequest request,
  ) => caller.callServerEndpoint<_ia2d415f.SessionChangeResult>(
    'planner',
    'moveSession',
    {'request': request},
  );

  _ida.Future<_ia2d415f.SessionChangeResult> cancelSession(
    _isc.UuidValue sessionId,
    _isc.UuidValue operationId,
    _isc.UuidValue? deviceId,
  ) => caller.callServerEndpoint<_ia2d415f.SessionChangeResult>(
    'planner',
    'cancelSession',
    {
      'sessionId': sessionId,
      'operationId': operationId,
      'deviceId': deviceId,
    },
  );

  /// Calendar events this device should create, move, remove or check.
  _ida.Future<List<_i4bu6rte.CalendarWrite>> deviceWork(
    _isc.UuidValue deviceId,
  ) => caller.callServerEndpoint<List<_i4bu6rte.CalendarWrite>>(
    'planner',
    'deviceWork',
    {'deviceId': deviceId},
  );

  _ida.Future<void> reportWrites(List<_ivswpuyg.CalendarWriteResult> results) =>
      caller.callServerEndpoint<void>(
        'planner',
        'reportWrites',
        {'results': results},
      );

  /// An export-only `.ics` file: a copy to import, not a live sync, and not
  /// proof of free time.
  _ida.Future<String> exportIcs(List<_isc.UuidValue> sessionIds) =>
      caller.callServerEndpoint<String>(
        'planner',
        'exportIcs',
        {'sessionIds': sessionIds},
      );
}

/// {@category Endpoint}
class EndpointProfile extends _isc.EndpointRef {
  EndpointProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  _ida.Future<_i1myizpd.PinneProfile?> get() =>
      caller.callServerEndpoint<_i1myizpd.PinneProfile?>(
        'profile',
        'get',
        {},
      );

  _ida.Future<_i1myizpd.PinneProfile> upsert(_iyve154t.ProfileDraft draft) =>
      caller.callServerEndpoint<_i1myizpd.PinneProfile>(
        'profile',
        'upsert',
        {'draft': draft},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    googleIdp = EndpointGoogleIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    calendar = EndpointCalendar(this);
    collection = EndpointCollection(this);
    health = EndpointHealth(this);
    item = EndpointItem(this);
    planner = EndpointPlanner(this);
    profile = EndpointProfile(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointGoogleIdp googleIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointCalendar calendar;

  late final EndpointCollection collection;

  late final EndpointHealth health;

  late final EndpointItem item;

  late final EndpointPlanner planner;

  late final EndpointProfile profile;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'googleIdp': googleIdp,
    'jwtRefresh': jwtRefresh,
    'calendar': calendar,
    'collection': collection,
    'health': health,
    'item': item,
    'planner': planner,
    'profile': profile,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
