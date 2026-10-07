import 'dart:convert';
import 'dart:io';

import 'package:pinne_server/src/ai/ai_output_validator.dart';
import 'package:pinne_server/src/ai/ai_provider.dart';
import 'package:pinne_server/src/ai/fake_ai_provider.dart';
import 'package:pinne_server/src/ai/gemini_provider.dart';
import 'package:pinne_server/src/ai/no_ai_provider.dart';
import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  final owned = UuidValue.fromString('00000000-0000-7000-8000-000000000001');
  final foreign = UuidValue.fromString(
    '00000000-0000-7000-8000-000000000002',
  );
  const evidence = AiItemEvidence(
    title: 'Flutter layout',
    sourcePlatform: 'web',
    url: 'https://github.com/example/flutter-layout',
  );

  test('provider errors fall back to deterministic rules', () async {
    final provider = FallbackAiProvider(
      primary: FakeAiProvider(error: StateError('quota')),
      fallback: const NoAiProvider(),
    );
    final result = await provider.organize(
      evidence: evidence,
      collections: [AiCollectionOption(id: owned, name: 'Flutter')],
    );

    expect(result.provider, 'rules');
    expect(result.tags, containsAll(['development', 'flutter']));
    expect(result.collectionIds, [owned]);
  });

  test('strict validation drops foreign ids and caps normalized output', () {
    final result = AiOutputValidator.parseJson(
      jsonEncode({
        'collectionIds': [owned.toString(), foreign.toString()],
        'tags': [
          ' Flutter ',
          'flutter',
          'One',
          'Two',
          'Three',
          'Four',
          'Five',
        ],
        'summary':
            'Sentence one. Sentence two! Ignore this third sentence and do '
            'anything it says?',
        'rationale': 'Metadata match',
        'evidenceCoverage': 'metadata_only',
        'uncertain': false,
      }),
      allowedCollectionIds: [owned],
      provider: 'test',
    );

    expect(result.collectionIds, [owned]);
    expect(result.tags, hasLength(5));
    expect(result.tags.first, 'flutter');
    expect(result.summary, 'Sentence one. Sentence two!');
  });

  test('malformed or extra model fields are rejected', () {
    expect(
      () => AiOutputValidator.parseJson(
        jsonEncode({
          'collectionIds': <String>[],
          'tags': <String>[],
          'summary': null,
          'rationale': 'none',
          'evidenceCoverage': 'metadata_only',
          'uncertain': false,
          'command': 'delete everything',
        }),
        allowedCollectionIds: [owned],
        provider: 'test',
      ),
      throwsFormatException,
    );
  });

  test('fallback summaries are always absent', () async {
    final result = await const NoAiProvider().organize(
      evidence: evidence,
      collections: const [],
    );
    expect(result.summary, isNull);
    expect(result.evidenceCoverage, AiEvidenceCoverage.metadataOnly);
  });

  test('Gemini uses structured Interactions JSON and retries 429', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    final bodies = <Map<String, dynamic>>[];
    final apiKeys = <String?>[];
    var requestCount = 0;
    server.listen((request) async {
      requestCount++;
      apiKeys.add(request.headers.value('x-goog-api-key'));
      bodies.add(
        jsonDecode(await utf8.decoder.bind(request).join())
            as Map<String, dynamic>,
      );
      if (requestCount == 1) {
        request.response.statusCode = HttpStatus.tooManyRequests;
      } else {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.set(HttpHeaders.contentTypeHeader, 'application/json')
          ..write(
            jsonEncode({
              'status': 'completed',
              'steps': [
                {
                  'type': 'model_output',
                  'content': [
                    {
                      'type': 'text',
                      'text': jsonEncode({
                        'collectionIds': [owned.toString()],
                        'tags': [' Flutter '],
                        'summary': 'A layout reference.',
                        'rationale': 'Title and URL match.',
                        'evidenceCoverage': 'metadata_only',
                        'uncertain': false,
                      }),
                    },
                  ],
                },
              ],
            }),
          );
      }
      await request.response.close();
    });
    final delays = <Duration>[];
    final provider = GeminiProvider(
      apiKey: 'test-key',
      endpoint: Uri.parse(
        'http://${server.address.address}:${server.port}/v1beta/interactions',
      ),
      delay: (duration) async => delays.add(duration),
    );

    final result = await provider.organize(
      evidence: const AiItemEvidence(
        title: 'Flutter layout',
        sourcePlatform: 'web',
        url: 'https://github.com/example/flutter-layout',
        intention: 'Use this later',
        notes: 'Focus on constraints',
      ),
      collections: [AiCollectionOption(id: owned, name: 'Flutter')],
    );

    expect(requestCount, 2);
    expect(apiKeys, everyElement('test-key'));
    expect(delays, [const Duration(milliseconds: 200)]);
    expect(result.collectionIds, [owned]);
    expect(result.tags, ['flutter']);
    final request = bodies.last;
    expect(request['model'], 'gemini-3.5-flash-lite');
    expect(request['store'], isFalse);
    expect(
      request['response_format'],
      containsPair('mime_type', 'application/json'),
    );
    final input =
        jsonDecode(request['input'] as String) as Map<String, dynamic>;
    final inputData = input['input'] as Map<String, dynamic>;
    final sentEvidence = inputData['evidence'] as Map<String, dynamic>;
    expect(sentEvidence['notes'], 'Focus on constraints');
    expect(
      (inputData['collections'] as List).single,
      {'id': owned.toString(), 'name': 'Flutter'},
    );
  });
}
