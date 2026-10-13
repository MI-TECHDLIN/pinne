import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'paths.dart';
import 'tour.dart';

/// Scene time and the guided tour, readable anywhere in the stage. The real app
/// inside the phone never depends on it, so it is not rebuilt by it.
class FilmScope extends InheritedWidget {
  const FilmScope({super.key, required this.film, required super.child});

  final Film film;

  static Film of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FilmScope>()!.film;

  @override
  bool updateShouldNotify(FilmScope oldWidget) => false;
}

/// Rebuilds [builder] every frame with the scene time in seconds.
class AtTime extends StatelessWidget {
  const AtTime({super.key, required this.builder, this.child});

  final Widget Function(BuildContext context, double t, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final film = FilmScope.of(context);
    return ValueListenableBuilder<double>(
      valueListenable: film.clock,
      builder: (context, t, child) => builder(context, t, child),
      child: child,
    );
  }
}

/// Films a scene: advances the real widget tree one 30 fps frame at a time
/// with `tester.pump`, captures the whole 1920x1080 stage and pipes the raw
/// frames to ffmpeg. With `--dart-define=FILM_PREVIEW=true` it writes a PNG
/// still every half second instead, for checking a scene quickly.
class Film {
  Film(this.tester, this.name);

  static const fps = 30;

  /// Seconds filmed past each scene's planned end (see tool/assemble.py).
  static const tail = 1.5;
  static const size = Size(1920, 1080);
  static const preview = bool.fromEnvironment('FILM_PREVIEW');
  static const ffmpeg = String.fromEnvironment('FILM_FFMPEG');

  final WidgetTester tester;
  final String name;
  final clock = ValueNotifier<double>(0);

  /// The camera, cursor and callouts over an app screen; null for cards.
  Guide? guide;
  final _boundary = GlobalKey();
  Process? _encoder;
  int frame = 0;

  /// Scene time when the scene's last essential moment ended, before the
  /// spare footage.
  double? core;
  Duration _pumped = Duration.zero;

  double get t => frame / fps;

  /// Starts the guided tour, with the screen first framed by [home].
  Guide guided([Shot? home]) => guide = Guide(this, home);

  Future<void> open(Widget stage) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    debugDisableShadows = false;
    await tester.pumpWidget(
      FilmScope(
        film: this,
        child: RepaintBoundary(key: _boundary, child: stage),
      ),
    );
    if (!preview) {
      Directory('${FilmPaths.out}/segments').createSync(recursive: true);
      _encoder = await tester.runAsync(
        () => Process.start(ffmpeg, [
          '-y',
          '-loglevel',
          'error',
          '-f',
          'rawvideo',
          '-pix_fmt',
          'rgba',
          '-s',
          '${size.width.toInt()}x${size.height.toInt()}',
          '-r',
          '$fps',
          '-i',
          '-',
          '-c:v',
          'libx264',
          '-preset',
          'medium',
          '-crf',
          '12',
          '-pix_fmt',
          'yuv420p',
          '${FilmPaths.out}/segments/$name.mp4',
        ]),
      );
      unawaited(_encoder!.stderr.forEach(stderr.add));
    } else {
      Directory('${FilmPaths.out}/preview/$name').createSync(recursive: true);
    }
  }

  /// Renders and records one frame.
  Future<void> step() async {
    clock.value = t;
    final target = Duration(microseconds: (frame + 1) * 1000000 ~/ fps);
    await tester.pump(target - _pumped);
    _pumped = target;
    guide?.afterFrame();
    await _capture();
    frame++;
  }

  Future<void> _capture() async {
    final stills = preview && frame % (fps ~/ 2) == 0;
    if (preview && !stills) return;
    await tester.runAsync(() async {
      final boundary =
          _boundary.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = await boundary.toImage();
      if (stills) {
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        final label = t.toStringAsFixed(1).padLeft(5, '0');
        File(
          '${FilmPaths.out}/preview/$name/t$label.png',
        ).writeAsBytesSync(png!.buffer.asUint8List());
      } else {
        final raw = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        _encoder!.stdin.add(raw!.buffer.asUint8List());
        await _encoder!.stdin.flush();
      }
      image.dispose();
    });
  }

  /// Records frames until scene time [seconds].
  Future<void> until(double seconds) async {
    while (t < seconds - 1e-6) {
      await step();
    }
  }

  Future<void> hold(double seconds) => until(t + seconds);

  Future<void> finish() async {
    guide?.write();
    // Unmount the app and let its timers (outbox backoff, polling) run out.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 30));
    final encoder = _encoder;
    if (encoder != null) {
      await tester.runAsync(() async {
        await encoder.stdin.close();
        final code = await encoder.exitCode;
        if (code != 0) throw StateError('ffmpeg exited with $code for $name');
      });
    }
    debugDisableShadows = true;
  }

  /// Types into a text field at a human pace.
  Future<void> type(
    Finder field,
    String text, {
    double charsPerSecond = 16,
  }) async {
    final start = t;
    for (var i = 1; i <= text.length; i++) {
      await tester.enterText(field, text.substring(0, i));
      await until(start + i / charsPerSecond);
    }
  }

  /// Decodes an image outside fake time so widgets can show it at once.
  Future<void> precache(ImageProvider provider) async {
    await tester.runAsync(() async {
      final done = Completer<void>();
      final stream = provider.resolve(ImageConfiguration.empty);
      late final ImageStreamListener listener;
      listener = ImageStreamListener(
        (image, sync) {
          if (!done.isCompleted) done.complete();
          stream.removeListener(listener);
        },
        onError: (error, stack) {
          if (!done.isCompleted) done.completeError(error, stack);
        },
      );
      stream.addListener(listener);
      await done.future;
    });
  }
}

/// Eased progress of [t] through the window [from]..[from + span].
double ramp(
  double t,
  double from,
  double span, [
  Curve curve = Curves.easeOutCubic,
]) => curve.transform(((t - from) / span).clamp(0.0, 1.0));

/// Fades in at [start] and out at [end].
double window(double t, double start, double end, {double fade = 0.35}) =>
    ramp(t, start, fade) * (1 - ramp(t, end - fade, fade, Curves.easeInCubic));
