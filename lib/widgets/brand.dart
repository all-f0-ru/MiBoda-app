import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text.dart';

/// Símbolo de MiBoda+: dos anillos entreabiertos rematados en gemas,
/// cuya unión en la base sugiere un corazón. Trazo fino, sin relleno.
class MiBodaSymbol extends StatelessWidget {
  const MiBodaSymbol({super.key, this.size = 48, this.color = AppColors.brass, this.strokeWidth});

  final double size;
  final Color color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _SymbolPainter(color, strokeWidth ?? (size >= 64 ? 1.4 : 1.8))),
      ),
    );
  }
}

class _SymbolPainter extends CustomPainter {
  _SymbolPainter(this.color, this.stroke);

  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // El diseño está en una grilla de 48×48.
    final s = size.width / 48;
    canvas.scale(s);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final left = Path()
      ..moveTo(24, 44)
      ..cubicTo(11, 36, 5.5, 24, 14, 12.5);
    final right = Path()
      ..moveTo(24, 44)
      ..cubicTo(37, 36, 42.5, 24, 34, 12.5);
    Path gem(double cx) => Path()
      ..moveTo(cx, 4.5)
      ..lineTo(cx + 3.2, 8.5)
      ..lineTo(cx, 12.5)
      ..lineTo(cx - 3.2, 8.5)
      ..close();

    canvas
      ..drawPath(left, paint)
      ..drawPath(right, paint)
      ..drawPath(gem(14), paint)
      ..drawPath(gem(34), paint);
  }

  @override
  bool shouldRepaint(covariant _SymbolPainter old) => old.color != color || old.stroke != stroke;
}

/// "MiBoda" en tinta y el "+" siempre en dorado.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = style ?? AppText.display;
    return Text.rich(
      TextSpan(children: [
        TextSpan(text: 'MiBoda', style: base),
        TextSpan(text: '+', style: base.copyWith(color: AppColors.brass)),
      ]),
      semanticsLabel: 'MiBoda+',
    );
  }
}

/// Logo horizontal pequeño (símbolo + wordmark).
class LogoInline extends StatelessWidget {
  const LogoInline({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MiBodaSymbol(size: 28),
        const SizedBox(width: 8),
        Wordmark(style: AppText.headingM),
      ],
    );
  }
}
