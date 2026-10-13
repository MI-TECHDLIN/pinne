import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/auth/sign_out.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/capture/saved_section.dart';
import 'package:pinne_flutter/features/progress/progress_providers.dart';
import 'package:pinne_flutter/features/search/search_providers.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:sqlite3/sqlite3.dart';

import 'progress/fake_progress_api.dart';

class _SwitchingAccount extends AccountIdNotifier {
  @override
  String? build() => 'account-a';

  void switchTo(String? accountId) => state = accountId;
}

class _FakeSignedIn extends SignedInNotifier {
  var didSignOut = false;

  @override
  bool build() => true;

  @override
  Future<void> signOut() async {
    didSignOut = true;
    state = false;
  }
}

void main() {
  test('A -> signed out -> B rebuilds server-backed state', () async {
    final reports = <ProgressPeriod, ProgressReport>{
      ProgressPeriod.thisWeek: sampleReport(),
    };
    final progress = FakeProgressApi(reports);
    final container = ProviderContainer(
      overrides: [
        accountIdProvider.overrideWith(_SwitchingAccount.new),
        progressApiProvider.overrideWithValue(progress),
      ],
    );
    addTearDown(container.dispose);

    expect(
      (await container.read(progressReportProvider.future))?.savedCount,
      12,
    );
    container.read(searchQueryProvider.notifier).set('account A query');

    (container.read(accountIdProvider.notifier) as _SwitchingAccount).switchTo(
      null,
    );
    expect(await container.read(progressReportProvider.future), isNull);
    expect(container.read(searchQueryProvider), isEmpty);

    reports[ProgressPeriod.thisWeek] = sampleReport().copyWith(savedCount: 4);
    (container.read(accountIdProvider.notifier) as _SwitchingAccount).switchTo(
      'account-b',
    );
    expect(
      (await container.read(progressReportProvider.future))?.savedCount,
      4,
    );
    expect(
      progress.queries,
      hasLength(2),
      reason: 'B gets a fresh server fetch',
    );
  });

  testWidgets('Saved shows a skeleton, then only B data after switching', (
    tester,
  ) async {
    final store = CaptureStore(sqlite3.openInMemory());
    addTearDown(store.close);
    store.save(
      parseCaptureInput('A private save'),
      accountId: 'account-a',
    );
    store.save(
      parseCaptureInput('B own save'),
      accountId: 'account-b',
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          captureStoreProvider.overrideWithValue(store),
          accountIdProvider.overrideWith(_SwitchingAccount.new),
          signedInProvider.overrideWith(_FakeSignedIn.new),
          savedItemsProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: MaterialApp(
          theme: pinneDarkTheme(),
          home: const Scaffold(
            body: SingleChildScrollView(child: SavedSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('A private save'), findsOneWidget);
    expect(find.text('B own save'), findsNothing);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SavedSection)),
    );
    (container.read(accountIdProvider.notifier) as _SwitchingAccount).switchTo(
      null,
    );
    await tester.pump();
    expect(find.text('A private save'), findsNothing);
    expect(find.byKey(const ValueKey('saved-list-skeleton')), findsOneWidget);

    (container.read(accountIdProvider.notifier) as _SwitchingAccount).switchTo(
      'account-b',
    );
    await tester.pumpAndSettle();
    expect(find.text('A private save'), findsNothing);
    expect(find.text('B own save'), findsOneWidget);
  });

  testWidgets('sign-out warns and Cancel preserves the session', (
    tester,
  ) async {
    final store = CaptureStore(sqlite3.openInMemory());
    addTearDown(store.close);
    for (final title in ['one', 'two']) {
      store.save(parseCaptureInput(title), accountId: 'account-a');
    }
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          captureStoreProvider.overrideWithValue(store),
          accountIdProvider.overrideWith(_SwitchingAccount.new),
          signedInProvider.overrideWith(_FakeSignedIn.new),
        ],
        child: MaterialApp(
          theme: pinneDarkTheme(),
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => ElevatedButton(
                onPressed: () => confirmSignOut(context, ref),
                child: const Text('Sign out'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign out'));
    await tester.pumpAndSettle();
    expect(find.textContaining('2 saves have not synced yet'), findsOneWidget);
    expect(find.textContaining('they stay on this phone'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.widgetWithText(ElevatedButton, 'Sign out')),
    );
    expect(
      (container.read(signedInProvider.notifier) as _FakeSignedIn).didSignOut,
      isFalse,
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-sign-out')));
    await tester.pumpAndSettle();
    expect(
      (container.read(signedInProvider.notifier) as _FakeSignedIn).didSignOut,
      isTrue,
    );
    expect(store.outboxLength(accountId: 'account-a'), 2);
  });
}
