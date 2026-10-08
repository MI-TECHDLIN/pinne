import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/auth/sign_in_screen.dart';
import 'package:pinne_flutter/features/settings/account_kind_provider.dart';
import 'package:pinne_flutter/features/settings/settings_screen.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:pinne_flutter/ui/motion.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

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
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

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
          serverHealthProvider.overrideWith(
            (ref) async => ServerHealth(
              ok: true,
              databaseOk: true,
              serverTime: DateTime.utc(2026, 10, 8),
              version: '0.1.0',
            ),
          ),
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
}
