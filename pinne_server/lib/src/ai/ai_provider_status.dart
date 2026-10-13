import 'dart:io';

/// The last remote AI outcome of this server process, for operators.
///
/// Production disables console session logs, so `session.log` warnings never
/// reach `serverpod cloud log`. Failures are therefore also written to stderr.
/// Lines and [describe] name the provider and failure class or HTTP status
/// only: never a key, a prompt, a response body or any saved-item content.
abstract final class AiProviderStatus {
  /// Where operator lines go. Tests replace it to capture them.
  static void Function(String line) sink = stderr.writeln;

  static String? _provider;
  static String? _failure;
  static DateTime? _at;

  static void recordSuccess(String provider) {
    _provider = provider;
    _failure = null;
    _at = DateTime.now().toUtc();
  }

  static void recordFailure(String provider, String reason) {
    _provider = provider;
    _failure = reason;
    _at = DateTime.now().toUtc();
    sink(
      'AI organizing: $provider failed, organized with rules instead: '
      '$reason',
    );
  }

  /// Logs work that failed outside a provider call, such as a task crash.
  static void recordTaskError(String reason) =>
      sink('AI organizing: task failed: $reason');

  /// One line, such as `groq: last call failed at <time>: Groq returned
  /// HTTP 401 (invalid_api_key).`
  static String describe({required String? configuredProvider}) {
    if (configuredProvider == null) {
      return 'rules: no remote AI provider is configured.';
    }
    final at = _at;
    if (at == null || _provider != configuredProvider) {
      return '$configuredProvider: not called since this server started.';
    }
    final failure = _failure;
    return failure == null
        ? '$configuredProvider: last call succeeded at '
              '${at.toIso8601String()}.'
        : '$configuredProvider: last call failed at '
              '${at.toIso8601String()}: $failure';
  }

  static void resetForTest() {
    _provider = null;
    _failure = null;
    _at = null;
    sink = stderr.writeln;
  }
}
