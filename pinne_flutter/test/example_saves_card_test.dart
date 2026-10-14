import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/features/examples/example_saves.dart';
import 'package:pinne_flutter/features/settings/account_kind_provider.dart';

import 'support/golden_theme.dart';

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('an empty guest account offers clearly labelled examples', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountKindProvider.overrideWith((ref) async => AccountKind.guest),
          exampleSavesStatusProvider.overrideWith(
            (ref) async => ExampleSavesStatus(
              totalItemCount: 0,
              exampleItemCount: 0,
              exampleCollectionCount: 0,
            ),
          ),
        ],
        child: MaterialApp(
          theme: goldenTheme(),
          home: const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: ExampleSavesCard(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('EXAMPLE'), findsOneWidget);
    expect(find.text('Load a few example saves to explore'), findsOneWidget);
    expect(find.byKey(const ValueKey('load-example-saves')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('dismiss-example-saves')));
    await tester.pump();
    expect(find.byKey(const ValueKey('example-saves-card')), findsNothing);
  });

  for (final kind in [AccountKind.registered, AccountKind.signedOut]) {
    testWidgets('an empty ${kind.name} account is not offered examples', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accountKindProvider.overrideWith((ref) async => kind),
            exampleSavesStatusProvider.overrideWith(
              (ref) async => ExampleSavesStatus(
                totalItemCount: 0,
                exampleItemCount: 0,
                exampleCollectionCount: 0,
              ),
            ),
          ],
          child: MaterialApp(
            theme: goldenTheme(),
            home: const Scaffold(body: ExampleSavesCard()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('example-saves-card')), findsNothing);
      expect(find.text('Load a few example saves to explore'), findsNothing);
    });
  }

  testWidgets('loaded examples expose a remove action', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          exampleSavesStatusProvider.overrideWith(
            (ref) async => ExampleSavesStatus(
              totalItemCount: 6,
              exampleItemCount: 6,
              exampleCollectionCount: 2,
            ),
          ),
        ],
        child: MaterialApp(
          theme: goldenTheme(),
          home: const Scaffold(body: ExampleSavesCard()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('6 clearly labelled examples are in your account.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('remove-example-saves')), findsOneWidget);
  });
}
