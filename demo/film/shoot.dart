import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'director.dart';
import 'film_http.dart';
import 'fonts.dart';

/// Registers one scene as a widget test that films a segment.
void shoot(String name, Future<void> Function(Film film) body) {
  testWidgets(name, (tester) async {
    final film = Film(tester, name);
    try {
      await body(film);
      film.core = film.t;
      // Spare footage, so the edit can hold a scene for the narration.
      await film.hold(Film.tail);
    } finally {
      await film.finish();
    }
  }, timeout: const Timeout(Duration(minutes: 40)));
}

/// Fonts, thumbnails and the stage size, once per test file.
void setUpFilm() {
  setUpAll(() async {
    await loadFilmFonts();
    HttpOverrides.global = FilmHttpOverrides();
  });
}

/// Lets the app settle before recording starts, without filming it.
Future<void> settle(WidgetTester tester, [double seconds = 1.5]) async {
  for (var i = 0; i < (seconds * 30).round(); i++) {
    await tester.pump(const Duration(microseconds: 33333));
  }
}

Finder text(String value) => find.text(value);
Finder key(String value) => find.byKey(ValueKey(value));

/// The whole button labelled [label], so a callout keeps clear of all of it.
Finder button(String label) => find
    .ancestor(
      of: find.text(label),
      matching: find.bySubtype<ButtonStyleButton>(),
    )
    .first;
