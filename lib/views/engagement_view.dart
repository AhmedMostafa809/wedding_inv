import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/invitation_controller.dart';
import '../theme/invitation_theme.dart';
import 'widgets/responsive_page.dart';
import 'widgets/scroll_reveal.dart';

const _red = Color(0xFF890B20);
const _cream = Color(0xFFFFF8ED);

class EngagementView extends StatefulWidget {
  const EngagementView({super.key, required this.controller});
  final InvitationController controller;
  @override
  State<EngagementView> createState() => _EngagementViewState();
}

class _EngagementViewState extends State<EngagementView>
    with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  late final _motion = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _motion.stop();
    } else {
      _motion.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _map() async {
    try {
      if (await launchUrl(
        widget.controller.invitation.mapUrl,
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }
    } catch (_) {
      /* Show the same friendly fallback below. */
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the map. Please try again.'),
        ),
      );
    }
  }

  Widget _script(String text, {double size = 48, Color color = _red}) => Text(
    text,
    textAlign: TextAlign.center,
    style: InvitationTheme.script.copyWith(
      fontSize: size,
      color: color,
      height: 1.3,
    ),
  );
  Widget _body(String text, {Color color = const Color(0xFF463B36)}) => Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 13, height: 1.8, color: color),
  );
  Widget _reveal(Widget child) =>
      ScrollReveal(scrollController: _scroll, child: child);

  @override
  Widget build(BuildContext context) {
    final invitation = widget.controller.invitation;
    return Scaffold(
      body: ResponsivePage(
        child: ColoredBox(
          color: _cream,
          child: SingleChildScrollView(
            key: const Key('engagement-scroll'),
            controller: _scroll,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 42, 24, 10),
                  child: Text(
                    'A LITTLE NOTE, A LOT OF LOVE',
                    textAlign: TextAlign.center,
                    style: InvitationTheme.eyebrow.copyWith(
                      color: _red,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                _reveal(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 28, 28, 48),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Transform.rotate(
                            angle: -.06,
                            child: _script('Guess what?', size: 55),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _script('We said yes!', size: 55),
                        ),
                        const SizedBox(height: 28),
                        AnimatedBuilder(
                          animation: _motion,
                          builder: (context, child) => Transform.translate(
                            offset: Offset(
                              0,
                              math.sin(_motion.value * math.pi * 2) * 5,
                            ),
                            child: child,
                          ),
                          child: CustomPaint(
                            painter: _HeartsPainter(),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 56),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Transform.rotate(
                                          angle: -.1,
                                          child: _script(
                                            invitation.groom,
                                            size: 37,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Transform.rotate(
                                          angle: .1,
                                          child: _script(
                                            invitation.bride,
                                            size: 37,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Image.asset(
                                    'assets/engagement/childhood_cutouts.png',
                                    key: const Key('childhood-portraits'),
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    semanticLabel: 'Childhood photos of Ahmed on the left and Habiba on the right',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: -.035,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            decoration: const BoxDecoration(
                              color: _red,
                              borderRadius: BorderRadius.all(
                                Radius.elliptical(100, 20),
                              ),
                            ),
                            child: _script(
                              "We're getting engaged!",
                              size: 31,
                              color: _cream,
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                        _script('Recognize us?', size: 40),
                        const SizedBox(height: 12),
                        _body(
                          'Yes, it’s us! Two little faces,\nall grown up and ready for our next chapter.',
                        ),
                        const SizedBox(height: 14),
                        _body(invitation.message),
                      ],
                    ),
                  ),
                ),
                _reveal(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 12, 28, 46),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: _red,
                          size: 36,
                        ),
                        const SizedBox(height: 16),
                        _body(
                          'Keep this evening for us.\nIt wouldn’t be the same without you.',
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: _script('October', size: 37),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('2026',
                                style: InvitationTheme.display.copyWith(
                                  fontSize: 37,
                                  color: _red,
                                  height: 1.3,
                                ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: _red, height: 1),
                        Row(
                          children: [
                            for (final entry in [
                              ('Thu', '29'),
                              ('Fri', '30'),
                              ('Sat', '31'),
                            ])
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: entry.$1 == 'Fri'
                                        ? const Border.symmetric(
                                            vertical: BorderSide(
                                              color: _red,
                                              width: .8,
                                            ),
                                          )
                                        : null,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        entry.$1,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: _red,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 82,
                                        child: entry.$1 == 'Fri'
                                            ? CustomPaint(
                                                painter: _SingleHeartPainter(
                                                  _red,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    entry.$2,
                                                    style: InvitationTheme.display.copyWith(
                                                      fontSize: 37,
                                                      color: _red,
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  entry.$2,
                                                  style: InvitationTheme.display.copyWith(
                                                    fontSize: 37,
                                                    color: _red,
                                                    height: 1.3,
                                                  ),                                      ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _reveal(
                  ClipPath(
                    clipper: _PaperEdge(),
                    child: Container(
                      key: const Key('engagement-venue'),
                      width: double.infinity,
                      color: _red,
                      padding: const EdgeInsets.fromLTRB(34, 46, 34, 48),
                      child: Column(
                        children: [
                          _script('The place', color: _cream, size: 48),
                          const SizedBox(height: 8),
                          _body(invitation.venueName, color: _cream),
                          const SizedBox(height: 28),
                          Transform.rotate(
                            angle: .045,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                10,
                                10,
                                10,
                                24,
                              ),
                              decoration: const BoxDecoration(
                                color: _cream,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x35000000),
                                    blurRadius: 12,
                                    offset: Offset(2, 5),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/venue/golden_gate_villa.png',
                                key: const Key('villa-photo'),
                                fit: BoxFit.cover,
                                semanticLabel: 'Golden Gate Villa garden and celebration tables',
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          OutlinedButton.icon(
                            key: const Key('open-map'),
                            onPressed: _map,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: _cream,
                              foregroundColor: _red,
                              shape: const RoundedRectangleBorder(),
                              minimumSize: const Size(190, 52),
                            ),
                            icon: const Icon(Icons.location_on_outlined),
                            label: const Text('OPEN THE MAP'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _reveal(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 46, 30, 48),
                    child: Column(
                      children: [
                        _script('When to be there?', size: 44),
                        const SizedBox(height: 24),
                        Text(widget.controller.timeLabel,  style: InvitationTheme.display.copyWith(
                          fontSize: 37,
                          color: _red,
                          height: 1.3,
                        ),),
                        _body('Friday, 30 October 2026\nCairo time'),
                        const SizedBox(height: 18),
                        _body(
                          'An evening of happy hearts,\nbig smiles & a beautiful beginning.',
                        ),
                        const SizedBox(height: 36),
                        const Icon(Icons.favorite, size: 25, color: _red),
                        const SizedBox(height: 20),
                        _script(
                          '${invitation.groom} & ${invitation.bride}',
                          size: 42,
                        ),
                        _body('Can’t wait to celebrate with you!'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Path _heart(Size size) => Path()
  ..moveTo(size.width * .5, size.height * .86)
  ..cubicTo(
    -size.width * .2,
    size.height * .4,
    size.width * .12,
    -size.height * .18,
    size.width * .5,
    size.height * .22,
  )
  ..cubicTo(
    size.width * .88,
    -size.height * .18,
    size.width * 1.2,
    size.height * .4,
    size.width * .5,
    size.height * .86,
  );

class _SingleHeartPainter extends CustomPainter {
  _SingleHeartPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _heart(size),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_SingleHeartPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _HeartsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final positions = [
      const Offset(.08, .25),
      const Offset(.79, .12),
      const Offset(.83, .68),
      const Offset(.04, .74),
      const Offset(.48, .02),
    ];
    for (var i = 0; i < positions.length; i++) {
      canvas.save();
      canvas.translate(
        size.width * positions[i].dx,
        size.height * positions[i].dy,
      );
      canvas.rotate(i.isEven ? -.2 : .2);
      final heart = _heart(Size(i.isEven ? 30 : 40, i.isEven ? 32 : 42));
      canvas.drawPath(
        heart,
        Paint()
          ..color = _red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      if (i.isOdd) {
        canvas.clipPath(heart);
        for (var y = -10.0; y < 60; y += 4) {
          canvas.drawLine(
            Offset(0, y),
            Offset(45, y - 20),
            Paint()
              ..color = _red
              ..strokeWidth = .8,
          );
        }
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_HeartsPainter oldDelegate) => false;
}

class _PaperEdge extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..moveTo(0, 7);
    for (var x = 0.0; x <= size.width; x += 4) {
      path.lineTo(x, 7 + math.sin(x / 19) * 2 + math.sin(x / 7));
    }
    path.lineTo(size.width, size.height - 8);
    for (var x = size.width; x >= 0; x -= 4) {
      path.lineTo(x, size.height - 7 + math.sin(x / 23) * 3);
    }
    return path..close();
  }

  @override
  bool shouldReclip(_PaperEdge oldClipper) => false;
}
