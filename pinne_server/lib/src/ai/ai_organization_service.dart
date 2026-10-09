import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'ai_output_validator.dart';
import 'ai_provider.dart';
import 'ai_provider_registry.dart';
import 'no_ai_provider.dart';

class AiOrganizationService {
  AiOrganizationService({
    this.dailyCap = 20,
    DateTime Function()? clock,
    this.remoteProviderOverride,
  }) : _clock = clock ?? (() => DateTime.now().toUtc());

  static AiOrganizationService instance = AiOrganizationService();

  final int dailyCap;
  final DateTime Function() _clock;
  final AiProvider? remoteProviderOverride;

  /// Creates the durable work record once without reopening completed work.
  /// Save retries can safely call this before scheduling another delivery.
  Future<AiOrganizeTask> ensureQueued(
    Session session, {
    required UuidValue ownerId,
    required UuidValue itemId,
  }) async {
    final existing = await AiOrganizeTask.db.findFirstRow(
      session,
      where: (t) => t.itemId.equals(itemId) & t.ownerId.equals(ownerId),
    );
    if (existing != null) return existing;
    try {
      return await AiOrganizeTask.db.insertRow(
        session,
        AiOrganizeTask(ownerId: ownerId, itemId: itemId),
      );
    } on DatabaseUniqueViolationException {
      // Concurrent save retries may both observe no row. The unique item
      // index makes one insertion authoritative.
      return (await AiOrganizeTask.db.findFirstRow(
        session,
        where: (t) => t.itemId.equals(itemId) & t.ownerId.equals(ownerId),
      ))!;
    }
  }

  /// Explicitly requests a new version even if this item was processed before.
  Future<AiOrganizeTask> enqueue(
    Session session, {
    required UuidValue ownerId,
    required UuidValue itemId,
  }) async {
    final existing = await AiOrganizeTask.db.findFirstRow(
      session,
      where: (t) => t.itemId.equals(itemId) & t.ownerId.equals(ownerId),
    );
    if (existing == null) {
      return ensureQueued(session, ownerId: ownerId, itemId: itemId);
    }
    return AiOrganizeTask.db.updateRow(
      session,
      existing.copyWith(
        state: AiProcessingState.queued,
        requestedVersion: existing.requestedVersion + 1,
        dailySlotClaimed: false,
        quotaDateKey: null,
        claimedAt: null,
        completedAt: null,
        provider: null,
      ),
    );
  }

