import 'package:flutter/material.dart';

abstract final class InvitationTheme {
  static const paper = Color(0xFFF0EAE1);
  static const ivory = Color(0xFFE0D6C7);
  static const stone = Color(0xFFAA9F8B);
  static const gold = Color(0xFF796B58);
  static const ink = Color(0xFF302C27);
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
        backgroundColor: gold,
        foregroundColor: paper,
        minimumSize: const Size(180, 52),
        textStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 12,
          letterSpacing: 1.2,
        ),
        shape: const RoundedRectangleBorder(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        side: const BorderSide(color: muted, width: .7),
        minimumSize: const Size(160, 48),
        shape: const RoundedRectangleBorder(),
        textStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10,
          letterSpacing: 1.8,
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
