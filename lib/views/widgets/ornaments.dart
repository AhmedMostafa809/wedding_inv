import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/invitation_theme.dart';

/// Fine botanical linework drawn locally, with no image downloads.
class BotanicalSprig extends StatelessWidget {
  const BotanicalSprig({super.key, this.mirrored = false, this.size = 120});
  final bool mirrored;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Transform.flip(
        flipX: mirrored,
        child: CustomPaint(
          size: Size(size, size * 1.45),
          painter: const _SprigPainter(),
        ),
      ),
    );
  }
}

class _SprigPainter extends CustomPainter {
  const _SprigPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 145);
    final stroke = Paint()
      ..color = InvitationTheme.gold.withValues(alpha: .52)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .65;
    canvas.drawPath(
      Path()
        ..moveTo(18, 143)
        ..cubicTo(75, 100, 30, 47, 80, 5),
      stroke,
    );
    for (var i = 0; i < 9; i++) {
      final t = i / 9;
      final y = 127 - t * 111;
      final x = 36 + 14 * t + 10 * math.sin(t * 5);
      for (final side in [-1.0, 1.0]) {
        final end = Offset(x + side * (23 - t * 7), y - 22);
        final leaf = Path()
          ..moveTo(x, y)
          ..quadraticBezierTo(x + side * 30, y - 3, end.dx, end.dy)
          ..quadraticBezierTo(x + side * 2, y - 23, x, y);
        canvas.drawPath(
          leaf,
          Paint()..color = InvitationTheme.gold.withValues(alpha: .045),
        );
        canvas.drawPath(leaf, stroke);
        canvas.drawLine(Offset(x, y), end, stroke);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SprigPainter oldDelegate) => false;
}

class OrnamentDivider extends StatelessWidget {
  const OrnamentDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            child: Divider(color: InvitationTheme.line),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  border: Border.all(color: InvitationTheme.gold),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 48,
            child: Divider(color: InvitationTheme.line),
          ),
        ],
      ),
    );
  }
}

/// A quiet paper grain and a double ruled border.
class StationeryPainter extends CustomPainter {
  const StationeryPainter({this.arch = false});
  final bool arch;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(12);
    final grain = Paint()..color = InvitationTheme.gold.withValues(alpha: .06);
    for (var i = 0; i < size.width * size.height / 200; i++) {
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        .5,
        grain,
      );
    }
    final rule = Paint()
      ..color = InvitationTheme.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = .7;
    for (final inset in [12.0, 18.0]) {
      final rect = Rect.fromLTWH(
        inset,
        inset,
        size.width - inset * 2,
        size.height - inset * 2,
      );
      final radius = arch
          ? BorderRadius.vertical(top: Radius.circular(size.width / 2))
          : BorderRadius.circular(2);
      canvas.drawRRect(radius.toRRect(rect), rule);
    }
  }

  @override
  bool shouldRepaint(StationeryPainter oldDelegate) => oldDelegate.arch != arch;
}
