import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Durable, idempotent capture for one owner.
///
/// Order of resolution, all in one transaction:
/// 1. A known operation id replays its stored receipt.
/// 2. A known client item id replays the receipt that created its mapping.
/// 3. A recognised duplicate (same platform item id, else same canonical URL)
///    returns the existing item, keeps its notes, memberships and `savedAt`,
///    and adds the new intention and collections to it.
/// 4. Otherwise a new item is inserted with enrichment `pending`.
///
/// Nothing here fetches the link; enrichment is a later, separate step.
class ItemCapture {
  ItemCapture(this.session, this.owner);

  final Session session;
  final UuidValue owner;

  /// Allowed clock skew for a device's `capturedAt` before it is clamped.
  static const futureTolerance = Duration(minutes: 5);

  Future<CaptureResult> capture(CaptureDraft draft) async {
    final read = _read(draft);
    final hash = _requestHash(draft);
    try {
      return await session.db.transaction((tx) => _run(draft, read, hash, tx));
    } on DatabaseUniqueViolationException {
      // A concurrent retry of this operation, or a concurrent capture of the
      // same item, committed first. Its rows are visible now, so running
      // again replays it or resolves to the duplicate.
      return session.db.transaction((tx) => _run(draft, read, hash, tx));
    }
  }

  Future<CaptureResult> _run(
    CaptureDraft draft,
    _ReadCapture read,
    String hash,
    Transaction tx,
  ) async {
    final byOperation = await CaptureReceipt.db.findFirstRow(
      session,
      where: (t) =>
          t.ownerId.equals(owner) & t.operationId.equals(draft.operationId),
      transaction: tx,
    );
    if (byOperation != null) {
      if (byOperation.requestHash != hash) {
        throw ValidationException(
          message: 'This operation id was already used for a different save.',
        );
      }
      return _replay(byOperation, tx);
    }
    final byClientItem = await CaptureReceipt.db.findFirstRow(
      session,
      where: (t) =>
          t.ownerId.equals(owner) & t.clientItemId.equals(draft.clientItemId),
      transaction: tx,
    );
    if (byClientItem != null) return _replay(byClientItem, tx);

    await _checkCollections(read.collectionIds, tx);

    final existing = await _findDuplicate(read, tx);
    final item = existing == null
        ? await _insert(draft, read, tx)
        : await _mergeInto(existing, read, tx);
    await _addMemberships(item.id!, read.collectionIds, tx);
    await CaptureReceipt.db.insertRow(
      session,
      CaptureReceipt(
        ownerId: owner,
        operationId: draft.operationId,
        clientItemId: draft.clientItemId,
        itemId: item.id!,
        requestHash: hash,
        duplicate: existing != null,
      ),
      transaction: tx,
    );
    return _result(item, draft.clientItemId, duplicate: existing != null);
  }

  Future<CaptureResult> _replay(CaptureReceipt receipt, Transaction tx) async {
    final item = await Item.db.findFirstRow(
      session,
      where: (t) => t.id.equals(receipt.itemId) & t.ownerId.equals(owner),
      transaction: tx,
    );
    // The receipt cascades with its item, so this only happens mid-delete.
    if (item == null) throw RecordNotFoundException(resource: 'item');
    return _result(item, receipt.clientItemId, duplicate: receipt.duplicate);
  }

  Future<Item?> _findDuplicate(_ReadCapture read, Transaction tx) async {
    final link = read.input.link;
    if (link == null) return null;
    final sourceItemId = link.sourceItemId;
    if (sourceItemId != null) {
      final byId = await Item.db.findFirstRow(
        session,
        where: (t) =>
            t.ownerId.equals(owner) &
            t.sourcePlatform.equals(read.platform) &
            t.sourceItemId.equals(sourceItemId),
        transaction: tx,
      );
      if (byId != null) return byId;
    }
    return Item.db.findFirstRow(
      session,
      where: (t) =>
          t.ownerId.equals(owner) & t.canonicalUrl.equals(link.canonicalUrl),
      transaction: tx,
    );
  }

  Future<Item> _insert(
    CaptureDraft draft,
    _ReadCapture read,
    Transaction tx,
  ) {
    final link = read.input.link;
    final now = DateTime.now().toUtc();
    final capturedAt = draft.capturedAt.toUtc();
    return Item.db.insertRow(
      session,
      Item(
        ownerId: owner,
        clientItemId: draft.clientItemId,
        url: link?.cleanUrl,
        canonicalUrl: link?.canonicalUrl,
        sourcePlatform: read.platform,
        sourceItemId: link?.sourceItemId,
        title: read.title,
        noteText: read.input.note,
        contentType: ContentType.values.byName(read.input.contentType.name),
        intention: read.intention,
        savedAt: capturedAt.isAfter(now.add(futureTolerance))
            ? now
            : capturedAt,
        enrichmentState: EnrichmentState.pending,
        // A note is its own content. A link has not been fetched yet.
        accessState: link == null ? AccessState.available : AccessState.unknown,
      ),
      transaction: tx,
    );
  }

