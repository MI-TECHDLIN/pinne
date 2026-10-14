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
  static const maxCollectionNameLength = 40;

  /// One collection per item: the closest existing one, else one to create.
  static const maxCollections = 1;

  /// Tags that say nothing about the item: model placeholders for missing
  /// evidence, and words that only describe the link's shape (a `youtu.be`
  /// short link). They are never suggested, whichever provider made them.
  static const placeholderTags = {
    'unknown',
    'none',
    'null',
    'n-a',
    'na',
    'tbd',
    'undefined',
    'untitled',
    'no-title',
    'other',
    'misc',
    'miscellaneous',
    'general',
    'uncategorized',
    'link',
    'links',
    'url',
    'short',
    'short-link',
    'shortlink',
    'http',
    'https',
    'www',
  };
  static const _placeholderCollections = {
    'collection',
    'new-collection',
    'collections',
    'saved',
    'saves',
    'inbox',
    'not-sorted',
    'unsorted',
  };

  /// Keys a response may leave out; they read as null.
  static const _optionalKeys = {'newCollectionName', 'collectionReason'};
  static const _keys = {
    'collectionIds',
    'newCollectionName',
    'collectionReason',
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
    AiEvidenceCoverage expectedCoverage = AiEvidenceCoverage.metadataOnly,
  }) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException {
      throw const FormatException('AI response is not valid JSON.');
    }
    if (decoded is! Map<String, dynamic> ||
        decoded.keys.any((key) => !_keys.contains(key)) ||
        !_keys.difference(_optionalKeys).every(decoded.containsKey)) {
      throw const FormatException('AI response has an unexpected shape.');
    }
    final ids = decoded['collectionIds'];
    final newCollectionName = decoded['newCollectionName'];
    final collectionReason = decoded['collectionReason'];
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
        (newCollectionName != null && newCollectionName is! String) ||
        (collectionReason != null && collectionReason is! String) ||
        rationale is! String ||
        coverage != _coverageName(expectedCoverage) ||
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
        newCollectionName: newCollectionName as String?,
        collectionReason: collectionReason as String?,
        rationale: rationale,
        evidenceCoverage: expectedCoverage,
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
    AiEvidenceCoverage? evidenceCoverage,
  }) {
    final allowed = allowedCollectionIds.map((id) => id.toString()).toSet();
    final ids = <UuidValue>[];
    final seenIds = <String>{};
    for (final id in result.collectionIds) {
      final text = id.toString();
      if (allowed.contains(text) && seenIds.add(text)) ids.add(id);
      if (ids.length == maxCollections) break;
    }

    final tags = <String>[];
    final seenTags = <String>{};
    for (final raw in result.tags) {
      final tag = normalizeTag(raw);
      if (tag.isNotEmpty &&
          !placeholderTags.contains(tag) &&
          seenTags.add(tag)) {
        tags.add(tag);
      }
      if (tags.length == maxTags) break;
    }
    final summary = _capSummary(result.summary);
    final reason = result.collectionReason?.trim() ?? '';
    return AiOrganizationResult(
      collectionIds: ids,
      // An existing collection always wins over creating another.
      newCollectionName: ids.isEmpty
          ? cleanCollectionName(result.newCollectionName)
          : null,
      collectionReason: reason.isEmpty
          ? null
          : _cap(reason, maxRationaleLength),
      tags: tags,
      summary: summary,
      rationale: _cap(result.rationale.trim(), maxRationaleLength),
      evidenceCoverage: evidenceCoverage ?? result.evidenceCoverage,
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

  /// A proposed collection name made safe to show and store: one line,
  /// without quotes, at most [maxCollectionNameLength] characters. Null when
  /// it is empty or a placeholder such as "Misc".
  static String? cleanCollectionName(String? value) {
    if (value == null) return null;
    final clean = value
        .replaceAll(RegExp(r'[\u0000-\u001f"“”]'), ' ')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
    final key = normalizeTag(clean);
    if (key.isEmpty ||
        placeholderTags.contains(key) ||
        _placeholderCollections.contains(key)) {
      return null;
    }
    final capped = _cap(clean, maxCollectionNameLength);
    return capped[0].toUpperCase() + capped.substring(1);
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

  static String _coverageName(AiEvidenceCoverage coverage) =>
      coverage == AiEvidenceCoverage.metadataPlusPreview
      ? 'metadata_plus_preview'
      : 'metadata_only';
}
