import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/ui/ai_suggestion_chips.dart';

void main() {
  testWidgets('accepts and dismisses individual text-labelled suggestions', (
    tester,
  ) async {
    String? accepted;
    String? dismissed;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AiSuggestionChips(
            suggestions: const [
              AiSuggestionChipData(id: 'work', label: 'Collection: Work'),
              AiSuggestionChipData(
                id: 'flutter',
                label: 'Tag: flutter',
                uncertain: true,
              ),
            ],
            onAccept: (id) => accepted = id,
            onDismiss: (id) => dismissed = id,
          ),
        ),
      ),
    );

    expect(find.text('Collection: Work'), findsOneWidget);
    expect(find.text('Tag: flutter'), findsOneWidget);
    expect(find.text('Maybe'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('accept-work')));
    await tester.tap(find.byKey(const ValueKey('dismiss-flutter')));
    expect(accepted, 'work');
    expect(dismissed, 'flutter');
  });

  testWidgets('has no motion when the platform disables animations', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: AiSuggestionChips(
              suggestions: const [
                AiSuggestionChipData(id: 'one', label: 'Tag: reading'),
              ],
              onAccept: (_) {},
              onDismiss: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AnimatedWidget), findsNothing);
    expect(find.byType(Hero), findsNothing);
  });
}
