import 'capture_limits.dart';
import 'capture_source.dart';
import 'link_normalizer.dart';
import 'text.dart';

/// What a share or a paste contains, read without any network access.
///
/// Holds either a [link] or a [note], never both. When a link arrives with
/// words around it (a page title in the share subject, a comment before the
/// URL), those words become the [titleHint].
final class CaptureInput {
  const CaptureInput._({this.link, this.note, this.titleHint});

  static const empty = CaptureInput._();

  final NormalizedLink? link;

  /// The whole text, when it holds no link.
  final String? note;

  /// Words that came with the link, cleaned up for use as a title.
  final String? titleHint;

  bool get isEmpty => link == null && note == null;

  CaptureSource get source => link?.source ?? CaptureSource.note;

  CaptureContentType get contentType =>
      link?.contentType ?? CaptureContentType.note;

  /// The title shown before the user edits it.
  String get suggestedTitle =>
      titleHint ?? link?.displayTitle ?? noteTitle(note ?? '');
}

/// Reads shared or pasted [text], plus the optional share [subject] some apps
/// send alongside it (often the page title).
///
/// The first http or https URL in the text is the link. A lone scheme-less
/// address such as `youtube.com/watch?v=…` is also read as a link. Anything
/// else is a note.
CaptureInput parseCaptureInput(String text, {String? subject}) {
  final trimmed = text.trim();
  final match = _urlInText.firstMatch(trimmed);
  if (match != null) {
    final url = _trimTrailingPunctuation(match.group(0)!);
    final link = normalizeLink(url);
    if (link != null) {
      final around =
          '${trimmed.substring(0, match.start)} '
          '${trimmed.substring(match.start + url.length)}';
      return CaptureInput._(
        link: link,
        titleHint: _hint(subject) ?? _hint(around),
      );
    }
  }

  final bare = _bareLink(trimmed);
  if (bare != null) {
    return CaptureInput._(link: bare, titleHint: _hint(subject));
  }

  final note = trimmed.isNotEmpty ? trimmed : subject?.trim();
  if (note == null || note.isEmpty) return CaptureInput.empty;
  return CaptureInput._(note: note);
}

/// A note's title: its first non-empty line, shortened.
String noteTitle(String note) {
  final firstLine = note
      .split('\n')
      .map(collapseWhitespace)
      .firstWhere((line) => line.isNotEmpty, orElse: () => '');
  if (firstLine.isEmpty) return 'Note';
  return truncateRunes(firstLine, CaptureLimits.derivedTitleLength);
}

final _urlInText = RegExp(r'''https?://[^\s<>"'`]+''', caseSensitive: false);

/// Drops sentence punctuation that text puts right after a URL. A closing
/// bracket stays when the URL opened one, as in Wikipedia titles.
String _trimTrailingPunctuation(String url) {
  const trailing = '.,;:!?\'"»”’>]}…';
  var result = url;
  while (result.isNotEmpty) {
    final last = result[result.length - 1];
    if (trailing.contains(last)) {
      result = result.substring(0, result.length - 1);
    } else if (last == ')' &&
        '('.allMatches(result).length < ')'.allMatches(result).length) {
      result = result.substring(0, result.length - 1);
    } else {
      break;
    }
  }
  return result;
}

final _bareAddress = RegExp(
  r'^(?:[a-z0-9-]+\.)+([a-z]{2,24})(?::\d{1,5})?(?:[/?#]\S*)?$',
  caseSensitive: false,
);

/// Top-level domains that are clearly addresses even with no path, so that
/// `example.com` is a link but `notes.md` stays a note.
const _commonTlds = {
  'ai',
  'app',
  'be',
  'co',
  'com',
  'dev',
  'edu',
  'gov',
  'info',
  'io',
  'me',
  'net',
  'org',
  'so',
  'xyz',
};

NormalizedLink? _bareLink(String text) {
  final match = _bareAddress.firstMatch(text);
  if (match == null) return null;
  final hasPath = text.contains('/') || text.contains('?');
  final tld = match.group(1)!.toLowerCase();
  if (!hasPath &&
      !text.toLowerCase().startsWith('www.') &&
      !_commonTlds.contains(tld)) {
    return null;
  }
  return normalizeLink('https://$text');
}

String? _hint(String? text) {
  if (text == null) return null;
  var hint = collapseWhitespace(text);
  hint = hint.replaceAll(RegExp(r'^[\s\-–—:|·•.,;]+|[\s\-–—:|·•.,;]+$'), '');
  if (hint.isEmpty || normalizeLink(hint) != null) return null;
  return truncateRunes(hint, CaptureLimits.derivedTitleLength + 40);
}
