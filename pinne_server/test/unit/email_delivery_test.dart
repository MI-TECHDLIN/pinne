import 'package:pinne_server/src/auth/email_delivery.dart';
import 'package:test/test.dart';

void main() {
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
