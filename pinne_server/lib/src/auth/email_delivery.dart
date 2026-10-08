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
  }) => _send(
    recipient: email,
    subject: 'Your Pinne verification code',
    body:
        'Your Pinne verification code is $verificationCode. '
        'It expires in 15 minutes. If you did not request this, ignore this '
        'message.',
  );

  Future<void> sendPasswordResetCode(
    Session session, {
    required String email,
    required UuidValue passwordResetRequestId,
    required String verificationCode,
    required Transaction? transaction,
  }) => _send(
    recipient: email,
    subject: 'Reset your Pinne password',
    body:
        'Your Pinne password reset code is $verificationCode. '
        'It expires in 15 minutes. If you did not request this, ignore this '
        'message.',
  );

  Future<void> _send({
    required String recipient,
    required String subject,
    required String body,
  }) async {
    final message = mailer.Message()
      ..from = mailer.Address(settings.fromEmail, settings.fromName)
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;
    await mailer.send(
      message,
      server,
      timeout: const Duration(seconds: 20),
    );
  }
}
