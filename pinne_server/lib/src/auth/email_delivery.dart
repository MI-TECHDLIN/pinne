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

  /// Loads optional SMTP settings and returns the email identity provider.
  ///
  /// Development and tests deliberately keep codes in the server console.
  /// Staging and production require SMTP; an unavailable sender fails fast so
  /// no user is left waiting for a code that was discarded.
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
    if (settings == null) {
      _available = false;
      stderr.writeln(
        'WARNING: SMTP is not configured; email registration and password '
        'reset are unavailable. Guest sign-in remains available.',
      );
      return EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _unavailableRegistration,
        sendPasswordResetVerificationCode: _unavailablePasswordReset,
      );
    }

    _available = true;
    final sender = SmtpEmailSender(settings);
    stdout.writeln(
      'Email delivery is enabled through SMTP at '
      '${settings.host}:${settings.port}.',
    );
    return EmailIdpConfigFromPasswords(
      sendRegistrationVerificationCode: sender.sendRegistrationCode,
      sendPasswordResetVerificationCode: sender.sendPasswordResetCode,
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

class SmtpEmailSender {
  SmtpEmailSender(this.settings)
    : server = SmtpServer(
        settings.host,
        port: settings.port,
        ssl: settings.ssl,
        username: settings.username,
        password: settings.password,
      );

  final SmtpSettings settings;
  final SmtpServer server;

  Future<void> sendRegistrationCode(
    Session session, {
    required String email,
    required UuidValue accountRequestId,
    required String verificationCode,
    required Transaction? transaction,
  }) {
    final content = PinneAuthEmail.registration(verificationCode);
    return _send(recipient: email, content: content);
  }

  Future<void> sendPasswordResetCode(
    Session session, {
    required String email,
    required UuidValue passwordResetRequestId,
    required String verificationCode,
    required Transaction? transaction,
  }) {
    final content = PinneAuthEmail.passwordReset(verificationCode);
    return _send(recipient: email, content: content);
  }

  Future<void> _send({
    required String recipient,
    required PinneAuthEmail content,
  }) async {
    final message = mailer.Message()
      ..from = mailer.Address(settings.fromEmail, settings.fromName)
      ..recipients.add(recipient)
      ..subject = content.subject
      ..text = content.text
      ..html = content.html;
    await mailer.send(message, server, timeout: const Duration(seconds: 20));
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
