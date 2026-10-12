import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../generated/protocol.dart' show AiEvidenceCoverage;
import 'ai_output_validator.dart';
import 'ai_provider.dart';
import 'ai_request.dart';

class GeminiProvider implements AiProvider {
  GeminiProvider({
    required this.apiKey,
    HttpClient? httpClient,
    this.model = 'gemini-3.5-flash-lite',
    this.requestTimeout = const Duration(seconds: 8),
    this.maxAttempts = 3,
    Uri? endpoint,
    Future<void> Function(Duration)? delay,
  }) : _client = httpClient ?? HttpClient(),
       _endpoint =
           endpoint ??
           Uri.https(
             'generativelanguage.googleapis.com',
             '/v1beta/interactions',
           ),
       _delay = delay ?? Future<void>.delayed,
       assert(maxAttempts > 0) {
    _client.connectionTimeout = const Duration(seconds: 3);
  }

  final String apiKey;
  final HttpClient _client;
  final Uri _endpoint;
  final Future<void> Function(Duration) _delay;
  final String model;
  final Duration requestTimeout;
  final int maxAttempts;

  @override
  String get name => 'gemini';

  @override
  Future<AiOrganizationResult> organize({
    required AiItemEvidence evidence,
    required List<AiCollectionOption> collections,
  }) async {
    if (apiKey.trim().isEmpty) throw StateError('Gemini is not configured.');
    final allowedIds = collections.map((collection) => collection.id).toList();
    final body = jsonEncode({
      'model': model,
      'system_instruction': AiRequest.systemInstruction,
      'input': AiRequest.input(evidence, collections),
      'generation_config': {
        'max_output_tokens': 500,
        'thinking_level': 'minimal',
      },
      'response_format': {
        'type': 'text',
        'mime_type': 'application/json',
        'schema': AiRequest.schema(
          allowedIds.map((id) => id.toString()).toList(),
          previewAvailable: evidence.previewAvailable,
        ),
      },
      'store': false,
    });

    Object? lastError;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response = await _post(body);
        if (response.statusCode == 429 || response.statusCode >= 500) {
          throw _RetryableGeminiException(response.statusCode);
        }
        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw GeminiException('Gemini returned HTTP ${response.statusCode}.');
        }
        final decoded = jsonDecode(response.body);
        final text = _responseText(decoded);
        return AiOutputValidator.parseJson(
          text,
          allowedCollectionIds: allowedIds,
          provider: name,
          expectedCoverage: evidence.previewAvailable
              ? AiEvidenceCoverage.metadataPlusPreview
              : AiEvidenceCoverage.metadataOnly,
        );
      } on _RetryableGeminiException catch (error) {
        lastError = error;
      } on TimeoutException catch (error) {
        lastError = error;
      } on SocketException catch (error) {
        lastError = error;
      }
      if (attempt < maxAttempts) {
        await _delay(Duration(milliseconds: 200 * (1 << (attempt - 1))));
      }
    }
    throw GeminiException('Gemini was temporarily unavailable.', lastError);
  }

  Future<({int statusCode, String body})> _post(String body) async {
    final request = await _client.postUrl(_endpoint).timeout(requestTimeout);
    request.headers
      ..set(HttpHeaders.contentTypeHeader, ContentType.json.mimeType)
      ..set('x-goog-api-key', apiKey);
    request.write(body);
    final response = await request.close().timeout(requestTimeout);
    final responseBody = await utf8
        .decodeStream(response)
        .timeout(requestTimeout);
    return (statusCode: response.statusCode, body: responseBody);
  }

  static String _responseText(Object? response) {
    if (response is! Map<String, dynamic>) {
      throw const FormatException('Gemini response is not an object.');
    }
    if (response['status'] != 'completed') {
      throw const FormatException('Gemini interaction did not complete.');
    }
    final steps = response['steps'];
    if (steps is! List) {
      throw const FormatException('Gemini response has no steps.');
    }
    for (final step in steps.reversed) {
      if (step is! Map || step['type'] != 'model_output') continue;
      final content = step['content'];
      if (content is! List) continue;
      for (final part in content) {
        if (part is Map && part['type'] == 'text' && part['text'] is String) {
          return part['text'] as String;
        }
      }
    }
    throw const FormatException('Gemini response has no model output text.');
  }
}

class GeminiException implements Exception {
  const GeminiException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'GeminiException: $message';
}

class _RetryableGeminiException extends GeminiException {
  _RetryableGeminiException(int statusCode)
    : super('Gemini transient HTTP $statusCode.');
}
