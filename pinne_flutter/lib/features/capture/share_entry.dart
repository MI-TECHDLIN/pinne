import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/pinne_theme.dart';
import '../../ui/motion.dart';
import 'share_sheet.dart';

/// What another app shared: `EXTRA_TEXT` and `EXTRA_SUBJECT` on Android.
@immutable
class SharedPayload {
  const SharedPayload({required this.text, this.subject});

  final String text;
  final String? subject;
}

/// Talks to `ShareActivity` on Android.
class ShareChannel {
  const ShareChannel();

  static const _channel = MethodChannel('app.pinne/share');

  /// The share that started this engine, or null if there was none.
  Future<SharedPayload?> take() async {
    final share = await _channel.invokeMapMethod<String, Object?>('takeShare');
    if (share == null) return null;
    return SharedPayload(
      text: share['text'] as String? ?? '',
      subject: share['subject'] as String?,
    );
  }

  /// Finishes the share activity, which returns to the app that shared.
  Future<void> finish() => _channel.invokeMethod<void>('finish');
}

/// The whole app the share engine runs: just the sheet, over a transparent
/// window so the source app stays visible behind the dim.
class ShareApp extends StatelessWidget {
  const ShareApp({super.key, required this.payload, required this.onDone});

  final SharedPayload payload;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save to Pinne',
      debugShowCheckedModeBanner: false,
      color: Colors.transparent,
      theme: pinneDarkTheme(),
      // The in-app motion setting is not stored yet, so the share sheet
      // follows the system reduce-motion flag.
      builder: (context, child) => MotionPreferenceScope(
        preference: MotionPreference.system,
        child: child ?? const SizedBox.shrink(),
      ),
      home: ShareSheetScreen(
        text: payload.text,
        subject: payload.subject,
        onDone: onDone,
      ),
    );
  }
}
