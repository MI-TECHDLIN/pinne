import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.x contrast ratio between two opaque colours.
double contrastRatio(Color a, Color b) {
  final aLuminance = a.computeLuminance();
  final bLuminance = b.computeLuminance();
  final lighter = math.max(aLuminance, bLuminance);
  final darker = math.min(aLuminance, bLuminance);
  return (lighter + 0.05) / (darker + 0.05);
}

/// One piece of on-screen text that is below its WCAG AA contrast floor.
class ContrastFailure {
  const ContrastFailure({
    required this.text,
    required this.foreground,
    required this.background,
    required this.ratio,
    required this.required,
  });

  final String text;
  final Color foreground;
  final Color background;
  final double ratio;
  final double required;

  @override
  String toString() =>
      '"$text": ${_hex(foreground)} on ${_hex(background)} = '
      '${ratio.toStringAsFixed(2)}:1, needs ${required.toStringAsFixed(1)}:1';
}

/// Fails when any visible text on the current screen is below WCAG AA.
///
/// Every [RichText] (which includes [Text] and [Icon]) and [EditableText] in
/// the top-most route and in overlays, and not under a [ModalBarrier], is
/// checked: its style colour (blended
/// onto the background when translucent) against the colour actually painted
/// just outside its box, sampled from the rendered frame. Body text needs
/// 4.5:1; large text (24 px, or 18.66 px bold) and icons need 3:1.
///
/// Text under a lower route, fully transparent, faded by an [Opacity] or
/// outside the screen is skipped, as are disabled controls (WCAG exempts
/// them) and text in [skip]. [within] limits the check to one subtree, for
/// overlays such as coach marks whose scrim is painted, not a barrier.
Future<void> expectReadableText(
  WidgetTester tester, {
  Finder? skip,
  Finder? within,
  String? reason,
}) async {
  final failures = await findContrastFailures(
    tester,
    skip: skip,
    within: within,
  );
  if (failures.isEmpty) return;
  fail(
    '${reason == null ? '' : '$reason: '}'
    '${failures.length} text contrast failure(s):\n  '
    '${failures.join('\n  ')}',
  );
}

Future<List<ContrastFailure>> findContrastFailures(
  WidgetTester tester, {
  Finder? skip,
  Finder? within,
}) async {
  final view = tester.binding.renderViews.first;
  final ratio = view.configuration.devicePixelRatio;
  final pixels = (await tester.runAsync(() async {
    final layer = view.debugLayer! as OffsetLayer;
    final image = await layer.toImage(view.paintBounds);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final result = _Pixels(image.width, image.height, bytes!);
    image.dispose();
    return result;
  }))!;
  final skipped = skip == null ? const <Element>{} : skip.evaluate().toSet();

  final barriers = {
    for (final element in find.byType(ModalBarrier).evaluate())
      if (element.renderObject case final RenderObject object) object,
  };

  final failures = <ContrastFailure>[];
  final seen = <String>{};
  Finder scoped(Finder finder) =>
      within == null ? finder : find.descendant(of: within, matching: finder);
  for (final element in [
    ...scoped(find.byType(RichText, skipOffstage: true)).evaluate(),
    ...scoped(find.byType(EditableText, skipOffstage: true)).evaluate(),
  ]) {
    if (_isSkipped(element, skipped) || !_isOnTopRoute(element)) continue;
    if (_isDisabledControl(element)) continue;
    final box = element.renderObject;
    if (box is! RenderBox || !box.hasSize || box.size.isEmpty) continue;
    if (!box.attached || _isFaded(box)) continue;

    final rect = MatrixUtils.transformRect(
      box.getTransformTo(null),
      Offset.zero & box.size,
    );
    final physical = Rect.fromLTRB(
      rect.left * ratio,
      rect.top * ratio,
      rect.right * ratio,
      rect.bottom * ratio,
    );
    if (!physical.overlaps(Offset.zero & pixels.size)) continue;
    if (_isUnderBarrier(tester, rect.center, barriers)) continue;
    final background = pixels.ringMode(physical.inflate(ratio));
    if (background == null) continue;

    for (final run in _runs(element, box)) {
      if (run.color.a == 0) continue;
      final foreground = Color.alphaBlend(run.color, background);
      final contrast = contrastRatio(foreground, background);
      if (contrast + 0.005 >= run.required) continue;
      final failure = ContrastFailure(
        text: run.text,
        foreground: run.color,
        background: background,
        ratio: contrast,
        required: run.required,
      );
      if (seen.add(failure.toString())) failures.add(failure);
    }
  }
  return failures;
}

class _Run {
  const _Run(this.text, this.color, this.required);
  final String text;
  final Color color;
  final double required;
}

