import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/server_client.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/ai_suggestion_chips.dart';
import '../../ui/feedback/toast.dart';
import '../../ui/pinne_loading.dart';
import '../collections/collections_screen.dart';
import 'capture_providers.dart';

/// The server calls behind AI suggestion review. Kept injectable so the
/// Saved card can be exercised without a live server.
abstract interface class AiSuggestionsApi {
  /// Pending suggestions, and whether a newer organizing pass is coming.
  Future<AiSuggestionReview> review(UuidValue itemId);

  /// Collection names by id, for labelling collection suggestions.
  Future<Map<UuidValue, String>> collectionNames();

  Future<void> accept(UuidValue suggestionId);

  Future<void> reject(UuidValue suggestionId);
}

class ServerAiSuggestionsApi implements AiSuggestionsApi {
  ServerAiSuggestionsApi(this.client);

  final Client client;

  @override
  Future<AiSuggestionReview> review(UuidValue itemId) =>
      client.aiOrganizing.review(itemId);

  @override
  Future<Map<UuidValue, String>> collectionNames() async => {
    for (final collection in await client.collection.list())
      if (collection.id != null) collection.id!: collection.name,
  };

  @override
  Future<void> accept(UuidValue suggestionId) =>
      client.aiOrganizing.accept(suggestionId);

  @override
  Future<void> reject(UuidValue suggestionId) =>
      client.aiOrganizing.reject(suggestionId);
}

final aiSuggestionsApiProvider = Provider<AiSuggestionsApi>(
  (ref) => ServerAiSuggestionsApi(ref.watch(clientProvider)),
);

/// How often the card asks again while organizing is still running, and for
/// how long at most (longer than the server's wait for a slow preview).
const aiSuggestionsPollInterval = Duration(seconds: 2);
const aiSuggestionsMaxPolls = 45;

/// What happened to an accepted suggestion.
enum AiSuggestionOutcome {
  applied,

  /// A newer organizing pass no longer proposes it; the chips were reloaded.
  replaced,
}

/// The pending AI suggestions for one server item, labelled for people.
///
/// Organizing runs again once a link's preview arrives, and that newer pass
/// may drop what the first one proposed. So the list is fetched again while
/// the server says organizing is still running, when the item changes on
/// the server, and whenever the server no longer knows a chip.
final aiSuggestionsProvider = AsyncNotifierProvider.autoDispose
    .family<AiSuggestionsNotifier, List<AiSuggestionChipData>, UuidValue>(
      AiSuggestionsNotifier.new,
    );

class AiSuggestionsNotifier extends AsyncNotifier<List<AiSuggestionChipData>> {
  AiSuggestionsNotifier(this.itemId);

  final UuidValue itemId;
  Timer? _poll;
  int _polls = 0;
  bool _organizing = false;

  /// Chips being accepted or dismissed, kept off the card by refreshes.
  final _resolving = <String>{};

  @override
  Future<List<AiSuggestionChipData>> build() async {
    ref.onDispose(() => _poll?.cancel());
    if (ref.watch(accountIdProvider) == null) return const [];
    return _load(ref.watch(aiSuggestionsApiProvider));
  }

  Future<List<AiSuggestionChipData>> _load(AiSuggestionsApi api) async {
    final review = await api.review(itemId);
    final suggestions = review.suggestions;
    final names = suggestions.any((s) => s.kind == AiSuggestionKind.collection)
        ? await api.collectionNames()
        : const <UuidValue, String>{};
    if (ref.mounted) _afterLoad(organizing: review.organizing);
    return [
      for (final suggestion in suggestions)
        if (_label(suggestion, names) case final label?)
          if (!_resolving.contains(suggestion.id!.uuid))
            AiSuggestionChipData(
              id: suggestion.id!.uuid,
              label: label,
              uncertain: suggestion.uncertain,
              maxLines: suggestion.kind == AiSuggestionKind.summary ? null : 1,
            ),
    ];
  }

  void _afterLoad({required bool organizing}) {
    _poll?.cancel();
    if (_organizing && !organizing) {
      // The pass that just finished usually followed a preview, which also
      // changed the card's title and thumbnail.
      ref.invalidate(savedItemsProvider);
    }
    _organizing = organizing;
    if (!organizing || _polls >= aiSuggestionsMaxPolls) return;
    _poll = Timer(aiSuggestionsPollInterval, () {
      _polls++;
      unawaited(refresh());
    });
  }

  /// Fetches the current suggestions, keeping the shown ones on failure.
  Future<void> refresh({bool restartPolling = false}) async {
    if (restartPolling) _polls = 0;
    try {
      final chips = await _load(ref.read(aiSuggestionsApiProvider));
      if (ref.mounted) state = AsyncData(chips);
    } on Object {
      // A missed poll is not worth an error; the next trigger tries again.
    }
  }

  static String? _label(AiSuggestion s, Map<UuidValue, String> names) {
    if (s.id == null) return null;
    return switch (s.kind) {
      AiSuggestionKind.collection => switch (names[s.collectionId]) {
        final name? => 'Collection: $name',
        null => null,
      },
      AiSuggestionKind.tag => switch (s.value?.trim()) {
        final tag? when tag.isNotEmpty => 'Tag: $tag',
        _ => null,
      },
      AiSuggestionKind.summary => switch (s.value?.trim()) {
        final summary? when summary.isNotEmpty => 'Summary: $summary',
        _ => null,
      },
    };
  }

