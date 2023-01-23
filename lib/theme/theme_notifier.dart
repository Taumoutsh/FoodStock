import 'package:flutter/material.dart';
import 'package:foodstock/theme/theme_mode.dart';
import 'package:logging/logging.dart';

class ThemeNotifier {
  static final log = Logger('ThemeNotifier');

  ValueNotifier<CustomThemeMode> currentTheme =
      ValueNotifier(CustomThemeMode.LIGHT_MODE);

  static final ThemeNotifier _instance = ThemeNotifier._internal();

  factory ThemeNotifier() {
    return _instance;
  }

  ThemeNotifier._internal();

  ThemeData? getCurrentTheme() {
    if (currentTheme.value == CustomThemeMode.LIGHT_MODE) {
        return lightTheme;
      } else {
        return darkTheme;
      }
  }

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: const TextTheme(
        bodySmall:
            TextStyle(fontSize: 16, color: Colors.black, letterSpacing: 0),
        titleMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFamily: ".AppleSystemUIFont",
            color: Colors.black,
            letterSpacing: 0),
        titleLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            fontFamily: ".AppleSystemUIFont",
            color: Colors.black,
            letterSpacing: 0)),
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFCFCDCD),
        onPrimary: Color(0xFFCFCDCD),
        secondary: Color(0xFF8B8787),
        onSecondary: Color(0xFF8B8787),
        tertiary: Color(0xFFE9E9E9),
        onTertiary: Color(0xFFE9E9E9),
        error: Color(0xFFF00000),
        onError: Color(0xFFF00000),
        background: Color(0xFFFFFFFF),
        onBackground: Color(0xFFFFFFFF),
        surface: Color(0x336B6B6B),
        onSurface: Color(0x336B6B6B),
        inversePrimary: Colors.black),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(
        bodySmall:
            TextStyle(fontSize: 16, color: Colors.white, letterSpacing: 0),
        titleMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFamily: ".AppleSystemUIFont",
            color: Colors.white,
            letterSpacing: 0),
        titleLarge: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          fontFamily: ".AppleSystemUIFont",
          color: Colors.white,
          letterSpacing: 0)),
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF505050),
        onPrimary: Color(0xFF505050),
        secondary: Color(0xFF969696),
        onSecondary: Color(0xFF969696),
        error: Color(0xFFF00000),
        onError: Color(0xFFF00000),
        background: Color(0xFF262626),
        onBackground: Color(0xFFFFFFFF),
        surface: Color(0x336B6B6B),
        onSurface: Color(0x336B6B6B),
        inversePrimary: Colors.white),
  );
}
