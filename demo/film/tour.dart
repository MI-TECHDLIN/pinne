import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';

import 'director.dart';
import 'paths.dart';

/// The guided tour drawn over the real app: a camera that eases toward the
/// element each step is about, a cursor that glides onto it and clicks, and
/// one short callout beside it. Every target is found in the widget tree,
/// so the cursor lands where the element really is; a landing outside it,
/// a target off the canvas, a callout over its target or two callouts at
/// once fail the render.

/// The app screen in logical pixels, as on a mid-size Android phone.
const appScreen = Size(412, 892);

/// Canvas pixels per app pixel at zoom 1: the screen at full canvas height.
const baseScale = 1080 / 892;

/// The camera never zooms past this, relative to the full-height screen.
const maxZoom = 2.0;

/// The shortest time a callout stays readable.
const minCallout = 1.6;

const _canvas = Rect.fromLTWH(0, 0, 1920, 1080);
const _calloutGap = 40.0;
const _calloutHeight = 76.0;
const _calloutFade = 0.3;

final _calloutStyle = TextStyle(
  fontFamily: 'Plus Jakarta Sans',
  fontSize: 30,
  fontWeight: FontWeight.w600,
  height: 1.2,
  color: PinneColors.text,
  letterSpacing: -0.2,
);

/// Where the screen sits: app point [focus] drawn at canvas point [at],
/// magnified [zoom] times beyond the full-height screen.
class Shot {
  const Shot(this.focus, this.at, this.zoom);

  /// The whole screen at full height, centred on canvas x [x].
  Shot.home([double x = 960])
    : focus = const Offset(206, 446),
      at = Offset(x, 540),
      zoom = 1;

  final Offset focus;
  final Offset at;
  final double zoom;

  double get scale => baseScale * zoom;

  Offset toCanvas(Offset app) => at + (app - focus) * scale;

  Rect toCanvasRect(Rect app) =>
      Rect.fromPoints(toCanvas(app.topLeft), toCanvas(app.bottomRight));

  Offset toApp(Offset canvas) => focus + (canvas - at) / scale;

  Shot moved(Offset by) => Shot(focus, at + by, zoom);

  static Shot lerp(Shot a, Shot b, double p) => Shot(
    Offset.lerp(a.focus, b.focus, p)!,
    Offset.lerp(a.at, b.at, p)!,
    a.zoom * math.pow(b.zoom / a.zoom, p),
  );
}

class _Move {
  _Move(this.from, this.to, this.start, this.seconds);
  final Shot from;
  final Shot to;
  final double start;
  final double seconds;

  Shot at(double t) => Shot.lerp(
    from,
    to,
    Curves.easeInOutCubic.transform(((t - start) / seconds).clamp(0, 1)),
  );
}

/// Eased moves between shots, in scene time. No spins, no cuts.
class Camera {
  Camera([Shot? home]) : home = home ?? Shot.home();

  final Shot home;
  final _moves = <_Move>[];

  Shot at(double t) {
    var shot = home;
    for (final move in _moves) {
      if (t < move.start) break;
      shot = move.at(t);
    }
    return shot;
  }

  void move(Shot to, {required double start, double seconds = 0.9}) {
    if (to.zoom > maxZoom + 1e-9) {
      throw StateError('zoom ${to.zoom} is past the ${maxZoom}x limit');
    }
    if (_moves.isNotEmpty && start < _moves.last.start) {
      throw StateError('camera moves must be in time order');
    }
    _moves.add(_Move(at(start), to, start, seconds));
  }
}

/// The cursor, kept in app coordinates so it rides with the screen when
/// the camera moves, exactly like a cursor in a screen recording.
class Cursor {
  Offset app = const Offset(460, 820);
  double shownAt = 1e9;
  double hiddenAt = 1e9;
  final clicks = <(double, Offset)>[];
}

enum Side { left, right }

/// One callout: a single line beside its target, never over it.
class Callout {
  Callout(this.text, this.target, this.app, this.side, this.start, this.end);

  final String text;
  final Finder? target;
  Rect app;
  final Side side;
  final double start;
  double end;
  final key = GlobalKey();

  double get width => calloutWidth(text);
}

double calloutWidth(String text) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: _calloutStyle),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout();
  final width = painter.width + 2 * 28 + 22;
  painter.dispose();
  return width;
}

/// The tour state of one scene, read by the stage's layers.
class Guide {
  Guide(this.film, [Shot? home]) : camera = Camera(home);

  final Film film;
  final Camera camera;
  final cursor = Cursor();
  final callouts = <Callout>[];
  final screenKey = GlobalKey();
  final steps = <Map<String, Object?>>[];

