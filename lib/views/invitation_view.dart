import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/invitation_controller.dart';
import '../services/rsvp_submitter.dart';
import '../theme/invitation_theme.dart';
import 'widgets/countdown.dart';
import 'widgets/envelope_cover.dart';
import 'widgets/infinity_memories.dart';
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

      if (!opened) {
        _showMessage('Could not open the map. Please try again.');
      }
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
      isScrollControlled: true,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 480),
      backgroundColor: InvitationTheme.paper,
      builder: (_) => const _RsvpSheet(),
    );
  }

  Widget _reveal(Widget child) {
    return ScrollReveal(scrollController: _scrollController, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      body: ResponsivePage(
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: reducedMotion ? 0 : 800),
            switchInCurve: Curves.easeOutCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, .035),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: !_opened
                ? EnvelopeCover(
                    key: const ValueKey('cover'),
                    controller: widget.controller,
                    onOpened: () {
                      setState(() => _opened = true);
                    },
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
                            color: InvitationTheme.ivory,
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
                                  child: FilledButton(
                                    key: const Key('rsvp'),
                                    onPressed: _showRsvp,
                                    child: const Text(
                                      'CONFIRM ATTENDANCE',
                                      textAlign: TextAlign.center,
                                    ),
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
                        _reveal(
                          Container(
                            width: double.infinity,
                            color: InvitationTheme.stone,
                            padding: const EdgeInsets.only(top: 54, bottom: 42),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Text(
                                    'To Infinity,Together',
                                    textAlign: TextAlign.center,
                                    style: InvitationTheme.script.copyWith(
                                      fontSize: 42,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const InfinityMemories(),
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

class _RsvpSheet extends StatefulWidget {
  const _RsvpSheet();

  @override
  State<_RsvpSheet> createState() => _RsvpSheetState();
}

class _RsvpSheetState extends State<_RsvpSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _attendeeNamesController = TextEditingController();
  final _messageController = TextEditingController();

  bool? _attending;
  int? _totalAttendees;

  bool _submitting = false;
  bool _submitted = false;

  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _attendeeNamesController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _errorMessage = null;
    });

    if (_attending == null) {
      setState(() {
        _errorMessage = 'Please choose whether you will attend.';
      });
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      await submitRsvp(
        name: _nameController.text,
        attending: _attending!,
        total: _attending! ? _totalAttendees : null,
        attendeeNames: _attending! ? _attendeeNamesController.text : '',
        message: _messageController.text,
      );

      if (!mounted) return;

      setState(() {
        _submitting = false;
        _submitted = true;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _submitting = false;
        _errorMessage = 'Could not submit your response. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(28, 8, 28, 28 + keyboardInset),
        child: _submitted
            ? _successView()
            : Form(key: _formKey, child: _formContent()),
      ),
    );
  }

  Widget _formContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('RSVP', style: InvitationTheme.display),
        const SizedBox(height: 12),
        const Text(
          'We would love to celebrate with you.\n'
          'يسعدنا حضوركم ومشاركتكم فرحتنا',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 26),
        TextFormField(
          controller: _nameController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Your name / اسمك',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your name.';
            }
            return null;
          },
        ),
        const SizedBox(height: 22),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Will you join us? / هل ستشاركوننا فرحتنا؟',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 6),
        RadioListTile<bool>(
          contentPadding: EdgeInsets.zero,
          value: true,
          groupValue: _attending,
          onChanged: _submitting
              ? null
              : (value) {
                  setState(() {
                    _attending = value;
                    _errorMessage = null;
                  });
                },
          title: const Text('Yes'),
        ),
        RadioListTile<bool>(
          contentPadding: EdgeInsets.zero,
          value: false,
          groupValue: _attending,
          onChanged: _submitting
              ? null
              : (value) {
                  setState(() {
                    _attending = value;
                    _totalAttendees = null;
                    _attendeeNamesController.clear();
                    _errorMessage = null;
                  });
                },
          title: const Text('No (Not an option)'),
        ),
        if (_errorMessage != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (_attending == true) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _totalAttendees,
            decoration: const InputDecoration(
              labelText:
                  'Total number attending/'
                  'عدد الحاضرين ',
              border: OutlineInputBorder(),
            ),
            items: List.generate(10, (index) {
              final count = index + 1;

              return DropdownMenuItem<int>(value: count, child: Text('$count'));
            }),
            onChanged: _submitting
                ? null
                : (value) {
                    setState(() {
                      _totalAttendees = value;
                    });
                  },
            validator: (_) {
              if (_totalAttendees == null) {
                return 'Please select the number of attendees.';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _attendeeNamesController,
            minLines: 2,
            maxLines: 4,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText:
                  'Names of everyone attending / '
                  'أسماء جميع الحاضرين',
              hintText: 'Include your own name and your family members',
              border: OutlineInputBorder(),
            ),
          ),
        ],
        const SizedBox(height: 18),
        TextFormField(
          controller: _messageController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText:
                'Message for Ahmed & Asmaa / '
                'رسالة لأحمد وأسماء',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 26),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('SUBMIT RSVP'),
          ),
        ),
      ],
    );
  }

  Widget _successView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        const Icon(
          Icons.check_circle_outline,
          size: 64,
          color: InvitationTheme.muted,
        ),
        const SizedBox(height: 18),
        const Text(
          'Thank you for your response.',
          textAlign: TextAlign.center,
          style: InvitationTheme.display,
        ),
        const SizedBox(height: 12),
        const Text(
          'شكرًا لتأكيد حضورك.\n'
          'We look forward to celebrating with you.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 26),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CLOSE'),
        ),
      ],
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
            child: OutlinedButton.icon(
              key: const Key('open-map'),
              onPressed: onOpenMap,
              icon: const Icon(Icons.location_on_outlined, size: 21),
              label: const Text('OPEN MAP', textAlign: TextAlign.center),
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
