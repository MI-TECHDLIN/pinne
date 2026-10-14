import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/feedback/toast.dart';

typedef OpenExternalUrl = Future<bool> Function(Uri uri);

/// Launches [uri] outside the app: installed native apps (YouTube, X,
/// TikTok, Instagram, Reddit) claim their links, otherwise the browser does.
final openExternalUrlProvider = Provider<OpenExternalUrl>(
  (ref) =>
      (uri) => launchUrl(uri, mode: LaunchMode.externalApplication),
);

/// Opens a saved item's original link. Opening is not reviewing: this
/// records nothing. Returns false when there is no link or it could not be
/// opened; the latter shows a toast.
Future<bool> openOriginal(
  BuildContext context,
  WidgetRef ref,
  String? url,
) async {
  final uri = url == null ? null : Uri.tryParse(url.trim());
  if (uri == null || !uri.hasScheme) return false;
  var opened = false;
  try {
    opened = await ref.read(openExternalUrlProvider)(uri);
  } on Object {
    opened = false;
  }
  if (!opened && context.mounted) {
    showPinneToast(context, 'Could not open that link.', kind: ToastKind.error);
  }
  return opened;
}
