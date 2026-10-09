import 'dart:async';
import 'dart:convert';

import '../ai/ai_organization_service.dart';
import '../generated/protocol.dart';
import '../generated/serverpod.dart';
import 'link_preview_parser.dart';
import 'restricted_fetcher.dart';

typedef PreviewLoader = Future<PreviewLoadResult> Function(Uri uri);

class PreviewLoadResult {
  const PreviewLoadResult({
    required this.accessState,
    this.preview,
    this.retryable = false,
  });

  final AccessState accessState;
  final LinkPreview? preview;
  final bool retryable;
}

/// Idempotent, at-least-once-safe background enrichment for saved links.
class LinkPreviewService {
  LinkPreviewService({
    RestrictedFetcher? fetcher,
    PreviewLoader? loader,
    DateTime Function()? clock,
    this.maxAttempts = 3,
  }) : _fetcher = fetcher ?? RestrictedFetcher(),
       _loaderOverride = loader,
       _clock = clock ?? (() => DateTime.now().toUtc());

  static LinkPreviewService instance = LinkPreviewService();

  final RestrictedFetcher _fetcher;
  final PreviewLoader? _loaderOverride;
  final DateTime Function() _clock;
  final int maxAttempts;

  static final Map<String, Future<void>> _rateGates = {};
  static final Map<String, DateTime> _lastStarted = {};

  Future<void> process(
    Session session, {
    required UuidValue ownerId,
    required UuidValue itemId,
  }) async {
    final claimed = await session.db.transaction((transaction) async {
      await Item.db.lockRows(
        session,
        where: (t) => t.id.equals(itemId) & t.ownerId.equals(ownerId),
        lockMode: LockMode.forUpdate,
        transaction: transaction,
      );
      final item = await Item.db.findFirstRow(
        session,
        where: (t) => t.id.equals(itemId) & t.ownerId.equals(ownerId),
        transaction: transaction,
      );
      if (item == null ||
          item.url == null ||
          item.enrichmentState == EnrichmentState.ready ||
          item.enrichmentState == EnrichmentState.partial ||
          item.enrichmentState == EnrichmentState.failed) {
        return null;
      }
      final now = _clock();
      final started = item.previewStartedAt;
      if (item.enrichmentState == EnrichmentState.processing &&
          started != null &&
          now.difference(started) < const Duration(minutes: 5)) {
        return null;
      }
      if (item.previewAttemptCount >= maxAttempts) {
        await Item.db.updateRow(
          session,
          item.copyWith(
            enrichmentState: EnrichmentState.failed,
            previewStartedAt: null,
            revision: item.revision + 1,
          ),
          transaction: transaction,
        );
        return null;
      }
      return Item.db.updateRow(
        session,
        item.copyWith(
          enrichmentState: EnrichmentState.processing,
          previewStartedAt: now,
          previewAttemptCount: item.previewAttemptCount + 1,
          revision: item.revision + 1,
        ),
        transaction: transaction,
      );
    });
    if (claimed == null) return;
    // If a worker dies after claiming, a distinct delivery can recover the
    // stale processing lease. Completed and terminal states make it a no-op.
    try {
      await session.serverpod.futureCalls
          .callWithDelay(
            const Duration(minutes: 6),
            identifier:
                'link-preview-${claimed.id}-recover-${claimed.previewAttemptCount}',
          )
          .linkPreview
          .process(claimed.id!, claimed.ownerId);
    } catch (_) {}

    final uri = Uri.tryParse(claimed.url!);
    if (uri == null) {
      await _finishFailure(session, claimed, AccessState.unknown);
      return;
    }

    await _politeDelay('owner:$ownerId', const Duration(milliseconds: 300));

    PreviewLoadResult result;
    try {
      result = await (_loaderOverride?.call(uri) ?? load(uri));
    } on Object {
      result = const PreviewLoadResult(
        accessState: AccessState.unknown,
        retryable: true,
      );
    }
    final preview = result.preview;
    if (preview != null && preview.hasEvidence) {
      await _finishSuccess(session, claimed, result);
      await _rerunAi(session, claimed);
      return;
    }
    if (result.retryable && claimed.previewAttemptCount < maxAttempts) {
      await _retry(session, claimed);
      return;
    }
    await _finishFailure(session, claimed, result.accessState);
  }

