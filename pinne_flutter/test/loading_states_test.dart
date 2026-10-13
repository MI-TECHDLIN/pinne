import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/core/motion.dart';
import 'package:pinne_flutter/core/server_client.dart';
import 'package:pinne_flutter/features/capture/capture_providers.dart';
import 'package:pinne_flutter/features/collections/collections_screen.dart';
import 'package:pinne_flutter/features/progress/progress_providers.dart';
import 'package:pinne_flutter/features/progress/progress_screen.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';
import 'package:pinne_flutter/ui/item_preview.dart';
import 'package:pinne_flutter/ui/pinne_loading.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'support/golden_theme.dart';
import 'support/test_account.dart';

void main() {
  setUpAll(() async {
    await loadGoldenFonts();
  });

  Widget app(Widget child, {List overrides = const []}) => ProviderScope(
    overrides: [
      accountIdProvider.overrideWith(TestAccountId.new),
      ...overrides,
    ],
    child: MaterialApp(
      theme: pinneDarkTheme(),
      builder: (context, child) => MotionPreferenceScope(
        preference: MotionPreference.reduced,
        child: child!,
      ),
      home: Scaffold(body: child),
    ),
  );

  testWidgets('collection loading uses shaped skeleton tiles, not a spinner', (
    tester,
  ) async {
    final pending = Completer<List<CollectionTileData>>();
    await tester.pumpWidget(
      app(
        const CollectionsScreen(),
        overrides: [
          captureStoreProvider.overrideWithValue(null),
          collectionsProvider.overrideWith((ref) => pending.future),
        ],
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('collections-skeleton')), findsOneWidget);
    expect(find.byType(PinneTileSkeleton), findsNWidgets(4));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('progress loading uses a skeleton deck, not a spinner', (
    tester,
  ) async {
    final pending = Completer<ProgressReport?>();
    await tester.pumpWidget(
      app(
        const ProgressScreen(),
        overrides: [
          progressReportProvider.overrideWith((ref) => pending.future),
        ],
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('progress-deck-skeleton')),
      findsOneWidget,
    );
    expect(find.byType(PinneCardSkeleton), findsNWidgets(3));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('pending image preview is a reduced-motion static skeleton', (
    tester,
  ) async {
    final item = Item(
      ownerId: const Uuid().v4obj(),
      title: 'Pending preview',
      sourcePlatform: SourcePlatform.web,
      contentType: ContentType.article,
      savedAt: DateTime.utc(2026, 10, 12),
      enrichmentState: EnrichmentState.pending,
    );
    await tester.pumpWidget(
      app(SizedBox(width: 320, child: PreviewThumbnail(item: item))),
    );

    final skeleton = tester.widget<Skeletonizer>(
      find.byWidgetPredicate((widget) => widget is Skeletonizer),
    );
    expect(skeleton.effect, isA<SolidColorEffect>());
    expect(find.byKey(const ValueKey('preview-skeleton')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('compact waits use the branded reduced-motion fallback', (
    tester,
  ) async {
    await tester.pumpWidget(app(const PinneBrandedLoader()));

    expect(find.byKey(const ValueKey('pinne-branded-loader')), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('card and tile loading states', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 920));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: goldenTheme(),
        home: MotionPreferenceScope(
          preference: MotionPreference.reduced,
          child: Scaffold(
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  Text(
                    'Getting things ready',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  PinneCardSkeleton(
                    height: 160,
                    label: 'Loading your next review',
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: PinneTileSkeleton(height: 150)),
                      SizedBox(width: 8),
                      Expanded(child: PinneTileSkeleton(height: 150)),
                    ],
                  ),
                  SizedBox(height: 12),
                  PinneCardSkeleton(
                    height: 132,
                    label: 'Loading saved item',
                  ),
                  SizedBox(height: 8),
                  PinneCardSkeleton(
                    height: 132,
                    label: 'Loading saved item',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../docs/loading/loading-states.png'),
    );
  });
}
