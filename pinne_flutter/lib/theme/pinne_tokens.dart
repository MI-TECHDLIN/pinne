import 'package:flutter/widgets.dart';

/// Pinne's design tokens, taken from the approved design preview.
///
/// Colour rule: lime is reserved. Use [accentDue] only for the "due now"
/// state and [accentPrimaryAction] only for the single primary action on a
/// screen. Every other button, selected state and link uses [violet]. Never
/// use lime decoratively.
abstract final class PinneColors {
  // Base surfaces.
  static const midnight = Color(0xFF0C0816);
  static const midnightRaised = Color(0xFF150F26);
  static const card = Color(0xFF1D1633);
  static const cardRaised = Color(0xFF271E44);

  /// Hairline borders on glass cards (white at 10%).
  static const line = Color(0x1AFFFFFF);

  /// Translucent fill for glass cards and chips (white at 8%).
  static const glass = Color(0x14FFFFFF);

  // Text.
  static const text = Color(0xFFF5F2FF);
  static const muted = Color(0xFFA79FC4);

  /// Dark ink used on light pastel and lime surfaces.
  static const ink = Color(0xFF14102A);

  // Brand.
  static const violet = Color(0xFF7C5CFF);
  static const lilac = Color(0xFFB9A7FF);

  // Lime, exposed only under its two allowed meanings.
  static const _lime = Color(0xFFC8F250);
  static const accentDue = _lime;
  static const accentPrimaryAction = _lime;

  // Pastel collection tiles.
  static const peach = Color(0xFFFFC27A);
  static const mint = Color(0xFF8FE8D0);
  static const pink = Color(0xFFF6A9DD);
  static const sky = Color(0xFFA9C4FF);

  /// Tile colours in the order new collections cycle through them.
  static const tilePalette = [peach, mint, pink, sky, lilac];

  /// Soft glow painted behind the top of every screen.
  static const glowViolet = Color(0xFF2A1B5A);
  static const glowPlum = Color(0x553B1A5C);
}

abstract final class PinneRadii {
  static const chip = 99.0;
  static const tile = 18.0;
  static const card = 22.0;
  static const sheet = 26.0;
}

abstract final class PinneSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  /// Side gutter for every screen.
  static const gutter = 16.0;

  /// Space reserved at the bottom of scrolling screens for the floating nav.
  static const navClearance = 104.0;
}

abstract final class PinneDurations {
  static const quick = Duration(milliseconds: 160);
  static const standard = Duration(milliseconds: 280);
}
