import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pinne_flutter/theme/pinne_tokens.dart';
import 'package:pinne_flutter/ui/ribbon_spirit/ribbon_spirit.dart';

import 'director.dart';
import 'paths.dart';
import 'stage.dart';

/// Stylised title cards and props drawn for the film. None of this is app
/// UI; the README lists which shots are cards and which are app renders.

/// The FLUX Ribbon Spirit art from pinne_flutter/assets/art/cutout.
FileImage spiritArt(String mood) => FileImage(
  File('${FilmPaths.app}/assets/art/cutout/ribbon_spirit_$mood.webp'),
);

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.radius = 30,
    this.tint = PinneColors.glass,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color tint;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: const Color(0x26FFFFFF), width: 1.5),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0x1FFFFFFF), Color(0x08FFFFFF)],
          ),
        ),
        child: child,
      ),
    ),
  );
}

Widget fadeRise(
  double t,
  double at,
  Widget child, {
  double dy = 30,
  double span = 0.6,
}) {
  final p = ramp(t, at, span);
  return Opacity(
    opacity: p,
    child: Transform.translate(offset: Offset(0, (1 - p) * dy), child: child),
  );
}

// ---------------------------------------------------------------- Hook

const _contentIcons = [
  Icons.play_arrow_rounded,
  Icons.chat_bubble_rounded,
  Icons.article_rounded,
  Icons.image_rounded,
  Icons.link_rounded,
  Icons.bookmark_rounded,
  Icons.mic_rounded,
  Icons.photo_camera_rounded,
];

class _Tile {
  _Tile(this.icon, this.color, this.rest, this.spin, this.drop, this.size);
  final IconData icon;
  final Color color;
  final Offset rest;
  final double spin;
  final double drop;
  final double size;
}

List<_Tile> _heap() {
  final rnd = math.Random(11);
  final tiles = <_Tile>[];
  const rows = [12, 11, 9, 7, 4];
  var i = 0;
  for (var r = 0; r < rows.length; r++) {
    final n = rows[r];
    final width = n * 132.0;
    for (var k = 0; k < n; k++) {
      final x = 960 - width / 2 + k * 132 + 66 + rnd.nextDouble() * 30 - 15;
      final y = 1030 - r * 104 - rnd.nextDouble() * 14;
      tiles.add(
        _Tile(
          _contentIcons[(i * 5 + r) % _contentIcons.length],
          PinneColors.tilePalette[(i * 3 + k) % PinneColors.tilePalette.length],
          Offset(x, y),
          (rnd.nextDouble() - 0.5) * 0.7,
          0.15 + (r * 0.55) + rnd.nextDouble() * 0.5,
          104 + rnd.nextDouble() * 18,
        ),
      );
      i++;
    }
  }
  return tiles;
}

/// Saves pile up, then the Ribbon Spirit and the name. The app screen with
/// the real onboarding is the scene's own [Stage.screen].
class HookCard extends StatelessWidget {
  HookCard({super.key});

  final _tiles = _heap();

