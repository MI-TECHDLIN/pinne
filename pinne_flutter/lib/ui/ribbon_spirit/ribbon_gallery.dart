import 'package:flutter/material.dart';

import '../../features/today/today_screen.dart';
import '../../theme/pinne_tokens.dart';
import 'ribbon_spirit.dart';

/// Debug route only. All 48 comparison poses are still; only the hero loops.
class RibbonGallery extends StatefulWidget {
  const RibbonGallery({super.key});

  static const seeds = [
    7,
    38,
    91,
    246,
    503,
    818,
    1203,
    2026,
    4091,
    8088,
    12345,
    86753,
  ];

  @override
  State<RibbonGallery> createState() => _RibbonGalleryState();
}

class _RibbonGalleryState extends State<RibbonGallery> {
  RibbonMood _mood = RibbonMood.idle;
  int _seed = RibbonGallery.seeds.first;
  int _palette = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ribbon studio')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'A little soul.\nAn infinite number of twists.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        Center(
          child: RibbonSpirit(
            seed: _seed,
            palette: _palette,
            mood: _mood,
            size: 220,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            for (final mood in RibbonMood.values)
              ChoiceChip(
                label: Text(mood.name),
                selected: _mood == mood,
                onSelected: (_) => setState(() => _mood = mood),
              ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          '12 identities × 4 moods · tap a row to animate above',
          style: TextStyle(color: PinneColors.muted),
        ),
        const SizedBox(height: 12),
        RibbonContactSheet(
          onSelected: (seed, palette) => setState(() {
            _seed = seed;
            _palette = palette;
          }),
        ),
        const SizedBox(height: 24),
        TodaySpiritCard(
          due: true,
          seed: _seed,
          palette: _palette,
          animate: false,
        ),
        const SizedBox(height: 16),
        TodaySpiritCard(
          due: false,
          seed: _seed,
          palette: _palette,
          animate: false,
        ),
      ],
    ),
  );
}

/// Shared by the route and the checked-in widget-rendered contact sheet.
class RibbonContactSheet extends StatelessWidget {
  const RibbonContactSheet({super.key, this.onSelected});
  final void Function(int seed, int palette)? onSelected;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          const SizedBox(width: 90),
          for (final mood in RibbonMood.values)
            Expanded(
              child: Center(
                child: Text(
                  mood.name,
                  style: const TextStyle(color: PinneColors.lilac),
                ),
              ),
            ),
        ],
      ),
      for (var index = 0; index < RibbonGallery.seeds.length; index++)
        InkWell(
          onTap: onSelected == null
              ? null
              : () => onSelected!(
                  RibbonGallery.seeds[index],
                  index % PinneSpiritPalettes.values.length,
                ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven
                  ? PinneColors.card
                  : PinneColors.midnightRaised,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      '${RibbonGallery.seeds[index]}\n${PinneSpiritPalettes.values[index % 6].name}',
                      style: const TextStyle(
                        color: PinneColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                for (final mood in RibbonMood.values)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => RibbonSpirit(
                        seed: RibbonGallery.seeds[index],
                        palette: index % 6,
                        mood: mood,
                        size: constraints.maxWidth.clamp(1, 128),
                        animate: false,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
    ],
  );
}