  WidgetTester get tester => film.tester;
  double get t => film.t;

  /// The rect of [finder] in app pixels, read from the live widget tree.
  Rect appRect(Finder finder) {
    final global = tester.getRect(finder.first);
    final box = screenKey.currentContext!.findRenderObject()! as RenderBox;
    return Rect.fromPoints(
      box.globalToLocal(global.topLeft),
      box.globalToLocal(global.bottomRight),
    );
  }

  /// A shot that shows [app] magnified [zoom] times with room beside it for
  /// a callout of [width] on [side], keeping the canvas covered top to
  /// bottom.
  Shot frame(
    Rect app, {
    required double zoom,
    required Side side,
    required double width,
    Offset? focus,
  }) {
    final scale = baseScale * zoom;
    final w = app.width * scale;
    final room = _calloutGap + width + 72;
    final f = focus ?? app.center;
    final double x = side == Side.right
        ? math.min(1240.0, 1920 - room) - w / 2 - (app.center.dx - f.dx) * scale
        : math.max(680.0, room) + w / 2 - (app.center.dx - f.dx) * scale;
    final top = f.dy * scale;
    final bottom = 1080 - (appScreen.height - f.dy) * scale;
    final y = zoom >= 1 ? 540.0.clamp(bottom, top) : 540.0;
    return Shot(f, Offset(x, y), zoom);
  }

  Callout? get current => callouts.isEmpty ? null : callouts.last;

  /// Shows [text] beside [target] from [start]; the previous callout must
  /// already have had its time and is faded out first.
  Callout say(
    String text,
    Finder? target,
    Rect app,
    Side side, {
    required double start,
    required double end,
  }) {
    final last = current;
    if (last != null && last.end + _calloutFade > start + 1e-6) {
      throw StateError(
        '"$text" at ${start.toStringAsFixed(2)} s would overlap "${last.text}"'
        ' (until ${last.end.toStringAsFixed(2)} s)',
      );
    }
    if (end - start < minCallout - 1e-6) {
      throw StateError('"$text" is shown only ${end - start} s');
    }
    final callout = Callout(text, target, app, side, start, end);
    callouts.add(callout);
    return callout;
  }

  /// Per frame: follow targets that move inside the app, and check that the
  /// visible callout sits on the canvas and off its target.
  void afterFrame() {
    final callout = current;
    if (callout == null || t < callout.start || t > callout.end) return;
    final target = callout.target;
    if (target != null && target.evaluate().isNotEmpty) {
      final now = appRect(target);
      final moved = (now.center - callout.app.center).distance > 1.5;
      callout.app = now;
      // Drawn this frame at the old place; check once it has caught up.
      if (moved) return;
    }
    final context = callout.key.currentContext;
    if (context == null || t < callout.start + 0.5) return;
    final box = context.findRenderObject()! as RenderBox;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    final over = camera.at(t).toCanvasRect(callout.app);
    if (!_canvas.deflate(16).contains(rect.topLeft) ||
        !_canvas.deflate(16).contains(rect.bottomRight)) {
      throw StateError('callout "${callout.text}" leaves the canvas: $rect');
    }
    if (rect.overlaps(over.inflate(6))) {
      throw StateError(
        'callout "${callout.text}" covers its target: $rect over $over',
      );
    }
  }

  /// Moves the camera to [target], glides the cursor onto its centre and
  /// shows [text] beside it; with [click], presses there. Returns when the
  /// cursor has landed (and clicked).
  Future<void> step(
    Finder target,
    String text, {
    bool click = true,
    double zoom = 1.6,
    Side? side,
    double move = 0.9,
    double glide = 0.85,
    double? hold,
    Offset? focus,
    Offset offset = Offset.zero,
    bool camera = true,
  }) async {
    await _afterLast();
    final start = t;
    final app = appRect(target);
    final s =
        side ?? (app.center.dx > appScreen.width / 2 ? Side.right : Side.left);
    final width = calloutWidth(text);
    final shot = camera
        ? frame(app, zoom: zoom, side: s, width: width, focus: focus)
        : this.camera.at(start);
    if (camera) this.camera.move(shot, start: start, seconds: move);
    final landAt = start + 0.15 + glide;
    final shown = start + 0.35;
    say(
      text,
      target,
      app,
      s,
      start: shown,
      end: math.max(shown + (hold ?? 1.7), landAt + (click ? 0.9 : 0.6)),
    );
    final room = s == Side.right
        ? 1920 - 24 - (shot.toCanvasRect(app).right + _calloutGap)
        : shot.toCanvasRect(app).left - _calloutGap - 24;
    if (room < width) {
      throw StateError('no room for "$text": $room px < $width px');
    }
    await glideTo(target, start: start + 0.15, seconds: glide, offset: offset);
    await land(target, text, click: click, offset: offset);
  }

