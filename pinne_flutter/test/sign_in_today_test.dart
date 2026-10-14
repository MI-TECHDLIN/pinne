import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/app.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/today/today_greeting.dart';
import 'package:pinne_flutter/features/today/today_screen.dart';
import 'package:pinne_flutter/features/tour/tour_store.dart';
import 'package:pinne_flutter/ui/motion.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'capture/fake_capture_server.dart';
import 'progress/fake_progress_api.dart';

/// One user known to the fake server.
class _User {
  _User({
    required String id,
    required this.token,
    this.email,
    this.displayName,
    this.items = const [],
    this.exampleCount = 0,
  }) : id = UuidValue.fromString(id);

  final UuidValue id;
  final String token;
  final String? email;
  String? displayName;
  final List<String> items;
  final int exampleCount;

  bool get isGuest => email == null;

  AuthSuccess get auth => AuthSuccess(
    authStrategy: 'jwt',
    token: token,
    authUserId: id,
    scopeNames: const {},
  );
}

final _guest = _User(
  id: '00000000-0000-4000-8000-0000000000aa',
  token: 'guest-token',
  items: ['Guest example: Designing calm interfaces'],
  exampleCount: 6,
);

/// A brand-new email account: no profile row and no items yet.
final _reader = _User(
  id: '00000000-0000-4000-8000-0000000000bb',
  token: 'reader-token',
  email: 'river.reader@example.com',
);

/// An email account that chose a display name on Profile.
final _named = _User(
  id: '00000000-0000-4000-8000-0000000000cc',
  token: 'named-token',
  email: 'named@example.com',
  displayName: 'River',
);

class _MemoryAuthStorage implements ClientAuthSuccessStorage {
  _MemoryAuthStorage([this.value]);

  AuthSuccess? value;

  @override
  Future<AuthSuccess?> get() async => value;

  @override
  Future<void> set(AuthSuccess? data) async => value = data;
}

/// Answers every endpoint the app calls, per signed-in user, the way the
/// production server does. Unknown calls fail loudly in [unexpected].
class _FakeServer {
  _FakeServer(this.users);

  final List<_User> users;
  final calls = <String>[];
  final unexpected = <String>[];

  /// When set, `account.summary` waits for it, like a slow network.
  Completer<void>? holdSummary;

  _User? _caller(http.Request request) {
    final header = request.headers['authorization'] ?? '';
    for (final user in users) {
      if (header.contains(user.token)) return user;
    }
    return null;
  }