  /// Loads official keyless oEmbed first, then safe page metadata as fallback.
  Future<PreviewLoadResult> load(Uri uri) async {
    final oEmbed = _oEmbedUri(uri);
    LinkPreview? providerPreview;
    var providerRetryable = false;
    if (oEmbed != null) {
      final response = await _safeGet(oEmbed);
      if (response != null &&
          response.statusCode >= 200 &&
          response.statusCode < 300) {
        try {
          providerPreview = LinkPreviewParser.oEmbed(response.body, uri);
        } on FormatException {
          // A provider response is untrusted; fall through to page metadata.
        }
      } else if (response?.statusCode == 429 ||
          (response?.statusCode ?? 0) >= 500) {
        providerRetryable = true;
      }
    }

    final response = await _safeGet(uri);
    if (response == null) {
      return providerPreview?.hasEvidence == true
          ? PreviewLoadResult(
              accessState: AccessState.available,
              preview: await _safeThumbnail(providerPreview!),
            )
          : const PreviewLoadResult(
              accessState: AccessState.unknown,
              retryable: true,
            );
    }
    if (response.statusCode == 401) {
      return providerPreview?.hasEvidence == true
          ? PreviewLoadResult(
              accessState: AccessState.available,
              preview: await _safeThumbnail(providerPreview!),
            )
          : const PreviewLoadResult(accessState: AccessState.loginRequired);
    }
    if (response.statusCode == 403) {
      if (providerPreview?.hasEvidence == true) {
        return PreviewLoadResult(
          accessState: AccessState.available,
          preview: await _safeThumbnail(providerPreview!),
        );
      }
      final wall = LinkPreviewParser.openGraph(response.body, response.uri);
      return PreviewLoadResult(
        accessState: wall.loginWall
            ? AccessState.loginRequired
            : AccessState.unknown,
      );
    }
    if (response.statusCode == 404 || response.statusCode == 410) {
      return providerPreview?.hasEvidence == true
          ? PreviewLoadResult(
              accessState: AccessState.available,
              preview: await _safeThumbnail(providerPreview!),
            )
          : const PreviewLoadResult(accessState: AccessState.unavailable);
    }
    if (response.statusCode == 429 || response.statusCode >= 500) {
      return providerPreview?.hasEvidence == true
          ? PreviewLoadResult(
              accessState: AccessState.available,
              preview: await _safeThumbnail(providerPreview!),
            )
          : const PreviewLoadResult(
              accessState: AccessState.unknown,
              retryable: true,
            );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return providerPreview?.hasEvidence == true
          ? PreviewLoadResult(
              accessState: AccessState.available,
              preview: await _safeThumbnail(providerPreview!),
            )
          : PreviewLoadResult(
              accessState: AccessState.unknown,
              retryable: providerRetryable,
            );
    }
    var preview = LinkPreviewParser.openGraph(response.body, response.uri);
    if (preview.loginWall) {
      return providerPreview?.hasEvidence == true
          ? PreviewLoadResult(
              accessState: AccessState.available,
              preview: await _safeThumbnail(providerPreview!),
            )
          : const PreviewLoadResult(accessState: AccessState.loginRequired);
    }
    preview = _merge(providerPreview, preview);
    preview = await _safeThumbnail(preview);
    return PreviewLoadResult(
      accessState: AccessState.available,
      preview: preview,
      retryable: providerRetryable && !preview.hasEvidence,
    );
  }

  static LinkPreview _merge(LinkPreview? provider, LinkPreview page) {
    if (provider == null) return page;
    return LinkPreview(
      title: provider.title ?? page.title,
      description: provider.description ?? page.description,
      author: provider.author ?? page.author,
      siteName: provider.siteName ?? page.siteName,
      provider: provider.provider ?? page.provider,
      thumbnailUrl: provider.thumbnailUrl ?? page.thumbnailUrl,
      durationSeconds: provider.durationSeconds ?? page.durationSeconds,
      metadata: {
        ...page.metadata,
        ...provider.metadata,
        'sources': ['oembed', 'open_graph'],
      },
    );
  }

  Future<RestrictedResponse?> _safeGet(Uri uri) async {
    try {
      return await _fetcher.get(uri);
    } on RestrictedFetchException catch (error) {
      if (error.kind == RestrictedFetchFailure.invalidUrl ||
          error.kind == RestrictedFetchFailure.blockedAddress ||
          error.kind == RestrictedFetchFailure.unsupportedContent) {
        return RestrictedResponse(
          uri: uri,
          statusCode: 400,
          contentType: 'text/html',
          body: '',
        );
      }
      return null;
    }
  }

  Future<LinkPreview> _safeThumbnail(LinkPreview preview) async {
    final image = preview.thumbnailUrl;
    if (image == null) return preview;
    try {
      await _fetcher.validatePublicUri(image);
      return preview;
    } on Object {
      return LinkPreview(
        title: preview.title,
        description: preview.description,
        author: preview.author,
        siteName: preview.siteName,
        provider: preview.provider,
        durationSeconds: preview.durationSeconds,
        loginWall: preview.loginWall,
        metadata: preview.metadata,
      );
    }
  }

