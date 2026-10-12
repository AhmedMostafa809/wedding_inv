import 'package:flutter/material.dart';

abstract final class InvitationTheme {
  static const paper = Color(0xFFFFF8ED);
  static const ivory = Color(0xFFF4EADB);
  static const stone = Color(0xFF322B2C);
  static const gold = Color(0xFF890B20);
  static const ink = Color(0xFF463B36);
  static const muted = Color(0xFF746C61);
  static const line = Color(0xFFBEB3A3);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: gold,
      primary: gold,
      surface: paper,
      onSurface: ink,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 13, height: 1.65, color: ink),
      bodyLarge: TextStyle(fontSize: 15, height: 1.7, color: ink),
      headlineMedium: TextStyle(
        fontFamily: 'CormorantGaramond',
        fontStyle: FontStyle.italic,
        fontSize: 42,
        height: 1.1,
        color: ink,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ink,
        foregroundColor: paper,
        minimumSize: const Size(180, 58),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        elevation: 3,
        shadowColor: const Color(0x60302C27),
        side: const BorderSide(color: gold, width: 1.3),
        textStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        backgroundColor: paper,
        side: const BorderSide(color: gold, width: 1.5),
        minimumSize: const Size(160, 56),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    ),
  );

  static const display = TextStyle(
    fontFamily: 'CormorantGaramond',
    fontStyle: FontStyle.italic,
    fontSize: 48,
    height: .95,
    color: ink,
  );

  static const eyebrow = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 10,
    letterSpacing: 1.8,
    fontWeight: FontWeight.w600,
    color: muted,
  );

  static const script = TextStyle(
    fontFamily: 'GreatVibes',
    fontSize: 56,
    height: 1.35,
    color: ink,
  );

  static const arabic = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 19,
    height: 1.9,
    color: ink,
  );
}
