import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';

/// Pinne's tokens with SDK Roboto: Linux goldens need no font network/cache.
Future<void> loadGoldenFonts() async {
  final sdk = Platform.environment['FLUTTER_ROOT']!;
  final font = FontLoader('Roboto')
    ..addFont(
      File(
        '$sdk/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf',
      ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
    );
  await font.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(
      File(
        '$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
    );
  await icons.load();
}

ThemeData goldenTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: PinneColors.violet,
    onPrimary: PinneColors.text,
    secondary: PinneColors.lilac,
    surface: PinneColors.midnight,
    onSurface: PinneColors.text,
    onSurfaceVariant: PinneColors.muted,
    outline: PinneColors.line,
    surfaceContainerHigh: PinneColors.cardRaised,
  ),
  scaffoldBackgroundColor: PinneColors.midnight,
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: 'Roboto',
    bodyColor: PinneColors.text,
    displayColor: PinneColors.text,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: PinneColors.violet,
      foregroundColor: PinneColors.text,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: PinneColors.lilac),
  ),
);
