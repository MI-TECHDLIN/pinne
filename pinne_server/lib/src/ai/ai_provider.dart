import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

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
  FallbackAiProvider({required this.primary, required this.fallback});

  final AiProvider primary;
  final AiProvider fallback;

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
    } catch (_) {
      return fallback.organize(evidence: evidence, collections: collections);
    }
  }
}
