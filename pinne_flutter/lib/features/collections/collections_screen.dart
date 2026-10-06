import 'package:flutter/material.dart';

import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PinnePage(
      headline: 'Your',
      headlineBold: 'collections',
      subtitle: 'Group saves by what you want to do with them.',
      children: [
        const ComingSoonCard(
          title: 'No collections yet',
          body: 'Create one to start sorting what you save.',
        ),
        const SizedBox(height: PinneSpacing.lg),
        _TileSwatches(),
      ],
    );
  }
}

/// Shows the pastel tile palette that real collection tiles will use.
class _TileSwatches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Row(
        children: [
          for (final colour in PinneColors.tilePalette)
            Expanded(
              child: Container(
                height: 56,
                margin: const EdgeInsets.only(right: PinneSpacing.sm),
                decoration: BoxDecoration(
                  color: colour.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(PinneRadii.tile),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
