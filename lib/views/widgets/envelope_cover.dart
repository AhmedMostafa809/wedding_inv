import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../controllers/invitation_controller.dart';
import '../../theme/invitation_theme.dart';

class EnvelopeCover extends StatefulWidget {
  const EnvelopeCover({
    super.key,
    required this.controller,
    required this.onOpened,
  });
  final InvitationController controller;
  final VoidCallback onOpened;

  @override
  State<EnvelopeCover> createState() => _EnvelopeCoverState();
}

class _EnvelopeCoverState extends State<EnvelopeCover>
    with TickerProviderStateMixin {
  late final _opening = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  late final _arrival = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  bool _started = false;
  bool _hovered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _arrival.value = 1;
    } else {
      _arrival.forward();
    }
  }

  Future<void> _open() async {
    if (_started) return;
    setState(() => _started = true);
    if (!MediaQuery.disableAnimationsOf(context)) {
      await _opening.forward();
    }
    if (mounted) widget.onOpened();
  }

  @override
  void dispose() {
    _opening.dispose();
    _arrival.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-.7, -.6),
          radius: 1.5,
          colors: [Color(0xFFD1C7B6), Color(0xFFA99C87), Color(0xFF8E7E67)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 38, 28, 30),
                child: AnimatedBuilder(
                  animation: _arrival,
                  builder: (context, child) {
                    final t = Curves.easeOutCubic.transform(_arrival.value);
                    return Opacity(
                      opacity: t,
                      child: Transform.translate(
                        offset: Offset(0, (1 - t) * 20),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'A WEDDING INVITATION',
                        style: InvitationTheme.eyebrow.copyWith(
                          color: InvitationTheme.paper,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'For you',
                        style: InvitationTheme.script.copyWith(
                          fontSize: 66,
                          color: InvitationTheme.paper,
                        ),
                      ),
                      const SizedBox(height: 18),
                      MouseRegion(
                        onEnter: (_) => setState(() => _hovered = true),
                        onExit: (_) => setState(() => _hovered = false),
                        child: AnimatedScale(
                          scale: _hovered && !_started ? 1.015 : 1,
                          duration: Duration(milliseconds: reduced ? 0 : 250),
                          child: TextButton(
                            key: const Key('open-envelope'),
                            onPressed: _started ? null : _open,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor: InvitationTheme.ink,
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Semantics(
                              label:
                                  'Open the wedding invitation for ${widget.controller.namesLabel}',
                              child: ExcludeSemantics(
                                child: AspectRatio(
                                  aspectRatio: .91,
                                  child: AnimatedBuilder(
                                    animation: _opening,
                                    builder: (context, _) => _FoldedLetter(
                                      progress: _opening.value,
                                      names: widget.controller.namesLabel,
                                      date: widget.controller.shortDate,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        widget.controller.namesLabel,
                        textAlign: TextAlign.center,
                        style: InvitationTheme.display.copyWith(
                          fontSize: 37,
                          color: InvitationTheme.paper,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedOpacity(
                        opacity: _started ? 0 : 1,
                        duration: Duration(milliseconds: reduced ? 0 : 200),
                        child: Text(
                          'TAP THE SEAL TO OPEN',
                          style: InvitationTheme.eyebrow.copyWith(
                            fontSize: 9,
                            color: InvitationTheme.paper,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        widget.controller.shortDate,
                        style: InvitationTheme.eyebrow.copyWith(
                          color: const Color(0xFFE5DDD1),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FoldedLetter extends StatelessWidget {
  const _FoldedLetter({
    required this.progress,
    required this.names,
    required this.date,
  });
  final double progress;
  final String names;
  final String date;

  @override
  Widget build(BuildContext context) {
    final unseal = Curves.easeInOut.transform((progress / .25).clamp(0, 1));
    final unfold = Curves.easeInOutCubic.transform(
      ((progress - .18) / .58).clamp(0, 1),
    );
    final lift = Curves.easeOutCubic.transform(
      ((progress - .55) / .45).clamp(0, 1),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF9D8A73),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x50000000)
                          .withValues(alpha: .22 * (1 - lift)),
                      blurRadius: 32,
                      offset: const Offset(4, 20),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, -28 * lift),
                child: Transform.scale(
                  scale: .92 + .08 * lift,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    color: InvitationTheme.paper,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: InvitationTheme.line,
                          width: .6,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'THE BEGINNING OF FOREVER',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 8,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FittedBox(
                            child: Text(
                              names,
                              style: InvitationTheme.script.copyWith(
                                fontSize: 42,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          const SizedBox(
                            width: 45,
                            child: Divider(color: InvitationTheme.line),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            date,
                            style: const TextStyle(
                              fontFamily: 'CormorantGaramond',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            for (final left in [true, false])
              Positioned(
                left: left ? 0 : null,
                right: left ? null : 0,
                top: 0,
                bottom: 0,
                width: width * .51,
                child: Opacity(
                  opacity: 1 - lift,
                  child: Transform(
                    alignment: left
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, .0015)
                      ..rotateY((left ? -1 : 1) * unfold * 1.48),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: left
                              ? const [
                                  Color(0xFFBCAD98),
                                  Color(0xFFD0C2AD),
                                  Color(0xFFAE9D85),
                                ]
                              : const [
                                  Color(0xFFBAAA92),
                                  Color(0xFFD4C7B3),
                                  Color(0xFFB5A48B),
                                ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF97866F),
                          width: .5,
                        ),
                      ),
                      child: CustomPaint(painter: _WrapperLines(left: left)),
                    ),
                  ),
                ),
              ),
            for (final left in [true, false])
              Positioned(
                left: left ? 0 : null,
                right: left ? null : 0,
                width: width * .51,
                height: 46,
                child: Opacity(
                  opacity: 1 - unseal,
                  child: Transform.translate(
                    offset: Offset((left ? -1 : 1) * unseal * width * .2, 0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF86745E),
                            Color(0xFFA18B6F),
                            Color(0xFF7D6A54),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x24000000),
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Opacity(
              opacity: 1 - unseal,
              child: Transform.scale(
                scale: 1 + .3 * unseal,
                child: CustomPaint(
                  painter: const _IvorySeal(),
                  child: SizedBox(
                    width: 74,
                    height: 74,
                    child: Center(
                      child: Text(
                        'A',
                        style: InvitationTheme.script.copyWith(
                          fontSize: 38,
                          color: const Color(0xFF88765F),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WrapperLines extends CustomPainter {
  const _WrapperLines({required this.left});
  final bool left;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7D6950).withValues(alpha: .15)
      ..strokeWidth = .5;
    for (var x = 2.0; x < size.width; x += 3.5) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    final fold = Path()
      ..moveTo(left ? 0 : size.width, 0)
      ..lineTo(left ? size.width : 0, size.height * .28)
      ..moveTo(left ? 0 : size.width, size.height)
      ..lineTo(left ? size.width : 0, size.height * .72);
    canvas.drawPath(
      fold,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = .8,
    );
  }

  @override
  bool shouldRepaint(_WrapperLines oldDelegate) => oldDelegate.left != left;
}

class _IvorySeal extends CustomPainter {
  const _IvorySeal();
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final path = Path();
    for (var i = 0; i <= 100; i++) {
      final angle = i * math.pi * 2 / 100;
      final radius = 34 + math.sin(angle * 11) * 1.2 + math.cos(angle * 7) * .7;
      final p = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawShadow(path, const Color(0x70000000), 5, true);
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFCF8EE), Color(0xFFC7BBA6), Color(0xFFE8DFCF)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawCircle(
      center,
      27,
      Paint()
        ..color = const Color(0xFFAE9E85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .9,
    );
    canvas.drawCircle(
      center.translate(0, 1),
      26,
      Paint()
        ..color = const Color(0xFFF9F4E8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .7,
    );
  }

  @override
  bool shouldRepaint(_IvorySeal oldDelegate) => false;
}
