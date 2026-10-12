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
  Future<List<AiSuggestion>> pending(UuidValue itemId);

  /// Collection names by id, for labelling collection suggestions.
  Future<Map<UuidValue, String>> collectionNames();

  Future<void> accept(UuidValue suggestionId);

  Future<void> reject(UuidValue suggestionId);
}

class ServerAiSuggestionsApi implements AiSuggestionsApi {
  ServerAiSuggestionsApi(this.client);

  final Client client;

  @override
  Future<List<AiSuggestion>> pending(UuidValue itemId) =>
      client.aiOrganizing.listSuggestions(itemId);

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

/// The pending AI suggestions for one server item, labelled for people.
final aiSuggestionsProvider = AsyncNotifierProvider.autoDispose
    .family<AiSuggestionsNotifier, List<AiSuggestionChipData>, UuidValue>(
      AiSuggestionsNotifier.new,
    );

class AiSuggestionsNotifier extends AsyncNotifier<List<AiSuggestionChipData>> {
  AiSuggestionsNotifier(this.itemId);

  final UuidValue itemId;

  @override
  Future<List<AiSuggestionChipData>> build() async {
    if (!ref.watch(signedInProvider)) return const [];
    final api = ref.watch(aiSuggestionsApiProvider);
    final suggestions = await api.pending(itemId);
    final names = suggestions.any((s) => s.kind == AiSuggestionKind.collection)
        ? await api.collectionNames()
        : const <UuidValue, String>{};
    return [
      for (final suggestion in suggestions)
        if (_label(suggestion, names) case final label?)
          AiSuggestionChipData(
            id: suggestion.id!.uuid,
            label: label,
            uncertain: suggestion.uncertain,
            maxLines: suggestion.kind == AiSuggestionKind.summary ? 4 : 1,
          ),
    ];
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
  Future<void> accept(String id) => _resolve(id, (api, id) async {
    await api.accept(id);
    if (!ref.mounted) return;
    ref
      ..invalidate(savedItemsProvider)
      ..invalidate(collectionsProvider);
  });

  Future<void> dismiss(String id) => _resolve(id, (api, id) => api.reject(id));

  /// Removes the chip at once and puts it back if the server refuses.
  Future<void> _resolve(
    String id,
    Future<void> Function(AiSuggestionsApi api, UuidValue id) send,
  ) async {
    final previous = state;
    final current = previous.asData?.value;
    if (current == null) return;
    state = AsyncData([
      for (final chip in current)
        if (chip.id != id) chip,
    ]);
    try {
      await send(ref.read(aiSuggestionsApiProvider), UuidValue.fromString(id));
    } catch (error, stackTrace) {
      if (ref.mounted) state = previous;
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}

/// AI suggestions on a Saved card. Uses an inline skeleton while loading and
/// shows nothing on error or when the AI had nothing to suggest.
class SavedItemAiSuggestions extends ConsumerWidget {
  const SavedItemAiSuggestions({super.key, required this.itemId});

  final UuidValue itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              color: PinneColors.muted,
            ),
          ),
          const SizedBox(height: PinneSpacing.xs),
          AiSuggestionChips(
            suggestions: suggestions,
            onAccept: (id) async {
              try {
                await notifier.accept(id);
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
