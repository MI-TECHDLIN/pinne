import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/shell/pill_nav_bar.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';
import 'package:pinne_flutter/ui/item_preview.dart';

const _destinations = [
  PillNavDestination(label: 'Today', icon: Icons.wb_sunny_outlined),
  PillNavDestination(label: 'Collections', icon: Icons.grid_view_rounded),
  PillNavDestination(label: 'Search', icon: Icons.search_rounded),
  PillNavDestination(label: 'Progress', icon: Icons.donut_large_rounded),
  PillNavDestination(label: 'Settings', icon: Icons.tune_rounded),
];

void main() {
  for (final width in [320.0, 430.0]) {
    testWidgets(
      'nav shares one centre line and contains indicator at ${width.round()}dp',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 240));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        for (var selected = 0; selected < _destinations.length; selected++) {
          await tester.pumpWidget(
            MaterialApp(
              home: MediaQuery(
                data: MediaQueryData(
                  size: Size(width, 240),
                  padding: const EdgeInsets.only(bottom: 24),
                  disableAnimations: true,
                  textScaler: const TextScaler.linear(2),
                ),
                child: Scaffold(
                  backgroundColor: PinneColors.midnight,
                  bottomNavigationBar: SafeArea(
                    minimum: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 1,
                        child: SizedBox(
                          width: PillNavBar.maxWidth,
                          child: PillNavBar(
                            destinations: _destinations,
                            selectedIndex: selected,
                            onSelected: (_) {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();

          final pill = tester.getRect(
            find.byKey(const ValueKey('pill-nav-pill')),
          );
          final indicator = tester.getRect(
            find.byKey(const ValueKey('pill-nav-selected-indicator')),
          );
          final iconCentres = [
            for (final destination in _destinations)
              tester.getCenter(
                find.byKey(
                  ValueKey(
                    'pill-nav-icon-${destination.label.toLowerCase()}',
                  ),
                ),
              ),
          ];

          for (final centre in iconCentres) {
            expect(
              (centre.dy - indicator.center.dy).abs(),
              lessThanOrEqualTo(0.5),
            );
          }
          expect(indicator.top, greaterThanOrEqualTo(pill.top));
          expect(indicator.bottom, lessThanOrEqualTo(pill.bottom));
          expect(indicator.left, greaterThanOrEqualTo(pill.left));
          expect(indicator.right, lessThanOrEqualTo(pill.right));

          final gaps = <double>[
            for (var i = 1; i < iconCentres.length; i++)
              iconCentres[i].dx - iconCentres[i - 1].dx,
          ];
          for (final gap in gaps.skip(1)) {
            expect((gap - gaps.first).abs(), lessThanOrEqualTo(0.5));
          }
          expect(
            indicator.center.dx,
            closeTo(iconCentres[selected].dx, 0.5),
          );
        }
      },
    );
  }

  final surfaces = <(String, PreviewChipSurface, Color)>[
    ('dark', PreviewChipSurface.dark, PinneColors.card),
    ('pastel', PreviewChipSurface.pastel, PinneColors.lilac),
    ('lime', PreviewChipSurface.due, PinneColors.accentDue),
  ];
  for (final (name, surface, cardColor) in surfaces) {
    testWidgets('preview chips meet AA on $name cards', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColoredBox(
              color: cardColor,
              child: Wrap(
                children: [
                  PreviewSourceChip(
                    source: SourcePlatform.web,
                    surface: surface,
                  ),
                  DurationChip(seconds: 724, surface: surface),
                ],
              ),
            ),
          ),
        ),
      );

      for (final key in const ['preview-source', 'known-duration']) {
        final chip = tester.widget<Chip>(find.byKey(ValueKey(key)));
        final label = chip.label as Text;
        final foreground = label.style!.color!;
        final background = chip.backgroundColor!;
        expect(
          _contrastRatio(foreground, background),
          greaterThanOrEqualTo(4.5),
          reason: '$key on $name',
        );
      }
    });
  }
}

double _contrastRatio(Color a, Color b) {
  final lighter = a.computeLuminance() > b.computeLuminance() ? a : b;
  final darker = identical(lighter, a) ? b : a;
  return (lighter.computeLuminance() + 0.05) /
      (darker.computeLuminance() + 0.05);
}
