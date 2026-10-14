import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/auth/sign_in_screen.dart';
import 'package:pinne_flutter/features/auth/sign_out.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:pinne_flutter/ui/pinne_loading.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'support/contrast.dart';
import 'support/golden_theme.dart';

const _uuid = '0199e0f6-6d39-7c1a-9d43-7c6b2a8f1e10';

/// Holds every endpoint call until the test answers it, so each busy state
/// stays on screen long enough to inspect.
class _Server {
  final _pending = <String, Completer<http.Response>>{};
  final calls = <String>[];

  late final client = Client(
    'http://localhost:8080/',
    httpClientOverride: MockClient(
      (request) {
        calls.add(request.url.path);
        return (_pending[request.url.path] = Completer()).future;
      },
    ),
  )..authSessionManager = FlutterAuthSessionManager();

  void answer(String path, Object body) =>
      _pending.remove(path)!.complete(http.Response(jsonEncode(body), 200));

  /// Fails every held call so no request timeout outlives the test.
  Future<void> finish(WidgetTester tester) async {
    for (final call in _pending.values) {
      call.complete(http.Response('{}', 500));
    }
    _pending.clear();
    await tester.pump();
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpWidget(const SizedBox());
  }
}

class _SlowSignOut extends SignedInNotifier {
  @override
  bool build() => true;

  @override
  Future<void> signOut() => Completer<void>().future;
}

/// Every auth wait shows the branded loader, never a circular spinner.
Future<void> _expectBranded(WidgetTester tester, String step) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  expect(
    find.byType(CircularProgressIndicator),
    findsNothing,
    reason: '$step shows a circular spinner',
  );
  expect(
    find.byType(PinneBrandedLoader),
    findsWidgets,
    reason: '$step shows no branded loader',
  );
  await expectReadableText(tester, reason: step);
}

void main() {
  setUpAll(loadGoldenFonts);

  test('lib/ never builds a circular spinner', () {
    // EmailSignInWidget draws the package's spinner while it is busy.
    final banned = RegExp(r'CircularProgressIndicator|EmailSignInWidget\(');
    final offenders = [
      for (final file in Directory('lib').listSync(recursive: true))
        if (file is File &&
            file.path.endsWith('.dart') &&
            banned.hasMatch(file.readAsStringSync()))
          file.path,
    ];
    expect(offenders, isEmpty, reason: 'use PinneBrandedLoader instead');
  });

  Future<_Server> open(
    WidgetTester tester, {
    bool createAccount = false,
    List overrides = const [],
  }) async {
    await tester.binding.setSurfaceSize(const Size(412, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final server = _Server();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clientProvider.overrideWithValue(server.client),
          emailDeliveryAvailableProvider.overrideWith((ref) async => true),
          ...overrides,
        ],
        child: MaterialApp(
          theme: pinneLightTheme(),
          home: SignInScreen(createAccount: createAccount),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return server;
  }

  Future<void> type(WidgetTester tester, String key, String text) async {
    await tester.enterText(find.byKey(ValueKey(key)), text);
    // Past the controller's email validation debounce.
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(ValueKey(key)));
    await tester.tap(find.byKey(ValueKey(key)));
  }

  testWidgets('signing in', (tester) async {
    final server = await open(tester);
    await type(tester, 'email-auth-email', 'river@example.com');
    await type(tester, 'email-login-password', 'Correct-horse-1');
    await tap(tester, 'email-login-submit');
    await _expectBranded(tester, 'sign in');
    await server.finish(tester);
  });

  testWidgets('creating an account: code, verify and password', (
    tester,
  ) async {
    final server = await open(tester, createAccount: true);
    await type(tester, 'email-auth-email', 'river@example.com');
    await tap(tester, 'email-sign-up-submit');
    await _expectBranded(tester, 'create account');

    server.answer('/emailIdp/startRegistration', _uuid);
    await tester.pumpAndSettle();
    expect(find.text('Verify account'), findsOneWidget);
    expect(find.text('Verify code'), findsOneWidget);
    expect(find.textContaining('Resend code in'), findsOneWidget);
    expect(find.text('Change email'), findsOneWidget);
    await expectReadableText(tester, reason: 'verify code');
    await tester.enterText(
      find.byKey(const ValueKey('email-verification-code')),
      '12345678',
    );
    await _expectBranded(tester, 'verify code');

    server.answer('/emailIdp/verifyRegistrationCode', 'token');
    await tester.pumpAndSettle();
    await type(tester, 'email-new-password', 'Correct-horse-battery-1! ');
    expect(find.text('Does not start or end with a space'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const ValueKey('email-password-submit')),
          )
          .onPressed,
      isNull,
    );
    await type(tester, 'email-new-password', 'Correct-horse-battery-1!');
    await expectReadableText(tester, reason: 'set password');
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Use a different email'), findsOneWidget);
    await tap(tester, 'email-password-submit');
    await tap(tester, 'email-password-submit');
    await _expectBranded(tester, 'finish registration');
    expect(server._pending.keys, ['/emailIdp/finishRegistration']);
    expect(
      server.calls.where((path) => path == '/emailIdp/finishRegistration'),
      hasLength(1),
    );
    await server.finish(tester);
  });

  testWidgets('forgot password: request, verify and new password', (
    tester,
  ) async {
    final server = await open(tester);
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    await expectReadableText(tester, reason: 'reset request');
    await type(tester, 'email-auth-email', 'river@example.com');
    await tap(tester, 'email-reset-submit');
    await _expectBranded(tester, 'request reset');

    server.answer('/emailIdp/startPasswordReset', _uuid);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('email-verification-code')),
      '12345678',
    );
    await _expectBranded(tester, 'verify reset code');

    server.answer('/emailIdp/verifyPasswordResetCode', 'token');
    await tester.pumpAndSettle();
    await type(tester, 'email-new-password', 'Correct-horse-battery-1!');
    await tap(tester, 'email-password-submit');
    await _expectBranded(tester, 'finish reset');
    expect(server._pending.keys, ['/emailIdp/finishPasswordReset']);
    await server.finish(tester);
  });

  testWidgets('trying Pinne as a guest', (tester) async {
    await open(
      tester,
      overrides: [
        guestSignInActionProvider.overrideWithValue(
          () => Completer<void>().future,
        ),
      ],
    );
    await tap(tester, 'guest-sign-in-button');
    await _expectBranded(tester, 'guest');
  });

  testWidgets('signing out', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signedInProvider.overrideWith(_SlowSignOut.new),
          accountIdProvider.overrideWith(_Account.new),
        ],
        child: MaterialApp(
          theme: pinneLightTheme(),
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => confirmSignOut(context, ref),
                  child: const Text('Sign out'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-sign-out')));
    await _expectBranded(tester, 'sign out');
    expect(find.byKey(const ValueKey('signing-out')), findsOneWidget);
  });
}

class _Account extends AccountIdNotifier {
  @override
  String? build() => '00000000-0000-4000-8000-000000000001';
}
