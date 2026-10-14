import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/search/search_providers.dart';
import 'package:pinne_flutter/features/search/search_history.dart';
import 'package:pinne_flutter/features/search/search_screen.dart';
import 'package:pinne_flutter/features/today/today_screen.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';
import 'package:pinne_flutter/ui/ribbon_spirit/ribbon_spirit.dart';

class _SignedOut extends SignedInNotifier {
  @override
  bool build() => false;
}

void main() {
  final ownerId = UuidValue.fromString('00000000-0000-4000-8000-000000000001');
  final itemId = UuidValue.fromString('00000000-0000-4000-8000-000000000002');
  final item = Item(
    id: itemId,
    ownerId: ownerId,
    url: 'https://x.com/example/status/1',
    sourcePlatform: SourcePlatform.x,
    title: 'Flutter desktop sidebar',
    contentType: ContentType.post,
    intention: 'Try this navigation pattern in my dashboard',
    savedAt: DateTime.utc(2026, 10, 5),
  );

  Widget themed(Widget child) => ProviderScope(
    child: MaterialApp(
      theme: pinneDarkTheme(),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );

  testWidgets('Today exposes honest quick outcomes', (tester) async {
    final calls = <String>[];
    await tester.pumpWidget(
      themed(
        TodaySpiritCard(
          due: true,
          seed: 42,
          palette: 0,
          animate: false,
          entry: ReviewQueueEntry(
            item: item,
            dueAt: DateTime.utc(2026, 10, 6),
            overdueMinutes: 60,
            estimatedMinutes: 5,
            selectionReason: 'Due for review · about 5 min (estimate)',
          ),
          onReviewed: () => calls.add('reviewed'),
          onRemindLater: () => calls.add('snoozed'),
          onArchive: () => calls.add('archived'),
          onOpen: () => calls.add('opened'),
        ),
      ),
    );

    expect(find.text('DUE NOW · 5 MIN EST.'), findsOneWidget);
    expect(find.textContaining('Try this navigation pattern'), findsOneWidget);
    for (final label in ['Reviewed', 'Remind me later', 'Archive']) {
      await tester.tap(find.text(label));
      await tester.pump();
    }
    await tester.tap(find.byKey(const ValueKey('review-open')));
    await tester.pump();
    expect(calls, ['reviewed', 'snoozed', 'archived', 'opened']);
  });

  testWidgets('Today says when the next save comes back', (tester) async {
    await tester.pumpWidget(
      themed(
        TodaySpiritCard(
          due: false,
          seed: 42,
          palette: 0,
          animate: false,
          now: DateTime.utc(2026, 10, 14, 9),
          nextDueAt: DateTime.utc(2026, 10, 14, 12),
        ),
      ),
    );

    expect(find.text('Your next save comes back in 3 h.'), findsOneWidget);
  });

  testWidgets('Search result explains the match and opens', (tester) async {
    var opened = false;
    await tester.pumpWidget(
      themed(
        SearchResultCard(
          result: SearchResult(
            item: item,
            score: 1,
            evidence: [
              SearchEvidence(
                field: 'saved note',
                snippet: 'Try this navigation pattern in my dashboard',
              ),
            ],
          ),
          color: PinneColors.lilac,
          onOpen: () => opened = true,
        ),
      ),
    );

    expect(find.text('X · Post'), findsOneWidget);
    expect(find.textContaining('Your note:'), findsOneWidget);
    expect(find.textContaining('Matched saved note:'), findsOneWidget);
    await tester.tap(find.text('Flutter desktop sidebar'));
    expect(opened, isTrue);
  });

  testWidgets('Search field debounces and empty state is sleepy', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [signedInProvider.overrideWith(_SignedOut.new)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: pinneDarkTheme(),
          home: const Scaffold(body: SearchScreen()),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.widget<RibbonSpirit>(find.byType(RibbonSpirit)).mood,
      RibbonMood.sleepy,
    );
    await tester.enterText(
      find.byKey(const ValueKey('search-field')),
      '  desktop sidebar from X  ',
    );
    await tester.pump(const Duration(milliseconds: 349));
    expect(container.read(searchQueryProvider), isEmpty);
    await tester.pump(const Duration(milliseconds: 2));
    expect(container.read(searchQueryProvider), 'desktop sidebar from X');
  });

  testWidgets('recent searches can be repeated, removed, and cleared', (
    tester,
  ) async {
    final store = MemorySearchHistoryStore(['Newest search', 'Older search']);
    final container = ProviderContainer(
      overrides: [
        signedInProvider.overrideWith(_SignedOut.new),
        searchHistoryStoreProvider.overrideWithValue(store),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: pinneDarkTheme(),
          home: const Scaffold(body: SearchScreen()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('Stored only on this device.'), findsOneWidget);
    await tester.tap(find.text('Older search'));
    await tester.pump();
    expect(container.read(searchQueryProvider), 'Older search');
    expect(container.read(searchHistoryProvider).first, 'Older search');

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    await tester.tap(
      find.byTooltip('Remove Older search from recent searches'),
    );
    await tester.pump();
    expect(find.text('Older search'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('clear-search-history')));
    await tester.pumpAndSettle();
    expect(find.text('Clear recent searches?'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('confirm-clear-search-history')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Recent searches'), findsNothing);
    expect(store.searches, isEmpty);
  });
}
