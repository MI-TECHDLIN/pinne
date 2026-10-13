import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../generated/protocol.dart' show AiEvidenceCoverage;
import 'ai_output_validator.dart';
import 'ai_provider.dart';
import 'ai_request.dart';

class GroqProvider implements AiProvider {
  GroqProvider({
    required this.apiKey,
    GroqHttpClient? httpClient,
    this.model = modelId,
    this.requestTimeout = const Duration(seconds: 8),
    Uri? endpoint,
  }) : _client = httpClient ?? IoGroqHttpClient(),
       _endpoint =
           endpoint ?? Uri.https('api.groq.com', '/openai/v1/chat/completions');

  static const modelId = 'openai/gpt-oss-20b';

  final String apiKey;
  final GroqHttpClient _client;
  final Uri _endpoint;
  final String model;
  final Duration requestTimeout;

  @override
  String get name => 'groq';

  @override
  Future<AiOrganizationResult> organize({
    required AiItemEvidence evidence,
    required List<AiCollectionOption> collections,
  }) async {
    if (apiKey.trim().isEmpty) throw StateError('Groq is not configured.');
    final allowedIds = collections.map((collection) => collection.id).toList();
    final body = jsonEncode({
      'model': model,
      'messages': [
        {'role': 'system', 'content': AiRequest.systemInstruction},
        {'role': 'user', 'content': AiRequest.input(evidence, collections)},
      ],
      'response_format': {
        'type': 'json_schema',
        'json_schema': {
          'name': 'pinne_organization',
          'strict': true,
          'schema': AiRequest.schema(
            allowedIds.map((id) => id.toString()).toList(),
            previewAvailable: evidence.previewAvailable,
          ),
        },
      },
      'max_completion_tokens': 500,
      'reasoning_effort': 'low',
      'include_reasoning': false,
      'stream': false,
    });

    final response = await _client.post(
      _endpoint,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $apiKey',
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
      },
      body: body,
      timeout: requestTimeout,
    );
    if (response.statusCode == HttpStatus.tooManyRequests) {
      throw GroqRateLimitException(retryAfter: response.retryAfter);
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final code = _errorCode(response.body);
      throw GroqException(
        'Groq returned HTTP ${response.statusCode}'
        '${code == null ? '' : ' ($code)'}.',
      );
    }
    final text = _responseText(jsonDecode(response.body));
    return AiOutputValidator.parseJson(
      text,
      allowedCollectionIds: allowedIds,
      provider: name,
      expectedCoverage: evidence.previewAvailable
          ? AiEvidenceCoverage.metadataPlusPreview
          : AiEvidenceCoverage.metadataOnly,
    );
  }

  static String _responseText(Object? response) {
    if (response is! Map<String, dynamic>) {
      throw const FormatException('Groq response is not an object.');
    }
    final choices = response['choices'];
    if (choices is! List || choices.isEmpty) {
      throw const FormatException('Groq response has no choices.');
    }
    final choice = choices.first;
    if (choice is Map && choice['finish_reason'] == 'length') {
      throw const GroqException('Groq output hit the token limit.');
    }
    final message = choice is Map ? choice['message'] : null;
    final content = message is Map ? message['content'] : null;
    if (content is! String || content.isEmpty) {
      throw const FormatException('Groq response has no model output text.');
    }
    return content;
  }

  /// Groq's machine-readable error code, such as `invalid_api_key` or
  /// `json_validate_failed`. Only a bare identifier is kept: the error
  /// message and any failed generation can echo the request.
  static String? _errorCode(String body) {
    try {
      final decoded = jsonDecode(body);
      final error = decoded is Map ? decoded['error'] : null;
      final code = error is Map ? (error['code'] ?? error['type']) : null;
      if (code is String && RegExp(r'^[a-z0-9_]{1,48}$').hasMatch(code)) {
        return code;
      }
    } on FormatException {
      // A proxy or gateway page instead of Groq JSON.
    }
    return null;
  }
}

class GroqHttpResponse {
  const GroqHttpResponse({
    required this.statusCode,
    required this.body,
    this.retryAfter,
  });

  final int statusCode;
  final String body;
  final String? retryAfter;
}

abstract interface class GroqHttpClient {
  Future<GroqHttpResponse> post(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
    required Duration timeout,
  });
}

class IoGroqHttpClient implements GroqHttpClient {
  IoGroqHttpClient([HttpClient? client]) : _client = client ?? HttpClient() {
    _client.connectionTimeout = const Duration(seconds: 3);
  }

  final HttpClient _client;

  @override
  Future<GroqHttpResponse> post(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
    required Duration timeout,
  }) => _post(uri, headers: headers, body: body).timeout(timeout);

  Future<GroqHttpResponse> _post(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
  }) async {
    final request = await _client.postUrl(uri);
    headers.forEach(request.headers.set);
    request.write(body);
    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);
    return GroqHttpResponse(
      statusCode: response.statusCode,
      body: responseBody,
      retryAfter: response.headers.value(HttpHeaders.retryAfterHeader),
    );
  }
}

class GroqException implements Exception {
  const GroqException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'GroqException: $message';
}

class GroqRateLimitException extends GroqException {
  GroqRateLimitException({this.retryAfter})
    : super(
        retryAfter == null
            ? 'Groq rate limit exceeded.'
            : 'Groq rate limit exceeded; retry after $retryAfter.',
      );

  final String? retryAfter;
}
