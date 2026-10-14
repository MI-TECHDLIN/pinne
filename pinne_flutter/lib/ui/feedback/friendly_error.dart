import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

/// Why something failed, in the terms a person can act on.
enum ErrorCause {
  /// No connection, a timeout, or the server could not be reached at all.
  offline,

  /// The server answered but could not do its part.
  server,

  /// The session ended or never started.
  signedOut,

  /// The thing is gone, or belongs to someone else (they look the same).
  notFound,

  /// The server refused the request and said why in plain words.
  rejected,

  /// The email and password did not match.
  credentials,

  /// Rate limited: too many attempts in a short time.
  tooManyAttempts,

  /// Anything else. Never shown as raw text.
  unknown,
}

/// A failure described for people: what happened, what to do, and how it
/// should look. Build one with [FriendlyError.from]; never show
/// `error.toString()` to users.
@immutable
class FriendlyError {
  const FriendlyError({
    required this.cause,
    required this.title,
    required this.message,
    required this.hint,
    this.canRetry = true,
  });

  /// Maps any exception to plain language. [subject] names what was being
  /// loaded, such as "your queue", and appears in the longer [message].
  factory FriendlyError.from(Object? error, {String subject = 'this'}) {
    if (_emailFlowError(_unwrap(error)) case final emailFlow?) {
      return emailFlow;
    }
    final cause = errorCauseOf(error);
    final serverMessage = _serverMessage(error);
    return switch (cause) {
      ErrorCause.offline => FriendlyError(
        cause: cause,
        title: 'You seem to be offline',
        message:
            'Pinne could not reach the server to load $subject. Anything you '
            'saved is still on this phone. Check your connection and try '
            'again.',
        hint: 'Check your connection and try again.',
      ),
      ErrorCause.server => FriendlyError(
        cause: cause,
        title: 'Pinne is having a moment',
        message:
            'The server could not load $subject right now. Nothing is lost. '
            'Try again in a minute.',
        hint: 'The server is busy. Try again in a minute.',
      ),
      ErrorCause.signedOut => const FriendlyError(
        cause: ErrorCause.signedOut,
        title: 'Please sign in again',
        message:
            'Your session ended. Sign in from Settings and everything will be '
            'where you left it.',
        hint: 'Sign in again from Settings to continue.',
        canRetry: false,
      ),
      ErrorCause.notFound => const FriendlyError(
        cause: ErrorCause.notFound,
        title: 'That is no longer here',
        message:
            'It may have been removed on another device. Refresh to see '
            'what is current.',
        hint: 'It may have been removed elsewhere.',
      ),
      ErrorCause.rejected => FriendlyError(
        cause: cause,
        title: 'That did not go through',
        message: serverMessage ?? 'Pinne could not accept that request.',
        hint: serverMessage ?? 'Pinne could not accept that request.',
        canRetry: false,
      ),
      ErrorCause.credentials => const FriendlyError(
        cause: ErrorCause.credentials,
        title: 'That email or password did not match',
        message: 'Check both and try again, or reset your password.',
        hint: 'Check your email and password, then try again.',
      ),
      ErrorCause.tooManyAttempts => const FriendlyError(
        cause: ErrorCause.tooManyAttempts,
        title: 'Too many tries for now',
        message:
            'For your safety Pinne paused this. Wait a few minutes, then '
            'try again.',
        hint: 'Wait a few minutes, then try again.',
      ),
      ErrorCause.unknown => FriendlyError(
        cause: cause,
        title: 'Something went wrong',
        message:
            'Pinne could not load $subject. Try again, and if it keeps '
            'happening, close and reopen the app.',
        hint: 'Please try again.',
      ),
    };
  }

  final ErrorCause cause;

  /// What happened, in a few words.
  final String title;

  /// What happened and what to do, for cards and full-screen states.
  final String message;

  /// A short what-to-do line, for toasts after a named action.
  final String hint;

  /// Whether trying the same thing again can help.
  final bool canRetry;

  IconData get icon => switch (cause) {
    ErrorCause.offline => Icons.wifi_off_rounded,
    ErrorCause.server => Icons.cloud_off_rounded,
    ErrorCause.signedOut => Icons.lock_outline_rounded,
    ErrorCause.notFound => Icons.search_off_rounded,
    ErrorCause.rejected => Icons.block_rounded,
    ErrorCause.credentials => Icons.key_off_rounded,
    ErrorCause.tooManyAttempts => Icons.hourglass_bottom_rounded,
    ErrorCause.unknown => Icons.error_outline_rounded,
  };

  /// The Ribbon Spirit pose that fits this failure.
  String get art => switch (cause) {
    ErrorCause.offline ||
    ErrorCause.server ||
    ErrorCause.tooManyAttempts => 'assets/art/cutout/ribbon_spirit_sleepy.webp',
    ErrorCause.signedOut ||
    ErrorCause.credentials => 'assets/art/cutout/ribbon_spirit_idle.webp',
    _ => 'assets/art/cutout/ribbon_spirit_search_no_results.webp',
  };

  /// One toast line for a failed action, such as "Could not archive it".
  String toast(String failedAction) => '$failedAction. $hint';
}

