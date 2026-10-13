import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinne_flutter/theme/pinne_theme.dart';

/// Loads Pinne's bundled fonts so Linux goldens match every offline phone.
Future<void> loadGoldenFonts() async {
  final outfit = FontLoader('Outfit')
    ..addFont(
      File(
        'assets/fonts/outfit/Outfit-VariableFont_wght.ttf',
      ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
    );
  await outfit.load();
  final jakarta = FontLoader('Plus Jakarta Sans')
    ..addFont(
      File(
        'assets/fonts/plus_jakarta_sans/PlusJakartaSans-VariableFont_wght.ttf',
      ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
    );
  await jakarta.load();
  final sdk = Platform.environment['FLUTTER_ROOT']!;
  final icons = FontLoader('MaterialIcons')
    ..addFont(
      File(
        '$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
    );
  await icons.load();
}

ThemeData goldenTheme() => pinneDarkTheme();
