import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'paths.dart';

/// Serves the app's own google_fonts requests from demo/.cache/fonts, filled
/// by demo/tool/fetch_fonts.py, and preloads every weight the film uses.
Future<void> loadFilmFonts() async {
  final dir = Directory('${FilmPaths.cache}/fonts');
  // google_fonts also keeps a copy in the app support folder.
  final support = Directory('${FilmPaths.cache}/app_support')
    ..createSync(recursive: true);
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (call) async => support.path,
      );
  GoogleFonts.config.allowRuntimeFetching = true;
  GoogleFonts.config.httpClient = MockClient((request) async {
    final name = request.url.pathSegments.last;
    final file = File('${dir.path}/$name');
    if (!file.existsSync()) return http.Response('missing $name', 404);
    return http.Response.bytes(file.readAsBytesSync(), 200);
  });
  for (final weight in FontWeight.values) {
    GoogleFonts.outfit(fontWeight: weight);
    GoogleFonts.plusJakartaSans(fontWeight: weight);
  }
  await GoogleFonts.pendingFonts();

  final sdk = Platform.environment['FLUTTER_ROOT']!;
  final material = '$sdk/bin/cache/artifacts/material_fonts';
  // Text styles that name no family use the phone's system font: Roboto on
  // Android. The engine looks for its Linux default family "Ubuntu" first,
  // so the SDK's Roboto is registered under that name too.
  for (final family in ['Roboto', 'Ubuntu']) {
    final roboto = FontLoader(family);
    for (final face in ['Light', 'Regular', 'Medium', 'Bold', 'Black']) {
      roboto.addFont(
        File(
          '$material/Roboto-$face.ttf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    }
    await roboto.load();
  }
  final icons = FontLoader('MaterialIcons')
    ..addFont(
      File(
        '$material/MaterialIcons-Regular.otf',
      ).readAsBytes().then(ByteData.sublistView),
    );
  await icons.load();
}
