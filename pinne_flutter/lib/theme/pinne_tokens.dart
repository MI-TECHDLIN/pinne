import 'package:flutter/material.dart';

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

/// The context-aware Pinne colour palette.
///
/// Keep [dark] pixel-identical to [PinneColors]. Widgets should read these
/// values through [PinneBuildContext.pinne] so the active theme can supply a
/// different palette without duplicating colour decisions in the UI.
@immutable
class PinnePalette extends ThemeExtension<PinnePalette> {
  const PinnePalette({
    required this.midnight,
    required this.midnightRaised,
    required this.card,
    required this.cardRaised,
    required this.line,
    required this.glass,
    required this.text,
    required this.muted,
    required this.ink,
    required this.violet,
    required this.lilac,
    required this.accentDue,
    required this.accentPrimaryAction,
    required this.peach,
    required this.mint,
    required this.pink,
    required this.sky,
    required this.glowViolet,
    required this.glowPlum,
  });

  static const dark = PinnePalette(
    midnight: PinneColors.midnight,
    midnightRaised: PinneColors.midnightRaised,
    card: PinneColors.card,
    cardRaised: PinneColors.cardRaised,
    line: PinneColors.line,
    glass: PinneColors.glass,
    text: PinneColors.text,
    muted: PinneColors.muted,
    ink: PinneColors.ink,
    violet: PinneColors.violet,
    lilac: PinneColors.lilac,
    accentDue: PinneColors.accentDue,
    accentPrimaryAction: PinneColors.accentPrimaryAction,
    peach: PinneColors.peach,
    mint: PinneColors.mint,
    pink: PinneColors.pink,
    sky: PinneColors.sky,
    glowViolet: PinneColors.glowViolet,
    glowPlum: PinneColors.glowPlum,
  );

  final Color midnight;
  final Color midnightRaised;
  final Color card;
  final Color cardRaised;
  final Color line;
  final Color glass;
  final Color text;
  final Color muted;
  final Color ink;
  final Color violet;
  final Color lilac;
  final Color accentDue;
  final Color accentPrimaryAction;
  final Color peach;
  final Color mint;
  final Color pink;
  final Color sky;
  final Color glowViolet;
  final Color glowPlum;

  List<Color> get tilePalette => [peach, mint, pink, sky, lilac];

  @override
  PinnePalette copyWith({
    Color? midnight,
    Color? midnightRaised,
    Color? card,
    Color? cardRaised,
    Color? line,
    Color? glass,
    Color? text,
    Color? muted,
    Color? ink,
    Color? violet,
    Color? lilac,
    Color? accentDue,
    Color? accentPrimaryAction,
    Color? peach,
    Color? mint,
    Color? pink,
    Color? sky,
    Color? glowViolet,
    Color? glowPlum,
  }) => PinnePalette(
    midnight: midnight ?? this.midnight,
    midnightRaised: midnightRaised ?? this.midnightRaised,
    card: card ?? this.card,
    cardRaised: cardRaised ?? this.cardRaised,
    line: line ?? this.line,
    glass: glass ?? this.glass,
    text: text ?? this.text,
    muted: muted ?? this.muted,
    ink: ink ?? this.ink,
    violet: violet ?? this.violet,
    lilac: lilac ?? this.lilac,
    accentDue: accentDue ?? this.accentDue,
    accentPrimaryAction: accentPrimaryAction ?? this.accentPrimaryAction,
    peach: peach ?? this.peach,
    mint: mint ?? this.mint,
    pink: pink ?? this.pink,
    sky: sky ?? this.sky,
    glowViolet: glowViolet ?? this.glowViolet,
    glowPlum: glowPlum ?? this.glowPlum,
  );

  @override
  PinnePalette lerp(covariant PinnePalette? other, double t) {
    if (other == null) return this;
    return PinnePalette(
      midnight: Color.lerp(midnight, other.midnight, t)!,
      midnightRaised: Color.lerp(midnightRaised, other.midnightRaised, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardRaised: Color.lerp(cardRaised, other.cardRaised, t)!,
      line: Color.lerp(line, other.line, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      text: Color.lerp(text, other.text, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      violet: Color.lerp(violet, other.violet, t)!,
      lilac: Color.lerp(lilac, other.lilac, t)!,
      accentDue: Color.lerp(accentDue, other.accentDue, t)!,
      accentPrimaryAction: Color.lerp(
        accentPrimaryAction,
        other.accentPrimaryAction,
        t,
      )!,
      peach: Color.lerp(peach, other.peach, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      sky: Color.lerp(sky, other.sky, t)!,
      glowViolet: Color.lerp(glowViolet, other.glowViolet, t)!,
      glowPlum: Color.lerp(glowPlum, other.glowPlum, t)!,
    );
  }
}

extension PinneBuildContext on BuildContext {
  PinnePalette get pinne =>
      Theme.of(this).extension<PinnePalette>() ?? PinnePalette.dark;
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

/// Stored palette indices are an API contract with ProfileEndpoint.paletteCount.
/// Append new entries; never reorder. No lime, including in highlights/shadows.
abstract final class PinneSpiritPalettes {
  static const values = [
    SpiritPalette(
      'Violet',
      Color(0xFF392081),
      PinneColors.violet,
      Color(0xFFE4D6FF),
    ),
    SpiritPalette(
      'Lilac',
      Color(0xFF62428F),
      PinneColors.lilac,
      Color(0xFFF3DEFF),
    ),
    SpiritPalette(
      'Peach',
      Color(0xFFAB4269),
      PinneColors.peach,
      Color(0xFFFFE7CC),
    ),
    SpiritPalette(
      'Mint',
      Color(0xFF206D7B),
      PinneColors.mint,
      Color(0xFFD8FFF5),
    ),
    SpiritPalette(
      'Pink',
      Color(0xFF89377E),
      PinneColors.pink,
      Color(0xFFFFDEEF),
    ),
    SpiritPalette(
      'Sky',
      Color(0xFF384C9C),
      PinneColors.sky,
      Color(0xFFE2EEFF),
    ),
  ];
}

class SpiritPalette {
  const SpiritPalette(this.name, this.shadow, this.body, this.light);
  final String name;
  final Color shadow;
  final Color body;
  final Color light;
}
