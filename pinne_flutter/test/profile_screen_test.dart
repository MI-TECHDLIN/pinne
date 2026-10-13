import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:pinne_flutter/features/settings/profile_screen.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';

import 'progress/fake_progress_api.dart';

void main() {
  Widget app({required AccountSummary account, PinneProfile? profile}) =>
      ProviderScope(
        overrides: [
          profileProvider.overrideWith((ref) async => profile),
          accountSummaryProvider.overrideWith((ref) async => account),
          profileProgressProvider.overrideWith((ref) async => sampleReport()),
          avatarRecipeProvider.overrideWithValue((seed: 2026, palette: 1)),
        ],
        child: MaterialApp(
          theme: pinneDarkTheme(),
          builder: (context, child) => MotionPreferenceScope(
            preference: MotionPreference.reduced,
            child: child!,
          ),
          home: const ProfileScreen(),
        ),
      );

  testWidgets('guest profile explains separate account and offers both flows', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        account: AccountSummary(
          type: ProfileAccountType.guest,
          memberSince: DateTime.utc(2026, 8, 2),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Guest'), findsOneWidget);
    expect(find.text('GUEST'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('profile-guest-separate-account-notice')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('profile-sign-in')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('profile-create-account')),
      findsOneWidget,
    );
    expect(find.text('12'), findsOneWidget);
    expect(find.text('31'), findsOneWidget);
  });

  testWidgets('email profile shows details, stats and sign-out confirmation', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        account: AccountSummary(
          type: ProfileAccountType.email,
          email: 'river@example.com',
          memberSince: DateTime.utc(2026, 1, 12),
        ),
        profile: PinneProfile(
          ownerId: UuidValue.fromString(
            '00000000-0000-4000-8000-000000000001',
          ),
          displayName: 'River',
          avatarSeed: 2026,
          avatarPalette: 1,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('River'), findsOneWidget);
    expect(find.text('EMAIL'), findsOneWidget);
    expect(find.text('river@example.com'), findsOneWidget);
    expect(find.text('Member since Jan 12, 2026'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('profile-sign-out')));
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget);
    expect(find.byKey(const ValueKey('confirm-sign-out')), findsOneWidget);
  });
}
