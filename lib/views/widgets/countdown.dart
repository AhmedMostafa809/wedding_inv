import 'dart:async';

import 'package:flutter/material.dart';

import '../../controllers/invitation_controller.dart';
import '../../theme/invitation_theme.dart';

class WeddingCountdown extends StatefulWidget {
  const WeddingCountdown({super.key, required this.controller});
  final InvitationController controller;

  @override
  State<WeddingCountdown> createState() => _WeddingCountdownState();
}

class _WeddingCountdownState extends State<WeddingCountdown> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.controller.remainingAt(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = widget.controller.remainingAt(DateTime.now());
      if (mounted) setState(() => _remaining = next);
      if (next == Duration.zero) _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining == Duration.zero) {
      return const Text(
        'Our forever begins today',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 26, color: InvitationTheme.gold),
      );
    }
    final values = [
      (_remaining.inDays, 'DAYS'),
      (_remaining.inHours % 24, 'HOURS'),
      (_remaining.inMinutes % 60, 'MIN'),
      (_remaining.inSeconds % 60, 'SEC'),
    ];
    return Semantics(
      label:
          '${_remaining.inDays} days and ${_remaining.inHours % 24} hours remaining',
      child: ExcludeSemantics(
        child: Row(
          children: [
            for (var i = 0; i < values.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 2,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: InvitationTheme.line),
                    ),
                  ),
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: AnimatedSwitcher(
                          duration: Duration(
                            milliseconds:
                                MediaQuery.disableAnimationsOf(context)
                                ? 0
                                : 450,
                          ),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, .18),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: Text(
                            values[i].$1.toString().padLeft(2, '0'),
                            key: ValueKey(values[i].$1),
                            style: const TextStyle(
                              fontFamily: 'CormorantGaramond',
                              fontSize: 34,
                              color: InvitationTheme.gold,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        values[i].$2,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 8,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
