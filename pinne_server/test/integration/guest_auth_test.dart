import 'package:pinne_server/src/auth/demo_account_seeder.dart';
import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  late AuthServices authServices;

  setUpAll(() {
    AuthServices.set(
      tokenManagerBuilders: [
        ServerSideSessionsConfig(
          sessionKeyHashPepper: 'pinne-test-session-pepper',
        ),
      ],
      identityProviderBuilders: [
        AnonymousIdpConfig(),
        const EmailIdpConfig(secretHashPepper: 'pinne-test-email-pepper'),
      ],
    );
    authServices = AuthServices.instance;
  });

  withServerpod(
    'Given guest authentication',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, endpoints) {
      test(
        'a guest gets an isolated owner and cannot read another guest',
        () async {
          final firstAuth = await endpoints.anonymousIdp.login(sessionBuilder);
          final secondAuth = await endpoints.anonymousIdp.login(sessionBuilder);
          expect(secondAuth.authUserId, isNot(firstAuth.authUserId));

          final firstGuest = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              firstAuth.authUserId.uuid,
              {},
            ),
          );
          final secondGuest = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              secondAuth.authUserId.uuid,
              {},
            ),
          );
          final item = await endpoints.item.create(
            firstGuest,
            ItemDraft(title: 'First guest private save'),
          );
          final registeredUser = await authServices.authUsers.create(
            sessionBuilder.build(),
          );
          final registered = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              registeredUser.id.uuid,
              {},
            ),
          );
          final registeredItem = await endpoints.item.create(
            registered,
            ItemDraft(title: 'Registered user private save'),
          );

          expect(item.ownerId, firstAuth.authUserId);
          expect(await endpoints.account.isGuest(firstGuest), isTrue);
          expect(await endpoints.account.isGuest(registered), isFalse);
          expect(await endpoints.item.get(secondGuest, item.id!), isNull);
          expect(
            await endpoints.item.get(firstGuest, registeredItem.id!),
            isNull,
          );
          expect(await endpoints.item.list(secondGuest), isEmpty);
          expect((await endpoints.item.list(firstGuest)).single.id, item.id);
        },
      );

      test('signed-out access is still rejected', () async {
        final signedOut = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );
        await expectLater(
          endpoints.item.list(signedOut),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
        await expectLater(
          endpoints.account.isGuest(signedOut),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });

      test(
        'demo seeding is idempotent and creates working credentials',
        () async {
          const email = 'judge@example.test';
          const password = 'JudgePassword123!';
          final seeder = DemoAccountSeeder(authServices: authServices);

          final first = await seeder.seed(
            sessionBuilder.build(),
            email: email,
            password: password,
          );
          final second = await seeder.seed(
            sessionBuilder.build(),
            email: email,
            password: password,
          );

          expect(first.created, isTrue);
          expect(second.created, isFalse);
          expect(second.authUserId, first.authUserId);
          final account = await authServices.providers
              .whereType<EmailIdp>()
              .single
              .admin
              .findAccount(sessionBuilder.build(), email: email);
          expect(account?.authUserId, first.authUserId);

          final login = await endpoints.emailIdp.login(
            sessionBuilder,
            email: email,
            password: password,
          );
          expect(login.authUserId, first.authUserId);
          expect(
            await endpoints.item.list(
              sessionBuilder.copyWith(
                authentication: AuthenticationOverride.authenticationInfo(
                  login.authUserId.uuid,
                  {},
                ),
              ),
            ),
            isEmpty,
          );
        },
      );
    },
  );
}
