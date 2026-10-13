import 'dart:async';
import 'dart:io';

import 'package:pinne_server/src/auth/email_delivery.dart';
import 'package:test/test.dart';

void main() {
  group('AuthCodeDelivery', () {
    late List<String> log;
    late DateTime now;

    setUp(() {
      log = [];
      now = DateTime.utc(2026, 10, 13, 20);
    });

    AuthCodeDelivery deliveryOf(
      List<AuthCodeSender> routes, {
      List<String> secrets = const [],
    }) => AuthCodeDelivery(
      routes,
      secrets: secrets,
      now: () => now,
      report: log.add,
    );

    test('a silent SMTP port falls back to the Cloud email service', () async {
      // Reproduces production: Serverpod Cloud never answers smtp.gmail.com
      // on 587, so the mailer waits for its timeout. Before the fallback this
      // threw and sign-up answered a generic 500 after about 20 seconds.
      final silent = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final held = <Socket>[];
      silent.listen(held.add);
      addTearDown(() async {
        for (final socket in held) {
          socket.destroy();
        }
        await silent.close();
      });
      final smtp = SmtpCodeSender(
        const SmtpSettings(
          host: '127.0.0.1',
          port: 0,
          fromEmail: 'pinne@example.com',
          fromName: 'Pinne',
          ssl: false,
          username: 'pinne@example.com',
          password: 'app-password-secret',
        ).withPort(silent.port),
        timeout: const Duration(milliseconds: 300),
      );
      final cloud = _RecordingSender('the Serverpod Cloud email service');

      final sent =
          await deliveryOf(
            [
              smtp,
              cloud,
            ],
            secrets: ['app-password-secret'],
          ).deliver(
            email: 'new@example.com',
            kind: AuthEmailKind.registration,
            code: '12345678',
          );

      expect(sent, isTrue);
      expect(cloud.sent, [('new@example.com', '12345678')]);
      expect(log.first, contains('via SMTP 127.0.0.1:${silent.port}'));
      expect(log.first, contains('Timed out'));
      expect(log.last, contains('via the Serverpod Cloud email service'));
      expect(log.join('\n'), isNot(contains('12345678')));
      expect(log.join('\n'), isNot(contains('app-password-secret')));
    });

    test('a failed route rests while a fallback exists', () async {
      final smtp = _FailingSender('SMTP smtp.example.com:587');
      final cloud = _RecordingSender('cloud');
      final delivery = deliveryOf([smtp, cloud]);

      await delivery.deliver(
        email: 'a@example.com',
        kind: AuthEmailKind.registration,
        code: '11111111',
      );
      now = now.add(const Duration(minutes: 29));
      await delivery.deliver(
        email: 'b@example.com',
        kind: AuthEmailKind.registration,
        code: '22222222',
      );
      expect(smtp.attempts, 1);

      now = now.add(const Duration(minutes: 2));
      await delivery.deliver(
        email: 'c@example.com',
        kind: AuthEmailKind.passwordReset,
        code: '33333333',
      );
      expect(smtp.attempts, 2);
      expect(cloud.sent.map((sent) => sent.$1), [
        'a@example.com',
        'b@example.com',
        'c@example.com',
      ]);
    });

    test('the last route is always tried and its failure is logged', () async {
      final only = _FailingSender(
        'SMTP smtp.example.com:587',
        error: const SocketException('Connection refused, code 99999999'),
      );
      final delivery = deliveryOf([only]);

      for (final code in ['99999999', '88888888']) {
        expect(
          await delivery.deliver(
            email: 'a@example.com',
            kind: AuthEmailKind.registration,
            code: code,
          ),
          isFalse,
        );
      }

      expect(only.attempts, 2);
      expect(log.first, contains('SocketException'));
      expect(log.first, contains('code <redacted>'));
      expect(
        log,
        contains(
          contains(
            'no route sent the registration code '
            '(tried SMTP smtp.example.com:587)',
          ),
        ),
      );
    });
  });

  group('PinneAuthEmail', () {
    test('renders registration code in HTML and plain text', () {
      final email = PinneAuthEmail.registration('123456');

      expect(email.subject, 'Your Pinne code: 123456');
      expect(email.text, contains('123456'));
      expect(email.html, contains('1&#8202;2&#8202;3&#8202;4&#8202;5&#8202;6'));
      expect(email.text, contains('valid for 15 minutes'));
      expect(email.html, contains('Pinne - Save it. Come back to it.'));
    });

    test('renders password reset as multipart-ready content', () {
      final email = PinneAuthEmail.passwordReset('a1b2c3d4');

      expect(email.subject, 'Reset your Pinne password');
      expect(email.text, contains('a1b2c3d4'));
      expect(email.html, contains('a&#8202;1&#8202;b&#8202;2'));
      expect(email.text, isNotEmpty);
      expect(email.html, isNotEmpty);
    });

    test('escapes untrusted code in HTML and strips subject newlines', () {
      final email = PinneAuthEmail.registration('<img src=x>\r\nBcc: bad');

      expect(email.html, isNot(contains('<img src=x>')));
      expect(email.html, contains('&lt;&#8202;i&#8202;m&#8202;g'));
      expect(email.subject, isNot(contains('\n')));
      expect(email.subject, isNot(contains('\r')));
    });
  });
}

extension on SmtpSettings {
  SmtpSettings withPort(int port) => SmtpSettings(
    host: host,
    port: port,
    fromEmail: fromEmail,
    fromName: fromName,
    ssl: ssl,
    username: username,
    password: password,
  );
}

class _RecordingSender implements AuthCodeSender {
  _RecordingSender(this.route);

  @override
  final String route;

  final sent = <(String, String)>[];

  @override
  Future<void> send({
    required String email,
    required AuthEmailKind kind,
    required String code,
  }) async => sent.add((email, code));
}

class _FailingSender implements AuthCodeSender {
  _FailingSender(this.route, {this.error = const SocketException('blocked')});

  @override
  final String route;

  final Exception error;
  var attempts = 0;

  @override
  Future<void> send({
    required String email,
    required AuthEmailKind kind,
    required String code,
  }) async {
    attempts++;
    throw error;
  }
}