Iterable<_Run> _runs(Element element, RenderBox box) sync* {
  final widget = element.widget;
  if (widget is EditableText) {
    final text = widget.controller.text;
    final color = widget.style.color;
    if (text.trim().isNotEmpty && color != null) {
      yield _Run(
        _snippet(text),
        color,
        _required(widget.style, widget.textScaler),
      );
    }
    return;
  }
  final paragraph = box as RenderParagraph;
  final runs = <_Run>[];
  void visit(InlineSpan span, TextStyle inherited) {
    final style = inherited.merge(span.style);
    if (span is TextSpan) {
      final text = span.text;
      final color = style.color ?? style.foreground?.color;
      if (text != null && text.trim().isNotEmpty && color != null) {
        runs.add(
          _Run(_snippet(text), color, _required(style, paragraph.textScaler)),
        );
      }
      for (final child in span.children ?? const <InlineSpan>[]) {
        visit(child, style);
      }
    }
  }

  visit(paragraph.text, const TextStyle());
  yield* runs;
}

double _required(TextStyle style, TextScaler? scaler) {
  if (style.fontFamily == 'MaterialIcons' ||
      (style.fontFamily?.startsWith('packages/') ?? false)) {
    return 3; // Icons are non-text graphics (WCAG 1.4.11).
  }
  final size = (scaler ?? TextScaler.noScaling).scale(style.fontSize ?? 14);
  final bold = (style.fontWeight?.value ?? 400) >= 700;
  return size >= 24 || (bold && size >= 18.66) ? 3 : 4.5;
}

bool _isSkipped(Element element, Set<Element> skipped) {
  if (skipped.isEmpty) return false;
  if (skipped.contains(element)) return true;
  var found = false;
  element.visitAncestorElements((ancestor) {
    found = skipped.contains(ancestor);
    return !found;
  });
  return found;
}

/// WCAG exempts inactive controls, which Material paints at 38%.
bool _isDisabledControl(Element element) {
  var disabled = false;
  element.visitAncestorElements((ancestor) {
    final widget = ancestor.widget;
    disabled = switch (widget) {
      ButtonStyleButton() => !widget.enabled,
      IconButton() => widget.onPressed == null,
      RawChip() => !widget.isEnabled,
      ChoiceChip() => !widget.isEnabled,
      FilterChip() => !widget.isEnabled,
      ListTile() => !widget.enabled,
      TextField() => !(widget.enabled ?? true),
      _ => false,
    };
    return !disabled;
  });
  return disabled;
}

/// Text on a route covered by another route sits under a scrim and is not
/// what the user is reading.
bool _isOnTopRoute(Element element) {
  final route = ModalRoute.of(element);
  return route == null || route.isCurrent;
}

/// Text under a modal scrim is dimmed with its background and not what the
/// user is reading; the scrim, not the text, is what a hit test finds there.
bool _isUnderBarrier(
  WidgetTester tester,
  Offset point,
  Set<RenderObject> barriers,
) {
  if (barriers.isEmpty) return false;
  for (final entry in tester.hitTestOnBinding(point).path) {
    final target = entry.target;
    if (target is! RenderObject) continue;
    for (RenderObject? node = target; node != null; node = node.parent) {
      if (barriers.contains(node)) return true;
    }
  }
  return false;
}

bool _isFaded(RenderObject object) {
  for (RenderObject? node = object; node != null; node = node.parent) {
    if (node is RenderOpacity && node.opacity < 1) return true;
    if (node is RenderAnimatedOpacity && node.opacity.value < 1) return true;
    if (node is RenderOffstage && node.offstage) return true;
  }
  return false;
}

String _snippet(String text) {
  final flat = text.replaceAll('\n', ' ').trim();
  return flat.length > 40 ? '${flat.substring(0, 40)}…' : flat;
}

String _hex(Color color) =>
    '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

class _Pixels {
  _Pixels(this.width, this.height, this.bytes);

  final int width;
  final int height;
  final ByteData bytes;

  Size get size => Size(width.toDouble(), height.toDouble());

  int? _at(int x, int y) {
    if (x < 0 || y < 0 || x >= width || y >= height) return null;
    final i = (y * width + x) * 4;
    final r = bytes.getUint8(i);
    final g = bytes.getUint8(i + 1);
    final b = bytes.getUint8(i + 2);
    final a = bytes.getUint8(i + 3);
    return a << 24 | r << 16 | g << 8 | b;
  }

  /// The most common colour on the one-pixel ring around [rect]: the surface
  /// the text is painted on, whatever widget or sibling painted it.
  Color? ringMode(Rect rect) {
    final left = rect.left.floor();
    final top = rect.top.floor();
    final right = rect.right.ceil();
    final bottom = rect.bottom.ceil();
    final counts = <int, int>{};
    void add(int x, int y) {
      final value = _at(x, y);
      if (value != null) counts[value] = (counts[value] ?? 0) + 1;
    }

    for (var x = left; x <= right; x++) {
      add(x, top);
      add(x, bottom);
    }
    for (var y = top + 1; y < bottom; y++) {
      add(left, y);
      add(right, y);
    }
    if (counts.isEmpty) return null;
    final best = counts.entries.reduce((a, b) => a.value >= b.value ? a : b);
    // The captured frame has no backdrop, so composite onto opaque black like
    // the device does.
    return Color.alphaBlend(Color(best.key), const Color(0xFF000000));
  }
}
