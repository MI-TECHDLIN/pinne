import 'dart:async';
import 'dart:math';

import 'package:pinne_client/pinne_client.dart';

import 'capture_store.dart';

/// The server side of capture sync, so tests can use a fake server.
abstract interface class CaptureApi {
  Future<CaptureResult> capture(CaptureDraft draft);

  /// Calls [onOnline] when the device regains a connection. Returns a
  /// function that stops listening.
  VoidCallback watchConnectivity(VoidCallback onOnline);
}

class ServerCaptureApi implements CaptureApi {
  ServerCaptureApi(this._client);

  final Client _client;

  @override
  Future<CaptureResult> capture(CaptureDraft draft) =>
      _client.item.capture(draft);

  @override
  VoidCallback watchConnectivity(VoidCallback onOnline) {
    final monitor = _client.connectivityMonitor;
    if (monitor == null) return () {};
    void listener(bool connected) {
      if (connected) onOnline();
    }

    monitor.addListener(listener);
    return () => monitor.removeListener(listener);
  }
}

/// Exponential backoff with jitter, capped.
@immutable
class BackoffPolicy {
  const BackoffPolicy({
    this.base = const Duration(seconds: 2),
    this.max = const Duration(minutes: 10),
  });

  final Duration base;
  final Duration max;

  /// The wait after the [attempts]th failure. [jitter] in `[0, 1)` spreads
  /// the wait over its upper half so many phones do not retry in step.
  Duration delay(int attempts, double jitter) {
    final exponent = (attempts - 1).clamp(0, 20);
    final full = base * pow(2, exponent).toDouble();
    final capped = full > max ? max : full;
    return capped * (0.5 + jitter.clamp(0, 1) / 2);
  }
}

/// How a failed send is treated.
enum SyncFailure {
  /// The request may not have arrived: retry the same operation later.
  retry,

  /// Nobody is signed in: wait for sign-in, do not count an attempt.
  signedOut,

  /// The server understood and refused it: park it for the user.
  rejected,
}

SyncFailure classifySyncError(Object error) => switch (error) {
  ValidationException() ||
  RecordNotFoundException() ||
  ServerpodClientBadRequest() => SyncFailure.rejected,
  ServerpodClientUnauthorized() ||
  ServerpodClientForbidden() => SyncFailure.signedOut,
  _ => SyncFailure.retry,
};

/// Sends queued captures in order, one at a time.
///
/// An operation leaves the outbox only after the server confirms it. A
/// failure that might be transient schedules a retry with backoff and stops
/// the pass, since the next operation would most likely fail the same way.
/// Calls are single-flight: a [drain] during a pass makes the pass run once
/// more instead of starting a second one.
class OutboxSync {
  OutboxSync({
    required this.store,
    required this.api,
    required this.canSync,
    this.backoff = const BackoffPolicy(),
    DateTime Function()? clock,
    double Function()? jitter,
  }) : _clock = clock ?? (() => DateTime.now().toUtc()),
       _jitter = jitter ?? Random().nextDouble;

  final CaptureStore store;
  final CaptureApi api;

  /// Whether a user is signed in. Captures wait locally while it is false.
  final bool Function() canSync;
  final BackoffPolicy backoff;
  final DateTime Function() _clock;
  final double Function() _jitter;

  Future<int>? _running;
  bool _again = false;
  bool _disposed = false;
  Timer? _timer;

  /// Sends every due operation. Completes with how many were confirmed.
  Future<int> drain() {
    if (_disposed) return Future.value(0);
    final running = _running;
    if (running != null) {
      _again = true;
      return running;
    }
    final pass = _drain().whenComplete(() => _running = null);
    _running = pass;
    return pass;
  }

  Future<int> _drain() async {
    var confirmed = 0;
    do {
      _again = false;
      if (!canSync()) break;
      store.releaseStaleHolds(now: _clock());
      for (final operation in store.dueOperations(_clock())) {
        if (_disposed) return confirmed;
        try {
          final result = await api.capture(operation.draft);
          store.confirm(operation.operationId, result);
          confirmed++;
        } on Exception catch (error) {
          switch (classifySyncError(error)) {
            case SyncFailure.rejected:
              store.markFailed(operation.operationId, _describe(error));
              continue;
            case SyncFailure.signedOut:
              // Wait for the next sign-in to call drain again.
              _again = false;
              _timer?.cancel();
              return confirmed;
            case SyncFailure.retry:
              final attempts = operation.attempts + 1;
              store.scheduleRetry(
                operation.operationId,
                attempts: attempts,
                nextAttemptAt: _clock().add(backoff.delay(attempts, _jitter())),
                error: _describe(error),
              );
          }
          break;
        }
      }
    } while (_again && !_disposed);
    _scheduleNext();
    return confirmed;
  }

  void _scheduleNext() {
    _timer?.cancel();
    _timer = null;
    final next = store.nextDueAt();
    if (_disposed || next == null || !canSync()) return;
    final wait = next.difference(_clock());
    _timer = Timer(wait.isNegative ? Duration.zero : wait, drain);
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
  }

  static String _describe(Exception error) => switch (error) {
    ValidationException(:final message) => message,
    RecordNotFoundException() => 'A chosen collection no longer exists.',
    ServerpodClientException(:final message) => message,
    _ => error.toString(),
  };
}
