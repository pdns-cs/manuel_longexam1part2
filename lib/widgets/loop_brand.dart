import 'package:flutter/material.dart';
import '../constants.dart';

/// The Loop wordmark + glyph. A simple interlocking-loop mark drawn with two
/// rounded rings, kept minimal and monochrome so it works on any surface.
class LoopLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showWordmark;

  const LoopLogo({
    super.key,
    this.size = 40,
    this.color,
    this.showWordmark = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? LOOP_ACCENT;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _LoopGlyphPainter(c)),
        ),
        if (showWordmark) ...[
          SizedBox(width: size * 0.28),
          Text(
            kAppName,
            style: TextStyle(
              fontFamily: 'Klavika',
              fontWeight: FontWeight.w700,
              fontSize: size * 0.7,
              letterSpacing: -1,
              color: color ?? LOOP_TEXT,
            ),
          ),
        ],
      ],
    );
  }
}

class _LoopGlyphPainter extends CustomPainter {
  final Color color;
  _LoopGlyphPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.16;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final r = size.width * 0.30;
    final cy = size.height / 2;
    canvas.drawCircle(Offset(size.width * 0.36, cy), r, paint);
    canvas.drawCircle(
      Offset(size.width * 0.64, cy),
      r,
      paint..color = color.withValues(alpha: 0.55),
    );
  }

  @override
  bool shouldRepaint(covariant _LoopGlyphPainter old) => old.color != color;
}

/// A pill-shaped chip used for stats and metadata.
class LoopChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  const LoopChip({super.key, required this.label, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? LOOP_MUTED;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: LOOP_SUBTLE,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: c),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c,
            ),
          ),
        ],
      ),
    );
  }
}
