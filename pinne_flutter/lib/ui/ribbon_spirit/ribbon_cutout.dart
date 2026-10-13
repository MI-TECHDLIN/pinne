import 'package:flutter/material.dart';

import '../../theme/pinne_tokens.dart';

/// A pre-rendered Ribbon Spirit cut-out with a light-theme backing plate.
///
/// The cut-outs were keyed for Pinne's midnight background. The lilac plate
/// keeps their dark edge pixels intentional on Lavender Mist while returning
/// the original image directly in dark mode so existing artwork is unchanged.
class RibbonSpiritCutout extends StatelessWidget {
  const RibbonSpiritCutout({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String? semanticLabel;
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
    );
    if (Theme.of(context).brightness == Brightness.dark) return image;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.pinne.spiritPlate,
        borderRadius: BorderRadius.circular(PinneRadii.card),
        boxShadow: [
          BoxShadow(
            color: context.pinne.shadow,
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: image,
    );
  }
}
