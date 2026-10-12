import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'gemini_provider.dart';
import 'groq_provider.dart';

/// Metadata that is already stored for an item. Providers must not fetch [url].
class AiItemEvidence {
  const AiItemEvidence({
    required this.title,
    required this.sourcePlatform,
    this.url,
    this.intention,
    this.notes,
    this.description,
    this.author,
    this.siteName,
    this.previewAvailable = false,
  });

  final String title;
  final String? url;
  final String sourcePlatform;
  final String? intention;
  final String? notes;
  final String? description;
  final String? author;
  final String? siteName;
  final bool previewAvailable;

  Map<String, Object?> toJson() => {
    'title': title,
    'url': url,
    'sourcePlatform': sourcePlatform,
    'intention': intention,
    'notes': notes,
    'description': description,
    'author': author,
    'siteName': siteName,
    'evidenceCoverage': previewAvailable
        ? 'metadata_plus_preview'
        : 'metadata_only',
  };
}

class AiCollectionOption {
  const AiCollectionOption({required this.id, required this.name});

  final UuidValue id;
  final String name;

  Map<String, Object?> toJson() => {'id': id.toString(), 'name': name};
}

class AiOrganizationResult {
  const AiOrganizationResult({
    required this.collectionIds,
    required this.tags,
    required this.rationale,
    required this.evidenceCoverage,
    required this.uncertain,
    required this.provider,
    this.summary,
  });

  final List<UuidValue> collectionIds;
  final List<String> tags;
  final String? summary;
  final String rationale;
  final AiEvidenceCoverage evidenceCoverage;
  final bool uncertain;
  final String provider;
}

abstract interface class AiProvider {
  String get name;

  Future<AiOrganizationResult> organize({
    required AiItemEvidence evidence,
    required List<AiCollectionOption> collections,
  });
}

/// Tries the network provider, but makes every failure a deterministic result.
class FallbackAiProvider implements AiProvider {
  FallbackAiProvider({
    required this.primary,
    required this.fallback,
    this.onPrimaryFailure,
  });

  final AiProvider primary;
  final AiProvider fallback;

  /// Told about each swallowed primary failure, so it can be logged.
  final void Function(Object error)? onPrimaryFailure;

  @override
  String get name => '${primary.name}+${fallback.name}';

  @override
  Future<AiOrganizationResult> organize({
    required AiItemEvidence evidence,
    required List<AiCollectionOption> collections,
  }) async {
    try {
      return await primary.organize(
        evidence: evidence,
        collections: collections,
      );
    } catch (error) {
      onPrimaryFailure?.call(error);
      return fallback.organize(evidence: evidence, collections: collections);
    }
  }
}

/// Why a provider call failed, safe for operator logs: the failure class and
/// HTTP status only, never the key, the prompt or the response body.
String describeAiFailure(Object error) => switch (error) {
  TimeoutException() => 'timeout',
  GroqException(:final message) || GeminiException(:final message) => message,
  SocketException() ||
  HandshakeException() ||
  HttpException() => 'network error (${error.runtimeType})',
  FormatException() => 'malformed response',
  StateError() => 'not configured',
  _ => 'unexpected ${error.runtimeType}',
};