  /// Applies a suggestion on the server, then refreshes what it changed.
  Future<AiSuggestionOutcome> accept(String id) async {
    final outcome = await _resolve(id, (api, id) => api.accept(id));
    if (outcome == AiSuggestionOutcome.applied && ref.mounted) {
      ref
        ..invalidate(savedItemsProvider)
        ..invalidate(collectionsProvider);
    }
    return outcome;
  }

  Future<void> dismiss(String id) async {
    // A dismissed proposal that a newer pass dropped is gone either way.
    await _resolve(id, (api, id) => api.reject(id));
  }

  /// Removes the chip at once and puts it back if the server refuses. When
  /// the server no longer knows the chip, a newer organizing pass replaced
  /// it: the list is reloaded and the same proposal, if it is still made
  /// under a new id, is resolved once more.
  Future<AiSuggestionOutcome> _resolve(
    String id,
    Future<void> Function(AiSuggestionsApi api, UuidValue id) send,
  ) async {
    final previous = state;
    final current = previous.asData?.value;
    if (current == null) return AiSuggestionOutcome.replaced;
    final chip = current.firstWhere((chip) => chip.id == id);
    state = AsyncData([
      for (final other in current)
        if (other.id != id) other,
    ]);
    _resolving.add(id);
    try {
      await send(ref.read(aiSuggestionsApiProvider), UuidValue.fromString(id));
      return AiSuggestionOutcome.applied;
    } on RecordNotFoundException {
      if (!ref.mounted) return AiSuggestionOutcome.replaced;
      await refresh(restartPolling: true);
      final latest = state.asData?.value ?? const <AiSuggestionChipData>[];
      final same = latest.where((other) => other.label == chip.label);
      if (same.isEmpty) return AiSuggestionOutcome.replaced;
      return _resolveOnce(same.first.id, send);
    } catch (error, stackTrace) {
      if (ref.mounted) state = previous;
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      _resolving.remove(id);
    }
  }

  Future<AiSuggestionOutcome> _resolveOnce(
    String id,
    Future<void> Function(AiSuggestionsApi api, UuidValue id) send,
  ) async {
    final current = state.asData?.value ?? const <AiSuggestionChipData>[];
    state = AsyncData([
      for (final other in current)
        if (other.id != id) other,
    ]);
    _resolving.add(id);
    try {
      await send(ref.read(aiSuggestionsApiProvider), UuidValue.fromString(id));
      return AiSuggestionOutcome.applied;
    } on RecordNotFoundException {
      if (ref.mounted) await refresh();
      return AiSuggestionOutcome.replaced;
    } finally {
      _resolving.remove(id);
    }
  }
}

/// AI suggestions on a Saved card. Uses an inline skeleton while loading and
/// shows nothing on error or when the AI had nothing to suggest. A new
/// server [revision] of the item (its preview arrived, a summary was
/// accepted) fetches the suggestions again.
class SavedItemAiSuggestions extends ConsumerStatefulWidget {
  const SavedItemAiSuggestions({
    super.key,
    required this.itemId,
    this.revision,
  });

  final UuidValue itemId;
  final int? revision;

  @override
  ConsumerState<SavedItemAiSuggestions> createState() =>
      _SavedItemAiSuggestionsState();
}

class _SavedItemAiSuggestionsState
    extends ConsumerState<SavedItemAiSuggestions> {
  @override
  void didUpdateWidget(SavedItemAiSuggestions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemId == widget.itemId &&
        oldWidget.revision != widget.revision) {
      unawaited(
        ref
            .read(aiSuggestionsProvider(widget.itemId).notifier)
            .refresh(restartPolling: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemId = widget.itemId;
    final state = ref.watch(aiSuggestionsProvider(itemId));
    if (state.isLoading && !state.hasValue) {
      return const Padding(
        padding: EdgeInsets.only(top: PinneSpacing.sm),
        child: PinneSuggestionSkeleton(),
      );
    }
    final suggestions = state.asData?.value ?? const [];
    if (suggestions.isEmpty) return const SizedBox.shrink();
    final notifier = ref.read(aiSuggestionsProvider(itemId).notifier);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: PinneSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI suggestions',
            style: theme.textTheme.labelMedium?.copyWith(
              color: context.pinne.muted,
            ),
          ),
          const SizedBox(height: PinneSpacing.xs),
          AiSuggestionChips(
            suggestions: suggestions,
            onAccept: (id) async {
              try {
                final outcome = await notifier.accept(id);
                if (outcome == AiSuggestionOutcome.replaced &&
                    context.mounted) {
                  showPinneToast(
                    context,
                    'Pinne updated its suggestions. Here are the latest.',
                  );
                }
              } catch (error) {
                if (context.mounted) {
                  showErrorToast(context, error, 'Could not apply it');
                }
              }
            },
            onDismiss: (id) async {
              try {
                await notifier.dismiss(id);
              } catch (error) {
                if (context.mounted) {
                  showErrorToast(context, error, 'Could not dismiss it');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
