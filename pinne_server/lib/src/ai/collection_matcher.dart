import 'package:serverpod/serverpod.dart';

import '../collections/collection_contents.dart';
import 'ai_provider.dart';

/// An existing collection that looks related to an item, with the words
/// they share.
class CollectionMatch {
  const CollectionMatch({
    required this.collection,
    required this.score,
    required this.shared,
  });

  final AiCollectionOption collection;
  final double score;
  final List<String> shared;

  String get reason {
    final words = shared.take(3).join(', ');
    return "Matches your '${collection.name}' saves: "
        '${words.isEmpty ? 'a similar topic' : 'both mention $words'}.';
  }
}

/// What an item's collection suggestion should be: an existing collection,
/// a new one to create, or nothing.
class CollectionChoice {
  const CollectionChoice.existing(UuidValue this.collectionId, this.reason)
    : newCollectionName = null;
  const CollectionChoice.create(String this.newCollectionName, this.reason)
    : collectionId = null;
  const CollectionChoice.none()
    : collectionId = null,
      newCollectionName = null,
      reason = null;

  final UuidValue? collectionId;
  final String? newCollectionName;
  final String? reason;
}

/// Deterministic collection matching on stored text only.
///
/// An item is compared with each collection's name, description and the
/// titles, tags and summaries of its recent saves. Words in a collection's
/// name count most, then its description and tags, then titles and
/// summaries; a word that recurs across its saves counts a little more.
/// Words that only say which platform a save came from count little, so
/// "both are YouTube videos" never makes two topics related.
abstract final class CollectionMatcher {
  /// The least overlap that makes a collection related: one word of its
  /// name, a shared tag plus a title word, or several shared title words.
  static const relatedScore = 3.0;

  static const _nameWeight = 3.0;
  static const _descriptionWeight = 2.0;
  static const _tagWeight = 2.0;
  static const _textWeight = 1.0;
  static const _weakWeight = 0.5;

  static final _stopWords = _set(
    'a an and are as at be by can do for from has have how i if in '
    'into is it its me my no not of on or our so than that the their '
    'them then there these this to up us was we what when which who '
    'why will with you your about all more most new one out some very '
    'just like get got use using used make way ways thing things good '
    'great best top here now day today save saved later want try look '
    'see read watch check http https www com org net io dev app html '
    'htm php index amp utm ref share post posts status shot shots '
    'watch video videos page link collection saves note notes idea '
    'ideas',
  );

  /// Platforms and content shapes: they say where a save came from, not
  /// what it is about.
  static final _weakWords = _set(
    'youtube youtu tiktok instagram twitter reddit facebook linkedin '
    'medium substack github web article reading newsletter '
    'development podcast thread pin pinterest blog tutorial',
  );

  /// Topics a new collection can be named after. The topic with the most
  /// words in the item wins; ties go to the earlier, more specific one.
  static final _topics = <String, Set<String>>{
    'Flutter': _set(
      'flutter dart widget',
    ),
    'Serverpod': _set(
      'serverpod',
    ),
    'Cooking': _set(
      'recipe cooking baking bake food meal dinner lunch breakfast '
      'pancake pasta cook kitchen',
    ),
    'Design inspiration': _set(
      'design ui ux figma dribbble behance typography',
    ),
    'Development': _set(
      'python javascript typescript react rust kotlin swift android ios '
      'programming coding code api',
    ),
    'Travel': _set(
      'travel trip hotel flight itinerary',
    ),
    'Finance': _set(
      'finance money investing invest budget stock',
    ),
    'Health & fitness': _set(
      'health fitness workout exercise gym running yoga',
    ),
    'Music': _set(
      'music song album playlist',
    ),
    'Podcasts': _set(
      'podcast',
    ),
    'Productivity': _set(
      'productivity habit focus routine',
    ),
    'Career': _set(
      'career job interview resume hiring',
    ),
    'Books': _set(
      'book novel',
    ),
  };

  static Set<String> _set(String words) => words.split(' ').toSet();

  /// Lower-case word stems in [text], without stop words.
  static Set<String> words(String? text) {
    if (text == null) return const {};
    return text
        .toLowerCase()
        .split(RegExp(r'[^a-z0-9]+'))
        .map(_stem)
        .where((word) => word.length >= 2 && !_stopWords.contains(word))
        .where((word) => !RegExp(r'^[0-9]+$').hasMatch(word))
        .toSet();
  }

  static String _stem(String word) {
    if (word.length > 3 && word.endsWith('s') && !word.endsWith('ss')) {
      return word.substring(0, word.length - 1);
    }
    return word;
  }

  /// Every word the item is known by: its text, site and tags.
  static Set<String> itemWords(
    AiItemEvidence evidence, {
    Iterable<String> tags = const [],
  }) {
    final uri = Uri.tryParse(evidence.url ?? '');
    return {
      ...words(evidence.title),
      ...words(evidence.intention),
      ...words(evidence.notes),
      ...words(evidence.description),
      ...words(evidence.siteName),
      ...words(uri?.host),
      ...words(uri?.pathSegments.join(' ')),
      for (final tag in tags) ...words(tag),
    };
  }

