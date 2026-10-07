import 'package:flutter/material.dart';

import '../theme/pinne_tokens.dart';

class AiSuggestionChipData {
  const AiSuggestionChipData({
    required this.id,
    required this.label,
    this.uncertain = false,
  });

  final String id;
  final String label;
  final bool uncertain;
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
        for (final suggestion in suggestions)
          Semantics(
            container: true,
            label:
                'AI suggestion: ${suggestion.label}'
                '${suggestion.uncertain ? ', uncertain' : ''}',
            child: Container(
              key: ValueKey('ai-suggestion-${suggestion.id}'),
              padding: const EdgeInsets.only(left: PinneSpacing.md),
              decoration: BoxDecoration(
                color: PinneColors.glass,
                border: Border.all(color: PinneColors.line),
                borderRadius: BorderRadius.circular(PinneRadii.chip),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      suggestion.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (suggestion.uncertain)
                    const Padding(
                      padding: EdgeInsets.only(left: PinneSpacing.xs),
                      child: Text(
                        'Maybe',
                        style: TextStyle(color: PinneColors.muted),
                      ),
                    ),
                  IconButton(
                    key: ValueKey('accept-${suggestion.id}'),
                    tooltip: 'Accept ${suggestion.label}',
                    color: PinneColors.violet,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onAccept(suggestion.id),
                    icon: const Icon(Icons.check_rounded),
                  ),
                  IconButton(
                    key: ValueKey('dismiss-${suggestion.id}'),
                    tooltip: 'Dismiss ${suggestion.label}',
                    color: PinneColors.muted,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onDismiss(suggestion.id),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
