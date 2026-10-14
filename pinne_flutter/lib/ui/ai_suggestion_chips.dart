import 'package:flutter/material.dart';

import '../theme/pinne_tokens.dart';

class AiSuggestionChipData {
  const AiSuggestionChipData({
    required this.id,
    required this.label,
    this.uncertain = false,
    this.maxLines = 1,
  });

  final String id;
  final String label;
  final bool uncertain;

  /// Lines before the label ellipsizes. Null wraps the whole label, as a
  /// summary must: the user is accepting exactly that text.
  final int? maxLines;
}

/// Review controls for AI output. It intentionally owns no animation; parent
/// screens may remove rows using durations gated by reduceMotionOf(context).
class AiSuggestionChips extends StatelessWidget {
  const AiSuggestionChips({
    super.key,
    required this.suggestions,
    required this.onAccept,
    required this.onDismiss,
  });

  final List<AiSuggestionChipData> suggestions;
  final ValueChanged<String> onAccept;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: PinneSpacing.sm,
      runSpacing: PinneSpacing.sm,
      children: [
        for (final suggestion in suggestions) _chip(context, suggestion),
      ],
    );
  }

  Widget _chip(BuildContext context, AiSuggestionChipData suggestion) {
    // A pill only suits one line; wrapped text gets a tile's corners so it
    // never runs into the curve.
    final multiline = suggestion.maxLines != 1;
    return Semantics(
      container: true,
      label:
          'AI suggestion: ${suggestion.label}'
          '${suggestion.uncertain ? ', uncertain' : ''}',
      child: Container(
        key: ValueKey('ai-suggestion-${suggestion.id}'),
        padding: EdgeInsets.only(
          left: PinneSpacing.md,
          top: multiline ? PinneSpacing.xs : 0,
          bottom: multiline ? PinneSpacing.xs : 0,
        ),
        decoration: BoxDecoration(
          color: context.pinne.glass,
          border: Border.all(color: context.pinne.line),
          borderRadius: BorderRadius.circular(
            multiline ? PinneRadii.tile : PinneRadii.chip,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                suggestion.label,
                key: ValueKey('ai-suggestion-text-${suggestion.id}'),
                maxLines: suggestion.maxLines,
                overflow: suggestion.maxLines == null
                    ? null
                    : TextOverflow.ellipsis,
              ),
            ),
            if (suggestion.uncertain)
              Padding(
                padding: EdgeInsets.only(left: PinneSpacing.xs),
                child: Text(
                  'Maybe',
                  style: TextStyle(color: context.pinne.muted),
                ),
              ),
            IconButton(
              key: ValueKey('accept-${suggestion.id}'),
              tooltip: 'Accept ${suggestion.label}',
              color: context.pinne.violet,
              visualDensity: VisualDensity.compact,
              onPressed: () => onAccept(suggestion.id),
              icon: const Icon(Icons.check_rounded),
            ),
            IconButton(
              key: ValueKey('dismiss-${suggestion.id}'),
              tooltip: 'Dismiss ${suggestion.label}',
              color: context.pinne.muted,
              visualDensity: VisualDensity.compact,
              onPressed: () => onDismiss(suggestion.id),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
