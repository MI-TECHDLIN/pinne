import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'paths.dart';

/// Loads the fonts the app bundles (Outfit and Plus Jakarta Sans, from
/// pinne_flutter/assets/fonts), plus the phone's system font and the
/// Material icons, the way they are found on an Android phone.
Future<void> loadFilmFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(File(file).readAsBytes().then(ByteData.sublistView));
    }
    await loader.load();
  }

  const fonts = '${FilmPaths.app}/assets/fonts';
  await load('Outfit', ['$fonts/outfit/Outfit-VariableFont_wght.ttf']);
  await load('Plus Jakarta Sans', [
    '$fonts/plus_jakarta_sans/PlusJakartaSans-VariableFont_wght.ttf',
  ]);

  final sdk = Platform.environment['FLUTTER_ROOT']!;
  final material = '$sdk/bin/cache/artifacts/material_fonts';
  // Text styles that name no family use the phone's system font: Roboto on
  // Android. The engine looks for its Linux default family "Ubuntu" first,
  // so the SDK's Roboto is registered under that name too.
  for (final family in ['Roboto', 'Ubuntu']) {
    await load(family, [
      for (final face in ['Light', 'Regular', 'Medium', 'Bold', 'Black'])
        '$material/Roboto-$face.ttf',
    ]);
  }
  await load('MaterialIcons', ['$material/MaterialIcons-Regular.otf']);
}
