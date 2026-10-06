import 'package:pinne_capture/pinne_capture.dart';
import 'package:test/test.dart';

void main() {
  group('parseCaptureInput', () {
    test('reads a bare shared URL', () {
      final input = parseCaptureInput('https://youtu.be/dQw4w9WgXcQ?si=x');
      expect(input.source, CaptureSource.youtube);
      expect(input.link!.sourceItemId, 'dQw4w9WgXcQ');
      expect(input.titleHint, isNull);
      expect(input.suggestedTitle, 'youtube.com/watch?v=dQw4w9WgXcQ');
    });

    test('uses the share subject as the title hint', () {
      final input = parseCaptureInput(
        'https://example.com/flutter-sidebar',
        subject: 'Building a desktop sidebar in Flutter',
      );
      expect(input.source, CaptureSource.web);
      expect(input.suggestedTitle, 'Building a desktop sidebar in Flutter');
    });

    test('finds the link inside shared text and keeps the words', () {
      final input = parseCaptureInput(
        'Great thread on adaptive nav: https://x.com/dev/status/123456789.',
      );
      expect(input.source, CaptureSource.x);
      expect(input.link!.sourceItemId, '123456789');
      expect(input.titleHint, 'Great thread on adaptive nav');
    });

    test('keeps balanced brackets in a URL inside text', () {
      final input = parseCaptureInput(
        '(see https://en.wikipedia.org/wiki/Flutter_(software))',
      );
      expect(
        input.link!.canonicalUrl,
        'https://en.wikipedia.org/wiki/Flutter_(software)',
      );
    });

    test('reads a pasted address without a scheme', () {
      final input = parseCaptureInput('youtube.com/watch?v=dQw4w9WgXcQ');
      expect(input.source, CaptureSource.youtube);
      expect(input.link!.sourceItemId, 'dQw4w9WgXcQ');

      expect(parseCaptureInput('example.com').source, CaptureSource.web);
      expect(parseCaptureInput('www.example.de').source, CaptureSource.web);
    });

    test('keeps file-like words as a note', () {
      final input = parseCaptureInput('notes.md');
      expect(input.source, CaptureSource.note);
      expect(input.note, 'notes.md');
    });

    test('treats text without a link as a note', () {
      final input = parseCaptureInput(
        '\n  Try the rail pattern\n  in the dashboard  \nlater',
      );
      expect(input.source, CaptureSource.note);
      expect(input.link, isNull);
      expect(input.contentType, CaptureContentType.note);
      expect(input.suggestedTitle, 'Try the rail pattern');
    });

    test('a non-web scheme stays a note', () {
      final input = parseCaptureInput('mailto:someone@example.com');
      expect(input.source, CaptureSource.note);
    });

    test('an ambiguous short link is explicitly unknown', () {
      final input = parseCaptureInput('look https://bit.ly/3xYzAbC');
      expect(input.source, CaptureSource.unknown);
      expect(input.link!.sourceItemId, isNull);
      expect(input.titleHint, 'look');
    });

    test('empty text with no subject is empty', () {
      expect(parseCaptureInput('   ').isEmpty, isTrue);
      expect(
        parseCaptureInput('', subject: 'Only a subject').note,
        'Only a subject',
      );
    });
  });

  group('noteTitle', () {
    test('uses the first non-empty line', () {
      expect(noteTitle('\n\nfirst\nsecond'), 'first');
      expect(noteTitle('   '), 'Note');
    });

    test('never splits an emoji', () {
      final title = noteTitle('🙂' * 100);
      expect(title.runes.length, CaptureLimits.derivedTitleLength);
      expect(title, endsWith('🙂…'));
    });
  });
}
