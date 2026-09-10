import 'package:flutter/material.dart';

import '../../theme/invitation_theme.dart';

/// Keeps the same stationery proportions on mobile and desktop.
class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: InvitationTheme.stone,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: InvitationTheme.paper,
              boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 55)],
            ),
            child: SizedBox.expand(child: child),
          ),
        ),
      ),
    );
  }
}
