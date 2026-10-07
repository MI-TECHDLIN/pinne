import 'package:pinne_server/src/generated/protocol.dart';
import 'package:pinne_server/src/reviews/review_service.dart';
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Keyword search', (sessionBuilder, endpoints) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;

    setUp(() async {
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
    });

    test(
      'ranks owner results and explains title, note and source matches',
      () async {
        await endpoints.item.create(
          alice,
          ItemDraft(
            title: 'Flutter desktop sidebar',
            url: 'https://x.com/example/status/1',
            sourcePlatform: SourcePlatform.x,
            contentType: ContentType.post,
            intention: 'Try this navigation pattern in my dashboard',
          ),
        );
        await endpoints.item.create(
          alice,
          ItemDraft(
            title: 'Adaptive navigation rail',
            url: 'https://youtube.com/watch?v=1',
            sourcePlatform: SourcePlatform.youtube,
            contentType: ContentType.video,
            intention: 'Desktop layouts',
          ),
        );
        await endpoints.item.create(
          bob,
          ItemDraft(title: 'Flutter desktop sidebar private'),
        );

        final page = await endpoints.search.keyword(
          alice,
          query: 'desktop sidebar from X',
        );
        expect(page.results.first.item.title, 'Flutter desktop sidebar');
        expect(
          page.results.every(
            (result) => !result.item.title.contains('private'),
          ),
          isTrue,
        );
        expect(
          page.results.first.evidence.map((e) => e.field),
          contains('title'),
        );

        final source = await endpoints.search.keyword(
          alice,
          query: 'x',
          source: SourcePlatform.x,
        );
        expect(source.results.single.item.sourcePlatform, SourcePlatform.x);
        expect(
          source.results.single.evidence.map((e) => e.field),
          contains('source'),
        );
      },
    );

    test('filters collections, content type and honest review state', () async {
      final reviewed = await endpoints.item.create(
        alice,
        ItemDraft(
          title: 'Flutter animation guide',
          sourcePlatform: SourcePlatform.web,
          contentType: ContentType.article,
        ),
      );
      final unreviewed = await endpoints.item.create(
        alice,
        ItemDraft(
          title: 'Flutter animation video',
          sourcePlatform: SourcePlatform.youtube,
          contentType: ContentType.video,
        ),
      );
      final collection = await endpoints.collection.create(
        alice,
        CollectionDraft(name: 'Flutter', coverSeed: 1, paletteIndex: 0),
      );
      final session = alice.build();
      addTearDown(session.close);
      await ItemCollection.db.insertRow(
        session,
        ItemCollection(
          ownerId: unreviewed.ownerId,
          itemId: unreviewed.id!,
          collectionId: collection.id!,
        ),
      );
      await const ReviewService().record(
        session,
        reviewed.ownerId,
        ReviewEventDraft(
          clientEventId: 'reviewed-for-search',
          itemId: reviewed.id!,
          eventType: ReviewEventType.reviewed,
          occurredAt: DateTime.utc(2026, 10, 6),
          timezone: 'UTC',
          timezoneOffsetMinutes: 0,
        ),
      );

      final filtered = await endpoints.search.keyword(
        alice,
        query: 'Flutter animation',
        source: SourcePlatform.youtube,
        contentType: ContentType.video,
        collectionId: collection.id,
        reviewStatus: ReviewStatusFilter.unreviewed,
      );
      expect(filtered.results.single.item.id, unreviewed.id);

      final reviewedOnly = await endpoints.search.keyword(
        alice,
        query: 'Flutter animation',
        reviewStatus: ReviewStatusFilter.reviewed,
      );
      expect(reviewedOnly.results.single.item.id, reviewed.id);
    });

    test('explains note, tag and URL host matches', () async {
      final item = await endpoints.item.create(
        alice,
        ItemDraft(
          title: 'Saved reference',
          url: 'https://patterns.example.dev/reference',
        ),
      );
      final session = alice.build();
      addTearDown(session.close);
      await ItemNote.db.insertRow(
        session,
        ItemNote(
          ownerId: item.ownerId,
          itemId: item.id!,
          body: 'Riverpod family cache details',
        ),
      );
      final tag = await Tag.db.insertRow(
        session,
        Tag(
          ownerId: item.ownerId,
          normalizedName: 'state-management',
          displayName: 'State management',
        ),
      );
      await ItemTag.db.insertRow(
        session,
        ItemTag(
          ownerId: item.ownerId,
          itemId: item.id!,
          tagId: tag.id!,
        ),
      );

      final note = await endpoints.search.keyword(alice, query: 'Riverpod');
      expect(
        note.results.single.evidence.map((value) => value.field),
        contains('note'),
      );

      final tagged = await endpoints.search.keyword(alice, query: 'management');
      expect(
        tagged.results.single.evidence.map((value) => value.field),
        contains('tag'),
      );

      final host = await endpoints.search.keyword(
        alice,
        query: 'example',
      );
      expect(
        host.results.single.evidence.map((value) => value.field),
        contains('URL host'),
      );
    });

    test(
      'cursor pagination is stable and foreign collections look missing',
      () async {
        for (var i = 0; i < 3; i++) {
          await endpoints.item.create(
            alice,
            ItemDraft(title: 'Flutter pattern $i'),
          );
        }
        final first = await endpoints.search.keyword(
          alice,
          query: 'Flutter',
          limit: 1,
        );
        expect(first.results, hasLength(1));
        expect(first.nextCursor, isNotNull);
        final second = await endpoints.search.keyword(
          alice,
          query: 'Flutter',
          limit: 1,
          cursor: first.nextCursor,
        );
        expect(
          second.results.single.item.id,
          isNot(first.results.single.item.id),
        );

        final foreign = await endpoints.collection.create(
          bob,
          CollectionDraft(name: 'Bob', coverSeed: 2, paletteIndex: 0),
        );
        await expectLater(
          endpoints.search.keyword(
            alice,
            query: 'Flutter',
            collectionId: foreign.id,
          ),
          throwsA(isA<RecordNotFoundException>()),
        );
      },
    );
  });
}
