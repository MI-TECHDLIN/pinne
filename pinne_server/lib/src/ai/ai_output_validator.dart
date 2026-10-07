import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'ai_provider.dart';

/// Strict boundary between untrusted model output and persisted suggestions.
abstract final class AiOutputValidator {
  static const maxTags = 5;
  static const maxTagLength = 32;
  static const maxSummaryLength = 360;
  static const maxRationaleLength = 240;
  static const _keys = {
    'collectionIds',
    'tags',
    'summary',
    'rationale',
    'evidenceCoverage',
    'uncertain',
  };

  static AiOrganizationResult parseJson(
    String source, {
    required Iterable<UuidValue> allowedCollectionIds,
    required String provider,
  }) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException {
      throw const FormatException('AI response is not valid JSON.');
    }
    if (decoded is! Map<String, dynamic> ||
        decoded.keys.any((key) => !_keys.contains(key)) ||
        !_keys.every(decoded.containsKey)) {
      throw const FormatException('AI response has an unexpected shape.');
    }
    final ids = decoded['collectionIds'];
    final tags = decoded['tags'];
    final summary = decoded['summary'];
    final rationale = decoded['rationale'];
    final coverage = decoded['evidenceCoverage'];
    final uncertain = decoded['uncertain'];
    if (ids is! List ||
        ids.any((value) => value is! String) ||
        tags is! List ||
        tags.any((value) => value is! String) ||
        (summary != null && summary is! String) ||
        rationale is! String ||
        coverage != 'metadata_only' ||
        uncertain is! bool) {
      throw const FormatException('AI response contains invalid field types.');
    }

    final parsedIds = <UuidValue>[];
    for (final raw in ids.cast<String>()) {
      try {
        parsedIds.add(UuidValue.fromString(raw));
      } on FormatException {
        throw const FormatException('AI response contains an invalid id.');
      }
    }
    return sanitize(
      AiOrganizationResult(
        collectionIds: parsedIds,
        tags: tags.cast<String>(),
        summary: summary as String?,
        rationale: rationale,
        evidenceCoverage: AiEvidenceCoverage.metadataOnly,
        uncertain: uncertain,
        provider: provider,
      ),
      allowedCollectionIds: allowedCollectionIds,
    );
  }

  /// Revalidates even typed results so test doubles and future providers do
  /// not bypass ownership and length rules.
  static AiOrganizationResult sanitize(
    AiOrganizationResult result, {
    required Iterable<UuidValue> allowedCollectionIds,
  }) {
    if (result.evidenceCoverage != AiEvidenceCoverage.metadataOnly) {
      throw const FormatException('Unsupported evidence coverage.');
    }
    final allowed = allowedCollectionIds.map((id) => id.toString()).toSet();
    final ids = <UuidValue>[];
    final seenIds = <String>{};
    for (final id in result.collectionIds) {
      final text = id.toString();
      if (allowed.contains(text) && seenIds.add(text)) ids.add(id);
    }

    final tags = <String>[];
    final seenTags = <String>{};
    for (final raw in result.tags) {
      final tag = normalizeTag(raw);
      if (tag.isNotEmpty && seenTags.add(tag)) tags.add(tag);
      if (tags.length == maxTags) break;
    }
    final summary = _capSummary(result.summary);
    return AiOrganizationResult(
      collectionIds: ids,
      tags: tags,
      summary: summary,
      rationale: _cap(result.rationale.trim(), maxRationaleLength),
      evidenceCoverage: AiEvidenceCoverage.metadataOnly,
      uncertain: result.uncertain,
      provider: _cap(result.provider.trim(), 40),
    );
  }

  static String normalizeTag(String value) {
    var normalized = value.trim().toLowerCase();
    normalized = normalized.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    normalized = normalized.replaceAll(RegExp(r'^-+|-+$'), '');
    return _cap(normalized, maxTagLength).replaceAll(RegExp(r'-+$'), '');
  }

  static String? _capSummary(String? value) {
    if (value == null) return null;
    final clean = value.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (clean.isEmpty) return null;
    final sentences = RegExp(r'[^.!?]+[.!?]?')
        .allMatches(clean)
        .map((match) => match.group(0)!.trim())
        .where((part) => part.isNotEmpty)
        .take(2)
        .join(' ');
    return _cap(sentences, maxSummaryLength);
  }

  static String _cap(String value, int length) =>
      value.length <= length ? value : value.substring(0, length).trimRight();
}
