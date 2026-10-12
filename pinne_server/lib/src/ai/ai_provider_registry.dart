import 'ai_provider.dart';
import 'gemini_provider.dart';
import 'groq_provider.dart';
import 'no_ai_provider.dart';

/// Process-wide provider configuration, initialized once by server.dart.
abstract final class AiProviderRegistry {
  static const fallback = NoAiProvider();
  static AiProvider? _remote;
  static bool _globallyEnabled = true;

  static bool get remoteAvailable => _globallyEnabled && _remote != null;
  static AiProvider? get remote => remoteAvailable ? _remote : null;
  static String get activeProviderName => remote?.name ?? fallback.name;

  static void configure({
    String? groqApiKey,
    String? geminiApiKey,
    required bool enabled,
  }) {
    _globallyEnabled = enabled;
    _remote = switch ((groqApiKey?.trim(), geminiApiKey?.trim())) {
      (final groq?, _) when groq.isNotEmpty => GroqProvider(apiKey: groq),
      (_, final gemini?) when gemini.isNotEmpty => GeminiProvider(
        apiKey: gemini,
      ),
      _ => null,
    };
  }

  static AiProvider provider({required bool userEnabled}) {
    final remote = _remote;
    if (!_globallyEnabled || !userEnabled || remote == null) return fallback;
    return FallbackAiProvider(primary: remote, fallback: fallback);
  }

  static void resetForTest() {
    _remote = null;
    _globallyEnabled = true;
  }
}
