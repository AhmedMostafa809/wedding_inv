import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../models/invitation.dart';
import '../theme/invitation_theme.dart';

/// A static, readable companion to the website, ready to send as a picture.
class PrintableInvitation extends StatelessWidget {
  const PrintableInvitation({super.key, required this.invitation});
  final Invitation invitation;

  String _arabicDigits(String value) => value.replaceAllMapped(
    RegExp(r'[0-9]'),
    (match) => '٠١٢٣٤٥٦٧٨٩'[int.parse(match[0]!)],
  );

  @override
  Widget build(BuildContext context) {
    final date = invitation.eventDate;
    final dateLabel = _arabicDigits(
      DateFormat('EEEE، d MMMM yyyy', 'ar').format(date),
    );
    final timeLabel = _arabicDigits(DateFormat('h:mm', 'ar').format(date));
    final period = date.hour >= 12 ? 'مساءً' : 'صباحًا';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ColoredBox(
        color: InvitationTheme.stone,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            decoration: BoxDecoration(
              color: InvitationTheme.paper,
              border: Border.all(color: InvitationTheme.gold, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            child: DefaultTextStyle(
              style: InvitationTheme.arabic.copyWith(
                fontSize: 25,
                height: 1.6,
                color: InvitationTheme.ink,
              ),
              textAlign: TextAlign.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: InvitationTheme.arabic.copyWith(fontSize: 20),
                  ),
                  if (invitation.verse != null)
                    Text(
                      invitation.verse!,
                      style: InvitationTheme.arabic.copyWith(
                        fontSize: 21,
                        height: 1.75,
                      ),
                    ),
                  const Text(
                    'دعوة زفاف',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 40,
                      height: 1.3,
                    ),
                  ),
                  Text(
                    '${invitation.groom} & ${invitation.bride}',
                    textDirection: TextDirection.ltr,
                    style: InvitationTheme.script.copyWith(
                      fontSize: 59,
                      height: 1.4,
                    ),
                  ),
                  const Text('بكل الحب والفرح\nنتشرف بدعوتكم لحضور حفل زفافنا'),
                  const SizedBox(
                    width: 90,
                    child: Divider(color: InvitationTheme.gold),
                  ),
                  Column(
                    children: [
                      Text(
                        dateLabel,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 30,
                          height: 1.6,
                        ),
                      ),
                      Text('الساعة $timeLabel $period بتوقيت القاهرة'),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: InvitationTheme.ivory,
                      border: Border.all(color: InvitationTheme.line),
                    ),
                    child: Text(
                      invitation.venueName.replaceFirst(' - ', '\n'),
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 29,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const Text(
                    'بحضوركم تكتمل فرحتنا',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 28,
                      height: 1.6,
                    ),
                  ),
                  const Text(
                    '∞',
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 44,
                      height: 1,
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
