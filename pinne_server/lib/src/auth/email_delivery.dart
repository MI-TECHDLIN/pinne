import 'dart:io';

import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

/// Configures email verification delivery without coupling auth to a vendor.
abstract final class EmailDelivery {
  static bool _available = false;

  /// Whether this server can deliver registration and password-reset codes.
  static bool get available => _available;

  /// Loads the configured email routes and returns the email identity
  /// provider.
  ///
  /// Development and tests deliberately keep codes in the server console.
  /// Staging and production send through SMTP when it is configured and fall
  /// back to the Serverpod Cloud email service, whose `scloudAuthEmailKey`
  /// Cloud sets on every deploy. Serverpod Cloud does not reliably allow
  /// outbound SMTP, so on Cloud the fallback is what keeps sign-up working.
  /// With no route at all the sender fails fast so no user is left waiting
  /// for a code that was discarded.
  static EmailIdpConfig configure(Serverpod pod) {
    if (pod.runMode == ServerpodRunMode.development ||
        pod.runMode == ServerpodRunMode.test) {
      _available = true;
      return EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode:
            (
              session, {
              required email,
              required accountRequestId,
              required verificationCode,
              required transaction,
            }) => session.log(
              '[EmailIdp] Registration code ($email): $verificationCode',
            ),
        sendPasswordResetVerificationCode:
            (
              session, {
              required email,
              required passwordResetRequestId,
              required verificationCode,
              required transaction,
            }) => session.log(
              '[EmailIdp] Password reset code ($email): $verificationCode',
            ),
      );
    }

    final settings = SmtpSettings.maybeFromServerpod(pod);
    final cloudKey = SmtpSettings._configured(
      pod.getPassword(CloudEmailCodeSender.passwordKey),
    );
    final routes = <AuthCodeSender>[
      if (settings != null) SmtpCodeSender(settings),
      if (cloudKey != null) CloudEmailCodeSender(token: cloudKey),
    ];
    if (routes.isEmpty) {
      _available = false;
      stderr.writeln(
        'WARNING: No email route is configured (neither SMTP nor the '
        'Serverpod Cloud email service); email registration and password '
        'reset are unavailable. Guest sign-in remains available.',
      );
      return EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _unavailableRegistration,
        sendPasswordResetVerificationCode: _unavailablePasswordReset,
      );
    }

    _available = true;
    final delivery = AuthCodeDelivery(
      routes,
      secrets: [?settings?.password, ?cloudKey],
    );
    stdout.writeln(
      'Email delivery is enabled through '
      '${routes.map((route) => route.route).join(', then ')}.',
    );
    return EmailIdpConfigFromPasswords(
      sendRegistrationVerificationCode: delivery.sendRegistrationCode,
      sendPasswordResetVerificationCode: delivery.sendPasswordResetCode,
    );
  }

  static Never _unavailableRegistration(
    Session session, {
    required String email,
    required UuidValue accountRequestId,
    required String verificationCode,
    required Transaction? transaction,
  }) => throw StateError(
    'Email delivery is not configured. Use guest sign-in instead.',
  );

  static Never _unavailablePasswordReset(
    Session session, {
    required String email,
    required UuidValue passwordResetRequestId,
    required String verificationCode,
    required Transaction? transaction,
  }) => throw StateError(
    'Email delivery is not configured. Password reset is unavailable.',
  );
}

/// Which verification email is being sent.
enum AuthEmailKind {
  registration('registration'),
  passwordReset('password reset');

  const AuthEmailKind(this.label);

  final String label;
}

/// One way to get a verification code into an inbox.
abstract interface class AuthCodeSender {
  /// Names the route in logs, such as `SMTP smtp.gmail.com:587`. Never
  /// contains a secret.
  String get route;

  /// Sends [code] to [email]. Throws when the email did not leave.
  Future<void> send({
    required String email,
    required AuthEmailKind kind,
    required String code,
  });
}

