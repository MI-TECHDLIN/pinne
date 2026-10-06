/// Size limits for a capture, enforced by the server and checked early by
/// the app so a capture is never accepted locally and refused later.
abstract final class CaptureLimits {
  static const maxUrlLength = 4096;
  static const maxTextLength = 10000;
  static const maxTitleLength = 300;
  static const maxIntentionLength = 2000;
  static const maxCollections = 20;

  /// Length of a title derived from a URL or a note's first line.
  static const derivedTitleLength = 80;
}