  /// Idempotent for a task version. Repeated future-call delivery returns
  /// before invoking a provider once that version is complete.
  Future<void> process(
    Session session, {
    required UuidValue ownerId,
    required UuidValue itemId,
  }) async {
    final item = await Item.db.findFirstRow(
      session,
      where: (t) => t.id.equals(itemId) & t.ownerId.equals(ownerId),
    );
    if (item == null) return;
    final claim = await session.db.transaction((transaction) async {
      await AiOrganizeTask.db.lockRows(
        session,
        where: (t) => t.itemId.equals(itemId) & t.ownerId.equals(ownerId),
        lockMode: LockMode.forUpdate,
        transaction: transaction,
      );
      final candidate = await AiOrganizeTask.db.findFirstRow(
        session,
        where: (t) => t.itemId.equals(itemId) & t.ownerId.equals(ownerId),
        transaction: transaction,
      );
      if (candidate == null ||
          (candidate.state == AiProcessingState.completed &&
              candidate.processedVersion >= candidate.requestedVersion)) {
        return null;
      }
      final now = _clock();
      final claimedAt = candidate.claimedAt;
      if (candidate.state == AiProcessingState.processing &&
          claimedAt != null &&
          claimedAt.isAfter(now.subtract(const Duration(minutes: 5)))) {
        return null;
      }
      final claimed = await AiOrganizeTask.db.updateRow(
        session,
        candidate.copyWith(
          state: AiProcessingState.processing,
          claimedAt: now,
        ),
        transaction: transaction,
      );
      return (task: claimed, version: claimed.requestedVersion);
    });
    if (claim == null) return;
    final task = claim.task;
    final processingVersion = claim.version;

    final preference = await AiPreference.db.findFirstRow(
      session,
      where: (t) => t.ownerId.equals(ownerId),
    );
    final userEnabled = preference?.enabled ?? true;
    final collections = await Collection.db.find(
      session,
      where: (t) => t.ownerId.equals(ownerId),
    );
    final options = collections
        .map((value) => AiCollectionOption(id: value.id!, name: value.name))
        .toList();
    final remote = remoteProviderOverride ?? AiProviderRegistry.remote;
    final canUseRemote = userEnabled && remote != null;
    final hasSlot = canUseRemote
        ? await _claimDailySlot(session, task: task)
        : false;
    final provider = canUseRemote && hasSlot
        ? FallbackAiProvider(
            primary: remote,
            fallback: const NoAiProvider(),
          )
        : const NoAiProvider();
    final evidence = AiItemEvidence(
      title: item.title,
      url: item.url,
      sourcePlatform: item.sourcePlatform.name,
      intention: item.intention,
      notes: item.noteText,
      description: item.previewDescription,
      author: item.previewAuthor,
      siteName: item.previewSiteName,
      previewAvailable: item.previewMetadataJson != null,
    );
    final result = await _organizeSafely(provider, evidence, options);

    await session.db.transaction((transaction) async {
      final latestTask = await AiOrganizeTask.db.findFirstRow(
        session,
        where: (t) => t.itemId.equals(itemId) & t.ownerId.equals(ownerId),
        transaction: transaction,
      );
      if (latestTask == null ||
          latestTask.requestedVersion != processingVersion) {
        return;
      }
      await AiSuggestion.db.deleteWhere(
        session,
        where: (t) =>
            t.ownerId.equals(ownerId) &
            t.itemId.equals(itemId) &
            t.status.equals(AiSuggestionStatus.pending),
        transaction: transaction,
      );
      final now = _clock();
      final suggestions = <AiSuggestion>[
        for (final collectionId in result.collectionIds)
          AiSuggestion(
            ownerId: ownerId,
            itemId: itemId,
            kind: AiSuggestionKind.collection,
            collectionId: collectionId,
            rationale: result.rationale,
            evidenceCoverage: result.evidenceCoverage,
            uncertain: result.uncertain,
            createdAt: now,
          ),
        for (final tag in result.tags)
          AiSuggestion(
            ownerId: ownerId,
            itemId: itemId,
            kind: AiSuggestionKind.tag,
            value: tag,
            rationale: result.rationale,
            evidenceCoverage: result.evidenceCoverage,
            uncertain: result.uncertain,
            createdAt: now,
          ),
        if (result.summary case final summary?)
          AiSuggestion(
            ownerId: ownerId,
            itemId: itemId,
            kind: AiSuggestionKind.summary,
            value: summary,
            rationale: result.rationale,
            evidenceCoverage: result.evidenceCoverage,
            uncertain: result.uncertain,
            createdAt: now,
          ),
      ];
      if (suggestions.isNotEmpty) {
        await AiSuggestion.db.insert(
          session,
          suggestions,
          transaction: transaction,
        );
      }
      await AiOrganizeTask.db.updateRow(
        session,
        latestTask.copyWith(
          state: AiProcessingState.completed,
          processedVersion: processingVersion,
          completedAt: now,
          provider: result.provider,
        ),
        transaction: transaction,
      );
    });
  }

  Future<AiOrganizationResult> _organizeSafely(
    AiProvider provider,
    AiItemEvidence evidence,
    List<AiCollectionOption> options,
  ) async {
    try {
      final raw = await provider.organize(
        evidence: evidence,
        collections: options,
      );
      return AiOutputValidator.sanitize(
        raw,
        allowedCollectionIds: options.map((option) => option.id),
        evidenceCoverage: evidence.previewAvailable
            ? AiEvidenceCoverage.metadataPlusPreview
            : AiEvidenceCoverage.metadataOnly,
      );
    } catch (_) {
      // Typed providers are still untrusted. A malformed test double or future
      // provider must have the same safe behavior as an HTTP/JSON failure.
      return const NoAiProvider().organize(
        evidence: evidence,
        collections: options,
      );
    }
  }

  Future<bool> _claimDailySlot(
    Session session, {
    required AiOrganizeTask task,
  }) async {
    final now = _clock().toUtc();
    final dateKey =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
    if (task.dailySlotClaimed && task.quotaDateKey == dateKey) return true;
    if (dailyCap <= 0) return false;
    return session.db.transaction((transaction) async {
      // One atomic upsert both serializes concurrent jobs for this owner/day
      // and refuses to increment once the cap is reached.
      final claimed = await session.db.unsafeQuery(
        '''
INSERT INTO "ai_daily_usage" ("ownerId", "dateKey", "requestCount")
VALUES (CAST(\$1 AS uuid), \$2, 1)
ON CONFLICT ("ownerId", "dateKey") DO UPDATE
SET "requestCount" = "ai_daily_usage"."requestCount" + 1
WHERE "ai_daily_usage"."requestCount" < \$3
RETURNING "requestCount"
''',
        parameters: QueryParameters.positional([
          task.ownerId.toString(),
          dateKey,
          dailyCap,
        ]),
        transaction: transaction,
      );
      if (claimed.isEmpty) return false;
      await AiOrganizeTask.db.updateRow(
        session,
        task.copyWith(dailySlotClaimed: true, quotaDateKey: dateKey),
        transaction: transaction,
      );
      return true;
    });
  }
}
