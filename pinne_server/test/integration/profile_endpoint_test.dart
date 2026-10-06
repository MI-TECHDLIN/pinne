import 'package:pinne_server/src/generated/protocol.dart';
import 'package:pinne_server/src/profile/profile_endpoint.dart';
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Profile', (sessionBuilder, endpoints) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;
    ProfileDraft draft({
      int palette = 0,
      int seed = 2026,
      String name = 'Alice',
    }) => ProfileDraft(
      displayName: name,
      avatarSeed: seed,
      avatarPalette: palette,
    );

    setUp(() async {
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
    });

    test(
      'save and reload preserves the avatar and updates the same row',
      () async {
        expect(await endpoints.profile.get(alice), isNull);
        final saved = await endpoints.profile.upsert(alice, draft());
        final loaded = (await endpoints.profile.get(alice))!;
        expect(loaded.id, saved.id);
        expect(loaded.avatarSeed, 2026);
        expect(loaded.avatarPalette, 0);
        expect(loaded.displayName, 'Alice');
        await endpoints.profile.upsert(
          alice,
          draft(palette: 5, seed: 91, name: '  A  '),
        );
        final updated = (await endpoints.profile.get(alice))!;
        expect(updated.id, saved.id);
        expect(updated.avatarSeed, 91);
        expect(updated.avatarPalette, 5);
        expect(updated.displayName, 'A');
      },
    );

    test('get and upsert cannot read or overwrite another owner', () async {
      final a = await endpoints.profile.upsert(alice, draft());
      expect(await endpoints.profile.get(bob), isNull);
      final b = await endpoints.profile.upsert(
        bob,
        draft(seed: 7, name: 'Bob'),
      );
      expect(b.ownerId, isNot(a.ownerId));
      expect(b.id, isNot(a.id));
      expect((await endpoints.profile.get(alice))!.avatarSeed, 2026);
      expect((await endpoints.profile.get(bob))!.avatarSeed, 7);
    });

    test(
      'all palette indices are accepted; out-of-range inputs are rejected',
      () async {
        for (
          var palette = 0;
          palette < ProfileEndpoint.paletteCount;
          palette++
        ) {
          expect(
            (await endpoints.profile.upsert(
              alice,
              draft(palette: palette),
            )).avatarPalette,
            palette,
          );
        }
        for (final palette in [-1, ProfileEndpoint.paletteCount, 999]) {
          await expectLater(
            endpoints.profile.upsert(alice, draft(palette: palette)),
            throwsA(isA<ValidationException>()),
          );
        }
      },
    );

    test('invalid seeds and names cannot replace a saved profile', () async {
      await endpoints.profile.upsert(alice, draft());
      for (final invalid in [
        draft(seed: -1),
        draft(seed: ProfileEndpoint.maxSeed + 1),
        draft(name: ' '),
        draft(name: 'x' * 81),
      ]) {
        await expectLater(
          endpoints.profile.upsert(alice, invalid),
          throwsA(isA<ValidationException>()),
        );
      }
      expect((await endpoints.profile.get(alice))!.displayName, 'Alice');
    });

    test('both methods require authentication', () async {
      await expectLater(
        endpoints.profile.get(sessionBuilder),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        endpoints.profile.upsert(sessionBuilder, draft()),
        throwsA(isA<Exception>()),
      );
    });
  });
}
