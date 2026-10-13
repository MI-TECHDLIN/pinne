import 'package:flutter/material.dart';

import 'pinne_tokens.dart';

/// The dark theme Pinne ships first. It remains pixel-identical to the
/// original theme while widgets read colours through [PinnePalette].
ThemeData pinneDarkTheme() => _pinneTheme(
  palette: PinnePalette.dark,
  brightness: Brightness.dark,
);

/// Pinne's approved Lavender Mist daytime theme.
ThemeData pinneLightTheme() => _pinneTheme(
  palette: PinnePalette.light,
  brightness: Brightness.light,
);

ThemeData _pinneTheme({
  required PinnePalette palette,
  required Brightness brightness,
}) {
  final scheme = brightness == Brightness.dark
      ? ColorScheme.dark(
          primary: palette.violet,
          onPrimary: palette.onViolet,
          secondary: palette.lilac,
          onSecondary: palette.ink,
          error: palette.error,
          surface: palette.midnight,
          onSurface: palette.text,
          onSurfaceVariant: palette.muted,
          surfaceContainerLow: palette.midnightRaised,
          surfaceContainer: palette.card,
          surfaceContainerHigh: palette.cardRaised,
          outline: palette.line,
          outlineVariant: palette.line,
        )
      : ColorScheme.light(
          primary: palette.violet,
          onPrimary: palette.onViolet,
          secondary: palette.lilac,
          onSecondary: palette.onViolet,
          error: palette.error,
          onError: palette.onViolet,
          surface: palette.midnight,
          onSurface: palette.text,
          onSurfaceVariant: palette.muted,
          surfaceContainerLow: palette.midnightRaised,
          surfaceContainer: palette.card,
          surfaceContainerHigh: palette.cardRaised,
          outline: palette.line,
          outlineVariant: palette.line,
        );

  final base = brightness == Brightness.dark
      ? ThemeData.dark()
      : ThemeData.light();
  final body = base.textTheme.apply(
    fontFamily: 'Plus Jakarta Sans',
    bodyColor: palette.text,
    displayColor: palette.text,
  );

  TextStyle? headline(TextStyle? style, FontWeight weight) => style?.copyWith(
    fontFamily: 'Outfit',
    fontWeight: weight,
    letterSpacing: -0.4,
    color: palette.text,
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
    brightness: brightness,
    colorScheme: scheme,
    extensions: [palette],
    scaffoldBackgroundColor: palette.midnight,
    textTheme: textTheme,
    cardTheme: CardThemeData(
      color: palette.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(PinneRadii.card),
        ),
        side: BorderSide(color: palette.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.violet,
        foregroundColor: palette.onViolet,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: palette.lilac),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? palette.onViolet
            : palette.muted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? palette.violet
            : palette.glass,
      ),
    ),
    dividerTheme: DividerThemeData(color: palette.line),
    // Fallback for any plain SnackBar; prefer showPinneToast (ui/feedback).
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: palette.cardRaised,
      contentTextStyle: TextStyle(color: palette.text),
      actionTextColor: palette.lilac,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PinneRadii.tile),
        side: BorderSide(color: palette.line),
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
