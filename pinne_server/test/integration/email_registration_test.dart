import 'dart:io';

import 'package:pinne_server/src/auth/email_delivery.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  final smtp = _SwitchableSender('SMTP smtp.gmail.com:587');
  final cloud = _SwitchableSender('the Serverpod Cloud email service');
  final log = <String>[];

  setUpAll(() {
    final delivery = AuthCodeDelivery([smtp, cloud], report: log.add);
    AuthServices.set(
      tokenManagerBuilders: [
        ServerSideSessionsConfig(
          sessionKeyHashPepper: 'pinne-test-session-pepper',
        ),
      ],
      identityProviderBuilders: [
        EmailIdpConfig(
          secretHashPepper: 'pinne-test-email-pepper',
          sendRegistrationVerificationCode: delivery.sendRegistrationCode,
          sendPasswordResetVerificationCode: delivery.sendPasswordResetCode,
        ),
      ],
    );
  });

  withServerpod(
    'Given SMTP that production cannot reach',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, endpoints) {
      test(
        'sign-up finishes with the code sent through the Cloud fallback',
        () async {
          smtp.failure = const SocketException('Connection timed out');
          const email = 'new-reader@example.com';

          final requestId = await endpoints.emailIdp.startRegistration(
            sessionBuilder,
            email: email,
          );
          expect(cloud.lastCode[email], isNotNull);
          final token = await endpoints.emailIdp.verifyRegistrationCode(
            sessionBuilder,
            accountRequestId: requestId,
            verificationCode: cloud.lastCode[email]!,
          );
          final auth = await endpoints.emailIdp.finishRegistration(
            sessionBuilder,
            registrationToken: token,
            password: 'long enough password',
          );

          expect(auth.authUserId, isNotNull);
          expect(log.first, contains('via SMTP smtp.gmail.com:587'));
        },
      );

      test(
        'when every route fails the app gets a reason and can retry',
        () async {
          smtp.failure = const SocketException('Connection timed out');
          cloud.failure = const HttpException('503 from email service');
          const email = 'unlucky-reader@example.com';

          await expectLater(
            endpoints.emailIdp.startRegistration(sessionBuilder, email: email),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.unknown,
              ),
            ),
          );
          final pending = await EmailAccountRequest.db.count(
            sessionBuilder.build(),
            where: (t) => t.email.equals(email),
          );
          expect(pending, 0, reason: 'the failed request is rolled back');

          cloud.failure = null;
          await endpoints.emailIdp.startRegistration(
            sessionBuilder,
            email: email,
          );
          expect(cloud.lastCode[email], isNotNull);
        },
      );
    },
  );
}

class _SwitchableSender implements AuthCodeSender {
  _SwitchableSender(this.route);

  @override
  final String route;

  Exception? failure;
  final lastCode = <String, String>{};

  @override
  Future<void> send({
    required String email,
    required AuthEmailKind kind,
    required String code,
  }) async {
    if (failure case final failure?) throw failure;
    lastCode[email] = code;
  }
}
