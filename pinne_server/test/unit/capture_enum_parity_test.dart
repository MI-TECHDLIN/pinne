import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_server/src/generated/protocol.dart';
import 'package:test/test.dart';

/// The shared capture rules map to the generated enums by name. A new value
/// on one side must be added on the other.
void main() {
  test('every capture source has a source platform', () {
    for (final source in CaptureSource.values) {
      expect(
        SourcePlatform.values.map((p) => p.name),
        contains(source.name),
        reason: source.name,
      );
    }
  });

  test('every capture content type has a content type', () {
    for (final type in CaptureContentType.values) {
      expect(
        ContentType.values.map((t) => t.name),
        contains(type.name),
        reason: type.name,
      );
    }
  });
}