/// Classifies an exception. Errors wrapped by the auth widgets are unwrapped
/// first so a network failure during sign-in still reads as offline.
ErrorCause errorCauseOf(Object? error) {
  final unwrapped = _unwrap(error);
  return switch (unwrapped) {
    ServerpodClientNetworkException() ||
    TimeoutException() ||
    MethodStreamException() => ErrorCause.offline,
    ServerpodClientUnauthorized() ||
    ServerpodClientForbidden() => ErrorCause.signedOut,
    ServerpodClientInternalServerError() ||
    ServerpodClientNotFound() => ErrorCause.server,
    ServerpodClientUnknownHttpException(:final statusCode)
        when statusCode == 429 =>
      ErrorCause.tooManyAttempts,
    ServerpodClientUnknownHttpException(:final statusCode)
        when statusCode >= 500 =>
      ErrorCause.server,
    RecordNotFoundException() => ErrorCause.notFound,
    ValidationException() ||
    PlanningException() ||
    CalendarRouteException() ||
    ServerpodClientBadRequest() => ErrorCause.rejected,
    EmailAccountLoginException(:final reason) => switch (reason) {
      EmailAccountLoginExceptionReason.invalidCredentials =>
        ErrorCause.credentials,
      EmailAccountLoginExceptionReason.tooManyAttempts =>
        ErrorCause.tooManyAttempts,
      EmailAccountLoginExceptionReason.unknown => ErrorCause.unknown,
    },
    EmailAccountRequestException(:final reason) => switch (reason) {
      EmailAccountRequestExceptionReason.tooManyAttempts =>
        ErrorCause.tooManyAttempts,
      EmailAccountRequestExceptionReason.unknown => ErrorCause.server,
      _ => ErrorCause.rejected,
    },
    EmailAccountPasswordResetException(:final reason) => switch (reason) {
      EmailAccountPasswordResetExceptionReason.tooManyAttempts =>
        ErrorCause.tooManyAttempts,
      EmailAccountPasswordResetExceptionReason.unknown => ErrorCause.server,
      _ => ErrorCause.rejected,
    },
    AnonymousAccountBlockedException(:final reason) => switch (reason) {
      AnonymousAccountBlockedExceptionReason.tooManyAttempts =>
        ErrorCause.tooManyAttempts,
      AnonymousAccountBlockedExceptionReason.denied => ErrorCause.rejected,
    },
    _ => ErrorCause.unknown,
  };
}

/// Sign-up and password-reset failures, said in terms of the step the person
/// is on. Too many attempts keeps the shared wording.
FriendlyError? _emailFlowError(Object? error) {
  const sendFailed = FriendlyError(
    cause: ErrorCause.server,
    title: 'We could not send your code',
    message:
        'Pinne could not email your code just now. Nothing was created. Try '
        'again in a few minutes, or keep using Pinne as a guest.',
    hint: 'Try again in a few minutes, or keep using Pinne as a guest.',
  );
  const codeMismatch = FriendlyError(
    cause: ErrorCause.rejected,
    title: 'That code is not active',
    message:
        'Check the latest Pinne email, or resend the code. If you already '
        'created this account, sign in instead.',
    hint: 'Use the latest code, resend it, or sign in instead.',
  );
  const codeExpired = FriendlyError(
    cause: ErrorCause.rejected,
    title: 'That code has expired',
    message: 'Codes last 15 minutes. Resend the code and try again.',
    hint: 'Resend the code and try again.',
    canRetry: false,
  );
  const passwordRule = 'Passwords cannot start or end with a space.';
  return switch (error) {
    EmailAccountRequestException(:final reason) => switch (reason) {
      EmailAccountRequestExceptionReason.unknown => sendFailed,
      EmailAccountRequestExceptionReason.invalid => codeMismatch,
      EmailAccountRequestExceptionReason.expired => codeExpired,
      EmailAccountRequestExceptionReason.policyViolation => const FriendlyError(
        cause: ErrorCause.rejected,
        title: 'Check the password spacing',
        message: passwordRule,
        hint: passwordRule,
        canRetry: false,
      ),
      EmailAccountRequestExceptionReason.tooManyAttempts => null,
    },
    EmailAccountPasswordResetException(:final reason) => switch (reason) {
      EmailAccountPasswordResetExceptionReason.unknown => const FriendlyError(
        cause: ErrorCause.server,
        title: 'We could not send your code',
        message:
            'Pinne could not email your reset code just now. Try again in a '
            'few minutes.',
        hint: 'Try again in a few minutes.',
      ),
      EmailAccountPasswordResetExceptionReason.invalid => codeMismatch,
      EmailAccountPasswordResetExceptionReason.expired => codeExpired,
      EmailAccountPasswordResetExceptionReason.policyViolation =>
        const FriendlyError(
          cause: ErrorCause.rejected,
          title: 'Choose a different password',
          message: passwordRule,
          hint: passwordRule,
          canRetry: false,
        ),
      EmailAccountPasswordResetExceptionReason.tooManyAttempts => null,
    },
    _ => null,
  };
}

/// Messages Pinne's own server writes for people. Never framework text.
String? _serverMessage(Object? error) => switch (_unwrap(error)) {
  ValidationException(:final message) ||
  PlanningException(:final message) ||
  CalendarRouteException(
    :final message,
  ) when message.trim().isNotEmpty => message.trim(),
  _ => null,
};

/// The auth widgets hand `onError` a `UserFacingException` that their package
/// does not export; its `originalException` carries the real cause.
Object? _unwrap(Object? error) {
  if (error == null) return null;
  try {
    final original = (error as dynamic).originalException;
    if (original is Object) return original;
  } on NoSuchMethodError {
    // Not a wrapper.
  }
  return error;
}
