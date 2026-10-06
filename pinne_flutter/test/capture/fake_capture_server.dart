import 'dart:async';

import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/features/capture/outbox_sync.dart';

/// An in-memory stand-in for `item.capture` with the same contract as the
/// server: idempotent by operation id and client item id, duplicates found
/// by platform item id or canonical URL using the shared rules.
class FakeCaptureServer implements CaptureApi {
  /// When true, every call fails as if the network were down.
  bool offline = false;

  /// When set, the next call is applied on the "server" but its response
  /// is lost, the way a dropped connection after commit looks to a phone.
  bool loseNextResponse = false;

  /// When set, the next call is refused with this exception.
  Exception? rejectNext;

  /// Completes calls only when the test says so.
  Completer<void>? gate;

  final List<CaptureDraft> calls = [];
  final Map<String, ({String itemId, bool duplicate})> _byOperation = {};
  final Map<String, ({String itemId, bool duplicate})> _byClientItem = {};
  final Map<String, NormalizedLink?> items = {};
  final List<VoidCallback> _onlineListeners = [];

  @override
  Future<CaptureResult> capture(CaptureDraft draft) async {
    calls.add(draft);
    final gate = this.gate;
    if (gate != null) await gate.future;
    if (offline) {
      throw const ServerpodClientNetworkException('Failed host lookup');
    }
    final reject = rejectNext;
    if (reject != null) {
      rejectNext = null;
      throw reject;
    }
    final result = _apply(draft);
    if (loseNextResponse) {
      loseNextResponse = false;
      throw const ServerpodClientNetworkException('Connection reset');
    }
    return result;
  }

  CaptureResult _apply(CaptureDraft draft) {
    final op = draft.operationId.uuid;
    final client = draft.clientItemId.uuid;
    final known = _byOperation[op] ?? _byClientItem[client];
    final input = parseCaptureInput(draft.url ?? draft.text ?? '');
    final link = input.link;
    if (known != null) return _result(draft, known.itemId, known.duplicate);

    String? existing;
    if (link != null) {
      for (final MapEntry(key: id, value: other) in items.entries) {
        if (other == null) continue;
        final sameItem =
            link.sourceItemId != null &&
            other.source == link.source &&
            other.sourceItemId == link.sourceItemId;
        if (sameItem || other.canonicalUrl == link.canonicalUrl) {
          existing = id;
          break;
        }
      }
    }
    final itemId = existing ?? const Uuid().v4();
    items.putIfAbsent(itemId, () => link);
    final outcome = (itemId: itemId, duplicate: existing != null);
    _byOperation[op] = outcome;
    _byClientItem[client] = outcome;
    return _result(draft, itemId, existing != null);
  }

  CaptureResult _result(CaptureDraft draft, String itemId, bool duplicate) {
    final input = parseCaptureInput(draft.url ?? draft.text ?? '');
    return CaptureResult(
      itemId: UuidValue.fromString(itemId),
      clientItemId: draft.clientItemId,
      revision: 1,
      title: draft.title ?? input.suggestedTitle,
      sourcePlatform: SourcePlatform.values.byName(input.source.name),
      sourceItemId: input.link?.sourceItemId,
      canonicalUrl: input.link?.canonicalUrl,
      duplicate: duplicate,
      duplicateOf: duplicate ? UuidValue.fromString(itemId) : null,
      enrichmentState: EnrichmentState.pending,
      savedAt: draft.capturedAt,
    );
  }

  /// Simulates the connection coming back.
  void comeOnline() {
    offline = false;
    for (final listener in [..._onlineListeners]) {
      listener();
    }
  }

  @override
  VoidCallback watchConnectivity(VoidCallback onOnline) {
    _onlineListeners.add(onOnline);
    return () => _onlineListeners.remove(onOnline);
  }
}