  Future<http.Response> handle(http.Request request) async {
    final path = request.url.path;
    calls.add(path);
    final user = _caller(request);
    Object? body;
    switch (path) {
      case '/health/emailDeliveryAvailable':
        body = true;
      case '/serverpod_auth_core.status/isSignedIn':
        body = user != null;
      case '/emailIdp/login':
        body = _reader.auth.toJson();
      case '/emailIdp/finishRegistration':
        body = _reader.auth.toJson();
      case '/emailIdp/startRegistration':
        body = '0199e0f6-6d39-7c1a-9d43-7c6b2a8f1e10';
      case '/emailIdp/verifyRegistrationCode':
        body = 'registration-token';
      case '/account/isGuest':
        body = user!.isGuest;
      case '/account/summary':
        await holdSummary?.future;
        body = AccountSummary(
          type: user!.isGuest
              ? ProfileAccountType.guest
              : ProfileAccountType.email,
          email: user.email,
          memberSince: DateTime.utc(2026, 10, 1),
        ).toJson();
      case '/profile/get':
        body = user!.displayName == null
            ? null
            : PinneProfile(
                ownerId: user.id,
                displayName: user.displayName!,
                avatarSeed: 42,
                avatarPalette: 1,
              ).toJson();
      case '/profile/upsert':
        final parameters = jsonDecode(request.body) as Map<String, dynamic>;
        final draft = parameters['draft'] as Map<String, dynamic>;
        user!.displayName = draft['displayName'] as String;
        body = PinneProfile(
          ownerId: user.id,
          displayName: user.displayName!,
          avatarSeed: draft['avatarSeed'] as int,
          avatarPalette: draft['avatarPalette'] as int,
        ).toJson();
      case '/reviewQueue/get':
        body = ReviewQueueResult(
          entries: [
            for (final title in user!.items)
              ReviewQueueEntry(
                item: Item(
                  id: UuidValue.fromString(
                    '00000000-0000-4000-8000-00000000c0de',
                  ),
                  ownerId: user.id,
                  title: title,
                  isExample: true,
                ),
                dueAt: DateTime.utc(2026, 10, 6),
                overdueMinutes: 60,
                estimatedMinutes: 3,
                selectionReason: 'due',
              ),
          ],
          timeBudgetMinutes: 10,
        ).toJson();
      case '/exampleSaves/status':
        body = ExampleSavesStatus(
          totalItemCount: user!.items.length,
          exampleItemCount: user.exampleCount,
          exampleCollectionCount: user.exampleCount > 0 ? 2 : 0,
        ).toJson();
      case '/progress/report':
        body = sampleReport().toJson();
      case '/planner/sessions':
        body = <Object>[];
      default:
        unexpected.add(path);
        return http.Response('{}', 500);
    }
    if (user == null && !path.startsWith('/health') && !path.contains('Idp')) {
      unexpected.add('unauthenticated $path');
    }
    return http.Response(jsonEncode(body), 200);
  }
}

class _AlwaysReduced extends MotionPreferenceNotifier {
  @override
  MotionPreference build() => MotionPreference.reduced;
}

Future<(_FakeServer, Client)> _pumpApp(
  WidgetTester tester, {
  required _User? signedIn,
  Completer<void>? holdSummary,
}) async {
  await tester.binding.setSurfaceSize(const Size(412, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final server = _FakeServer([_guest, _reader, _named])
    ..holdSummary = holdSummary;
  final client =
      Client(
          'http://localhost:8080/',
          httpClientOverride: MockClient(server.handle),
        )
        ..authSessionManager = FlutterAuthSessionManager(
          storage: _MemoryAuthStorage(signedIn?.auth),
        );
  await tester.runAsync(client.auth.initialize);

  final store = CaptureStore(sqlite3.openInMemory());
  addTearDown(store.close);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        serverUrlProvider.overrideWithValue('http://localhost:8080/'),
        clientProvider.overrideWithValue(client),
        captureStoreProvider.overrideWithValue(store),
        captureApiProvider.overrideWithValue(FakeCaptureServer()),
        motionPreferenceProvider.overrideWith(_AlwaysReduced.new),
        tourStoreProvider.overrideWithValue(MemoryTourStore(seen: true)),
        greetingClockProvider.overrideWithValue(
          () => DateTime(2026, 10, 7, 9),
        ),
        greetingIndexPickerProvider.overrideWithValue((_) => 0),
      ],
      child: const PinneApp(),
    ),
  );
  if (holdSummary == null) await tester.pumpAndSettle();
  return (server, client);
}

Finder get _headerName => find.byKey(const ValueKey('today-name'));

String _shownName(WidgetTester tester) =>
    tester.widget<Text>(_headerName).data!;

Future<void> _tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _type(WidgetTester tester, String key, String text) async {
  await tester.enterText(find.byKey(ValueKey(key)), text);
  // Past the email controller's validation debounce.
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
}

void _expectSignedInToday(
  WidgetTester tester,
  _FakeServer server, {
  String expectedName = 'river.reader',
}) {
  expect(find.byType(TodayScreen), findsOneWidget);
  expect(_shownName(tester), expectedName);
  expect(find.text('Guest'), findsNothing);
  expect(find.byKey(const ValueKey('today-account-badge-email')), findsNothing);
  expect(find.textContaining('Guest example'), findsNothing);
  // A real account is never shown the guest's loaded examples, and is not
  // offered examples either: it starts with its own saves.
  expect(find.text('Load a few example saves to explore'), findsNothing);
  expect(find.text('Explore with example saves'), findsNothing);
  expect(server.unexpected, isEmpty);
}

