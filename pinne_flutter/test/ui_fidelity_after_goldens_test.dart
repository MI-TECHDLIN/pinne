import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/collections/collections_screen.dart';
import 'package:pinne_flutter/features/search/search_providers.dart';
import 'package:pinne_flutter/features/search/search_screen.dart';
import 'package:pinne_flutter/features/settings/profile_provider.dart';
import 'package:pinne_flutter/features/today/today_providers.dart';
import 'package:pinne_flutter/features/today/today_screen.dart';
import 'package:pinne_flutter/shell/pill_nav_bar.dart';
import 'package:pinne_flutter/ui/motion.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'support/golden_theme.dart';

class _SignedOut extends SignedInNotifier {
  @override
  bool build() => false;
}

class _FakeSearchQuery extends SearchQuery {
  @override
  String build() => 'desktop sidebar from X';
}

class _FakeSearchResults extends SearchResults {
  _FakeSearchResults(this.result);

  final SearchResult result;

  @override
  Future<SearchPage> build() async => SearchPage(results: [result]);
}

void main() {
  setUpAll(loadGoldenFonts);
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  final owner = UuidValue.fromString('00000000-0000-4000-8000-000000000001');
  final item = Item(
    id: UuidValue.fromString('00000000-0000-4000-8000-000000000002'),
    ownerId: owner,
    url: 'https://example.com/fake-flutter-sidebar',
    sourcePlatform: SourcePlatform.x,
    title: 'Flutter desktop sidebar patterns',
    contentType: ContentType.post,
    intention: 'Try this navigation pattern in the demo dashboard',
    savedAt: DateTime.utc(2026, 10, 5),
    durationSeconds: 420,
  );
  final searchResult = SearchResult(
    item: item,
    score: 1,
    evidence: [
      SearchEvidence(
        field: 'saved note',
        snippet: 'navigation pattern in the demo dashboard',
      ),
    ],
  );

  Widget screen(
    Widget child, {
    bool withTodayData = false,
    bool withSearchData = false,
  }) => ProviderScope(
    overrides: [
      signedInProvider.overrideWith(_SignedOut.new),
      captureStoreProvider.overrideWithValue(
        CaptureStore(sqlite3.openInMemory()),
      ),
      if (withTodayData) ...[
        todayClockProvider.overrideWithValue(DateTime(2026, 10, 7, 17, 30)),
        profileProvider.overrideWith(
          (_) async => PinneProfile(
            ownerId: owner,
            displayName: 'Demo Friend',
            avatarSeed: 42,
            avatarPalette: 0,
          ),
        ),
        todayQueueProvider.overrideWith(
          (_) async => ReviewQueueResult(
            entries: [
              ReviewQueueEntry(
                item: item,
                dueAt: DateTime.utc(2026, 10, 7, 16),
                overdueMinutes: 90,
                estimatedMinutes: 7,
                selectionReason: 'Due for review',
              ),
              ReviewQueueEntry(
                item: item.copyWith(
                  id: UuidValue.fromString(
                    '00000000-0000-4000-8000-000000000003',
                  ),
                  title: 'Adaptive navigation notes',
                ),
                dueAt: DateTime.utc(2026, 10, 7, 16, 30),
                overdueMinutes: 60,
                estimatedMinutes: 3,
                selectionReason: 'Due for review',
              ),
            ],
            timeBudgetMinutes: 10,
            eligibleCount: 2,
          ),
        ),
        todayOverviewProvider.overrideWith(
          (_) async => const TodayOverview(),
        ),
      ],
      if (withSearchData) ...[
        searchQueryProvider.overrideWith(_FakeSearchQuery.new),
        searchPageProvider.overrideWith(
          () => _FakeSearchResults(searchResult),
        ),
      ],
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: goldenTheme(),
      home: MotionPreferenceScope(
        preference: MotionPreference.reduced,
        child: Scaffold(body: child),
      ),
    ),
  );

  Future<void> capture(
    WidgetTester tester,
    Widget child,
    String name, {
    bool withTodayData = false,
    bool withSearchData = false,
  }) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      screen(
        child,
        withTodayData: withTodayData,
        withSearchData: withSearchData,
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(
      find.byType(Scaffold).first,
      matchesGoldenFile('../../docs/ui-fidelity/after-$name.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  }

  testWidgets(
    'Today after',
    (tester) => capture(
      tester,
      const TodayScreen(),
      'today',
      withTodayData: true,
    ),
  );

  testWidgets(
    'Collections after',
    (tester) => capture(
      tester,
      const CollectionsScreen(),
      'collections',
    ),
  );

  testWidgets('Search after', (tester) async {
    await capture(
      tester,
      const SearchScreen(),
      'search',
      withSearchData: true,
    );
  });

  testWidgets(
    'Nav after',
    (tester) => capture(
      tester,
      Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          minimum: const EdgeInsets.only(bottom: 14),
          child: PillNavBar(
            destinations: const [
              PillNavDestination(label: 'Today', icon: Icons.wb_sunny_outlined),
              PillNavDestination(
                label: 'Collections',
                icon: Icons.grid_view_rounded,
              ),
              PillNavDestination(label: 'Search', icon: Icons.search_rounded),
              PillNavDestination(
                label: 'Progress',
                icon: Icons.donut_large_rounded,
              ),
              PillNavDestination(label: 'Settings', icon: Icons.tune_rounded),
            ],
            selectedIndex: 0,
            onSelected: (_) {},
          ),
        ),
      ),
      'nav',
    ),
  );
}