  @override
  Widget build(BuildContext context) => AtTime(
    builder: (context, t, _) {
      final away = ramp(t, 9.1, 1.0, Curves.easeInOutCubic);
      final heap = Stack(
        children: [
          for (final tile in _tiles)
            if (t > tile.drop) _tile(tile, t - tile.drop),
        ],
      );
      return Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 1 - away,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(
                sigmaX: 0.01 + away * 16,
                sigmaY: 0.01 + away * 16,
              ),
              child: Transform.translate(
                offset: Offset(0, away * 140),
                child: heap,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 150,
            child: Opacity(
              opacity: 1 - ramp(t, 9.0, 0.5),
              child: Column(
                children: [
                  fadeRise(
                    t,
                    0.35,
                    Text('You save everything.', style: Words.title(88)),
                  ),
                  const SizedBox(height: 14),
                  fadeRise(
                    t,
                    6.9,
                    Text(
                      'And never come back to it.',
                      style: Words.light(88).copyWith(color: PinneColors.lilac),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (t > 9.6) _reveal(t),
        ],
      );
    },
  );

  Widget _tile(_Tile tile, double age) {
    const fall = 0.75;
    final p = (age / fall).clamp(0.0, 1.0);
    final y = ui.lerpDouble(-160, tile.rest.dy, Curves.bounceOut.transform(p))!;
    final angle = tile.spin * (0.4 + 0.6 * p) + (1 - p) * 0.8;
    return Positioned(
      left: tile.rest.dx - tile.size / 2,
      top: y - tile.size / 2,
      width: tile.size,
      height: tile.size,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          decoration: BoxDecoration(
            color: Color.lerp(PinneColors.card, tile.color, 0.18),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: tile.color.withValues(alpha: 0.55),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Icon(tile.icon, color: tile.color, size: tile.size * 0.5),
        ),
      ),
    );
  }

  /// The name and the Ribbon Spirit on the left, beside the app screen
  /// that rises in with the real onboarding. They make way for the tour.
  Widget _reveal(double t) =>
      Opacity(opacity: 1 - ramp(t, 12.9, 0.5), child: _brand(t));

  Widget _brand(double t) {
    const x = 510.0;
    final p = ramp(t, 9.8, 1.1, Curves.easeOutBack);
    final glow = ramp(t, 9.7, 1.4);
    final float = math.sin((t - 9.7) * 1.6) * 8;
    return Stack(
      children: [
        Positioned(
          left: x - 480,
          top: 330 - 480,
          width: 960,
          height: 960,
          child: Opacity(
            opacity: glow,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0x887C5CFF), Color(0x00000000)],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: x - 160,
          top: 110 + float,
          width: 320,
          height: 400,
          child: Opacity(
            opacity: ramp(t, 9.8, 0.5),
            child: Transform.scale(
              scale: 0.6 + 0.4 * p,
              child: Image(image: spiritArt('welcome'), fit: BoxFit.contain),
            ),
          ),
        ),
        Positioned(
          left: x - 450,
          width: 900,
          top: 560,
          child: Column(
            children: [
              fadeRise(
                t,
                10.3,
                Text(
                  'Pinne',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 140,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -4,
                    height: 1,
                    color: PinneColors.text,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              fadeRise(
                t,
                11.1,
                Text(
                  'Save it. Come back to it.',
                  style: Words.light(54).copyWith(color: PinneColors.lilac),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------- Serverpod card

class _Row {
  const _Row(this.icon, this.title, this.detail);
  final IconData icon;
  final String title;
  final String detail;
}

// In the order the narration names them.
const _serverRows = [
  _Row(
    Icons.code_rounded,
    'A typed Dart backend',
    'Models in .spy.yaml; the client the app calls is generated from them.',
  ),
  _Row(
    Icons.storage_rounded,
    'PostgreSQL with migrations',
    'Items, reviews, plans and progress. Migrations checked in.',
  ),
  _Row(
    Icons.lock_person_rounded,
    'Owner-scoped endpoints',
    'Owner from the session, never the client. Only ever your own data.',
  ),
  _Row(
    Icons.bolt_rounded,
    'An AI pipeline that never makes you wait',
    'Saves land on the phone first. Organizing runs as the outbox syncs and '
        'falls back to rules if the AI fails.',
  ),
  _Row(
    Icons.person_rounded,
    'Sign-in with Serverpod auth',
    'Try it as a guest, or keep an email account.',
  ),
];

/// When each server row appears, in step with the narration.
const _rowTimes = [3.5, 5.1, 8.0, 11.0, 12.6];

class ServerpodCard extends StatelessWidget {
  const ServerpodCard({super.key});

  @override
  Widget build(BuildContext context) => AtTime(
    builder: (context, t, _) => Stack(
      children: [
        Positioned(
          left: 130,
          top: 84,
          right: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fadeRise(
                t,
                0.2,
                Text('BUILT ON SERVERPOD 4', style: Words.kicker()),
              ),
              const SizedBox(height: 16),
              fadeRise(
                t,
                0.3,
                Text('Serverpod does the real work.', style: Words.title(64)),
              ),
            ],
          ),
        ),
        // Connectors behind the boxes.
        Positioned.fill(child: CustomPaint(painter: _Wires(t))),
        Positioned(
          left: 130,
          top: 330,
          width: 330,
          child: fadeRise(
            t,
            0.8,
            _SideBox(
              icon: Icons.smartphone_rounded,
              title: 'Flutter app',
              lines: const [
                'Riverpod and go_router',
                'Saves to a local SQLite outbox first',
                'Reads phone calendars on the device',
              ],
              color: PinneColors.sky,
            ),
          ),
        ),
        Positioned(
          left: 560,
          top: 270,
          width: 800,
          child: fadeRise(t, 1.2, _ServerBox(t: t)),
        ),
        Positioned(
          left: 1460,
          top: 330,
          width: 330,
          child: fadeRise(
            t,
            5.1,
            _SideBox(
              icon: Icons.dns_rounded,
              title: 'PostgreSQL',
              lines: const [
                'Every owned row filtered by owner',
                'Managed by Serverpod Cloud',
              ],
              color: PinneColors.mint,
            ),
          ),
        ),
        Positioned(
          left: 130,
          top: 870,
          right: 130,
          child: fadeRise(
            t,
            13.7,
            Row(
              children: [
                const Icon(
                  Icons.cloud_done_rounded,
                  color: PinneColors.lilac,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Text(
                  'Running on Serverpod Cloud',
                  style: Words.title(40).copyWith(color: PinneColors.text),
                ),
                const SizedBox(width: 22),
                Flexible(
                  child: Text(
                    'Managed PostgreSQL, migrations applied on every deploy.',
                    style: Words.body(24).copyWith(color: PinneColors.lilac),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 1460,
          top: 650,
          width: 330,
          child: fadeRise(
            t,
            11.0,
            _SideBox(
              icon: Icons.auto_awesome_rounded,
              title: 'Groq (gpt-oss-20b)',
              lines: const [
                'Strict JSON, validated',
                'Rules if it is down',
                'Opt-out in Settings',
              ],
              color: PinneColors.pink,
            ),
          ),
        ),
      ],
    ),
  );
}

class _Wires extends CustomPainter {
  _Wires(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    void wire(Offset a, Offset b, double at, Color color, String? label) {
      final p = ramp(t, at, 0.7, Curves.easeInOutCubic);
      if (p <= 0) return;
      final end = Offset.lerp(a, b, p)!;
      final paint = Paint()
        ..color = color.withValues(alpha: 0.75)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(a, end, paint);
      // A packet travelling the wire, so it reads as live traffic.
      if (p >= 1) {
        final q = ((t - at) * 0.6) % 1;
        canvas.drawCircle(Offset.lerp(a, b, q)!, 6, Paint()..color = color);
      }
    }

    wire(
      const Offset(460, 470),
      const Offset(560, 470),
      1.6,
      PinneColors.sky,
      null,
    );
    wire(
      const Offset(1360, 450),
      const Offset(1460, 450),
      5.5,
      PinneColors.mint,
      null,
    );
    wire(
      const Offset(1360, 760),
      const Offset(1460, 760),
      11.4,
      PinneColors.pink,
      null,
    );
  }

  @override
  bool shouldRepaint(_Wires old) => old.t != t;
}

class _SideBox extends StatelessWidget {
  const _SideBox({
    required this.icon,
    required this.title,
    required this.lines,
    required this.color,
  });

  final IconData icon;
  final String title;
  final List<String> lines;
  final Color color;

  @override
  Widget build(BuildContext context) => GlassPanel(
    padding: const EdgeInsets.fromLTRB(26, 24, 26, 26),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: PinneColors.ink, size: 27),
            ),
            const SizedBox(width: 14),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(title, style: Words.title(32)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final line in lines)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(line, style: Words.body(21).copyWith(height: 1.3)),
          ),
      ],
    ),
  );
}

class _ServerBox extends StatelessWidget {
  const _ServerBox({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) => GlassPanel(
    tint: const Color(0x337C5CFF),
    padding: const EdgeInsets.fromLTRB(34, 28, 34, 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Serverpod 4 server', style: Words.title(38)),
            const Spacer(),
            Text(
              'pinne_server',
              style: Words.body(20).copyWith(color: PinneColors.lilac),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final (i, row) in _serverRows.indexed)
          fadeRise(
            t,
            _rowTimes[i],
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: PinneColors.violet,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(row.icon, color: PinneColors.text, size: 24),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.title,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: PinneColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          row.detail,
                          style: Words.body(19).copyWith(height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            dy: 16,
          ),
      ],
    ),
  );
}

// ------------------------------------------------------------- Close

class CloseCard extends StatelessWidget {
  const CloseCard({super.key});

  @override
  Widget build(BuildContext context) => AtTime(
    builder: (context, t, _) {
      final float = math.sin(t * 1.5) * 9;
      return Stack(
        children: [
          Positioned(
            left: 960 - 560,
            top: 300 - 560,
            width: 1120,
            height: 1120,
            child: Opacity(
              opacity: ramp(t, 0, 1.2),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0x777C5CFF), Color(0x00000000)],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 960 - 170,
            top: 70 + float,
            width: 340,
            height: 420,
            child: Opacity(
              opacity: ramp(t, 0.1, 0.6),
              child: Transform.scale(
                scale: 0.75 + 0.25 * ramp(t, 0.1, 1.0, Curves.easeOutBack),
                child: Image(image: spiritArt('happy'), fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 520,
            child: Column(
              children: [
                fadeRise(
                  t,
                  0.6,
                  Text(
                    'Pinne',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 132,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -3.5,
                      height: 1,
                      color: PinneColors.text,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                fadeRise(
                  t,
                  1.1,
                  Text(
                    'Save it. Come back to it.',
                    style: Words.light(54).copyWith(color: PinneColors.lilac),
                  ),
                ),
                const SizedBox(height: 46),
                fadeRise(
                  t,
                  1.8,
                  GlassPanel(
                    radius: 99,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 34,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.code_rounded,
                          color: PinneColors.lilac,
                          size: 34,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'github.com/MI-TECHDLIN/pinne',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            color: PinneColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                fadeRise(
                  t,
                  2.3,
                  Text(
                    'Built with Serverpod 4 and Flutter',
                    style: Words.body(26),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

// ----------------------------------------------- Another app, for capture

/// A generic light reading app the link is shared from. Not Pinne, and not
/// any real app.
class SourceAppPage extends StatelessWidget {
  const SourceAppPage({super.key, required this.hero});

  final ImageProvider hero;

  @override
  Widget build(BuildContext context) {
    final ink = const Color(0xFF1E1A2B);
    final muted = const Color(0xFF6E6880);
    TextStyle s(double size, FontWeight w, Color c, [double h = 1.35]) =>
        TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: size,
          fontWeight: w,
          color: c,
          height: h,
        );
    return ColoredBox(
      color: const Color(0xFFF8F6F2),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 44, 18, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_back_rounded, color: ink, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECE8E1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'fieldnotes.example',
                          style: s(13, FontWeight.w600, muted),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.share_outlined,
                  key: const ValueKey('source-share'),
                  color: ink,
                  size: 22,
                ),
                const SizedBox(width: 6),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'FIELD NOTES · DESIGN',
              style: s(
                11,
                FontWeight.w800,
                const Color(0xFFB0563C),
              ).copyWith(letterSpacing: 1.4),
            ),
            const SizedBox(height: 10),
            Text(
              'Calm onboarding: 7 patterns that don’t nag',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: ink,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'By M. Okafor · 6 min read',
              style: s(13, FontWeight.w500, muted),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image(
                image: hero,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'The best first-run screens feel like a friend showing you '
              'around, not a checklist. Here are seven patterns that keep new '
              'people curious without a single nagging popup.',
              style: s(15.5, FontWeight.w500, ink, 1.55),
            ),
            const SizedBox(height: 14),
            Text(
              '1. Show one useful thing first. Let people reach a small win '
              'before you ask for anything.',
              style: s(15.5, FontWeight.w500, muted, 1.55),
            ),
          ],
        ),
      ),
    );
  }
}

/// A generic share chooser, as a phone shows when you tap Share.
class ShareChooser extends StatelessWidget {
  const ShareChooser({super.key, required this.progress});

  /// 0 hidden, 1 fully up.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final ink = const Color(0xFF1E1A2B);
    Widget target(String label, Widget icon, {Key? key}) => SizedBox(
      key: key,
      width: 78,
      child: Column(
        children: [
          SizedBox(width: 58, height: 58, child: icon),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: ink,
            ),
          ),
        ],
      ),
    );
    Widget round(IconData icon, Color color) => Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 28),
    );
    return Stack(
      children: [
        Positioned.fill(
          child: ColoredBox(color: Color.fromRGBO(0, 0, 0, 0.35 * progress)),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -260 * (1 - progress),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0x33000000),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Share',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    target(
                      'Pinne',
                      key: const ValueKey('chooser-pinne'),
                      Container(
                        decoration: const BoxDecoration(
                          color: PinneColors.midnight,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: RibbonSpirit(
                            seed: 2026,
                            palette: 0,
                            size: 46,
                            animate: false,
                            mood: RibbonMood.idle,
                          ),
                        ),
                      ),
                    ),
                    target(
                      'Messages',
                      round(Icons.chat_rounded, const Color(0xFF4C8DF6)),
                    ),
                    target(
                      'Notes',
                      round(
                        Icons.sticky_note_2_rounded,
                        const Color(0xFFE9A53A),
                      ),
                    ),
                    target(
                      'Copy link',
                      round(Icons.link_rounded, const Color(0xFF8A8597)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
