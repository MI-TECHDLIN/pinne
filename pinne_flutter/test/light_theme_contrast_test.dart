import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';

void main() {
  const palette = PinnePalette.light;

  test('Lavender Mist text pairs meet WCAG AA', () {
    final pairs = <String, (Color, Color)>{
      'text on background': (palette.text, palette.midnight),
      'text on card': (palette.text, palette.card),
      'secondary on background': (palette.muted, palette.midnight),
      'secondary on card': (palette.muted, palette.card),
      'violet link on background': (palette.lilac, palette.midnight),
      'violet link on card': (palette.lilac, palette.card),
      'white on violet button': (palette.onViolet, palette.violet),
      'white on ink preview chip': (palette.onViolet, palette.ink),
      'ink on lime': (palette.ink, palette.accentDue),
      'ink on peach': (palette.ink, palette.peach),
      'ink on mint': (palette.ink, palette.mint),
      'ink on lilac': (palette.ink, palette.lilacTile),
      'ink on sky': (palette.ink, palette.sky),
      'success on card': (palette.success, palette.card),
      'warning on card': (palette.warning, palette.card),
      'error on card': (palette.error, palette.card),
    };

    for (final MapEntry(key: name, value: pair) in pairs.entries) {
      expect(
        _contrastRatio(pair.$1, pair.$2),
        greaterThanOrEqualTo(4.5),
        reason: name,
      );
    }
  });

  test('Lavender Mist UI pairs meet the 3:1 contrast floor', () {
    final navSurface = Color.alphaBlend(palette.navFill, palette.midnight);
    final pairs = <String, (Color, Color)>{
      'lime edge against background': (palette.dueEdge, palette.midnight),
      'violet fill against background': (palette.violet, palette.midnight),
      'selected nav dot against nav': (palette.navSelected, navSurface),
    };

    for (final MapEntry(key: name, value: pair) in pairs.entries) {
      expect(
        _contrastRatio(pair.$1, pair.$2),
        greaterThanOrEqualTo(3),
        reason: name,
      );
    }
  });
}

double _contrastRatio(Color a, Color b) {
  final aLuminance = a.computeLuminance();
  final bLuminance = b.computeLuminance();
  final lighter = aLuminance > bLuminance ? aLuminance : bLuminance;
  final darker = aLuminance > bLuminance ? bLuminance : aLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}
