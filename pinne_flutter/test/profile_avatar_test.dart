import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/features/settings/settings_screen.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:pinne_flutter/ui/ribbon_spirit/ribbon_spirit.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'support/golden_theme.dart';

class _SignedIn extends SignedInNotifier {
  @override
  bool build() => true;
}

class _Alice extends ProfileUserId {
  @override
  String? build() => '00000000-0000-4000-8000-000000000001';
}

/// Keeps endpoint state across disposal of all app state, like server storage.
/// Real persistence and authorization are covered by profile_endpoint_test.
class _ProfileEndpoint extends Fake implements EndpointProfile {
  PinneProfile? stored;
  bool fail = false;
  int gets = 0;

  @override
  Future<PinneProfile?> get() async {
    gets++;
    return stored;
  }

  @override
  Future<PinneProfile> upsert(ProfileDraft draft) async {
    if (fail) throw Exception('offline');
    return stored = PinneProfile(
      ownerId: UuidValue.fromString('00000000-0000-4000-8000-000000000001'),
      displayName: draft.displayName,
      avatarSeed: draft.avatarSeed,
      avatarPalette: draft.avatarPalette,
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  testWidgets(
    'choose, save and reload an avatar after app state is destroyed',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final endpoint = _ProfileEndpoint();
      Widget app() => ProviderScope(
        overrides: [
          profileUserIdProvider.overrideWith(_Alice.new),
          profileEndpointProvider.overrideWithValue(endpoint),
          signedInProvider.overrideWith(_SignedIn.new),
          serverUrlProvider.overrideWithValue('http://localhost:8080/'),
          serverHealthProvider.overrideWith(
            (ref) async => ServerHealth(
              ok: true,
              databaseOk: true,
              serverTime: DateTime.utc(2026, 10, 6),
              version: '0.1.0',
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: goldenTheme(),
          builder: (context, child) => MotionPreferenceScope(
            preference: MotionPreference.reduced,
            child: child!,
          ),
          home: const Scaffold(body: SettingsScreen()),
        ),
      );

      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      final fallback = tester
          .widget<RibbonSpirit>(find.byType(RibbonSpirit))
          .seed;
      expect(
        fallback,
        RibbonRecipe.seedForUser('00000000-0000-4000-8000-000000000001'),
      );
      await tester.tap(find.text('Choose your spirit'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('avatar-choice-6')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'Peach'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'River');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../../docs/ribbon-spirit/avatar-picker.png'),
      );
      await tester.tap(find.text('Keep this spirit'));
      await tester.pumpAndSettle();
      expect(endpoint.stored!.displayName, 'River');
      expect(endpoint.stored!.avatarPalette, 2);
      expect(endpoint.stored!.avatarSeed, isNot(fallback));
      final savedSeed = endpoint.stored!.avatarSeed;

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      final restored = tester.widget<RibbonSpirit>(find.byType(RibbonSpirit));
      expect(restored.seed, savedSeed);
      expect(restored.palette, 2);
      expect(find.text('River'), findsOneWidget);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../../docs/ribbon-spirit/settings.png'),
      );
      expect(endpoint.gets, greaterThanOrEqualTo(3));

      endpoint.fail = true;
      await tester.tap(find.text('Choose your spirit'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('avatar-choice-4')));
      await tester.tap(find.text('Keep this spirit'));
      await tester.pumpAndSettle();
      expect(
        find.text('Could not save your spirit. Please try again.'),
        findsOneWidget,
      );
      expect(endpoint.stored!.avatarSeed, savedSeed);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
