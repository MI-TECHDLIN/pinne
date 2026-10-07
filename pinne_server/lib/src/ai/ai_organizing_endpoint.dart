import '../auth/owner.dart';
import '../generated/protocol.dart';
import '../generated/serverpod.dart';
import 'ai_organization_service.dart';
import 'ai_output_validator.dart';

class AiOrganizingEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const disclosure =
      "When AI organizing is on, Pinne sends the saved item's title, URL, "
      'source platform, your intention and notes, plus the names and IDs of '
      "your collections, to Google's Gemini API. It does not fetch the page. "
      "On Gemini's unpaid tier, Google may use prompts and responses to "
      'improve its products, and human reviewers may process them. Google '
      'says not to send sensitive, confidential or personal information. '
      'Different data terms apply in the EEA, Switzerland and UK. Turn this '
      'off to keep organizing on this server with simple rules only.';

  Future<AiSettings> getSettings(Session session) async {
    final preference = await AiPreference.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(session.ownerId),
    );
    return AiSettings(
      enabled: preference?.enabled ?? true,
      disclosure: disclosure,
    );
  }

  Future<AiSettings> setEnabled(Session session, bool enabled) async {
    await AiPreference.db.upsertRow(
      session,
      AiPreference(ownerId: session.ownerId, enabled: enabled),
      conflictColumns: (t) => [t.ownerId],
      updateColumns: (t) => [t.enabled],
      updateWhere: (t) => t.ownerId.equals(session.ownerId),
    );
    return AiSettings(enabled: enabled, disclosure: disclosure);
  }

  Future<List<AiSuggestion>> listSuggestions(
    Session session,
    UuidValue itemId,
  ) async {
    await _ownedItem(session, itemId);
    return AiSuggestion.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(session.ownerId) &
          t.itemId.equals(itemId) &
          t.status.equals(AiSuggestionStatus.pending),
      orderBy: (t) => t.createdAt,
    );
  }

  Future<void> reprocess(Session session, UuidValue itemId) async {
    final item = await _ownedItem(session, itemId);
    await AiOrganizationService.instance.enqueue(
      session,
      ownerId: item.ownerId,
      itemId: itemId,
    );
    await session.serverpod.futureCalls
        .callWithDelay(Duration.zero, identifier: 'ai-organize-$itemId')
        .aiOrganize
        .process(itemId, item.ownerId);
  }

  Future<AiSuggestion> accept(
    Session session,
    UuidValue suggestionId,
  ) async {
    final suggestion = await _ownedSuggestion(session, suggestionId);
    if (suggestion.status != AiSuggestionStatus.pending) return suggestion;
    final item = await _ownedItem(session, suggestion.itemId);
    switch (suggestion.kind) {
      case AiSuggestionKind.collection:
        final collectionId = suggestion.collectionId;
        final collection = collectionId == null
            ? null
            : await Collection.db.findFirstRow(
                session,
                where: (t) =>
                    t.id.equals(collectionId) &
                    t.ownerId.equals(session.ownerId),
              );
        if (collection == null) {
          throw RecordNotFoundException(resource: 'collection');
        }
        final existing = await ItemCollection.db.findFirstRow(
          session,
          where: (t) =>
              t.ownerId.equals(session.ownerId) &
              t.itemId.equals(item.id!) &
              t.collectionId.equals(collectionId),
        );
        if (existing == null) {
          await ItemCollection.db.insertRow(
            session,
            ItemCollection(
              ownerId: session.ownerId,
              itemId: item.id!,
              collectionId: collectionId!,
              origin: AssignmentOrigin.ai,
            ),
          );
        }
      case AiSuggestionKind.tag:
        final normalized = AiOutputValidator.normalizeTag(
          suggestion.value ?? '',
        );
        if (normalized.isEmpty) {
          throw ValidationException(message: 'The suggested tag is invalid.');
        }
        var tag = await Tag.db.findFirstRow(
          session,
          where: (t) =>
              t.ownerId.equals(session.ownerId) &
              t.normalizedName.equals(normalized),
        );
        tag ??= await Tag.db.insertRow(
          session,
          Tag(
            ownerId: session.ownerId,
            normalizedName: normalized,
            displayName: normalized,
          ),
        );
        final existing = await ItemTag.db.findFirstRow(
          session,
          where: (t) =>
              t.ownerId.equals(session.ownerId) &
              t.itemId.equals(item.id!) &
              t.tagId.equals(tag!.id!),
        );
        if (existing == null) {
          await ItemTag.db.insertRow(
            session,
            ItemTag(
              ownerId: session.ownerId,
              itemId: item.id!,
              tagId: tag.id!,
              origin: AssignmentOrigin.ai,
            ),
          );
        }
      case AiSuggestionKind.summary:
        if (!item.summaryManuallyLocked &&
            item.summaryOrigin != AssignmentOrigin.manual) {
          await Item.db.updateRow(
            session,
            item.copyWith(
              summary: suggestion.value,
              summaryOrigin: AssignmentOrigin.ai,
              revision: item.revision + 1,
            ),
          );
        }
    }
    return AiSuggestion.db.updateRow(
      session,
      suggestion.copyWith(
        status: AiSuggestionStatus.accepted,
        resolvedAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<AiSuggestion> reject(
    Session session,
    UuidValue suggestionId,
  ) async {
    final suggestion = await _ownedSuggestion(session, suggestionId);
    if (suggestion.status != AiSuggestionStatus.pending) return suggestion;
    return AiSuggestion.db.updateRow(
      session,
      suggestion.copyWith(
        status: AiSuggestionStatus.rejected,
        resolvedAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<Item> _ownedItem(Session session, UuidValue itemId) async {
    final item = await Item.db.findFirstRow(
      session,
      where: (t) => t.id.equals(itemId) & t.ownerId.equals(session.ownerId),
    );
    if (item == null) throw RecordNotFoundException(resource: 'item');
    return item;
  }

  Future<AiSuggestion> _ownedSuggestion(
    Session session,
    UuidValue suggestionId,
  ) async {
    final suggestion = await AiSuggestion.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(suggestionId) & t.ownerId.equals(session.ownerId),
    );
    if (suggestion == null) {
      throw RecordNotFoundException(resource: 'AI suggestion');
    }
    return suggestion;
  }
}