  /// Keeps everything on [existing] and only adds: a new intention is
  /// appended when it says something the stored one does not.
  Future<Item> _mergeInto(
    Item existing,
    _ReadCapture read,
    Transaction tx,
  ) async {
    final incoming = read.intention;
    final current = existing.intention?.trim() ?? '';
    if (incoming == null || current.contains(incoming)) return existing;
    return Item.db.updateRow(
      session,
      existing.copyWith(
        intention: current.isEmpty ? incoming : '$current\n\n$incoming',
        revision: existing.revision + 1,
      ),
      transaction: tx,
    );
  }

  /// A foreign collection id fails exactly like a missing one.
  Future<void> _checkCollections(Set<UuidValue> ids, Transaction tx) async {
    if (ids.isEmpty) return;
    final owned = await Collection.db.count(
      session,
      where: (t) => t.ownerId.equals(owner) & t.id.inSet(ids),
      transaction: tx,
    );
    if (owned != ids.length) {
      throw RecordNotFoundException(resource: 'collection');
    }
  }

  Future<void> _addMemberships(
    UuidValue itemId,
    Set<UuidValue> collectionIds,
    Transaction tx,
  ) async {
    if (collectionIds.isEmpty) return;
    final present = await ItemCollection.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.itemId.equals(itemId) &
          t.collectionId.inSet(collectionIds),
      transaction: tx,
    );
    final missing = collectionIds.difference({
      for (final membership in present) membership.collectionId,
    });
    if (missing.isEmpty) return;
    await ItemCollection.db.insert(
      session,
      [
        for (final collectionId in missing)
          ItemCollection(
            ownerId: owner,
            itemId: itemId,
            collectionId: collectionId,
            origin: AssignmentOrigin.manual,
            manuallyLocked: true,
          ),
      ],
      transaction: tx,
    );
  }

  CaptureResult _result(
    Item item,
    UuidValue clientItemId, {
    required bool duplicate,
  }) {
    return CaptureResult(
      itemId: item.id!,
      clientItemId: clientItemId,
      revision: item.revision,
      title: item.title,
      sourcePlatform: item.sourcePlatform,
      sourceItemId: item.sourceItemId,
      canonicalUrl: item.canonicalUrl,
      duplicate: duplicate,
      duplicateOf: duplicate ? item.id : null,
      enrichmentState: item.enrichmentState,
      savedAt: item.savedAt,
    );
  }

  static _ReadCapture _read(CaptureDraft draft) {
    String? clean(String? value, int max, String field) {
      final trimmed = value?.trim();
      if (trimmed == null || trimmed.isEmpty) return null;
      if (trimmed.length > max) {
        throw ValidationException(message: '$field is too long.');
      }
      return trimmed;
    }

    final url = clean(draft.url, CaptureLimits.maxUrlLength, 'The link');
    final text = clean(draft.text, CaptureLimits.maxTextLength, 'The text');
    final CaptureInput input;
    if (url != null) {
      input = parseCaptureInput(url);
      if (input.link == null) {
        throw ValidationException(message: 'The link is not a web address.');
      }
    } else if (text != null) {
      input = parseCaptureInput(text);
    } else {
      throw ValidationException(message: 'There is nothing to save.');
    }

    final collectionIds = {...?draft.collectionIds};
    if (collectionIds.length > CaptureLimits.maxCollections) {
      throw ValidationException(message: 'Too many collections.');
    }
    return _ReadCapture(
      input: input,
      platform: SourcePlatform.values.byName(input.source.name),
      title:
          clean(draft.title, CaptureLimits.maxTitleLength, 'The title') ??
          input.suggestedTitle,
      intention: clean(
        draft.intention,
        CaptureLimits.maxIntentionLength,
        'The note',
      ),
      collectionIds: collectionIds,
    );
  }

  /// Everything the client chose, so a reused operation id with a changed
  /// payload is caught. Collection order does not matter.
  static String _requestHash(CaptureDraft draft) {
    final ids = [...?draft.collectionIds?.map((id) => id.uuid)]..sort();
    final canonical = jsonEncode([
      draft.clientItemId.uuid,
      draft.url,
      draft.text,
      draft.title,
      draft.intention,
      ids,
      draft.capturedAt.toUtc().toIso8601String(),
    ]);
    return sha256.convert(utf8.encode(canonical)).toString();
  }
}

class _ReadCapture {
  _ReadCapture({
    required this.input,
    required this.platform,
    required this.title,
    required this.intention,
    required this.collectionIds,
  });

  final CaptureInput input;
  final SourcePlatform platform;
  final String title;
  final String? intention;
  final Set<UuidValue> collectionIds;
}