  /// Shows a callout beside [target] without moving the cursor or camera.
  Future<void> note(
    Finder target,
    String text, {
    double seconds = 1.8,
    Side? side,
  }) async {
    await _afterLast();
    final app = appRect(target);
    final s =
        side ?? (app.center.dx > appScreen.width / 2 ? Side.right : Side.left);
    say(text, target, app, s, start: t, end: t + seconds);
    _log('note', target, app, null, text);
  }

  /// Waits until the previous callout has had its time and faded, less the
  /// moment a step takes before its callout appears.
  Future<void> _afterLast() async {
    final last = current;
    if (last != null) await film.until(last.end + _calloutFade + 0.02 - 0.35);
  }

  /// Films until [finder] is on screen, as when an answer arrives.
  Future<void> waitFor(Finder finder, {double seconds = 4}) async {
    final end = t + seconds;
    while (finder.evaluate().isEmpty) {
      if (t > end) throw StateError('$finder never appeared');
      await film.step();
    }
  }

  /// Eases the camera back to the whole screen.
  void home({double seconds = 0.9, double x = 960}) =>
      camera.move(Shot.home(x), start: t, seconds: seconds);

  Future<void> glideTo(
    Finder target, {
    required double start,
    double seconds = 0.85,
    Offset offset = Offset.zero,
  }) async {
    await film.until(start);
    if (cursor.shownAt > t) {
      cursor.shownAt = t;
      // Enter from the lower right of the canvas.
      cursor.app = camera.at(t).toApp(const Offset(1760, 980));
    }
    final from = cursor.app;
    final begin = t;
    while (t < begin + seconds - 1e-6) {
      final p = Curves.easeInOutCubic.transform(
        ((t - begin + 1 / Film.fps) / seconds).clamp(0, 1),
      );
      final to = appRect(target).center + offset;
      final straight = Offset.lerp(from, to, p)!;
      // A slight arc, as a hand moves a mouse.
      final d = to - from;
      final normal = d.distance == 0
          ? Offset.zero
          : Offset(-d.dy, d.dx) / d.distance;
      cursor.app =
          straight + normal * (math.sin(math.pi * p) * d.distance * 0.08);
      await film.step();
    }
    cursor.app = appRect(target).center + offset;
  }

  /// Checks the landing against the live widget tree, then clicks.
  Future<void> land(
    Finder target,
    String text, {
    bool click = true,
    Offset offset = Offset.zero,
  }) async {
    final rect = tester.getRect(target.first);
    final point = camera.at(t).toCanvas(cursor.app);
    if (!rect.contains(point)) {
      throw StateError('cursor $point is not on $target at $rect');
    }
    if (!_canvas.contains(rect.topLeft) ||
        !_canvas.contains(rect.bottomRight)) {
      throw StateError('$target is not fully on the canvas: $rect');
    }
    _log(click ? 'click' : 'point', target, appRect(target), point, text);
    if (!click) return;
    cursor.clicks.add((t, cursor.app));
    final gesture = await tester.startGesture(point);
    await film.hold(0.18);
    await gesture.up();
  }

  /// Presses at [target] and drags by [by] app pixels, as a scroll or a
  /// flick. With [shot], the camera eases there first.
  Future<void> drag(
    Finder target,
    Offset by, {
    double seconds = 0.8,
    Curve curve = Curves.easeInOutCubic,
    Offset offset = Offset.zero,
    Shot? shot,
  }) async {
    // A drag changes what the visible callout points at; let it finish.
    final last = current;
    if (last != null) await film.until(last.end + _calloutFade);
    if (shot != null) camera.move(shot, start: t, seconds: 0.7);
    await glideTo(
      target,
      start: t,
      seconds: shot == null ? 0.6 : 0.8,
      offset: offset,
    );
    final from = camera.at(t).toCanvas(cursor.app);
    final anchor = cursor.app;
    final startRect = appRect(target);
    final scale = camera.at(t).scale;
    if (!tester.getRect(target.first).contains(from)) {
      throw StateError('drag does not start on $target');
    }
    final gesture = await tester.startGesture(from);
    cursor.clicks.add((t, cursor.app));
    await film.hold(0.12);
    final start = t;
    var moved = Offset.zero;
    while (t < start + seconds - 1e-6) {
      final p = curve.transform(
        ((t - start + 1 / Film.fps) / seconds).clamp(0, 1),
      );
      final next = by * scale * p;
      await gesture.moveBy(next - moved);
      moved = next;
      cursor.app = anchor + moved / scale;
      await film.step();
    }
    await gesture.up();
    _log('drag', target, startRect, from, null, by: by);
  }

