import 'dart:io';

import 'package:image/image.dart' as image;

const _size = 1024;
final _background = image.ColorRgba8(21, 15, 38, 255);
final _transparent = image.ColorRgba8(0, 0, 0, 0);

void main() {
  final source = image.decodeWebP(
    File('assets/art/cutout/ribbon_spirit_master.webp').readAsBytesSync(),
  );
  if (source == null) {
    stderr.writeln('Could not decode the Ribbon Spirit master art.');
    exitCode = 1;
    return;
  }

  final output = Directory('assets/branding')..createSync(recursive: true);
  final foreground = _placeOnSquare(source, height: 700);
  final icon = image.Image(width: _size, height: _size, numChannels: 4);
  image.fill(icon, color: _background);
  image.compositeImage(icon, foreground);

  final splash = _placeOnSquare(source, height: 610);
  File('${output.path}/pinne_icon.png').writeAsBytesSync(
    image.encodePng(icon),
  );
  File('${output.path}/pinne_icon_foreground.png').writeAsBytesSync(
    image.encodePng(foreground),
  );
  File('${output.path}/pinne_splash.png').writeAsBytesSync(
    image.encodePng(splash),
  );
}

image.Image _placeOnSquare(image.Image source, {required int height}) {
  final mark = image.copyResize(
    source,
    height: height,
    interpolation: image.Interpolation.cubic,
  );
  final canvas = image.Image(width: _size, height: _size, numChannels: 4);
  image.fill(canvas, color: _transparent);
  image.compositeImage(
    canvas,
    mark,
    dstX: (_size - mark.width) ~/ 2,
    dstY: (_size - mark.height) ~/ 2,
  );
  return canvas;
}
