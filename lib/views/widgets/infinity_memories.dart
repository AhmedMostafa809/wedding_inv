import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Shared silhouette for the animated ornament and the launcher artwork.
Path infinityPath(Size size) {
  final path = Path();
  for (var i = 0; i <= 360; i++) {
    final t = i * math.pi / 180;
    final x = size.width * (.5 + .43 * math.cos(t));
    final y = size.height * (.5 + .34 * math.sin(2 * t));
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  return path..close();
}

class InfinityMemories extends StatefulWidget {
  const InfinityMemories({super.key});

  @override
  State<InfinityMemories> createState() => _InfinityMemoriesState();
}

class _InfinityMemoriesState extends State<InfinityMemories>
    with SingleTickerProviderStateMixin {
  late final _motion = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _motion.stop();
      _motion.value = 0;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'An infinity symbol. Our forever, together.',
    image: true,
    child: RepaintBoundary(
      child: SizedBox(
        key: const Key('infinity-memories'),
        height: 220,
        width: double.infinity,
        child: CustomPaint(painter: _InfinityPainter(_motion)),
      ),
    ),
  );
}

class _InfinityPainter extends CustomPainter {
  _InfinityPainter(this.motion) : super(repaint: motion);
  final Animation<double> motion;

  Offset _point(double t, double width) =>
      Offset(math.cos(t) * width * .37, math.sin(2 * t) * 52);

  Path _ribbon(double from, double to, double width, {double inset = 0}) {
    final outer = <Offset>[];
    final inner = <Offset>[];
    for (var i = 0; i <= 160; i++) {
      final t = from + (to - from) * i / 160;
      final point = _point(t, width);
      final tangent = Offset(-math.sin(t) * width * .37, 104 * math.cos(2 * t));
      final normal = Offset(-tangent.dy, tangent.dx) / tangent.distance;
      final thickness = (3.5 + 10 * math.pow(math.sin(t + .5), 2) - inset)
          .clamp(.5, 20.0);
      outer.add(point + normal * thickness);
      inner.add(point - normal * thickness);
    }
    return Path()..addPolygon([...outer, ...inner.reversed], true);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final phase = motion.value * math.pi * 2;
    final breath = math.sin(phase);
    canvas.save();
    // Keep both loops level throughout the animation: no rotation or skew.
    canvas.translate(size.width / 2, size.height / 2 + breath * 4);
    canvas.scale(1 + breath * .035);
    final ribbon = _ribbon(0, math.pi * 2, size.width);
    // A soft cast shadow lifts the silk-like black ribbon off the paper.
    canvas.save();
    canvas.translate(0, 12 - breath * 3);
    canvas.drawPath(
      ribbon,
      Paint()
        ..color = const Color(0x30000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    canvas.restore();

    final bounds = Rect.fromLTWH(-size.width / 2, -85, size.width, 170);
    final ink = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF060606),
          Color(0xFF393735),
          Color(0xFF030303),
          Color(0xFF222120),
          Color(0xFF000000),
        ],
        stops: [0, .28, .48, .72, 1],
      ).createShader(bounds);
    canvas.drawPath(ribbon, ink);

    // Redraw the upper strand with its own shadow to create a woven crossing.
    final bridge = _ribbon(math.pi * .39, math.pi * .61, size.width);
    canvas.save();
    canvas.clipPath(ribbon);
    canvas.drawPath(
      bridge,
      Paint()
        ..color = const Color(0xFF000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.restore();
    canvas.drawPath(bridge, ink);

    // A narrow reflection sweeps over the ribbon like light across black satin.
    canvas.save();
    canvas.clipPath(ribbon);
    final lightX = math.sin(phase) * size.width * .43;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = LinearGradient(
          colors: const [
            Color(0x00FFFFFF),
            Color(0x48FFFFFF),
            Color(0x00FFFFFF),
          ],
          stops: const [0, .5, 1],
        ).createShader(Rect.fromLTWH(lightX - 32, -85, 64, 170)),
    );
    canvas.restore();

    // Two short glints chase each other around the endless ribbon.
    // They fade along their tails, with no sudden flashes or resets.
    canvas.save();
    canvas.clipPath(ribbon);
    for (final offset in [0.0, .5]) {
      for (var i = 0; i < 36; i++) {
        final t = (motion.value + offset - i * .0018) * math.pi * 2;
        final segment = Path()
          ..moveTo(_point(t, size.width).dx, _point(t, size.width).dy)
          ..lineTo(
            _point(t + .018, size.width).dx,
            _point(t + .018, size.width).dy,
          );
        canvas.drawPath(
          segment,
          Paint()
            ..color = Color.fromRGBO(240, 234, 225, (1 - i / 36) * .7)
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 1.5,
        );
      }
    }
    canvas.restore();

    // Fine echo strokes follow the silhouette, suggesting flowing ink.
    for (final direction in [-1.0, 1.0]) {
      final flourish = Path()
        ..moveTo(-size.width * .31, direction * 75)
        ..cubicTo(
          -size.width * .08,
          direction * (105 + breath * 5),
          size.width * .16,
          direction * (70 - breath * 5),
          size.width * .33,
          direction * 79,
        );
      canvas.drawPath(
        flourish,
        Paint()
          ..color = const Color(0x35000000)
          ..style = PaintingStyle.stroke
          ..strokeWidth = .6,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InfinityPainter oldDelegate) =>
      oldDelegate.motion != motion;
}