/// Sends verification codes through the first route that works.
///
/// Every failed route is logged with its reason; the code and the configured
/// secrets never appear in the log. A route that fails while a later one
/// exists rests for [cooldown], so one blocked SMTP port slows down a single
/// sign-up instead of every one. When no route works the endpoint answers
/// with the auth package's own `unknown` reason, which the app explains,
/// and the pending request is rolled back so the person can simply retry.
class AuthCodeDelivery {
  AuthCodeDelivery(
    List<AuthCodeSender> routes, {
    this.cooldown = const Duration(minutes: 30),
    Iterable<String> secrets = const [],
    DateTime Function()? now,
    void Function(String line)? report,
  }) : routes = List.unmodifiable(routes),
       _secrets = secrets.where((secret) => secret.isNotEmpty).toList(),
       _now = now ?? DateTime.now,
       _report = report ?? stderr.writeln {
    if (routes.isEmpty) throw ArgumentError.value(routes, 'routes');
  }

  final List<AuthCodeSender> routes;
  final Duration cooldown;
  final List<String> _secrets;
  final DateTime Function() _now;
  final void Function(String line) _report;
  final Map<AuthCodeSender, DateTime> _restingUntil = {};

  Future<void> sendRegistrationCode(
    Session session, {
    required String email,
    required UuidValue accountRequestId,
    required String verificationCode,
    required Transaction? transaction,
  }) async {
    if (!await deliver(
      email: email,
      kind: AuthEmailKind.registration,
      code: verificationCode,
    )) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.unknown,
      );
    }
  }

  Future<void> sendPasswordResetCode(
    Session session, {
    required String email,
    required UuidValue passwordResetRequestId,
    required String verificationCode,
    required Transaction? transaction,
  }) async {
    if (!await deliver(
      email: email,
      kind: AuthEmailKind.passwordReset,
      code: verificationCode,
    )) {
      throw EmailAccountPasswordResetException(
        reason: EmailAccountPasswordResetExceptionReason.unknown,
      );
    }
  }

  /// Tries each route in order and returns whether one sent the email.
  Future<bool> deliver({
    required String email,
    required AuthEmailKind kind,
    required String code,
  }) async {
    final failed = <String>[];
    for (final (index, sender) in routes.indexed) {
      final hasFallback = index < routes.length - 1;
      final restingUntil = _restingUntil[sender];
      if (hasFallback &&
          restingUntil != null &&
          _now().isBefore(restingUntil)) {
        continue;
      }
      try {
        await sender.send(email: email, kind: kind, code: code);
        _restingUntil.remove(sender);
        if (failed.isNotEmpty) {
          _report(
            'Email delivery: sent the ${kind.label} code via ${sender.route} '
            'after ${failed.join(', ')} failed.',
          );
        }
        return true;
      } catch (error) {
        failed.add(sender.route);
        if (hasFallback) _restingUntil[sender] = _now().add(cooldown);
        _report(
          'ERROR: Email delivery: could not send the ${kind.label} code via '
          '${sender.route}: ${_redact('${error.runtimeType}: $error', code)}'
          '${hasFallback ? ' Trying the next route; this one rests for '
                    '${cooldown.inMinutes} minutes.' : ''}',
        );
      }
    }
    _report(
      'ERROR: Email delivery: no route sent the ${kind.label} code '
      '(${failed.isEmpty ? 'none tried' : 'tried ${failed.join(', ')}'}). '
      'The person sees "We could not send your code".',
    );
    return false;
  }

  String _redact(String text, String code) {
    var redacted = text;
    for (final secret in [..._secrets, code]) {
      redacted = redacted.replaceAll(secret, '<redacted>');
    }
    return redacted.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

/// Sends codes through the Serverpod Cloud transactional email service over
/// HTTPS, using Serverpod's own email template.
class CloudEmailCodeSender implements AuthCodeSender {
  CloudEmailCodeSender({required this.token, ServerpodCloudEmailClient? client})
    : client =
          client ??
          ServerpodCloudEmailClient(timeout: const Duration(seconds: 15));

  /// The password Serverpod Cloud sets on deploy for this service.
  static const passwordKey = 'scloudAuthEmailKey';

  final String token;
  final ServerpodCloudEmailClient client;

  @override
  String get route => 'the Serverpod Cloud email service';

  @override
  Future<void> send({
    required String email,
    required AuthEmailKind kind,
    required String code,
  }) => client.sendEmail(
    token: token,
    emailType: switch (kind) {
      AuthEmailKind.registration => ServerpodCloudEmailType.signup,
      AuthEmailKind.passwordReset => ServerpodCloudEmailType.lostpassword,
    },
    email: email,
    projectName: 'Pinne',
    authCode: code,
  );
}

class SmtpSettings {
  const SmtpSettings({
    required this.host,
    required this.port,
    required this.fromEmail,
    required this.fromName,
    required this.ssl,
    this.username,
    this.password,
  });

  static SmtpSettings? maybeFromServerpod(Serverpod pod) {
    final host = _configured(pod.getPassword('smtpHost'));
    final fromEmail = _configured(pod.getPassword('smtpFromEmail'));
    if (host == null || fromEmail == null) return null;

    final portText = _configured(pod.getPassword('smtpPort'));
    final port = portText == null ? 587 : int.tryParse(portText);
    if (port == null || port < 1 || port > 65535) {
      stderr.writeln('WARNING: smtpPort must be between 1 and 65535.');
      return null;
    }

    final username = _configured(pod.getPassword('smtpUsername'));
    final password = _configured(pod.getPassword('smtpPassword'));
    if ((username == null) != (password == null)) {
      stderr.writeln(
        'WARNING: smtpUsername and smtpPassword must be configured together.',
      );
      return null;
    }

    return SmtpSettings(
      host: host,
      port: port,
      fromEmail: fromEmail,
      fromName: _configured(pod.getPassword('smtpFromName')) ?? 'Pinne',
      ssl: _configured(pod.getPassword('smtpSsl'))?.toLowerCase() == 'true',
      username: username,
      password: password,
    );
  }

  final String host;
  final int port;
  final String fromEmail;
  final String fromName;
  final bool ssl;
  final String? username;
  final String? password;

  static String? _configured(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null ||
        trimmed.isEmpty ||
        (trimmed.startsWith('<') && trimmed.endsWith('>'))) {
      return null;
    }
    return trimmed;
  }
}