void main() {
  setUp(
    () {
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
      _reader.displayName = null;
    },
  );

  testWidgets('guest -> Profile -> Sign in -> Today shows the new account', (
    tester,
  ) async {
    final (server, _) = await _pumpApp(tester, signedIn: _guest);
    expect(_shownName(tester), 'Guest');
    expect(
      find.byKey(const ValueKey('today-account-badge-guest')),
      findsNothing,
    );
    expect(find.textContaining('Guest example'), findsWidgets);
    // The guest's dismissal must not hide the offer from the next account.
    await _tapKey(tester, 'dismiss-example-saves');

    await _tapKey(tester, 'today-profile');
    await _tapKey(tester, 'profile-sign-in');
    await _type(tester, 'email-auth-email', _reader.email!);
    await _type(tester, 'email-login-password', 'Correct-horse-1');
    await _tapKey(tester, 'email-login-submit');

    // Sign-in closes back to Profile, now for the email account.
    expect(find.text('river.reader@example.com'), findsWidgets);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    _expectSignedInToday(tester, server);
  });

  testWidgets('sign-up without a name uses the email local-part', (
    tester,
  ) async {
    final (server, _) = await _pumpApp(tester, signedIn: _guest);

    await _tapKey(tester, 'today-profile');
    await _tapKey(tester, 'profile-create-account');
    await _type(tester, 'email-auth-email', _reader.email!);
    await _tapKey(tester, 'email-sign-up-submit');
    await tester.enterText(
      find.byKey(const ValueKey('email-verification-code')),
      '12345678',
    );
    await tester.pumpAndSettle();
    await _type(tester, 'email-new-password', 'Correct-horse-battery-1!');
    await _tapKey(tester, 'email-password-submit');

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    _expectSignedInToday(tester, server);
  });

  testWidgets('sign-up saves a trimmed name before Today opens', (
    tester,
  ) async {
    final (server, _) = await _pumpApp(tester, signedIn: _guest);

    await _tapKey(tester, 'today-profile');
    await _tapKey(tester, 'profile-create-account');
    await _type(tester, 'email-auth-email', _reader.email!);
    await _type(tester, 'email-sign-up-name', '  River  ');
    await _tapKey(tester, 'email-sign-up-submit');
    await tester.enterText(
      find.byKey(const ValueKey('email-verification-code')),
      '12345678',
    );
    await tester.pumpAndSettle();
    await _type(tester, 'email-new-password', 'Correct-horse-battery-1!');
    await _tapKey(tester, 'email-password-submit');

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    _expectSignedInToday(tester, server, expectedName: 'River');
    expect(server.calls, contains('/profile/upsert'));
  });

  testWidgets('cold start already signed in shows the account', (
    tester,
  ) async {
    final (server, _) = await _pumpApp(tester, signedIn: _reader);
    _expectSignedInToday(tester, server);
  });

  testWidgets('the header loads instead of saying Guest', (tester) async {
    final hold = Completer<void>();
    final (server, _) = await _pumpApp(
      tester,
      signedIn: _reader,
      holdSummary: hold,
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(
      find.byKey(const ValueKey('today-name-skeleton')),
      findsOneWidget,
    );
    expect(_headerName, findsNothing);
    expect(find.text('Guest'), findsNothing);

    hold.complete();
    await tester.pumpAndSettle();
    _expectSignedInToday(tester, server);
  });

  testWidgets('a chosen display name wins over the email', (tester) async {
    await _pumpApp(tester, signedIn: _named);
    expect(_shownName(tester), 'River');
    expect(
      find.byKey(const ValueKey('today-account-badge-email')),
      findsNothing,
    );
  });
}
