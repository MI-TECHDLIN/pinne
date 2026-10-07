import 'ai_provider.dart';

/// Programmable provider for tests. No network or secret is required.
class FakeAiProvider implements AiProvider {
  FakeAiProvider({this.result, this.error});

  AiOrganizationResult? result;
  Object? error;
  int calls = 0;

  @override
  String get name => 'fake';

  @override
  Future<AiOrganizationResult> organize({
    required AiItemEvidence evidence,
    required List<AiCollectionOption> collections,
  }) async {
    calls++;
    if (error case final error?) throw error;
    final value = result;
    if (value == null) throw StateError('FakeAiProvider.result was not set.');
    return value;
  }
}
