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

/// One of the owner's collections as the organizer sees it: its name and
/// description plus a compact profile of what is already saved in it, so a
/// related item goes to an existing collection before a new one is proposed.
class AiCollectionOption {
  const AiCollectionOption({
    required this.id,
    required this.name,
    this.description,
    this.itemCount = 0,
    this.samples = const [],
  });

  final UuidValue id;
  final String name;
  final String? description;
  final int itemCount;

  /// A few of its most recently added saves, already truncated.
  final List<AiCollectionSample> samples;

  Map<String, Object?> toJson() => {
    'id': id.toString(),
    'name': name,
    if (description != null) 'description': description,
    'itemCount': itemCount,
    'recentSaves': [for (final sample in samples) sample.toJson()],
  };
}

/// A save inside a collection, reduced to what tells its topic.
class AiCollectionSample {
  const AiCollectionSample({
    required this.title,
    this.tags = const [],
    this.summary,
  });

  final String title;
  final List<String> tags;
  final String? summary;

  Map<String, Object?> toJson() => {
    'title': title,
    if (tags.isNotEmpty) 'tags': tags,
    if (summary != null) 'summary': summary,
  };
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
    this.newCollectionName,
    this.collectionReason,
  });

  /// At most one existing collection the item belongs in.
  final List<UuidValue> collectionIds;

  /// A collection to create, proposed only when no existing one is related.
  final String? newCollectionName;

  /// Why the item fits the chosen or proposed collection.
  final String? collectionReason;

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
  FormatException(:final message) => switch (message) {
    'AI response is not valid JSON.' => 'malformed response (invalid JSON)',
    'AI response has an unexpected shape.' =>
      'malformed response (unexpected fields)',
    'AI response contains invalid field types.' =>
      'malformed response (invalid field types or evidence coverage)',
    'AI response contains an invalid id.' =>
      'malformed response (invalid collection id)',
    'Groq response is not an object.' =>
      'malformed response (Groq response is not an object)',
    'Groq response has no choices.' => 'malformed response (no Groq choices)',
    'Groq response has no model output text.' =>
      'malformed response (no Groq output text)',
    _ => 'malformed response',
  },
  StateError() => 'not configured',
  _ => 'unexpected ${error.runtimeType}',
};