  void _log(
    String kind,
    Finder target,
    Rect app,
    Offset? cursorAt,
    String? text, {
    Offset? by,
  }) {
    double r(double v) => (v * 10).roundToDouble() / 10;
    steps.add({
      'scene': film.name,
      't': (t * 100).roundToDouble() / 100,
      'kind': kind,
      'target': describe(target),
      'app_rect': [r(app.left), r(app.top), r(app.width), r(app.height)],
      'zoom': (camera.at(t).zoom * 100).roundToDouble() / 100,
      'cursor': cursorAt == null ? null : [r(cursorAt.dx), r(cursorAt.dy)],
      'drag': by == null ? null : [r(by.dx), r(by.dy)],
      'callout': text,
    });
  }

  void write() {
    if (FilmPaths.out.isEmpty) return;
    final dir = Directory('${FilmPaths.out}/coords')
      ..createSync(recursive: true);
    File('${dir.path}/${film.name}.json').writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert({
        'scene': film.name,
        'seconds': ((film.core ?? t) * 100).roundToDouble() / 100,
        'callouts': [
          for (final c in callouts)
            {
              'text': c.text,
              'start': (c.start * 100).roundToDouble() / 100,
              'end': (math.min(c.end, t) * 100).roundToDouble() / 100,
            },
        ],
        'steps': steps,
      }),
    );
  }
}

/// A finder in words, for the coordinate list.
String describe(Finder finder) {
  final d = finder.describeMatch(Plurality.one);
  return d
      .replaceAll(RegExp(r"^(A|The) widget with "), '')
      .replaceAll(RegExp(r'^widget with '), '')
      .replaceAll("[<'", "'")
      .replaceAll("'>]", "'");
}

// ------------------------------------------------------------ Drawing

/// The real app screen, no device around it, placed by the camera.
class ScreenRig extends StatelessWidget {
  const ScreenRig({super.key, required this.screen});

  final Widget screen;

