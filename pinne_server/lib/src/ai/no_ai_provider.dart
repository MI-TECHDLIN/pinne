import '../generated/protocol.dart';
import 'ai_output_validator.dart';
import 'ai_provider.dart';
import 'collection_matcher.dart';

/// Fully local, deterministic fallback. It never fetches a URL.
///
/// Every saved link gets at least a site tag, and a summary once a preview
/// description (or the user's note) is stored, so an item never ends up with
/// no suggestions just because the remote provider is unavailable.
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

  static const _keywords = {
    'recipe',
    'design',
    'flutter',
    'dart',
    'serverpod',
    'travel',
    'finance',
    'health',
    'music',
    'video',
    'article',
    'tutorial',
    'podcast',
    'python',
    'javascript',
    'typescript',
    'react',
    'rust',
    'kotlin',
    'swift',
    'android',
    'ios',
    'fitness',
    'cooking',
    'productivity',
    'career',
  };

  /// Platforms that say nothing about the content, so never become tags.
  static const _untaggedPlatforms = {'web', 'other', 'unknown', 'note'};

  /// Host labels that name a section of a site rather than the site.
  static const _genericHostLabels = {
    'www',
    'docs',
    'doc',
    'blog',
    'blogs',
    'm',
    'mobile',
    'en',
    'api',
    'app',
    'dev',
    'developer',
    'developers',
    'news',
    'help',
    'support',
    'web',
  };

  @override
  Future<AiOrganizationResult> organize({
    required AiItemEvidence evidence,
    required List<AiCollectionOption> collections,
  }) async {
    final tags = <String>{};
    final platform = AiOutputValidator.normalizeTag(evidence.sourcePlatform);
    if (!_untaggedPlatforms.contains(platform) && platform.isNotEmpty) {
      tags.add(platform);
    }

    final uri = Uri.tryParse(evidence.url ?? '');
    final host = (uri?.host ?? '').toLowerCase().replaceFirst(
      RegExp(r'^www\.'),
      '',
    );
    if (host.isNotEmpty) {
      for (final entry in _hostTags.entries) {
        if (host == entry.key || host.endsWith('.${entry.key}')) {
          tags.add(entry.value);
        }
      }
      if (_siteLabel(host) case final site?) tags.add(site);
    }

    final text = [
      ...?uri?.pathSegments,
      evidence.title,
      evidence.intention,
      evidence.notes,
      evidence.description,
      evidence.siteName,
    ].whereType<String>().join(' ').toLowerCase();
    tags.addAll(
      text.split(RegExp(r'[^a-z0-9]+')).where(_keywords.contains).toSet(),
    );

    // The closest existing collection by name, description and contents;
    // only when none is related, a new one named after the item's topic.
    final match = CollectionMatcher.bestMatch(
      evidence,
      collections,
      tags: tags,
    );
    final newCollectionName = match == null
        ? CollectionMatcher.proposeName(evidence, tags: tags)
        : null;

    // Extractive only: the page's own description, else the user's note.
    // The validator keeps at most two sentences.
    final summary =
        [
              evidence.description,
              evidence.notes,
            ]
            .whereType<String>()
            .map((value) => value.trim())
            .firstWhere(
              (value) => value.isNotEmpty,
              orElse: () => '',
            );

    return AiOutputValidator.sanitize(
      AiOrganizationResult(
        collectionIds: [?match?.collection.id],
        newCollectionName: newCollectionName,
        collectionReason: switch ((match, newCollectionName)) {
          (final match?, _) => match.reason,
          (_, final name?) => CollectionMatcher.newCollectionReason(name),
          _ => null,
        },
        tags: tags.toList(),
        summary: summary.isEmpty ? null : summary,
        rationale: [
          match == null
              ? 'Matched source and URL metadata only.'
              : 'Compared it with what your collections already hold.',
          if (summary.isNotEmpty) 'The summary quotes the saved text.',
        ].join(' '),
        evidenceCoverage: evidence.previewAvailable
            ? AiEvidenceCoverage.metadataPlusPreview
            : AiEvidenceCoverage.metadataOnly,
        // Every rule is an exact match on stored text, so nothing it
        // suggests is a guess that needs a "Maybe".
        uncertain: false,
        provider: name,
      ),
      allowedCollectionIds: collections.map((collection) => collection.id),
    );
  }

  /// The registrable name of [host]: `docs.flutter.dev` is `flutter`,
  /// `bbc.co.uk` is `bbc`. Null for IP addresses and single labels.
  static String? _siteLabel(String host) {
    if (RegExp(r'^[0-9.:]+$').hasMatch(host)) return null;
    final labels = host.split('.').where((part) => part.isNotEmpty).toList();
    if (labels.length < 2) return null;
    // A two-letter country code after a short second level (co.uk, com.au).
    final countrySecondLevel =
        labels.length >= 3 &&
        labels.last.length == 2 &&
        labels[labels.length - 2].length <= 3;
    final index = labels.length - (countrySecondLevel ? 3 : 2);
    final label = AiOutputValidator.normalizeTag(labels[index]);
    if (label.isEmpty || _genericHostLabels.contains(label)) return null;
    return label;
  }
}
