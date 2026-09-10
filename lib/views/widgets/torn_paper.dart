import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/invitation_theme.dart';

class TornPaper extends StatelessWidget {
  const TornPaper({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.fromLTRB(28, 42, 28, 42),
  });

  final Widget child;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvitationTheme.stone,
      child: ClipPath(
        clipper: const _TornPaperClipper(),
        child: ColoredBox(
          color: color,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class _TornPaperClipper extends CustomClipper<Path> {
  const _TornPaperClipper();

  @override
  Path getClip(Size size) {
    final random = math.Random(42);
    double edge(double x) => 9 + math.sin(x / 39) * 3 + random.nextDouble() * 5;
    final path = Path()..moveTo(0, edge(0));
    var x = 0.0;
    while (x < size.width) {
      x = (x + 3 + random.nextDouble() * 6).clamp(0, size.width);
      path.lineTo(x, edge(x));
    }
    path.lineTo(size.width, size.height - edge(size.width));
    x = size.width;
    while (x > 0) {
      x = (x - 3 - random.nextDouble() * 6).clamp(0, size.width);
      path.lineTo(x, size.height - edge(x + 73));
    }
    return path..close();
  }

  @override
  bool shouldReclip(_TornPaperClipper oldClipper) => false;
}
