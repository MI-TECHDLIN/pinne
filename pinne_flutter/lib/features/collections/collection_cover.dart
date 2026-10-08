import 'package:flutter/material.dart';
import 'package:mesh/mesh.dart';

import '../../theme/pinne_tokens.dart';

const _coverPalettes = <List<Color>>[
  [
    Color(0xFFB9A7FF),
    Color(0xFF7C5CFF),
    Color(0xFFF6A9DD),
    Color(0xFFA9C4FF),
    Color(0xFFFFC27A),
    Color(0xFF8F73FF),
    Color(0xFFFBD2EC),
    Color(0xFFC9BDFF),
    Color(0xFF8EAFFF),
  ],
  [
    Color(0xFFFFC27A),
    Color(0xFFFF9E76),
    Color(0xFFF6A9DD),
    Color(0xFFFFD7A6),
    Color(0xFFB9A7FF),
    Color(0xFFFFA85A),
    Color(0xFFFFD6D0),
    Color(0xFFFFC27A),
    Color(0xFFFF8FBF),
  ],
  [
    Color(0xFF8FE8D0),
    Color(0xFF51CDB0),
    Color(0xFFA9C4FF),
    Color(0xFFC8F0E6),
    Color(0xFF75D8C2),
    Color(0xFFB9A7FF),
    Color(0xFF9EE9DB),
    Color(0xFFA7D8FF),
    Color(0xFF62C8B8),
  ],
  [
    Color(0xFFF6A9DD),
    Color(0xFFE77BC3),
    Color(0xFFB9A7FF),
    Color(0xFFFFCBEA),
    Color(0xFFA9C4FF),
    Color(0xFFF58DCB),
    Color(0xFFFFD0E9),
    Color(0xFFD4B8FF),
    Color(0xFFF2A2D8),
  ],
  [
    Color(0xFFA9C4FF),
    Color(0xFF6EA1FF),
    Color(0xFFB9A7FF),
    Color(0xFFC7D7FF),
    Color(0xFF8FE8D0),
    Color(0xFF8EAFFF),
    Color(0xFFD8D0FF),
    Color(0xFF9ADCCF),
    Color(0xFF7E9FFF),
  ],
];

/// Produces the exact mesh for a stored seed and allow-listed palette.
///
/// This uses a tiny fixed integer generator rather than platform randomness,
/// so a persisted seed maps to the same vertices and colours on every device.
OMeshRect collectionCoverMesh(int seed, int paletteIndex) {
  final random = _StableRandom(seed);
  final palette = _coverPalettes[paletteIndex % _coverPalettes.length];
  final vertices = <OVertex>[];
  for (var row = 0; row < 3; row++) {
    for (var column = 0; column < 3; column++) {
      final x = column / 2 + random.signed(0.13);
      final y = row / 2 + random.signed(0.13);
      vertices.add(OVertex(x, y));
    }
  }
  final offset = random.nextInt(palette.length);
  final colours = List<Color>.generate(
    9,
    (index) => palette[(index + offset) % palette.length],
  );
  return OMeshRect(
    width: 3,
    height: 3,
    vertices: vertices,
    colors: colours,
    colorSpace: OMeshColorSpace.lab,
    backgroundColor: palette.first,
    fallbackColor: palette.first,
  );
}

class CollectionCover extends StatelessWidget {
  const CollectionCover({
    super.key,
    required this.seed,
    required this.paletteIndex,
    this.borderRadius = PinneRadii.tile,
  });

  final int seed;
  final int paletteIndex;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: ExcludeSemantics(
          child: OMeshGradient(
            key: ValueKey('collection-cover-$seed-$paletteIndex'),
            tessellation: 10,
            mesh: collectionCoverMesh(seed, paletteIndex),
          ),
        ),
      ),
    );
  }
}

class _StableRandom {
  _StableRandom(int seed) : _state = (seed ^ 0x6d2b79f5) & 0x7fffffff;

  int _state;

  int nextInt(int maximum) {
    _state = ((_state * 1103515245) + 12345) & 0x7fffffff;
    return _state % maximum;
  }

  double nextDouble() => nextInt(0x7fffffff) / 0x7fffffff;

  double signed(double magnitude) => (nextDouble() * 2 - 1) * magnitude;
}

/// The flat colour that stands for a collection outside its cover, such as
/// a progress bar. It is the cover palette's base colour.
Color collectionAccent(int paletteIndex) =>
    _coverPalettes[paletteIndex % _coverPalettes.length].first;
