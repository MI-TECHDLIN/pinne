import 'package:serverpod/serverpod.dart';

import '../auth/owner.dart';
import '../generated/protocol.dart';
import 'search_service.dart';

class SearchEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final SearchService _service = const SearchService();

  Future<SearchPage> keyword(
    Session session, {
    required String query,
    SourcePlatform? source,
    ContentType? contentType,
    UuidValue? collectionId,
    ReviewStatusFilter? reviewStatus,
    String? cursor,
    int? limit,
  }) => _service.keyword(
    session,
    ownerId: session.ownerId,
    query: query,
    source: source,
    contentType: contentType,
    collectionId: collectionId,
    reviewStatus: reviewStatus,
    cursor: cursor,
    limit: limit,
  );
}
