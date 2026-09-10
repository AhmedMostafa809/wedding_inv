import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/invitation_controller.dart';
import '../theme/invitation_theme.dart';
import 'widgets/countdown.dart';
import 'widgets/envelope_cover.dart';
import 'widgets/photo_gallery.dart';
import 'widgets/responsive_page.dart';
import 'widgets/scroll_reveal.dart';
import 'widgets/torn_paper.dart';

class InvitationView extends StatefulWidget {
  const InvitationView({super.key, required this.controller});

  final InvitationController controller;

  @override
  State<InvitationView> createState() => _InvitationViewState();
}

class _InvitationViewState extends State<InvitationView> {
  final _scrollController = ScrollController();
  bool _opened = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openMap() async {
    try {
      final opened = await launchUrl(
        widget.controller.invitation.mapUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) _showMessage('Could not open the map. Please try again.');
    } catch (_) {
      _showMessage('Could not open the map. Please try again.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showRsvp() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 480),
      backgroundColor: InvitationTheme.paper,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('RSVP', style: InvitationTheme.display),
              const SizedBox(height: 18),
              const Text(
                'We would love to celebrate with you.\nOnline responses will be available soon.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'يسعدنا حضوركم ومشاركتكم فرحتنا',
                textAlign: TextAlign.center,
                style: InvitationTheme.arabic,
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CLOSE'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reveal(Widget child) =>
      ScrollReveal(scrollController: _scrollController, child: child);

  @override
  Widget build(BuildContext context) {
    final invitation = widget.controller.invitation;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      body: ResponsivePage(
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: reducedMotion ? 0 : 800),
            switchInCurve: Curves.easeOutCubic,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, .035),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: !_opened
                ? EnvelopeCover(
                    key: const ValueKey('cover'),
                    controller: widget.controller,
                    onOpened: () => setState(() => _opened = true),
                  )
                : SingleChildScrollView(
                    key: const Key('invitation-scroll'),
                    controller: _scrollController,
                    child: Column(
                      children: [
                        _reveal(_Hero(controller: widget.controller)),
                        _reveal(
                          Transform.translate(
                            offset: const Offset(0, -18),
                            child: TornPaper(
                              padding: const EdgeInsets.fromLTRB(
                                34,
                                56,
                                34,
                                62,
                              ),
                              color: InvitationTheme.paper,
                              child: _Welcome(controller: widget.controller),
                            ),
                          ),
                        ),
                        _reveal(
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(30, 58, 30, 58),
                            color: InvitationTheme.ivory,
                            child: Column(
                              children: [
                                const _SectionHeading(
                                  eyebrow: 'SAVE THE DATE',
                                  title: 'We will see you\nin…',
                                ),
                                const SizedBox(height: 34),
                                WeddingCountdown(controller: widget.controller),
                                const SizedBox(height: 22),
                                Text(
                                  widget.controller.dateLabel.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: InvitationTheme.eyebrow,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _reveal(
                          _LocationSection(
                            controller: widget.controller,
                            onOpenMap: _openMap,
                          ),
                        ),
                        _reveal(
                          TornPaper(
                            color: InvitationTheme.paper,
                            padding: const EdgeInsets.fromLTRB(34, 60, 34, 64),
                            child: Column(
                              children: [
                                const _SectionHeading(
                                  eyebrow: 'THE WEDDING DAY',
                                  title: 'Our timing',
                                ),
                                const SizedBox(height: 34),
                                _TimelineItem(
                                  time: widget.controller.timeLabel,
                                  title: 'Wedding celebration',
                                  detail: 'Welcome, ceremony & celebration',
                                ),
                                const SizedBox(height: 40),
                                const Divider(color: InvitationTheme.line),
                                const SizedBox(height: 34),
                                const _SectionHeading(
                                  eyebrow: 'YOUR PRESENCE IS OUR GIFT',
                                  title: 'Kind wishes',
                                ),
                                const SizedBox(height: 18),
                                const Text(
                                  'The greatest gift is having you beside us as we begin this new chapter.',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _reveal(
                          Container(
                            padding: const EdgeInsets.fromLTRB(30, 48, 30, 48),
                            decoration: BoxDecoration(
                              color: InvitationTheme.ivory,
                            ),
                            child: Column(
                              children: [
                                const _SectionHeading(
                                  eyebrow: 'PLEASE REPLY',
                                  title: 'Will you join us?',
                                ),
                                const SizedBox(height: 18),
                                const Text(
                                  'Your answer will help us prepare a beautiful evening for everyone.',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 26),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    key: const Key('rsvp'),
                                    onPressed: _showRsvp,
                                    child: const Text('CONFIRM ATTENDANCE'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _reveal(
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 60, 24, 48),
                            child: Column(
                              children: [
                                Text(
                                  widget.controller.namesLabel,
                                  textDirection: TextDirection.ltr,
                                  style: InvitationTheme.script.copyWith(
                                    fontSize: 42,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.controller.shortDate,
                                  textDirection: TextDirection.ltr,
                                  style: InvitationTheme.eyebrow,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (invitation.photoAssets.isNotEmpty)
                          _reveal(
                            Container(
                              width: double.infinity,
                              color: InvitationTheme.stone,
                              padding: const EdgeInsets.only(
                                top: 54,
                                bottom: 42,
                              ),
                              child: Column(
                                children: [
                                  const _SectionHeading(
                                    eyebrow: 'TO INFINITY, TOGETHER',
                                    title: 'Our memories',
                                  ),
                                  const SizedBox(height: 24),
                                  PhotoGallery(photos: invitation.photoAssets),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.controller});

  final InvitationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 520),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(30, 72, 30, 56),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB4AA98), Color(0xFF8F826E)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'TOGETHER WITH OUR FAMILIES',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 9,
              letterSpacing: 2.4,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 26),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              controller.namesLabel,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: InvitationTheme.script.copyWith(
                fontSize: 62,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 26),
          const SizedBox(width: 64, child: Divider(color: Colors.white54)),
          const SizedBox(height: 26),
          Text(
            controller.shortDate,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              letterSpacing: 3,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.controller});

  final InvitationController controller;

  @override
  Widget build(BuildContext context) {
    final invitation = controller.invitation;
    return Column(
      children: [
        const _SectionHeading(
          eyebrow: 'DEAR FAMILY & FRIENDS',
          title: 'You are invited',
        ),
        const SizedBox(height: 20),
        Text(invitation.message, textAlign: TextAlign.center),
        if (invitation.verse != null) ...[
          const SizedBox(height: 28),
          const Divider(color: InvitationTheme.line),
          const SizedBox(height: 24),
          Text(
            invitation.verse!,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: InvitationTheme.arabic,
          ),
        ],
      ],
    );
  }
}

class _LocationSection extends StatelessWidget {
  const _LocationSection({required this.controller, required this.onOpenMap});

  final InvitationController controller;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final invitation = controller.invitation;
    return TornPaper(
      color: InvitationTheme.paper,
      padding: const EdgeInsets.fromLTRB(30, 52, 30, 54),
      child: Column(
        children: [
          const _SectionHeading(eyebrow: 'THE VENUE', title: 'Meet us there'),
          const SizedBox(height: 22),
          Text(
            invitation.venueName,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: InvitationTheme.arabic.copyWith(fontSize: 23),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              key: const Key('open-map'),
              onPressed: onOpenMap,
              child: const Text('OPEN MAP'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          eyebrow,
          textAlign: TextAlign.center,
          style: InvitationTheme.eyebrow,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: InvitationTheme.script.copyWith(fontSize: 49),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.time,
    required this.title,
    required this.detail,
  });

  final String time;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 94,
          child: Text(
            time,
            textDirection: TextDirection.ltr,
            style: InvitationTheme.display.copyWith(fontSize: 31),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                style: const TextStyle(color: InvitationTheme.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
