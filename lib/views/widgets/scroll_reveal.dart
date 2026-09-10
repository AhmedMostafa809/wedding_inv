import 'package:flutter/material.dart';

/// Checks visibility after layout, including after the cover transition.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.scrollController,
    required this.child,
  });
  final ScrollController scrollController;
  final Widget child;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  );
  late final _curve = CurvedAnimation(
    parent: _animation,
    curve: Curves.easeOutCubic,
  );
  bool _scheduled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scheduleCheck);
    _scheduleCheck();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _animation.value = 1;
    _scheduleCheck();
  }

  @override
  void didUpdateWidget(ScrollReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_scheduleCheck);
      widget.scrollController.addListener(_scheduleCheck);
    }
    _scheduleCheck();
  }

  void _scheduleCheck() {
    if (_scheduled || _animation.isCompleted || _animation.isAnimating) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (!mounted) return;
      final box = context.findRenderObject();
      final viewport = Scrollable.maybeOf(context)?.context.findRenderObject();
      if (box is! RenderBox || !box.hasSize) return;
      final viewportTop = viewport is RenderBox
          ? viewport.localToGlobal(Offset.zero).dy
          : 0.0;
      final viewportHeight = viewport is RenderBox
          ? viewport.size.height
          : MediaQuery.sizeOf(context).height;
      final top = box.localToGlobal(Offset.zero).dy;
      if (top < viewportTop + viewportHeight &&
          top + box.size.height > viewportTop) {
        _animation.forward();
      }
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scheduleCheck);
    _curve.dispose();
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      _scheduleCheck();
      return AnimatedBuilder(
        animation: _curve,
        child: widget.child,
        builder: (context, child) => Opacity(
          opacity: _curve.value,
          child: Transform.translate(
            offset: Offset(0, 22 * (1 - _curve.value)),
            child: Transform.scale(
              scale: .985 + .015 * _curve.value,
              child: child,
            ),
          ),
        ),
      );
    },
  );
}
