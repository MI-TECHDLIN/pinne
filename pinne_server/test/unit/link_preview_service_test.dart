import 'package:pinne_server/src/generated/protocol.dart';
import 'package:pinne_server/src/link_previews/link_preview_service.dart';
import 'package:pinne_server/src/link_previews/restricted_fetcher.dart';
import 'package:test/test.dart';

class _FakeFetcher extends RestrictedFetcher {
  _FakeFetcher(this.responses);

  final Map<String, RestrictedResponse> responses;

  @override
  Future<RestrictedResponse> get(Uri uri) async => responses[uri.toString()]!;

  @override
  Future<void> validatePublicUri(Uri uri) async {}
}

void main() {
  test('404 is unavailable without fabricated preview text', () async {
    final uri = Uri.parse('https://example.com/missing');
    final service = LinkPreviewService(
      fetcher: _FakeFetcher({
        uri.toString(): RestrictedResponse(
          uri: uri,
          statusCode: 404,
          contentType: 'text/html',
          body: 'not found',
        ),
      }),
    );
    final result = await service.load(uri);
    expect(result.accessState, AccessState.unavailable);
    expect(result.preview, isNull);
  });

  test('login wall stays loginRequired and does not invent a summary', () async {
    final uri = Uri.parse('https://example.com/private-post');
    final service = LinkPreviewService(
      fetcher: _FakeFetcher({
        uri.toString(): RestrictedResponse(
          uri: uri,
          statusCode: 200,
          contentType: 'text/html',
          body:
              '<title>Sign in to continue</title><p>Create an account to view.</p>',
        ),
      }),
    );
    final result = await service.load(uri);
    expect(result.accessState, AccessState.loginRequired);
    expect(result.preview, isNull);
  });
}