/// Sends Pinne's branded code emails through an SMTP server.
class SmtpCodeSender implements AuthCodeSender {
  SmtpCodeSender(
    this.settings, {
    this.timeout = const Duration(seconds: 10),
  }) : server = SmtpServer(
         settings.host,
         port: settings.port,
         ssl: settings.ssl,
         username: settings.username,
         password: settings.password,
       );

  final SmtpSettings settings;
  final SmtpServer server;

  /// Bounds the connection and each SMTP reply, so a blocked port fails over
  /// quickly instead of holding the registration transaction open.
  final Duration timeout;

  @override
  String get route => 'SMTP ${settings.host}:${settings.port}';

  @override
  Future<void> send({
    required String email,
    required AuthEmailKind kind,
    required String code,
  }) async {
    final content = switch (kind) {
      AuthEmailKind.registration => PinneAuthEmail.registration(code),
      AuthEmailKind.passwordReset => PinneAuthEmail.passwordReset(code),
    };
    await mailer.send(
      content.toMessage(settings, email),
      server,
      timeout: timeout,
    );
  }
}

/// Rendered content for an authentication email.
class PinneAuthEmail {
  const PinneAuthEmail({
    required this.subject,
    required this.text,
    required this.html,
  });

  static const _spiritUrl =
      'https://pinneapp.serverpod.space/assets/assets/branding/pinne_icon.png';

  final String subject;
  final String text;
  final String html;

  /// A multipart message with a plain-text part and an HTML part.
  mailer.Message toMessage(SmtpSettings settings, String recipient) =>
      mailer.Message()
        ..from = mailer.Address(settings.fromEmail, settings.fromName)
        ..recipients.add(recipient)
        ..subject = subject
        ..text = text
        ..html = html;

