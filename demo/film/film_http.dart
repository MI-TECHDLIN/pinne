import 'dart:async';
import 'dart:io';

import 'paths.dart';

/// Answers the app's `Image.network` requests for link-preview thumbnails
/// with the sample images in demo/assets/thumbs, by file name. Anything
/// else gets a 404, so nothing reaches the real network during a render.
class FilmHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _Client();
}

class _Client implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _Request(url);

  // Settings such as timeouts are accepted and ignored.
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      invocation.isSetter ? null : super.noSuchMethod(invocation);
}

class _Request implements HttpClientRequest {
  _Request(this.url);
  final Uri url;

  @override
  Future<HttpClientResponse> close() async {
    final file = File(
      '${FilmPaths.root}/assets/thumbs/${url.pathSegments.last}',
    );
    return _Response(file.existsSync() ? file.readAsBytesSync() : null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Response extends Stream<List<int>> implements HttpClientResponse {
  _Response(this.bytes);
  final List<int>? bytes;

  @override
  int get statusCode => bytes == null ? 404 : 200;

  @override
  int get contentLength => bytes?.length ?? 0;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => Stream<List<int>>.fromIterable([?bytes]).listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
