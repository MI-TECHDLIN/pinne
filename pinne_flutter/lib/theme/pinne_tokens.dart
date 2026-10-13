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
    required this.lilacTile,
    required this.onViolet,
    required this.accentDue,
    required this.accentPrimaryAction,
    required this.dueEdge,
    required this.peach,
    required this.mint,
    required this.pink,
    required this.sky,
    required this.success,
    required this.warning,
    required this.error,
    required this.glowViolet,
    required this.glowPlum,
    required this.shimmerHighlight,
    required this.navFill,
    required this.navSelected,
    required this.shadow,
    required this.selectionFill,
    required this.selectionText,
    required this.spiritPlate,
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
    lilacTile: PinneColors.lilac,
    onViolet: PinneColors.text,
    accentDue: PinneColors.accentDue,
    accentPrimaryAction: PinneColors.accentPrimaryAction,
    dueEdge: PinneColors.accentDue,
    peach: PinneColors.peach,
    mint: PinneColors.mint,
    pink: PinneColors.pink,
    sky: PinneColors.sky,
    success: PinneColors.mint,
    warning: PinneColors.peach,
    error: PinneColors.pink,
    glowViolet: PinneColors.glowViolet,
    glowPlum: PinneColors.glowPlum,
    shimmerHighlight: Color(0xFF4A3D6B),
    navFill: Color(0xD90A0716),
    navSelected: Colors.white,
    shadow: Color(0xAA000000),
    selectionFill: PinneColors.lilac,
    selectionText: PinneColors.ink,
    spiritPlate: PinneColors.card,
  );

  /// The approved Lavender Mist daytime palette.
  static const light = PinnePalette(
    midnight: Color(0xFFF3F0FA),
    midnightRaised: Color(0xFFFEFDFF),
    card: Color(0xFFFBFAFE),
    cardRaised: Color(0xFFFEFDFF),
    line: Color(0xFFE2DCF2),
    glass: Color(0xFFFBFAFE),
    text: Color(0xFF14102A),
    muted: Color(0xFF5E5780),
    ink: Color(0xFF14102A),
    violet: Color(0xFF6B4CF5),
    lilac: Color(0xFF5B3DE0),
    lilacTile: Color(0xFFD2C6FF),
    onViolet: Colors.white,
    accentDue: Color(0xFFC8F250),
    accentPrimaryAction: Color(0xFFC8F250),
    dueEdge: Color(0xFF6A8F12),
    peach: Color(0xFFFFCF94),
    mint: Color(0xFFA6EEDA),
    pink: Color(0xFFF6A9DD),
    sky: Color(0xFFC3D5FF),
    success: Color(0xFF1C7A55),
    warning: Color(0xFF9A5200),
    error: Color(0xFFC0304B),
    glowViolet: Color(0xFFE2D8FF),
    glowPlum: Color(0x125B3DE0),
    shimmerHighlight: Color(0xFFE9E3F5),
    navFill: Color(0xD1FBFAFE),
    navSelected: Color(0xFF14102A),
    shadow: Color(0x125B3DE0),
    selectionFill: Color(0xFFE4DCFF),
    selectionText: Color(0xFF3A22B0),
    spiritPlate: Color(0xFFE2D8FF),
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
  final Color lilacTile;
  final Color onViolet;
  final Color accentDue;
  final Color accentPrimaryAction;
  final Color dueEdge;
  final Color peach;
  final Color mint;
  final Color pink;
  final Color sky;
  final Color success;
  final Color warning;
  final Color error;
  final Color glowViolet;
  final Color glowPlum;
  final Color shimmerHighlight;
  final Color navFill;
  final Color navSelected;
  final Color shadow;
  final Color selectionFill;
  final Color selectionText;
  final Color spiritPlate;

  List<Color> get tilePalette => [peach, mint, pink, sky, lilacTile];

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
    Color? lilacTile,
    Color? onViolet,
    Color? accentDue,
    Color? accentPrimaryAction,
    Color? dueEdge,
    Color? peach,
    Color? mint,
    Color? pink,
    Color? sky,
    Color? success,
    Color? warning,
    Color? error,
    Color? glowViolet,
    Color? glowPlum,
    Color? shimmerHighlight,
    Color? navFill,
    Color? navSelected,
    Color? shadow,
    Color? selectionFill,
    Color? selectionText,
    Color? spiritPlate,
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
    lilacTile: lilacTile ?? this.lilacTile,
    onViolet: onViolet ?? this.onViolet,
    accentDue: accentDue ?? this.accentDue,
    accentPrimaryAction: accentPrimaryAction ?? this.accentPrimaryAction,
    dueEdge: dueEdge ?? this.dueEdge,
    peach: peach ?? this.peach,
    mint: mint ?? this.mint,
    pink: pink ?? this.pink,
    sky: sky ?? this.sky,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    error: error ?? this.error,
    glowViolet: glowViolet ?? this.glowViolet,
    glowPlum: glowPlum ?? this.glowPlum,
    shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    navFill: navFill ?? this.navFill,
    navSelected: navSelected ?? this.navSelected,
    shadow: shadow ?? this.shadow,
    selectionFill: selectionFill ?? this.selectionFill,
    selectionText: selectionText ?? this.selectionText,
    spiritPlate: spiritPlate ?? this.spiritPlate,
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
      lilacTile: Color.lerp(lilacTile, other.lilacTile, t)!,
      onViolet: Color.lerp(onViolet, other.onViolet, t)!,
      accentDue: Color.lerp(accentDue, other.accentDue, t)!,
      accentPrimaryAction: Color.lerp(
        accentPrimaryAction,
        other.accentPrimaryAction,
        t,
      )!,
      dueEdge: Color.lerp(dueEdge, other.dueEdge, t)!,
      peach: Color.lerp(peach, other.peach, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      sky: Color.lerp(sky, other.sky, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      glowViolet: Color.lerp(glowViolet, other.glowViolet, t)!,
      glowPlum: Color.lerp(glowPlum, other.glowPlum, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
      navFill: Color.lerp(navFill, other.navFill, t)!,
      navSelected: Color.lerp(navSelected, other.navSelected, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      selectionFill: Color.lerp(selectionFill, other.selectionFill, t)!,
      selectionText: Color.lerp(selectionText, other.selectionText, t)!,
      spiritPlate: Color.lerp(spiritPlate, other.spiritPlate, t)!,
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
