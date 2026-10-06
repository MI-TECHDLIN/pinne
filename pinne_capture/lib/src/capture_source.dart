/// Where a captured item came from.
///
/// The value names match the server's `SourcePlatform` enum, which maps to
/// this one by name; a test on each side keeps the two in step.
enum CaptureSource {
  x('X'),
  youtube('YouTube'),
  instagram('Instagram'),
  tiktok('TikTok'),
  reddit('Reddit'),
  github('GitHub'),

  /// A well-formed web link on a site Pinne has no special rules for.
  web('Web'),

  /// Text with no link in it.
  note('Note'),

  /// A link whose origin cannot be told without following it, such as a
  /// generic URL shortener, or a host that is not a public site.
  unknown('Unknown');

  const CaptureSource(this.label);

  /// Short human label, shown as text so the source never depends on colour.
  final String label;
}

/// A first guess at the kind of content, from the URL shape alone.
///
/// The value names match the server's `ContentType` enum.
enum CaptureContentType { article, video, post, thread, note, other }
