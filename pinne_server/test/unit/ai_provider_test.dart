import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pinne_server/src/ai/ai_output_validator.dart';
import 'package:pinne_server/src/ai/ai_organizing_endpoint.dart';
import 'package:pinne_server/src/ai/ai_provider.dart';
import 'package:pinne_server/src/ai/ai_provider_registry.dart';
import 'package:pinne_server/src/ai/fake_ai_provider.dart';
import 'package:pinne_server/src/ai/gemini_provider.dart';
import 'package:pinne_server/src/ai/groq_provider.dart';
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

  test('preview evidence coverage is derived from supplied evidence', () async {
    final result = await const NoAiProvider().organize(
      evidence: const AiItemEvidence(
        title: 'Real title',
        sourcePlatform: 'web',
        description: 'Extracted public description',
        previewAvailable: true,
      ),
      collections: const [],
    );
    expect(result.evidenceCoverage, AiEvidenceCoverage.metadataPlusPreview);
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

  test(
    'Groq uses strict JSON Schema and validates successful output',
    () async {
      late Uri sentUri;
      late Map<String, String> sentHeaders;
      late Map<String, dynamic> sentBody;
      final client = _FakeGroqHttpClient((uri, headers, body, timeout) async {
        sentUri = uri;
        sentHeaders = headers;
        sentBody = jsonDecode(body) as Map<String, dynamic>;
        return GroqHttpResponse(
          statusCode: HttpStatus.ok,
          body: jsonEncode({
            'choices': [
              {
                'message': {
                  'content': jsonEncode({
                    'collectionIds': [owned.toString()],
                    'tags': [' Flutter '],
                    'summary': 'A layout reference.',
                    'rationale': 'Title and URL match.',
                    'evidenceCoverage': 'metadata_only',
                    'uncertain': false,
                  }),
                },
              },
            ],
          }),
        );
      });
      final provider = GroqProvider(apiKey: 'test-key', httpClient: client);

      final result = await provider.organize(
        evidence: evidence,
        collections: [AiCollectionOption(id: owned, name: 'Flutter')],
      );

      expect(
        sentUri.toString(),
        'https://api.groq.com/openai/v1/chat/completions',
      );
      expect(sentHeaders[HttpHeaders.authorizationHeader], 'Bearer test-key');
      expect(sentBody['model'], GroqProvider.modelId);
      expect(sentBody['reasoning_effort'], 'low');
      expect(sentBody['include_reasoning'], isFalse);
      final responseFormat =
          sentBody['response_format'] as Map<String, dynamic>;
      expect(responseFormat['type'], 'json_schema');
      final jsonSchema = responseFormat['json_schema'] as Map<String, dynamic>;
      expect(jsonSchema['strict'], isTrue);
      final schema = jsonSchema['schema'] as Map<String, dynamic>;
      expect(schema['additionalProperties'], isFalse);
      final messages = sentBody['messages'] as List;
      final userMessage = messages.last as Map<String, dynamic>;
      final input = jsonDecode(userMessage['content'] as String);
      expect(input['input']['evidence']['title'], 'Flutter layout');
      expect(result.provider, 'groq');
      expect(result.collectionIds, [owned]);
      expect(result.tags, ['flutter']);
    },
  );

  test('Groq rejects schema-violating model output', () async {
    final client = _FakeGroqHttpClient((uri, headers, body, timeout) async {
      return GroqHttpResponse(
        statusCode: HttpStatus.ok,
        body: jsonEncode({
          'choices': [
            {
              'message': {
                'content': jsonEncode({
                  'collectionIds': <String>[],
                  'tags': <String>[],
                  'summary': null,
                  'rationale': 'No match.',
                  'evidenceCoverage': 'metadata_only',
                  'uncertain': true,
                  'unexpected': true,
                }),
              },
            },
          ],
        }),
      );
    });

    await expectLater(
      GroqProvider(apiKey: 'test-key', httpClient: client).organize(
        evidence: evidence,
        collections: const [],
      ),
      throwsFormatException,
    );
  });

  test('Groq 429 with Retry-After falls back immediately', () async {
    var calls = 0;
    final client = _FakeGroqHttpClient((uri, headers, body, timeout) async {
      calls++;
      return const GroqHttpResponse(
        statusCode: HttpStatus.tooManyRequests,
        body: '{}',
        retryAfter: '17',
      );
    });
    final provider = FallbackAiProvider(
      primary: GroqProvider(apiKey: 'test-key', httpClient: client),
      fallback: const NoAiProvider(),
    );

    final result = await provider.organize(
      evidence: evidence,
      collections: [AiCollectionOption(id: owned, name: 'Flutter')],
    );

    expect(calls, 1);
    expect(result.provider, 'rules');
  });

  test('Groq timeout falls back to deterministic rules', () async {
    final client = _FakeGroqHttpClient((uri, headers, body, timeout) {
      return Future<GroqHttpResponse>.error(
        TimeoutException('fake request timeout', timeout),
      );
    });
    final provider = FallbackAiProvider(
      primary: GroqProvider(apiKey: 'test-key', httpClient: client),
      fallback: const NoAiProvider(),
    );

    final result = await provider.organize(
      evidence: evidence,
      collections: [AiCollectionOption(id: owned, name: 'Flutter')],
    );

    expect(result.provider, 'rules');
  });

  group('AI provider registry', () {
    tearDown(AiProviderRegistry.resetForTest);

    test('selects Groq before Gemini', () {
      AiProviderRegistry.configure(
        groqApiKey: 'groq-key',
        geminiApiKey: 'gemini-key',
        enabled: true,
      );

      expect(AiProviderRegistry.remote, isA<GroqProvider>());
      expect(AiProviderRegistry.activeProviderName, 'groq');
      expect(AiOrganizingEndpoint.disclosure, contains('GroqCloud'));
      expect(AiOrganizingEndpoint.disclosure, isNot(contains('Gemini')));
    });

    test('selects Gemini only when Groq key is missing', () {
      AiProviderRegistry.configure(
        geminiApiKey: 'gemini-key',
        enabled: true,
      );

      expect(AiProviderRegistry.remote, isA<GeminiProvider>());
      expect(AiProviderRegistry.activeProviderName, 'gemini');
    });

    test('missing keys do not select a remote provider', () {
      AiProviderRegistry.configure(
        groqApiKey: '  ',
        geminiApiKey: null,
        enabled: true,
      );

      expect(AiProviderRegistry.remote, isNull);
      expect(AiProviderRegistry.activeProviderName, 'rules');
    });

    test('global off switch forces deterministic organizing', () {
      AiProviderRegistry.configure(groqApiKey: 'groq-key', enabled: false);

      expect(AiProviderRegistry.remote, isNull);
      expect(AiProviderRegistry.activeProviderName, 'rules');
      expect(
        AiProviderRegistry.provider(userEnabled: true),
        isA<NoAiProvider>(),
      );
    });
  });
}

class _FakeGroqHttpClient implements GroqHttpClient {
  _FakeGroqHttpClient(this.handler);

  final Future<GroqHttpResponse> Function(
    Uri uri,
    Map<String, String> headers,
    String body,
    Duration timeout,
  )
  handler;

  @override
  Future<GroqHttpResponse> post(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
    required Duration timeout,
  }) => handler(uri, headers, body, timeout);
}