  @override
  Widget build(BuildContext context) {
    final guide = FilmScope.of(context).guide!;
    return AtTime(
      child: AppScreen(key: guide.screenKey, child: screen),
      builder: (context, t, child) {
        final shot = guide.camera.at(t);
        final topLeft = shot.toCanvas(Offset.zero);
        final scale = shot.scale;
        final radius = BorderRadius.circular(30 * scale);
        return Stack(
          children: [
            Positioned(
              left: topLeft.dx,
              top: topLeft.dy,
              width: appScreen.width * scale,
              height: appScreen.height * scale,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x88000000),
                      blurRadius: 70,
                      offset: Offset(0, 24),
                    ),
                    BoxShadow(
                      color: Color(0x332A1B5A),
                      blurRadius: 120,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: FittedBox(fit: BoxFit.fill, child: child),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The app at its phone size, with the phone's status and gesture bars.
class AppScreen extends StatelessWidget {
  const AppScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: appScreen,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: MediaQuery(
        data: const MediaQueryData(
          size: appScreen,
          devicePixelRatio: 2.625,
          padding: EdgeInsets.only(top: 34, bottom: 18),
          viewPadding: EdgeInsets.only(top: 34, bottom: 18),
          platformBrightness: Brightness.dark,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: PinneColors.midnight),
            child,
            const _StatusBar(),
            const _GestureBar(),
          ],
        ),
      ),
    ),
  );
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 34,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            children: [
              Text(
                '10:24',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: PinneColors.text,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.signal_cellular_alt_rounded,
                size: 15,
                color: PinneColors.text,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.wifi_rounded, size: 15, color: PinneColors.text),
              const SizedBox(width: 4),
              const Icon(
                Icons.battery_5_bar_rounded,
                size: 15,
                color: PinneColors.text,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _GestureBar extends StatelessWidget {
  const _GestureBar();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Container(
          width: 112,
          height: 4.5,
          decoration: BoxDecoration(
            color: PinneColors.text.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    ),
  );
}

/// The visible callout: rises in beside its target with a short connector.
class CalloutLayer extends StatelessWidget {
  const CalloutLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final guide = FilmScope.of(context).guide!;
    return IgnorePointer(
      child: AtTime(
        builder: (context, t, _) {
          final c = guide.current;
          if (c == null || t < c.start || t > c.end + _calloutFade) {
            return const SizedBox.shrink();
          }
          final inP = ramp(t, c.start, 0.45);
          final outP = ramp(t, c.end, _calloutFade, Curves.easeInCubic);
          final o = inP * (1 - outP);
          final target = guide.camera.at(t).toCanvasRect(c.app);
          final cy = target.center.dy.clamp(80.0, 1000.0);
          final width = c.width;
          final left = c.side == Side.right
              ? target.right + _calloutGap
              : target.left - _calloutGap - width;
          final edge = c.side == Side.right ? left : left + width;
          final dot = Offset(
            c.side == Side.right ? target.right + 14 : target.left - 14,
            target.center.dy.clamp(target.top + 8, target.bottom - 8),
          );
          return Opacity(
            opacity: o.clamp(0, 1),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _Connector(dot, Offset(edge, cy), inP),
                  ),
                ),
                Positioned(
                  left: left,
                  top: cy - _calloutHeight / 2 + (1 - inP) * 20,
                  width: width,
                  height: _calloutHeight,
                  child: Transform.scale(
                    scale: 0.96 + 0.04 * inP,
                    child: _CalloutCard(key: c.key, text: c.text),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CalloutCard extends StatelessWidget {
  const _CalloutCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xF2201A33),
      borderRadius: BorderRadius.circular(_calloutHeight / 2),
      border: Border.all(
        color: PinneColors.lilac.withValues(alpha: 0.55),
        width: 1.5,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x99000000),
          blurRadius: 30,
          offset: Offset(0, 12),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: PinneColors.violet,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(text, maxLines: 1, softWrap: false, style: _calloutStyle),
        ],
      ),
    ),
  );
}

class _Connector extends CustomPainter {
  _Connector(this.dot, this.edge, this.p);
  final Offset dot;
  final Offset edge;
  final double p;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = PinneColors.lilac.withValues(alpha: 0.8)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(edge, Offset.lerp(edge, dot, p)!, line);
    canvas.drawCircle(dot, 6 * p, Paint()..color = PinneColors.lilac);
    canvas.drawCircle(
      dot,
      11 * p,
      Paint()
        ..color = PinneColors.lilac.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_Connector old) =>
      old.dot != dot || old.edge != edge || old.p != p;
}

/// The cursor and its click ripples.
class CursorLayer extends StatelessWidget {
  const CursorLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final guide = FilmScope.of(context).guide!;
    return IgnorePointer(
      child: AtTime(
        builder: (context, t, _) {
          final cursor = guide.cursor;
          final o =
              ramp(t, cursor.shownAt, 0.3) *
              (1 - ramp(t, cursor.hiddenAt, 0.3));
          if (o <= 0) return const SizedBox.shrink();
          final shot = guide.camera.at(t);
          final at = shot.toCanvas(cursor.app);
          var press = 1.0;
          final ripples = <Widget>[];
          for (final (time, app) in cursor.clicks) {
            final age = t - time;
            if (age < 0 || age > 0.7) continue;
            if (age < 0.22) press = 1 - 0.14 * math.sin(math.pi * age / 0.22);
            final p = Curves.easeOutCubic.transform(age / 0.7);
            final c = shot.toCanvas(app);
            final r = 12 + 46 * p;
            ripples.add(
              Positioned(
                left: c.dx - r,
                top: c.dy - r,
                width: r * 2,
                height: r * 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PinneColors.violet.withValues(alpha: 0.28 * (1 - p)),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9 * (1 - p)),
                      width: 3,
                    ),
                  ),
                ),
              ),
            );
          }
          return Opacity(
            opacity: o,
            child: Stack(
              children: [
                ...ripples,
                Positioned(
                  left: at.dx,
                  top: at.dy,
                  width: 46,
                  height: 56,
                  child: Transform.scale(
                    scale: press,
                    alignment: Alignment.topLeft,
                    child: const CustomPaint(painter: _Arrow()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A plain arrow pointer whose tip is the click point.
class _Arrow extends CustomPainter {
  const _Arrow();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, 40)
      ..lineTo(10, 30.5)
      ..lineTo(17.5, 47)
      ..lineTo(25, 43.5)
      ..lineTo(17.5, 27.5)
      ..lineTo(31, 27.5)
      ..close();
    canvas.drawShadow(path, const Color(0xFF000000), 6, false);
    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawPath(
      path,
      Paint()
        ..color = PinneColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_Arrow old) => false;
}