  factory PinneAuthEmail.registration(String verificationCode) => _build(
    verificationCode: verificationCode,
    subject: 'Your Pinne code: ${_subjectSafe(verificationCode)}',
    heading: 'Welcome to Pinne',
    introduction:
        'Thanks for making a little space for what matters. '
        'Use this code to finish creating your account:',
  );

  factory PinneAuthEmail.passwordReset(String verificationCode) => _build(
    verificationCode: verificationCode,
    subject: 'Reset your Pinne password',
    heading: 'Let’s get you back in',
    introduction:
        'Use this code to choose a new password for your Pinne '
        'account:',
  );

  static PinneAuthEmail _build({
    required String verificationCode,
    required String subject,
    required String heading,
    required String introduction,
  }) {
    const expiry = 'This code is valid for 15 minutes.';
    const ignore = 'Didn’t ask for this? You can safely ignore this email.';
    final code = _escapeHtml(verificationCode);
    final spacedCode = verificationCode
        .split('')
        .map(_escapeHtml)
        .join('&#8202;');
    return PinneAuthEmail(
      subject: subject,
      text:
          '$heading\n\n$introduction\n\n$verificationCode\n\n'
          '$expiry\n\n$ignore\n\nPinne - Save it. Come back to it.',
      html:
          '''
<!doctype html>
<html lang="en">
<head>
  <meta name="color-scheme" content="light dark">
  <meta name="supported-color-schemes" content="light dark">
  <style>
    @media (prefers-color-scheme: dark) {
      .page { background: #171126 !important; }
      .card { background: #241a38 !important; }
      .copy { color: #f5efff !important; }
      .muted { color: #c9bddc !important; }
      .code { background: #34264d !important; color: #f5efff !important; }
    }
  </style>
</head>
<body class="page" style="margin:0;padding:0;background:#f5f0fa;">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0"
      border="0" style="width:100%;background:#f5f0fa;">
    <tr><td align="center" style="padding:28px 12px;">
      <table class="card" role="presentation" width="100%" cellspacing="0"
          cellpadding="0" border="0"
          style="width:100%;max-width:560px;background:#ffffff;border-radius:20px;overflow:hidden;">
        <tr>
          <td align="center" bgcolor="#25143d"
              style="padding:24px;background:#25143d;">
            <img src="$_spiritUrl" width="64" height="64" alt="Pinne Ribbon Spirit"
                style="display:block;width:64px;height:64px;border:0;border-radius:16px;">
            <div style="margin-top:8px;color:#ffffff;font-family:Arial,sans-serif;font-size:28px;font-weight:700;line-height:34px;">Pinne</div>
          </td>
        </tr>
        <tr>
          <td class="copy" style="padding:34px 36px 12px;color:#261d32;font-family:Arial,sans-serif;">
            <h1 style="margin:0 0 14px;font-size:25px;line-height:32px;">${_escapeHtml(heading)}</h1>
            <p style="margin:0;font-size:16px;line-height:25px;">${_escapeHtml(introduction)}</p>
          </td>
        </tr>
        <tr>
          <td align="center" style="padding:18px 36px;">
            <div class="code" aria-label="$code"
                style="padding:18px 12px;background:#eee7f7;border-radius:14px;color:#25143d;font-family:'Courier New',monospace;font-size:30px;font-weight:700;letter-spacing:3px;line-height:38px;">$spacedCode</div>
          </td>
        </tr>
        <tr>
          <td class="muted" style="padding:4px 36px 34px;color:#665b72;font-family:Arial,sans-serif;font-size:14px;line-height:22px;">
            <p style="margin:0 0 12px;">$expiry</p>
            <p style="margin:0;">$ignore</p>
          </td>
        </tr>
        <tr>
          <td align="center" bgcolor="#25143d"
              style="padding:18px;background:#25143d;color:#ddd0ef;font-family:Arial,sans-serif;font-size:13px;line-height:20px;">
            Pinne - Save it. Come back to it.
          </td>
        </tr>
      </table>
    </td></tr>
  </table>
</body>
</html>''',
    );
  }

  static String _subjectSafe(String value) =>
      value.replaceAll(RegExp(r'[\r\n]+'), ' ').trim();

  static String _escapeHtml(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}
