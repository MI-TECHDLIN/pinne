import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/capture/capture_store.dart';
import 'package:pinne_flutter/features/collections/collections_screen.dart';
import 'package:pinne_flutter/features/search/search_screen.dart';
import 'package:pinne_flutter/features/today/today_screen.dart';
import 'package:pinne_flutter/shell/pill_nav_bar.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'support/golden_theme.dart';

class _SignedOut extends SignedInNotifier {
  @override
  bool build() => false;
}

void main() {
  setUpAll(loadGoldenFonts);
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  Widget screen(Widget child) => ProviderScope(
    overrides: [
      signedInProvider.overrideWith(_SignedOut.new),
      captureStoreProvider.overrideWithValue(
        CaptureStore(sqlite3.openInMemory()),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: goldenTheme(),
      home: Scaffold(body: child),
    ),
  );

  Future<void> capture(
    WidgetTester tester,
    Widget child,
    String name,
  ) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(screen(child));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(
      find.byType(Scaffold).first,
      matchesGoldenFile('../../docs/ui-fidelity/before-$name.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  }

  testWidgets(
    'Today before',
    (tester) => capture(
      tester,
      const TodayScreen(),
      'today',
    ),
  );

  testWidgets(
    'Collections before',
    (tester) => capture(
      tester,
      const CollectionsScreen(),
      'collections',
    ),
  );

  testWidgets('Search before', (tester) async {
    final owner = UuidValue.fromString('00000000-0000-4000-8000-000000000001');
    final item = Item(
      id: UuidValue.fromString('00000000-0000-4000-8000-000000000002'),
      ownerId: owner,
      url: null,
      sourcePlatform: SourcePlatform.x,
      title: 'Flutter desktop sidebar',
      contentType: ContentType.post,
      intention: 'Try this navigation pattern in my dashboard',
      savedAt: DateTime.utc(2026, 10, 5),
    );
    await capture(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: SearchResultCard(
          result: SearchResult(
            item: item,
            score: 1,
            evidence: [
              SearchEvidence(
                field: 'saved note',
                snippet: 'navigation pattern in my dashboard',
              ),
            ],
          ),
          color: PinneColors.lilac,
          onOpen: () {},
        ),
      ),
      'search',
    );
  });

  testWidgets(
    'Nav before',
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
