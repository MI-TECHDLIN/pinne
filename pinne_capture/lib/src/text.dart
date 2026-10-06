/// Shortens [text] to at most [maxRunes] runes, ending with an ellipsis when
/// anything was cut. Works on runes so emoji and other astral characters are
/// never split in half.
String truncateRunes(String text, int maxRunes) {
  final runes = text.runes;
  if (runes.length <= maxRunes) return text;
  return '${String.fromCharCodes(runes.take(maxRunes - 1)).trimRight()}…';
}

/// Collapses every run of whitespace, including newlines, to one space.
String collapseWhitespace(String text) =>
    text.replaceAll(RegExp(r'\s+'), ' ').trim();
