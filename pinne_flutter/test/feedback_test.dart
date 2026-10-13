import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/ui/feedback/error_state.dart';
import 'package:pinne_flutter/ui/feedback/friendly_error.dart';
import 'package:pinne_flutter/ui/feedback/toast.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import 'support/golden_theme.dart';

/// Stands in for the auth widgets' unexported `UserFacingException`.
class _Wrapped implements Exception {
  _Wrapped(this.originalException);
  final Object originalException;
  @override
  String toString() => 'Wrapped: $originalException';
}

void main() {
  group('error mapping', () {
    final cases = <Object, ErrorCause>{
      const ServerpodClientNetworkException('SocketException: errno 111'):
          ErrorCause.offline,
      TimeoutException('slow'): ErrorCause.offline,
      ServerpodClientUnauthorized(): ErrorCause.signedOut,
      ServerpodClientForbidden(): ErrorCause.signedOut,
      ServerpodClientInternalServerError(): ErrorCause.server,
      ServerpodClientUnknownHttpException('busy', 503): ErrorCause.server,
      ServerpodClientUnknownHttpException('slow down', 429):
          ErrorCause.tooManyAttempts,
      RecordNotFoundException(resource: 'item'): ErrorCause.notFound,
      ValidationException(message: 'Titles can be 200 characters at most.'):
          ErrorCause.rejected,
      EmailAccountLoginException(
        reason: EmailAccountLoginExceptionReason.invalidCredentials,
      ): ErrorCause.credentials,
      EmailAccountLoginException(
        reason: EmailAccountLoginExceptionReason.tooManyAttempts,
      ): ErrorCause.tooManyAttempts,
      EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.unknown,
      ): ErrorCause.server,
      EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      ): ErrorCause.rejected,
      EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.expired,
      ): ErrorCause.rejected,
      EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.policyViolation,
      ): ErrorCause.rejected,
      EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.tooManyAttempts,
      ): ErrorCause.tooManyAttempts,
      EmailAccountPasswordResetException(
        reason: EmailAccountPasswordResetExceptionReason.unknown,
      ): ErrorCause.server,
      EmailAccountPasswordResetException(
        reason: EmailAccountPasswordResetExceptionReason.policyViolation,
      ): ErrorCause.rejected,
      _Wrapped(const ServerpodClientNetworkException('down')):
          ErrorCause.offline,
      StateError('Bad state: no element'): ErrorCause.unknown,
    };
    for (final MapEntry(key: error, value: cause) in cases.entries) {
      test('${error.runtimeType} reads as ${cause.name}', () {
        expect(errorCauseOf(error), cause);
      });
    }

    test('never shows raw exception text', () {
      for (final error in cases.keys) {
        final friendly = FriendlyError.from(error, subject: 'your queue');
        for (final text in [friendly.title, friendly.message, friendly.hint]) {
          expect(text, isNot(contains('Exception')), reason: '$error');
          expect(text, isNot(contains('errno')), reason: '$error');
          expect(text, isNot(contains('Bad state')), reason: '$error');
          expect(text, isNot(contains('statusCode')), reason: '$error');
        }
      }
    });

    test("the server's own human message is kept for refusals", () {
      final friendly = FriendlyError.from(
        ValidationException(message: 'Titles can be 200 characters at most.'),
      );
      expect(friendly.message, 'Titles can be 200 characters at most.');
      expect(friendly.canRetry, isFalse);
    });

    test('sign-up failures name the step, not a busy server', () {
      String titleOf(EmailAccountRequestExceptionReason reason) =>
          FriendlyError.from(
            _Wrapped(EmailAccountRequestException(reason: reason)),
          ).title;

      expect(
        titleOf(EmailAccountRequestExceptionReason.unknown),
        'We could not send your code',
      );
      expect(
        titleOf(EmailAccountRequestExceptionReason.invalid),
        'That code did not match',
      );
      expect(
        titleOf(EmailAccountRequestExceptionReason.expired),
        'That code has expired',
      );
      expect(
        FriendlyError.from(
          EmailAccountRequestException(
            reason: EmailAccountRequestExceptionReason.policyViolation,
          ),
        ).hint,
        contains('at least 8 characters'),
      );
      expect(
        titleOf(EmailAccountRequestExceptionReason.tooManyAttempts),
        'Too many tries for now',
      );
    });

    test('offline loads say saves are safe on the phone', () {
      final friendly = FriendlyError.from(
        const ServerpodClientNetworkException('down'),
        subject: 'your queue',
      );
      expect(friendly.title, 'You seem to be offline');
      expect(friendly.message, contains('your queue'));
      expect(friendly.message, contains('still on this phone'));
    });
  });

  group('error surfaces', () {
    setUpAll(loadGoldenFonts);

    Widget host(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: goldenTheme(),
      home: Scaffold(
        body: SafeArea(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );

    testWidgets('the error card explains and retries', (tester) async {
      var retried = 0;
      await tester.pumpWidget(
        host(
          PinneErrorCard(
            error: const ServerpodClientNetworkException('SocketException'),
            subject: 'your collections',
            onRetry: () => retried++,
          ),
        ),
      );
      expect(find.text('You seem to be offline'), findsOneWidget);
      expect(find.textContaining('SocketException'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('error-retry')));
      expect(retried, 1);
    });

    testWidgets('the error card stacks on narrow screens', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(() {
        tester.binding.setSurfaceSize(null);
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });
      await tester.pumpWidget(
        host(
          SingleChildScrollView(
            child: PinneErrorCard(
              error: ServerpodClientInternalServerError(),
              onRetry: () {},
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Pinne is having a moment'), findsOneWidget);
    });

    testWidgets('toasts replace the grey bar and keep their action', (
      tester,
    ) async {
      var undone = false;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showPinneToast(
                context,
                'Counted as reviewed.',
                kind: ToastKind.success,
                actionLabel: 'Undo',
                onAction: () => undone = true,
              ),
              child: const Text('go'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('pinne-toast-success')), findsOneWidget);
      expect(
        tester.widget<SnackBar>(find.byType(SnackBar)).behavior,
        SnackBarBehavior.floating,
      );
      await tester.tap(find.byKey(const ValueKey('pinne-toast-action')));
      await tester.pumpAndSettle();
      expect(undone, isTrue);
    });

    testWidgets('an error toast names the action and the fix', (tester) async {
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showErrorToast(
                context,
                const ServerpodClientNetworkException('errno 111'),
                'Could not archive it',
              ),
              child: const Text('go'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Could not archive it. Check your connection and try again.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('errno'), findsNothing);
    });

    testWidgets('error states render for review', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => Column(
              children: [
                PinneErrorCard(
                  error: const ServerpodClientNetworkException('down'),
                  subject: 'your queue',
                  onRetry: () {},
                ),
                const SizedBox(height: 16),
                PinneErrorCard(
                  error: ServerpodClientInternalServerError(),
                  subject: 'your collections',
                  onRetry: () {},
                ),
                const SizedBox(height: 16),
                const PinneToastBody(
                  message: 'Counted as reviewed.',
                  kind: ToastKind.success,
                  actionLabel: 'Undo',
                ),
                const SizedBox(height: 8),
                const PinneToastBody(
                  message: 'Kept on this phone; it syncs when you are online.',
                  kind: ToastKind.info,
                ),
                const SizedBox(height: 8),
                const PinneToastBody(
                  message:
                      'Could not archive it. Check your connection and try '
                      'again.',
                  kind: ToastKind.error,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('../../docs/errors/cards-and-toasts.png'),
      );

      await tester.pumpWidget(
        host(
          PinneErrorState(
            error: const ServerpodClientNetworkException('down'),
            subject: 'your planner',
            onRetry: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('../../docs/errors/full-screen.png'),
      );
    });
  });
}
