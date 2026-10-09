import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';

/// Opt-in starter data for a new account.
///
/// Every query is owner-scoped. Seeding is idempotent because an owner with
/// any example row is returned unchanged; removal only touches flagged rows.
class ExampleSavesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<ExampleSavesStatus> status(Session session) =>
      _status(session, session.ownerId);

  Future<ExampleSavesStatus> seed(Session session) async {
    final ownerId = session.ownerId;
    return session.db.transaction((tx) async {
      // Serialize retries for one owner so concurrent taps still create one
      // starter set. The UUID remains a parameter, never interpolated SQL.
      await session.db.unsafeQuery(
        'SELECT pg_advisory_xact_lock(hashtextextended(\$1, 0))',
        parameters: QueryParameters.positional([ownerId.toString()]),
        transaction: tx,
      );
      final existing = await Item.db.count(
        session,
        where: (t) => t.ownerId.equals(ownerId) & t.isExample.equals(true),
        transaction: tx,
      );
      if (existing == 0) {
        final now = DateTime.now().toUtc();
        final collections = await Collection.db.insert(
          session,
          [
            Collection(
              ownerId: ownerId,
              name: 'Ideas to try',
              description: 'Example saves for projects and creative sparks.',
              coverSeed: 1847,
              paletteIndex: 0,
              isExample: true,
            ),
            Collection(
              ownerId: ownerId,
              name: 'Worth revisiting',
              description: 'Example reads and notes to bring back later.',
              coverSeed: 90210,
              paletteIndex: 1,
              isExample: true,
            ),
          ],
          transaction: tx,
        );
        final items = await Item.db.insert(
          session,
          [
            Item(
              ownerId: ownerId,
              url: 'https://example.com/designing-calm-interfaces',
              canonicalUrl: 'https://example.com/designing-calm-interfaces',
              sourcePlatform: SourcePlatform.web,
              title: 'Designing calm interfaces',
              contentType: ContentType.article,
              intention: 'Borrow the idea of one clear action per screen.',
              summary: 'A short guide to quieter product decisions.',
              savedAt: now.subtract(const Duration(hours: 30)),
              accessState: AccessState.available,
              enrichmentState: EnrichmentState.ready,
              isExample: true,
            ),
            Item(
              ownerId: ownerId,
              url: 'https://example.com/tiny-habits',
              canonicalUrl: 'https://example.com/tiny-habits',
              sourcePlatform: SourcePlatform.web,
              title: 'Tiny habits that actually stick',
              contentType: ContentType.article,
              intention: 'Try the two-minute version this week.',
              savedAt: now.subtract(const Duration(hours: 20)),
              accessState: AccessState.available,
              enrichmentState: EnrichmentState.ready,
              isExample: true,
            ),
            Item(
              ownerId: ownerId,
              noteText: 'Sketch the smallest version before adding polish.',
              sourcePlatform: SourcePlatform.note,
              title: 'Start with the smallest version',
              contentType: ContentType.note,
              intention: 'Use this on the next side project.',
              savedAt: now.subtract(const Duration(hours: 12)),
              accessState: AccessState.available,
              enrichmentState: EnrichmentState.ready,
              isExample: true,
            ),
            Item(
              ownerId: ownerId,
              url: 'https://example.com/motion-with-purpose',
              canonicalUrl: 'https://example.com/motion-with-purpose',
              sourcePlatform: SourcePlatform.web,
              title: 'Motion with a purpose',
              contentType: ContentType.video,
              intention: 'Revisit the reduced-motion examples.',
              savedAt: now.subtract(const Duration(hours: 8)),
              accessState: AccessState.available,
              enrichmentState: EnrichmentState.ready,
              isExample: true,
            ),
            Item(
              ownerId: ownerId,
              url: 'https://example.com/reading-notes',
              canonicalUrl: 'https://example.com/reading-notes',
              sourcePlatform: SourcePlatform.web,
              title: 'A better way to keep reading notes',
              contentType: ContentType.article,
              intention: 'Compare this with my current notes.',
              savedAt: now.subtract(const Duration(hours: 4)),
              accessState: AccessState.available,
              enrichmentState: EnrichmentState.ready,
              isExample: true,
            ),
            Item(
              ownerId: ownerId,
              noteText: 'Leave a sentence about why every save matters.',
              sourcePlatform: SourcePlatform.note,
              title: 'Save the why, not just the link',
              contentType: ContentType.note,
              intention: 'Use this as a capture rule.',
              savedAt: now.subtract(const Duration(hours: 1)),
              accessState: AccessState.available,
              enrichmentState: EnrichmentState.ready,
              isExample: true,
            ),
          ],
          transaction: tx,
        );
        await ItemCollection.db.insert(
          session,
          [
            for (var index = 0; index < items.length; index++)
              ItemCollection(
                ownerId: ownerId,
                itemId: items[index].id!,
                collectionId: collections[index < 3 ? 0 : 1].id!,
                origin: AssignmentOrigin.manual,
                manuallyLocked: true,
              ),
          ],
          transaction: tx,
        );
      }
      return _status(session, ownerId, transaction: tx);
    });
  }

  Future<ExampleSavesStatus> remove(Session session) async {
    final ownerId = session.ownerId;
    return session.db.transaction((tx) async {
      await Item.db.deleteWhere(
        session,
        where: (t) => t.ownerId.equals(ownerId) & t.isExample.equals(true),
        transaction: tx,
      );
      await Collection.db.deleteWhere(
        session,
        where: (t) => t.ownerId.equals(ownerId) & t.isExample.equals(true),
        transaction: tx,
      );
      return _status(session, ownerId, transaction: tx);
    });
  }

  Future<ExampleSavesStatus> _status(
    Session session,
    UuidValue ownerId, {
    Transaction? transaction,
  }) async {
    final counts = await Future.wait([
      Item.db.count(
        session,
        where: (t) => t.ownerId.equals(ownerId),
        transaction: transaction,
      ),
      Item.db.count(
        session,
        where: (t) => t.ownerId.equals(ownerId) & t.isExample.equals(true),
        transaction: transaction,
      ),
      Collection.db.count(
        session,
        where: (t) => t.ownerId.equals(ownerId) & t.isExample.equals(true),
        transaction: transaction,
      ),
    ]);
    return ExampleSavesStatus(
      totalItemCount: counts[0],
      exampleItemCount: counts[1],
      exampleCollectionCount: counts[2],
    );
  }
}
