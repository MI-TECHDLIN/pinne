import 'package:flutter/material.dart';

import 'pinne_tokens.dart';

/// The dark theme Pinne ships first. Outfit for headlines, Plus Jakarta Sans
/// for body text.
ThemeData pinneDarkTheme() {
  const scheme = ColorScheme.dark(
    primary: PinneColors.violet,
    onPrimary: PinneColors.text,
    secondary: PinneColors.lilac,
    onSecondary: PinneColors.ink,
    surface: PinneColors.midnight,
    onSurface: PinneColors.text,
    onSurfaceVariant: PinneColors.muted,
    surfaceContainerLow: PinneColors.midnightRaised,
    surfaceContainer: PinneColors.card,
    surfaceContainerHigh: PinneColors.cardRaised,
    outline: PinneColors.line,
    outlineVariant: PinneColors.line,
  );

  final body = ThemeData.dark().textTheme.apply(
    fontFamily: 'Plus Jakarta Sans',
    bodyColor: PinneColors.text,
    displayColor: PinneColors.text,
  );

  TextStyle? headline(TextStyle? base, FontWeight weight) => base?.copyWith(
    fontFamily: 'Outfit',
    fontWeight: weight,
    letterSpacing: -0.4,
    color: PinneColors.text,
  );

  final textTheme = body.copyWith(
    displayLarge: headline(body.displayLarge, FontWeight.w300),
    displayMedium: headline(body.displayMedium, FontWeight.w300),
    displaySmall: headline(body.displaySmall, FontWeight.w300),
    headlineLarge: headline(body.headlineLarge, FontWeight.w300),
    headlineMedium: headline(body.headlineMedium, FontWeight.w300),
    headlineSmall: headline(body.headlineSmall, FontWeight.w400),
    titleLarge: headline(body.titleLarge, FontWeight.w600),
    titleMedium: headline(body.titleMedium, FontWeight.w600),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: PinneColors.midnight,
    textTheme: textTheme,
    cardTheme: const CardThemeData(
      color: PinneColors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(PinneRadii.card)),
        side: BorderSide(color: PinneColors.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: PinneColors.violet,
        foregroundColor: PinneColors.text,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: PinneColors.lilac),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? PinneColors.text
            : PinneColors.muted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? PinneColors.violet
            : PinneColors.glass,
      ),
    ),
    dividerTheme: const DividerThemeData(color: PinneColors.line),
    // Fallback for any plain SnackBar; prefer showPinneToast (ui/feedback).
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: PinneColors.cardRaised,
      contentTextStyle: const TextStyle(color: PinneColors.text),
      actionTextColor: PinneColors.lilac,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PinneRadii.tile),
        side: const BorderSide(color: PinneColors.line),
      ),
    ),
  );
}

/// The one primary action on a screen: lime with ink text. Use at most once
/// per screen; everything else uses the violet [FilledButton] theme.
ButtonStyle pinnePrimaryActionStyle() => FilledButton.styleFrom(
  backgroundColor: PinneColors.accentPrimaryAction,
  foregroundColor: PinneColors.ink,
  shape: const StadiumBorder(),
  textStyle: const TextStyle(fontWeight: FontWeight.w700),
);
