import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/invitation_controller.dart';
import 'data/local_invitation.dart';
import 'theme/invitation_theme.dart';
import 'views/engagement_view.dart';

class WeddingInvitationApp extends StatelessWidget {
  const WeddingInvitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahmed, Habiba | دعوة خطوبة',
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: InvitationTheme.theme,
      home: EngagementView(
        controller: InvitationController(invitation: localInvitation),
      ),
    );
  }
}
