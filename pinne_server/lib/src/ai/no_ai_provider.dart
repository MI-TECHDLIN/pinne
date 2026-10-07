import '../generated/protocol.dart';
import 'ai_output_validator.dart';
import 'ai_provider.dart';

/// Fully local, deterministic fallback. It never fetches a URL.
class NoAiProvider implements AiProvider {
  const NoAiProvider();

  @override
  String get name => 'rules';

  static const _hostTags = {
    'github.com': 'development',
    'youtube.com': 'video',
    'youtu.be': 'video',
    'medium.com': 'reading',
    'substack.com': 'newsletter',
  };

  static const _pathKeywords = {
    'recipe',
    'design',
    'flutter',
    'serverpod',
    'travel',
    'finance',
    'health',
    'music',
    'video',
    'article',
  };

  @override
  Future<AiOrganizationResult> organize({
    required AiItemEvidence evidence,
    required List<AiCollectionOption> collections,
  }) async {
    final tags = <String>{};
    final platform = AiOutputValidator.normalizeTag(evidence.sourcePlatform);
    if (platform != 'web' && platform != 'other' && platform.isNotEmpty) {
      tags.add(platform);
    }

    final uri = Uri.tryParse(evidence.url ?? '');
    if (uri != null) {
      final host = uri.host.toLowerCase().replaceFirst(RegExp(r'^www\.'), '');
      for (final entry in _hostTags.entries) {
        if (host == entry.key || host.endsWith('.${entry.key}')) {
          tags.add(entry.value);
        }
      }
      final pathTokens = uri.pathSegments
          .expand((part) => part.toLowerCase().split(RegExp(r'[^a-z0-9]+')))
          .where(_pathKeywords.contains);
      tags.addAll(pathTokens);
    }

    final haystack = [
      evidence.title,
      evidence.url,
      evidence.intention,
      evidence.notes,
      ...tags,
    ].whereType<String>().join(' ').toLowerCase();
    final collectionIds = collections
        .where((collection) {
          final needle = collection.name.trim().toLowerCase();
          if (needle.isEmpty) return false;
          final escaped = RegExp.escape(needle);
          return RegExp(
            '(^|[^a-z0-9])$escaped([^a-z0-9]|\$)',
          ).hasMatch(haystack);
        })
        .map((collection) => collection.id)
        .toList();

    return AiOutputValidator.sanitize(
      AiOrganizationResult(
        collectionIds: collectionIds,
        tags: tags.toList(),
        summary: null,
        rationale: collectionIds.isEmpty
            ? 'Matched source and URL metadata only.'
            : 'Matched collection names and metadata keywords exactly.',
        evidenceCoverage: AiEvidenceCoverage.metadataOnly,
        uncertain: collectionIds.isEmpty,
        provider: name,
      ),
      allowedCollectionIds: collections.map((collection) => collection.id),
    );
  }
}
