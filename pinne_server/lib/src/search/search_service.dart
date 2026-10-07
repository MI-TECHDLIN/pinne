import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Keyword-search boundary. A later semantic provider can merge candidates at
/// this boundary without changing the endpoint or keyword implementation.
class SearchService {
  const SearchService();

  static const defaultPageSize = 20;
  static const maxPageSize = 50;

  Future<SearchPage> keyword(
    Session session, {
    required UuidValue ownerId,
    required String query,
    SourcePlatform? source,
    ContentType? contentType,
    UuidValue? collectionId,
    ReviewStatusFilter? reviewStatus,
    String? cursor,
    int? limit,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return SearchPage(results: []);
    if (trimmed.length > 300) {
      throw ValidationException(message: 'Search query is too long.');
    }
    if (collectionId != null) {
      final collection = await Collection.db.findFirstRow(
        session,
        where: (t) => t.id.equals(collectionId) & t.ownerId.equals(ownerId),
      );
      if (collection == null) {
        throw RecordNotFoundException(resource: 'collection');
      }
    }

    final keywordQuery = _keywordQuery(trimmed);
    if (keywordQuery.isEmpty) return SearchPage(results: []);
    final pageSize = (limit ?? defaultPageSize).clamp(1, maxPageSize);
    final decoded = _decodeCursor(cursor);
    final filters = <String>[
      'i."ownerId" = @owner_id::uuid',
      'i.lifecycle = \'active\'',
      '''((
        setweight(to_tsvector('simple', coalesce(i.title, '')), 'A') ||
        setweight(to_tsvector('simple', coalesce(i.intention, '') || ' ' || coalesce(i."noteText", '')), 'B') ||
        setweight(to_tsvector('simple', coalesce(i.url, '') || ' ' || i."sourcePlatform" || ' ' || i."contentType"), 'C')
      ) @@ websearch_to_tsquery('simple', @query)
      OR EXISTS (
        SELECT 1 FROM item_note n
        WHERE n."ownerId" = i."ownerId" AND n."itemId" = i.id
          AND to_tsvector('simple', n.body) @@ websearch_to_tsquery('simple', @query)
      )
      OR EXISTS (
        SELECT 1 FROM item_tag it
        JOIN tag t ON t.id = it."tagId" AND t."ownerId" = it."ownerId"
        WHERE it."ownerId" = i."ownerId" AND it."itemId" = i.id
          AND to_tsvector('simple', t."displayName" || ' ' || t."normalizedName")
              @@ websearch_to_tsquery('simple', @query)
      )
      OR position(@host_query in lower(split_part(split_part(
        regexp_replace(coalesce(i.url, ''), '^https?://', '', 'i'),
        '/', 1), ':', 1))) > 0
      )''',
    ];
    final parameters = <String, Object?>{
      'owner_id': ownerId.uuid,
      'query': keywordQuery,
      'host_query': trimmed.toLowerCase(),
      'take': pageSize + 1,
    };
    if (source != null) {
      filters.add('i."sourcePlatform" = @source');
      parameters['source'] = source.name;
    }
    if (contentType != null) {
      filters.add('i."contentType" = @content_type');
      parameters['content_type'] = contentType.name;
    }
    if (collectionId != null) {
      filters.add('''EXISTS (
        SELECT 1 FROM item_collection ic
        WHERE ic."ownerId" = i."ownerId" AND ic."itemId" = i.id
          AND ic."collectionId" = @collection_id::uuid
      )''');
      parameters['collection_id'] = collectionId.uuid;
    }
    if (reviewStatus != null) {
      final exists = reviewStatus == ReviewStatusFilter.reviewed;
      filters.add('''${exists ? '' : 'NOT '}EXISTS (
        SELECT 1 FROM item_progress p
        WHERE p."ownerId" = i."ownerId" AND p."itemId" = i.id
          AND p."firstReviewedAt" IS NOT NULL
      )''');
    }
    if (decoded != null) {
      filters.add(
        '(rank < @cursor_rank OR (rank = @cursor_rank AND id < @cursor_id::uuid))',
      );
      parameters['cursor_rank'] = decoded.$1;
      parameters['cursor_id'] = decoded.$2.uuid;
    }

    final sql =
        '''
      WITH candidates AS (
        SELECT i.id,
          GREATEST(
            ts_rank_cd(
              setweight(to_tsvector('simple', coalesce(i.title, '')), 'A') ||
              setweight(to_tsvector('simple', coalesce(i.intention, '') || ' ' || coalesce(i."noteText", '')), 'B') ||
              setweight(to_tsvector('simple', coalesce(i.url, '') || ' ' || i."sourcePlatform" || ' ' || i."contentType"), 'C'),
              websearch_to_tsquery('simple', @query)
            ),
            coalesce((SELECT max(ts_rank_cd(to_tsvector('simple', n.body), websearch_to_tsquery('simple', @query)))
              FROM item_note n WHERE n."ownerId" = i."ownerId" AND n."itemId" = i.id), 0),
            coalesce((SELECT max(ts_rank_cd(to_tsvector('simple', t."displayName" || ' ' || t."normalizedName"), websearch_to_tsquery('simple', @query)))
              FROM item_tag it JOIN tag t ON t.id = it."tagId" AND t."ownerId" = it."ownerId"
              WHERE it."ownerId" = i."ownerId" AND it."itemId" = i.id), 0),
            CASE WHEN position(@host_query in lower(split_part(split_part(
                regexp_replace(coalesce(i.url, ''), '^https?://', '', 'i'),
                '/', 1), ':', 1))) > 0 THEN 0.2 ELSE 0 END
          )::double precision AS rank
        FROM item i
        WHERE ${filters.take(decoded == null ? filters.length : filters.length - 1).join(' AND ')}
      )
      SELECT id, rank FROM candidates
      ${decoded == null ? '' : 'WHERE ${filters.last}'}
      ORDER BY rank DESC, id DESC
      LIMIT @take
    ''';
    final rows = await session.db.unsafeQuery(
      sql,
      parameters: QueryParameters.named(parameters),
    );
    final ranked = rows.map((row) {
      final values = row.toColumnMap();
      return (_uuid(values['id']), (values['rank'] as num).toDouble());
    }).toList();
    final hasMore = ranked.length > pageSize;
    final visible = ranked.take(pageSize).toList();
    final results = <SearchResult>[];
    for (final candidate in visible) {
      final item = await Item.db.findFirstRow(
        session,
        where: (t) => t.id.equals(candidate.$1) & t.ownerId.equals(ownerId),
      );
      if (item == null) continue;
      results.add(
        SearchResult(
          item: item,
          evidence: await _evidence(session, ownerId, item, trimmed),
          score: candidate.$2,
        ),
      );
    }
    final last = visible.isEmpty ? null : visible.last;
    return SearchPage(
      results: results,
      nextCursor: hasMore && last != null
          ? _encodeCursor(last.$2, last.$1)
          : null,
    );
  }

  Future<List<SearchEvidence>> _evidence(
    Session session,
    UuidValue ownerId,
    Item item,
    String query,
  ) async {
    final terms = RegExp(r'[\p{L}\p{N}]+', unicode: true)
        .allMatches(query.toLowerCase())
        .map((match) => match.group(0)!)
        .where((term) => term.length > 1 || term == 'x')
        .toSet();
    bool matches(String? value) {
      final lower = value?.toLowerCase() ?? '';
      return terms.any(lower.contains);
    }

    final evidence = <SearchEvidence>[];
    void add(String field, String? value) {
      if (value == null || value.trim().isEmpty || !matches(value)) return;
      evidence.add(
        SearchEvidence(field: field, snippet: _snippet(value.trim(), terms)),
      );
    }

    add('title', item.title);
    add('saved note', item.intention);
    add('note', item.noteText);
    add('source', item.sourcePlatform.name);
    add('content type', item.contentType.name);
    final host = item.url == null ? null : Uri.tryParse(item.url!)?.host;
    add('URL host', host);

    final notes = await ItemNote.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.itemId.equals(item.id!),
      orderBy: (t) => t.createdAt,
      limit: 3,
    );
    for (final note in notes) {
      add('note', note.body);
    }
    final itemTags = await ItemTag.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId) & t.itemId.equals(item.id!),
      limit: 10,
    );
    for (final itemTag in itemTags) {
      final tag = await Tag.db.findFirstRow(
        session,
        where: (t) => t.ownerId.equals(ownerId) & t.id.equals(itemTag.tagId),
      );
      add('tag', tag?.displayName);
    }
    if (evidence.isEmpty) {
      evidence.add(SearchEvidence(field: 'item', snippet: item.title));
    }
    return evidence.take(3).toList();
  }

  static String _snippet(String value, Set<String> terms) {
    final lower = value.toLowerCase();
    var index = terms
        .map(lower.indexOf)
        .where((position) => position >= 0)
        .fold<int>(
          lower.length,
          (best, position) => position < best ? position : best,
        );
    if (index == lower.length) index = 0;
    final start = (index - 32).clamp(0, value.length);
    final end = (start + 112).clamp(0, value.length);
    return '${start > 0 ? '…' : ''}${value.substring(start, end)}${end < value.length ? '…' : ''}';
  }

  /// Removes conversational glue that would otherwise turn a remembered
  /// phrase such as "desktop sidebar from X" into an overly strict AND query.
  /// The remaining terms still use Postgres' safe web-search parser.
  static String _keywordQuery(String value) {
    const glue = {
      'a',
      'an',
      'and',
      'at',
      'by',
      'for',
      'from',
      'in',
      'of',
      'on',
      'the',
      'to',
      'with',
    };
    return RegExp(r'[\p{L}\p{N}_-]+', unicode: true)
        .allMatches(value)
        .map((match) => match.group(0)!)
        .where((term) => !glue.contains(term.toLowerCase()))
        .join(' ');
  }

  static UuidValue _uuid(Object? value) =>
      value is UuidValue ? value : UuidValue.fromString(value.toString());

  static String _encodeCursor(double rank, UuidValue id) => base64Url.encode(
    utf8.encode(jsonEncode({'rank': rank, 'id': id.uuid})),
  );

  static (double, UuidValue)? _decodeCursor(String? cursor) {
    if (cursor == null || cursor.isEmpty) return null;
    try {
      final data =
          jsonDecode(
                utf8.decode(base64Url.decode(base64Url.normalize(cursor))),
              )
              as Map<String, dynamic>;
      return (
        (data['rank'] as num).toDouble(),
        UuidValue.fromString(data['id'] as String),
      );
    } on Object {
      throw ValidationException(message: 'Search cursor is invalid.');
    }
  }
}