  static Map<String, double> _profile(AiCollectionOption collection) {
    final weights = <String, double>{};
    final occurrences = <String, int>{};
    void add(Set<String> found, double weight) {
      for (final word in found) {
        final capped = _weakWords.contains(word)
            ? (weight < _weakWeight ? weight : _weakWeight)
            : weight;
        final current = weights[word] ?? 0;
        if (capped > current) weights[word] = capped;
      }
    }

    add(words(collection.name), _nameWeight);
    add(words(collection.description), _descriptionWeight);
    for (final sample in collection.samples) {
      final sampleWords = <String>{
        ...words(sample.title),
        ...words(sample.summary),
        for (final tag in sample.tags) ...words(tag),
      };
      for (final word in sampleWords) {
        occurrences[word] = (occurrences[word] ?? 0) + 1;
      }
      add({for (final tag in sample.tags) ...words(tag)}, _tagWeight);
      add(words(sample.title), _textWeight);
      add(words(sample.summary), _textWeight);
    }
    for (final entry in occurrences.entries) {
      if (_weakWords.contains(entry.key)) continue;
      final extra = entry.value - 1;
      if (extra > 0) {
        weights[entry.key] =
            weights[entry.key]! + 0.5 * (extra > 2 ? 2 : extra);
      }
    }
    return weights;
  }

  /// The most related of [collections], or null when none reaches
  /// [relatedScore]. Ties go to the fuller collection, then by name.
  static CollectionMatch? bestMatch(
    AiItemEvidence evidence,
    List<AiCollectionOption> collections, {
    Iterable<String> tags = const [],
  }) {
    final item = itemWords(evidence, tags: tags);
    if (item.isEmpty) return null;
    CollectionMatch? best;
    for (final collection in collections) {
      final profile = _profile(collection);
      final shared = item.where(profile.containsKey).toList()
        ..sort((a, b) => profile[b]!.compareTo(profile[a]!));
      final score = shared.fold<double>(0, (sum, word) => sum + profile[word]!);
      if (score < relatedScore) continue;
      final candidate = CollectionMatch(
        collection: collection,
        score: score,
        shared: [
          for (final word in shared)
            if (!_weakWords.contains(word)) word,
        ],
      );
      if (best == null || _better(candidate, best)) best = candidate;
    }
    return best;
  }

  static bool _better(CollectionMatch a, CollectionMatch b) {
    if (a.score != b.score) return a.score > b.score;
    if (a.collection.itemCount != b.collection.itemCount) {
      return a.collection.itemCount > b.collection.itemCount;
    }
    return a.collection.name.compareTo(b.collection.name) < 0;
  }

  /// A topic name for a new collection, or null when the item says too
  /// little to name one.
  static String? proposeName(
    AiItemEvidence evidence, {
    Iterable<String> tags = const [],
  }) {
    final item = itemWords(evidence, tags: tags);
    String? best;
    var bestHits = 0;
    for (final entry in _topics.entries) {
      final hits = entry.value.where(item.contains).length;
      if (hits > bestHits) {
        best = entry.key;
        bestHits = hits;
      }
    }
    return best;
  }

  static String newCollectionReason(String name) =>
      "None of your collections is related yet, so this could start "
      "'$name'.";

  /// The verify step every organizing result goes through before it is
  /// stored, whichever provider made it:
  ///
  /// * an item already in a collection gets no collection suggestion;
  /// * an existing collection the provider chose is kept;
  /// * a proposed new collection is replaced by an existing one with the
  ///   same name, or by the best related existing collection;
  /// * with no proposal, the best related collection is suggested, else a
  ///   new collection named after the item's topic.
  static CollectionChoice settle({
    required AiItemEvidence evidence,
    required List<AiCollectionOption> collections,
    required AiOrganizationResult result,
    required bool alreadyFiled,
  }) {
    if (alreadyFiled) return const CollectionChoice.none();
    final byId = {for (final c in collections) c.id.toString(): c};
    if (result.collectionIds.isNotEmpty) {
      final chosen = byId[result.collectionIds.first.toString()];
      if (chosen != null) {
        return CollectionChoice.existing(
          chosen.id,
          result.collectionReason ?? "Fits your '${chosen.name}' collection.",
        );
      }
    }
    final proposed = result.newCollectionName;
    if (proposed != null) {
      final key = collectionNameKey(proposed);
      for (final collection in collections) {
        if (collectionNameKey(collection.name) == key) {
          return CollectionChoice.existing(
            collection.id,
            result.collectionReason ??
                "Fits your '${collection.name}' collection.",
          );
        }
      }
    }
    final match = bestMatch(evidence, collections, tags: result.tags);
    if (match != null) {
      return CollectionChoice.existing(match.collection.id, match.reason);
    }
    if (proposed == null) return const CollectionChoice.none();
    return CollectionChoice.create(
      proposed,
      result.collectionReason ?? newCollectionReason(proposed),
    );
  }
}
