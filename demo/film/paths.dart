/// Locations passed in by demo/tool/render.sh.
abstract final class FilmPaths {
  /// The demo/ directory of the repo the film's source lives in.
  static const root = String.fromEnvironment('FILM_ROOT');
  static const cache = '$root/.cache';

  /// Where rendered segments go, outside the repo.
  static const out = String.fromEnvironment('FILM_OUT');

  /// The pinne_flutter package whose code is being filmed.
  static const app = String.fromEnvironment('FILM_APP');
}
