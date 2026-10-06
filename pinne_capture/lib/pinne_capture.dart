/// Capture rules shared by the Pinne server and app, so a link is labelled
/// and recognised the same way on the phone and on the server.
library;

export 'src/capture_input.dart';
export 'src/capture_limits.dart';
export 'src/capture_source.dart';
export 'src/link_normalizer.dart'
    show NormalizedLink, normalizeLink, readableUrl, trackingParameters;
export 'src/text.dart' show truncateRunes;
