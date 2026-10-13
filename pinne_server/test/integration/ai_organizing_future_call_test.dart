import 'package:pinne_server/src/ai/ai_organization_service.dart';
import 'package:pinne_server/src/ai/ai_provider.dart';
import 'package:pinne_server/src/ai/ai_provider_status.dart';
import 'package:pinne_server/src/ai/fake_ai_provider.dart';
import 'package:pinne_server/src/ai/groq_provider.dart';
import 'package:pinne_server/src/generated/protocol.dart';
import 'package:pinne_server/src/link_previews/link_preview_parser.dart';
import 'package:pinne_server/src/link_previews/link_preview_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

/// The production path: a capture schedules organizing and a link preview as
/// real future calls, and a successful preview requeues organizing with the
/// richer evidence. This is the path where a new guest saw no suggestions.
void main() {
  withServerpod(
    'Given AI organizing through future calls',
    (sessionBuilder, endpoints) {
      late TestSessionBuilder owner;
      late UuidValue ownerId;
      late List<String> operatorLines;
      final previousAi = AiOrganizationService.instance;
      final previousPreviews = LinkPreviewService.instance;

      setUp(() async {
        owner = await signedInAs(sessionBuilder);
        ownerId = UuidValue.fromString(
          owner.build().authenticated!.userIdentifier,
        );
        operatorLines = [];
        AiProviderStatus.resetForTest();
        AiProviderStatus.sink = operatorLines.add;
        LinkPreviewService.instance = LinkPreviewService(
          loader: (uri) async => const PreviewLoadResult(
            accessState: AccessState.available,
            preview: LinkPreview(
              title: 'Layouts in Flutter',
              description:
                  "Learn how Flutter's layout mechanism works and how to "
                  'build a layout. Widgets are classes used to build UIs.',
              siteName: 'Flutter',
            ),
          ),
        );
      });

      tearDown(() {
        AiOrganizationService.instance = previousAi;
        LinkPreviewService.instance = previousPreviews;
        AiProviderStatus.resetForTest();
      });

      Future<UuidValue> capture() async {
        final saved = await endpoints.item.capture(
          owner,
          CaptureDraft(
            clientItemId: const Uuid().v4obj(),
            operationId: const Uuid().v4obj(),
            url: 'https://docs.flutter.dev/ui/layout',
            intention: 'learn this for my side project',
            capturedAt: DateTime.now().toUtc(),
          ),
        );
        expect(saved.enrichmentState, EnrichmentState.pending);
        return saved.itemId;
      }

      /// Waits for the post-preview organizing version to complete.
      Future<List<AiSuggestion>> settledSuggestions(UuidValue itemId) async {
        final deadline = DateTime.now().add(const Duration(seconds: 20));
        while (DateTime.now().isBefore(deadline)) {
          final item = await Item.db.findById(owner.build(), itemId);
          final task = await AiOrganizeTask.db.findFirstRow(
            owner.build(),
            where: (t) => t.itemId.equals(itemId),
          );
          if (item?.enrichmentState == EnrichmentState.ready &&
              task != null &&
              task.requestedVersion >= 2 &&
              task.state == AiProcessingState.completed &&
              task.processedVersion == task.requestedVersion) {
            return endpoints.aiOrganizing.listSuggestions(owner, itemId);
          }
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
        fail('AI organizing did not settle after the preview.');
      }

      test(
        'a failing remote provider still yields rules tags and a summary, '
        'and logs the provider and reason without saved content',
        () async {
          final failing = FakeAiProvider(
            error: const GroqException(
              'Groq returned HTTP 401 (invalid_api_key).',
            ),
          );
          AiOrganizationService.instance = AiOrganizationService(
            remoteProviderOverride: failing,
          );

          final itemId = await capture();
          final suggestions = await settledSuggestions(itemId);

          expect(failing.calls, greaterThanOrEqualTo(1));
          expect(
            suggestions
                .where((value) => value.kind == AiSuggestionKind.tag)
                .map((value) => value.value),
            contains('flutter'),
          );
          final summary = suggestions.singleWhere(
            (value) => value.kind == AiSuggestionKind.summary,
          );
          expect(summary.value, startsWith("Learn how Flutter's layout"));
          expect(
            summary.evidenceCoverage,
            AiEvidenceCoverage.metadataPlusPreview,
          );
          expect(suggestions.every((value) => value.ownerId == ownerId), true);

          expect(
            operatorLines,
            contains(
              'AI organizing: fake failed, organized with rules instead: '
              'Groq returned HTTP 401 (invalid_api_key).',
            ),
          );
          for (final line in operatorLines) {
            expect(line, isNot(contains('docs.flutter.dev')));
            expect(line, isNot(contains('side project')));
            expect(line, isNot(contains('Layouts')));
          }
          expect(
            await endpoints.health.aiProviderStatus(sessionBuilder),
            // The registry has no key in tests, so the probe reports rules.
            'rules: no remote AI provider is configured.',
          );
        },
      );

      test('a working remote provider supplies its suggestions', () async {
        final working = FakeAiProvider(
          result: const AiOrganizationResult(
            collectionIds: [],
            tags: ['layout', 'widgets'],
            summary: 'How Flutter lays out widgets.',
            rationale: 'Title and description match.',
            evidenceCoverage: AiEvidenceCoverage.metadataPlusPreview,
            uncertain: false,
            provider: 'fake',
          ),
        );
        AiOrganizationService.instance = AiOrganizationService(
          remoteProviderOverride: working,
        );

        final itemId = await capture();
        final suggestions = await settledSuggestions(itemId);

        expect(
          suggestions
              .where((value) => value.kind == AiSuggestionKind.tag)
              .map((value) => value.value),
          ['layout', 'widgets'],
        );
        expect(
          suggestions
              .where((value) => value.kind == AiSuggestionKind.summary)
              .map((value) => value.value),
          ['How Flutter lays out widgets.'],
        );
        expect(operatorLines, isEmpty);
      });

      test(
        'rules suggest a matching collection when the remote fails',
        () async {
          final collection = await Collection.db.insertRow(
            owner.build(),
            Collection(ownerId: ownerId, name: 'Flutter'),
          );
          AiOrganizationService.instance = AiOrganizationService(
            remoteProviderOverride: FakeAiProvider(
              error: const GroqException('Groq returned HTTP 400.'),
            ),
          );

          final itemId = await capture();
          final suggestions = await settledSuggestions(itemId);

          expect(
            suggestions
                .where((value) => value.kind == AiSuggestionKind.collection)
                .map((value) => value.collectionId),
            [collection.id],
          );
        },
      );
    },
    configOverride: (config) => config.copyWith(
      futureCall: const FutureCallConfig(
        scanInterval: Duration(milliseconds: 100),
      ),
    ),
    // Future calls run in their own sessions and must see committed rows.
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
