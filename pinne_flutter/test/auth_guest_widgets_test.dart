import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/auth/sign_in_screen.dart';
import 'package:pinne_flutter/features/settings/account_kind_provider.dart';
import 'package:pinne_flutter/features/settings/settings_screen.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:pinne_flutter/ui/motion.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'support/contrast.dart';
import 'support/golden_theme.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

class _AlwaysReduced extends MotionPreferenceNotifier {
  @override
  MotionPreference build() => MotionPreference.reduced;
}

Client _client() =>
    Client('http://localhost:8080/')
      ..authSessionManager = FlutterAuthSessionManager();

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('sign-in, sign-up and guest Settings are readable in '
      'Lavender Mist', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final (emailAvailable, createAccount) in [
      (false, false),
      (true, false),
      (true, true),
    ]) {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            clientProvider.overrideWithValue(_client()),
            emailDeliveryAvailableProvider.overrideWith(
              (ref) async => emailAvailable,
            ),
          ],
          child: MaterialApp(
            theme: pinneLightTheme(),
            home: SignInScreen(createAccount: createAccount),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectReadableText(
        tester,
        reason: 'sign in (email $emailAvailable, create $createAccount)',
      );
      await tester.enterText(find.byType(TextField).first, 'r@example.com');
      // Let the email validation debounce finish before the screen goes.
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      await expectReadableText(tester, reason: 'sign in, typed');
      await tester.pumpWidget(const SizedBox.shrink());
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clientProvider.overrideWithValue(_client()),
          serverUrlProvider.overrideWithValue('http://localhost:8080/'),
          signedInProvider.overrideWith(_SignedIn.new),
          accountKindProvider.overrideWith((ref) async => AccountKind.guest),
          motionPreferenceProvider.overrideWith(_AlwaysReduced.new),
        ],
        child: MaterialApp(
          theme: pinneLightTheme(),
          home: const Scaffold(body: SettingsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectReadableText(tester, reason: 'signed-in guest Settings');
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('sign-in screen offers and runs the guest path', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var guestStarted = false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clientProvider.overrideWithValue(_client()),
          emailDeliveryAvailableProvider.overrideWith((ref) async => false),
          guestSignInActionProvider.overrideWithValue(() async {
            guestStarted = true;
          }),
        ],
        child: MaterialApp(
          theme: pinneDarkTheme(),
          home: const SignInScreen(),
        ),
      ),
    );
    await tester.pump();

    final guestButton = find.byKey(const ValueKey('guest-sign-in-button'));
    expect(guestButton, findsOneWidget);
    expect(find.text('Try without an account'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('email-delivery-unavailable')),
      findsOneWidget,
    );
    expect(find.text('Create account'), findsNothing);
    expect(find.text('Forgot password?'), findsNothing);
    expect(
      find.byKey(const ValueKey('email-login-submit')),
      findsOneWidget,
    );

    await tester.tap(guestButton);
    await tester.pumpAndSettle();
    expect(guestStarted, isTrue);
  });

  testWidgets('Settings warns a guest that the account is device-bound', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clientProvider.overrideWithValue(_client()),
          serverUrlProvider.overrideWithValue('http://localhost:8080/'),
          signedInProvider.overrideWith(_SignedIn.new),
          accountKindProvider.overrideWith(
            (ref) async => AccountKind.guest,
          ),
          motionPreferenceProvider.overrideWith(_AlwaysReduced.new),
        ],
        child: MaterialApp(
          theme: pinneDarkTheme(),
          home: const Scaffold(body: SettingsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Guest account'), findsOneWidget);
    expect(find.byKey(const ValueKey('guest-data-notice')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('guest-linking-unavailable')),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('guest account switch never offers a second guest account', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clientProvider.overrideWithValue(_client()),
          signedInProvider.overrideWith(_SignedIn.new),
          emailDeliveryAvailableProvider.overrideWith((ref) async => true),
        ],
        child: MaterialApp(
          theme: pinneDarkTheme(),
          home: const SignInScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('guest-account-switch-notice')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('guest-sign-in-button')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('email-delivery-unavailable')),
      findsNothing,
    );
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });
}
