import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../theme/invitation_theme.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({
    super.key,
    required this.photos,
  });

  final List<String> photos;

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final Ticker _ticker;
  late List<String> _photos;

  Duration? _previous;

  double _progress = 0;
  bool _foreground = true;

  Size? _trackSize;
  Path? _trackPath;
  ui.PathMetric? _trackMetric;

  // Higher = slower movement.
  static const double _loopSeconds = 36;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_advance);
    _shufflePhotos();

    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _foreground =
        lifecycle == null || lifecycle == AppLifecycleState.resumed;

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMotion();
  }

  @override
  void didUpdateWidget(covariant PhotoGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    _shufflePhotos();
    _updateMotion();
  }

  void _shufflePhotos() {
    _photos = List<String>.of(widget.photos)
      ..shuffle(math.Random(16));
  }

  void _updateMotion() {
    final animate = _foreground &&
        _photos.isNotEmpty &&
        TickerMode.of(context) &&
        !MediaQuery.disableAnimationsOf(context);

    if (animate && !_ticker.isActive) {
      _previous = null;
      _ticker.start();
    } else if (!animate && _ticker.isActive) {
      _ticker.stop();
      _previous = null;
    }
  }

  void _advance(Duration elapsed) {
    final previous = _previous;
    _previous = elapsed;

    if (previous == null) return;

    final seconds =
    ((elapsed - previous).inMicroseconds / 1000000)
        .clamp(0.0, .05)
        .toDouble();

    setState(() {
      // Always advance in the same direction.
      _progress = (_progress + seconds / _loopSeconds) % 1.0;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _updateMotion();
  }

  void _prepareTrack(
      Size size,
      double cardWidth,
      double cardHeight,
      ) {
    if (_trackSize == size) return;

    _trackSize = size;

    final cx = size.width / 2;
    final cy = size.height / 2;

    final rx = math.max(
      0.0,
      size.width / 2 - cardWidth * .80,
    );

    final ry = math.max(
      0.0,
      size.height / 2 - cardHeight * .80,
    );

    // Four connected Bézier curves:
    // center → right bend → center → left bend → center.
    //
    // Matching tangents keep the joins smooth, including
    // the transition from the end back to the beginning.
    final path = Path()
      ..moveTo(cx, cy)
      ..cubicTo(
        cx + rx * .48,
        cy - ry,
        cx + rx,
        cy - ry,
        cx + rx,
        cy,
      )
      ..cubicTo(
        cx + rx,
        cy + ry,
        cx + rx * .48,
        cy + ry,
        cx,
        cy,
      )
      ..cubicTo(
        cx - rx * .48,
        cy - ry,
        cx - rx,
        cy - ry,
        cx - rx,
        cy,
      )
      ..cubicTo(
        cx - rx,
        cy + ry,
        cx - rx * .48,
        cy + ry,
        cx,
        cy,
      )
      ..close();

    _trackPath = path;

    final metrics = path.computeMetrics().toList();
    _trackMetric = metrics.isEmpty ? null : metrics.first;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_photos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: 'Photo memories of Ahmed and Asmaa',
      child: IgnorePointer(
        key: const Key('photo-input-disabled'),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.hasBoundedWidth
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;

            if (width <= 0) {
              return const SizedBox.shrink();
            }

            final height =
            (width * .72).clamp(280.0, 520.0).toDouble();

            final cardWidth =
            (width * .17).clamp(48.0, 110.0).toDouble();

            final cardHeight = cardWidth * 1.25;
            final size = Size(width, height);

            _prepareTrack(size, cardWidth, cardHeight);

            final metric = _trackMetric;

            if (metric == null || metric.length <= 0) {
              return SizedBox(width: width, height: height);
            }

            return SizedBox(
              key: const Key('photo-gallery'),
              width: width,
              height: height,
              child: ClipRRect(
                // Rounded clipping at the section's left and right ends.
                borderRadius: BorderRadius.circular(height / 2),
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Color(0x99000000),
                        Colors.black,
                        Colors.black,
                        Color(0x99000000),
                        Colors.transparent,
                      ],
                      stops: [
                        0.0,
                        .055,
                        .16,
                        .84,
                        .945,
                        1.0,
                      ],
                    ).createShader(bounds);
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _InfinityTrackPainter(
                            path: _trackPath!,
                            color: InvitationTheme.muted,
                          ),
                        ),
                      ),

                      for (var index = 0;
                      index < _photos.length;
                      index++)
                        _buildMovingPhoto(
                          context: context,
                          index: index,
                          metric: metric,
                          cardWidth: cardWidth,
                          cardHeight: cardHeight,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMovingPhoto({
    required BuildContext context,
    required int index,
    required ui.PathMetric metric,
    required double cardWidth,
    required double cardHeight,
  }) {
    final progress =
        (_progress + index / _photos.length) % 1.0;

    // Move by distance along the path, keeping speed and spacing
    // consistent through the curves.
    final tangent = metric.getTangentForOffset(
      progress * metric.length,
    );

    if (tangent == null) {
      return const SizedBox.shrink();
    }

    final position = tangent.position;

    // Slightly lean into each curve without spinning the photos.
    final angle = tangent.vector.dy * .12;

    return Positioned(
      key: ValueKey(index),
      left: position.dx - cardWidth / 2,
      top: position.dy - cardHeight / 2,
      width: cardWidth,
      height: cardHeight,
      child: Transform.rotate(
        angle: angle,
        child: RepaintBoundary(
          child: _buildPhoto(
            context,
            index,
            cardWidth,
            cardHeight,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto(
      BuildContext context,
      int index,
      double width,
      double height,
      ) {
    final border = width * .045;
    final outerRadius = width * .14;
    final innerRadius = width * .10;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: InvitationTheme.paper,
        borderRadius: BorderRadius.circular(outerRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 8,
            offset: Offset(1, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          border,
          border,
          border,
          border * 2,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: Image.asset(
            _photos[index],
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            cacheHeight:
            (height * MediaQuery.devicePixelRatioOf(context))
                .round()
                .clamp(1, 720),
            excludeFromSemantics: true,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: InvitationTheme.ivory,
                child: Center(
                  child: Icon(
                    Icons.photo_outlined,
                    color: InvitationTheme.muted,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InfinityTrackPainter extends CustomPainter {
  const _InfinityTrackPainter({
    required this.path,
    required this.color,
  });

  final Path path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle soft glow behind the rounded track.
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withAlpha(15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          5,
        ),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withAlpha(48)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _InfinityTrackPainter oldDelegate) {
    return oldDelegate.path != path || oldDelegate.color != color;
  }
}