  Future<void> _finishSuccess(
    Session session,
    Item claimed,
    PreviewLoadResult result,
  ) async {
    final preview = result.preview!;
    await _updateIfClaimCurrent(session, claimed, (latest) {
      return latest.copyWith(
        title: latest.titleManuallyLocked
            ? latest.title
            : (preview.title ?? latest.title),
        previewDescription: preview.description,
        previewAuthor: preview.author,
        previewSiteName: preview.siteName,
        previewProvider: preview.provider,
        thumbnailUrl: preview.thumbnailUrl?.toString(),
        durationSeconds: preview.durationSeconds,
        previewMetadataJson: jsonEncode(preview.metadata),
        previewUpdatedAt: _clock(),
        previewStartedAt: null,
        accessState: result.accessState,
        enrichmentState: result.accessState == AccessState.available
            ? EnrichmentState.ready
            : EnrichmentState.partial,
        revision: latest.revision + 1,
      );
    });
  }

  Future<void> _finishFailure(
    Session session,
    Item claimed,
    AccessState access,
  ) => _updateIfClaimCurrent(
    session,
    claimed,
    (latest) => latest.copyWith(
      accessState: access,
      enrichmentState: EnrichmentState.failed,
      previewStartedAt: null,
      previewUpdatedAt: _clock(),
      revision: latest.revision + 1,
    ),
  );

  Future<void> _retry(Session session, Item claimed) async {
    final updated = await _updateIfClaimCurrent(
      session,
      claimed,
      (latest) => latest.copyWith(
        enrichmentState: EnrichmentState.pending,
        previewStartedAt: null,
        revision: latest.revision + 1,
      ),
    );
    if (!updated) return;
    final delay = Duration(seconds: 1 << (claimed.previewAttemptCount - 1));
    try {
      await session.serverpod.futureCalls
          .callWithDelay(
            delay,
            identifier:
                'link-preview-${claimed.id}-attempt-${claimed.previewAttemptCount + 1}',
          )
          .linkPreview
          .process(claimed.id!, claimed.ownerId);
    } catch (_) {}
  }

  Future<bool> _updateIfClaimCurrent(
    Session session,
    Item claimed,
    Item Function(Item latest) update,
  ) async {
    return session.db.transaction((transaction) async {
      await Item.db.lockRows(
        session,
        where: (t) =>
            t.id.equals(claimed.id) & t.ownerId.equals(claimed.ownerId),
        lockMode: LockMode.forUpdate,
        transaction: transaction,
      );
      final latest = await Item.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(claimed.id) & t.ownerId.equals(claimed.ownerId),
        transaction: transaction,
      );
      if (latest == null ||
          latest.enrichmentState != EnrichmentState.processing ||
          latest.previewAttemptCount != claimed.previewAttemptCount) {
        return false;
      }
      await Item.db.updateRow(
        session,
        update(latest),
        transaction: transaction,
      );
      return true;
    });
  }

  Future<void> _rerunAi(Session session, Item item) async {
    try {
      final task = await AiOrganizationService.instance.enqueue(
        session,
        ownerId: item.ownerId,
        itemId: item.id!,
      );
      await session.serverpod.futureCalls
          .callWithDelay(
            Duration.zero,
            identifier: 'ai-organize-${item.id}-v${task.requestedVersion}',
          )
          .aiOrganize
          .process(item.id!, item.ownerId);
    } catch (_) {}
  }

  Future<void> _politeDelay(String key, Duration spacing) {
    final previous = _rateGates[key] ?? Future.value();
    final next = previous.catchError((_) {}).then((_) async {
      final last = _lastStarted[key];
      final wait = last == null
          ? Duration.zero
          : spacing - _clock().difference(last);
      if (wait > Duration.zero) await Future<void>.delayed(wait);
      _lastStarted[key] = _clock();
    });
    _rateGates[key] = next;
    return next;
  }

  static Uri? _oEmbedUri(Uri source) {
    final host = source.host.toLowerCase();
    if (host == 'youtu.be' ||
        host == 'youtube.com' ||
        host.endsWith('.youtube.com')) {
      return Uri.https('www.youtube.com', '/oembed', {
        'url': source.toString(),
        'format': 'json',
      });
    }
    if (host == 'x.com' ||
        host.endsWith('.x.com') ||
        host == 'twitter.com' ||
        host.endsWith('.twitter.com')) {
      return Uri.https('publish.twitter.com', '/oembed', {
        'url': source.toString(),
        'omit_script': 'true',
        'dnt': 'true',
      });
    }
    if (host == 'tiktok.com' || host.endsWith('.tiktok.com')) {
      return Uri.https('www.tiktok.com', '/oembed', {
        'url': source.toString(),
      });
    }
    return null;
  }
}
