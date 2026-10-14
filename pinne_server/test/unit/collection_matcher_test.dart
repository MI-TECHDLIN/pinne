import 'dart:convert';

import 'package:pinne_server/src/ai/ai_output_validator.dart';
import 'package:pinne_server/src/ai/ai_provider.dart';
import 'package:pinne_server/src/ai/ai_request.dart';
import 'package:pinne_server/src/ai/collection_matcher.dart';
import 'package:pinne_server/src/ai/no_ai_provider.dart';
import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  final uiId = UuidValue.fromString('00000000-0000-7000-8000-000000000011');
  final flutterId = UuidValue.fromString(
    '00000000-0000-7000-8000-000000000012',
  );
  final cookingVideosId = UuidValue.fromString(
    '00000000-0000-7000-8000-000000000013',
  );
  final ui = AiCollectionOption(
    id: uiId,
    name: 'UI inspiration',
    itemCount: 3,
    samples: const [
      AiCollectionSample(
        title: 'Meditation app onboarding screens',
        tags: ['design', 'dribbble'],
      ),
      AiCollectionSample(title: 'Dashboard UI kit', tags: ['dribbble']),
    ],
  );
  final flutter = AiCollectionOption(
    id: flutterId,
    name: 'Flutter tips',
    samples: const [
      AiCollectionSample(
        title: 'Layouts in Flutter',
        tags: ['flutter'],
        summary: 'How rows and columns build a widget tree.',
      ),
    ],
  );
  final cookingVideos = AiCollectionOption(
    id: cookingVideosId,
    name: 'Weeknight dinners',
    samples: const [
      AiCollectionSample(title: 'Quick ramen', tags: ['youtube', 'video']),
      AiCollectionSample(title: 'Sheet pan salmon', tags: ['youtube']),
    ],
  );
  final collections = [ui, flutter, cookingVideos];

  AiOrganizationResult remote({
    List<UuidValue> ids = const [],
    String? newName,
    List<String> tags = const [],
  }) => AiOrganizationResult(
    collectionIds: ids,
    newCollectionName: newName,
    tags: tags,
    rationale: 'Remote.',
    evidenceCoverage: AiEvidenceCoverage.metadataOnly,
    uncertain: false,
    provider: 'fake',
  );

  group('bestMatch', () {
    test('a design link matches the collection whose saves look alike', () {
      final match = CollectionMatcher.bestMatch(
        const AiItemEvidence(
          title: 'Fintech dashboard concept',
          sourcePlatform: 'web',
          url: 'https://dribbble.com/shots/204-fintech-dashboard',
        ),
        collections,
      );
      expect(match?.collection.id, uiId);
      expect(match!.reason, startsWith("Matches your 'UI inspiration' saves"));
      expect(match.shared, containsAll(['dribbble', 'dashboard']));
    });

    test('an unrelated item matches nothing', () {
      final match = CollectionMatcher.bestMatch(
        const AiItemEvidence(
          title: 'Fluffy buttermilk pancakes recipe',
          sourcePlatform: 'web',
          url: 'https://www.seriouseats.com/fluffy-buttermilk-pancakes',
        ),
        collections,
      );
      expect(match, isNull);
    });

    test('sharing only a platform does not make topics related', () {
      final match = CollectionMatcher.bestMatch(
        const AiItemEvidence(
          title: 'Rust ownership explained',
          sourcePlatform: 'youtube',
          url: 'https://www.youtube.com/watch?v=abc',
        ),
        collections,
        tags: const ['youtube', 'video'],
      );
      expect(match, isNull);
    });

    test('one word of a collection name is enough', () {
      final match = CollectionMatcher.bestMatch(
        const AiItemEvidence(
          title: 'Flutter 4 release notes',
          sourcePlatform: 'web',
        ),
        collections,
      );
      expect(match?.collection.id, flutterId);
    });
  });

  group('proposeName', () {
    test('names a new collection after the item topic', () {
      expect(
        CollectionMatcher.proposeName(
          const AiItemEvidence(
            title: 'Fluffy buttermilk pancakes recipe',
            sourcePlatform: 'web',
          ),
        ),
        'Cooking',
      );
      expect(
        CollectionMatcher.proposeName(
          const AiItemEvidence(
            title: 'Layouts in Flutter',
            sourcePlatform: 'web',
            url: 'https://docs.flutter.dev/ui/layout',
          ),
        ),
        'Flutter',
      );
    });

    test('says nothing when the topic is unknown', () {
      expect(
        CollectionMatcher.proposeName(
          const AiItemEvidence(title: 'Untitled', sourcePlatform: 'web'),
        ),
        isNull,
      );
    });
  });

  group('settle', () {
    const designLink = AiItemEvidence(
      title: 'Travel booking app screens',
      sourcePlatform: 'web',
      url: 'https://dribbble.com/shots/305-travel-booking',
    );

    test('a proposed new collection becomes the related existing one', () {
      final choice = CollectionMatcher.settle(
        evidence: designLink,
        collections: collections,
        result: remote(newName: 'Design references'),
        alreadyFiled: false,
      );
      expect(choice.collectionId, uiId);
      expect(choice.newCollectionName, isNull);
    });

    test('a proposed name equal to an existing one, in any case, is it', () {
      final choice = CollectionMatcher.settle(
        evidence: const AiItemEvidence(title: 'Note', sourcePlatform: 'note'),
        collections: collections,
        result: remote(newName: ' weeknight DINNERS '),
        alreadyFiled: false,
      );
      expect(choice.collectionId, cookingVideosId);
    });

    test('a new collection survives only when nothing is related', () {
      final choice = CollectionMatcher.settle(
        evidence: const AiItemEvidence(
          title: 'Kyoto in autumn itinerary',
          sourcePlatform: 'web',
        ),
        collections: collections,
        result: remote(newName: 'Travel'),
        alreadyFiled: false,
      );
      expect(choice.collectionId, isNull);
      expect(choice.newCollectionName, 'Travel');
      expect(choice.reason, contains('None of your collections'));
    });

    test('the provider choice of an existing collection is kept', () {
      final choice = CollectionMatcher.settle(
        evidence: designLink,
        collections: collections,
        result: remote(ids: [flutterId]),
        alreadyFiled: false,
      );
      expect(choice.collectionId, flutterId);
    });

    test('a related collection is found even when the provider chose none, '
        'but no new one is invented for it', () {
      expect(
        CollectionMatcher.settle(
          evidence: designLink,
          collections: collections,
          result: remote(),
          alreadyFiled: false,
        ).collectionId,
        uiId,
      );
      final none = CollectionMatcher.settle(
        evidence: const AiItemEvidence(
          title: 'Fluffy pancakes recipe',
          sourcePlatform: 'web',
        ),
        collections: collections,
        result: remote(),
        alreadyFiled: false,
      );
      expect(none.collectionId, isNull);
      expect(none.newCollectionName, isNull);
    });

    test('an item already in a collection gets no suggestion', () {
      final choice = CollectionMatcher.settle(
        evidence: designLink,
        collections: collections,
        result: remote(ids: [uiId]),
        alreadyFiled: true,
      );
      expect(choice.collectionId, isNull);
      expect(choice.newCollectionName, isNull);
    });
  });

  test('rules suggest the related collection, else a new one', () async {
    final related = await const NoAiProvider().organize(
      evidence: const AiItemEvidence(
        title: 'Fintech dashboard concept',
        sourcePlatform: 'web',
        url: 'https://dribbble.com/shots/204-fintech-dashboard',
      ),
      collections: collections,
    );
    expect(related.collectionIds, [uiId]);
    expect(related.newCollectionName, isNull);

    final unrelated = await const NoAiProvider().organize(
      evidence: const AiItemEvidence(
        title: 'Fluffy buttermilk pancakes recipe',
        sourcePlatform: 'web',
        url: 'https://www.seriouseats.com/fluffy-buttermilk-pancakes',
      ),
      collections: collections,
    );
    expect(unrelated.collectionIds, isEmpty);
    expect(unrelated.newCollectionName, 'Cooking');
  });

  group('validator', () {
    test('keeps one collection, and no new one beside an existing one', () {
      final result = AiOutputValidator.parseJson(
        jsonEncode({
          'collectionIds': [uiId.toString(), flutterId.toString()],
          'newCollectionName': 'Design',
          'collectionReason': '  Matches your design saves. ',
          'tags': <String>[],
          'summary': null,
          'rationale': 'r',
          'evidenceCoverage': 'metadata_only',
          'uncertain': false,
        }),
        allowedCollectionIds: [uiId, flutterId],
        provider: 'test',
      );
      expect(result.collectionIds, [uiId]);
      expect(result.newCollectionName, isNull);
      expect(result.collectionReason, 'Matches your design saves.');
    });

    test('cleans proposed names and drops placeholders', () {
      expect(
        AiOutputValidator.cleanCollectionName('  "ui   inspiration"\n'),
        'Ui inspiration',
      );
      expect(AiOutputValidator.cleanCollectionName('Misc'), isNull);
      expect(AiOutputValidator.cleanCollectionName('New collection'), isNull);
      expect(AiOutputValidator.cleanCollectionName('   '), isNull);
      expect(
        AiOutputValidator.cleanCollectionName('x' * 80),
        hasLength(AiOutputValidator.maxCollectionNameLength),
      );
    });

    test('the schema requires the collection fields', () {
      final schema = AiRequest.schema(const [], previewAvailable: false);
      expect(
        schema['required'],
        containsAll(['newCollectionName', 'collectionReason']),
      );
    });
  });

  test('the prompt carries each collection profile', () {
    final input =
        jsonDecode(
              AiRequest.input(
                const AiItemEvidence(title: 'x', sourcePlatform: 'web'),
                [ui],
              ),
            )
            as Map<String, dynamic>;
    final sent =
        ((input['input'] as Map<String, dynamic>)['collections'] as List).single
            as Map<String, dynamic>;
    expect(sent['name'], 'UI inspiration');
    expect(sent['itemCount'], 3);
    expect(
      (sent['recentSaves'] as List).first,
      {
        'title': 'Meditation app onboarding screens',
        'tags': ['design', 'dribbble'],
      },
    );
    expect(input['task'], contains('Only when no collection is related'));
  });
}
