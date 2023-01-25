import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodstock/theme/theme_mode.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier {

  static final log = Logger('ThemeNotifier');

  late ValueNotifier<CustomThemeMode> currentTheme;

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

  Future<void> initializeTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? themeInPreferences = sharedPreferences.getString("theme");
    if (themeInPreferences != null) {
      if (themeInPreferences == "dark") {
        currentTheme = ValueNotifier(CustomThemeMode.DARK_MODE);
      } else {
        currentTheme = ValueNotifier(CustomThemeMode.LIGHT_MODE);
      }
    } else {
      currentTheme = ValueNotifier(CustomThemeMode.LIGHT_MODE);
    }
  }

  void switchTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (currentTheme.value == CustomThemeMode.LIGHT_MODE) {
      currentTheme.value = CustomThemeMode.DARK_MODE;
      sharedPreferences.setString("theme", "dark");

    } else {
      currentTheme.value = CustomThemeMode.LIGHT_MODE;
      sharedPreferences.setString("theme", "light");
    }
  }

  final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    brightness: Brightness.light,
    textTheme: const TextTheme(
        bodySmall: TextStyle(
            fontSize: 16,
            color: Colors.black,
            letterSpacing: 0.15),
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
        inversePrimary: Colors.black,
        inverseSurface: Color(0xFFF5D208))
  );

  final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF0F1A1A),
    brightness: Brightness.dark,
    textTheme: const TextTheme(
        bodySmall: TextStyle(
            fontSize: 16,
            color: Colors.white,
            letterSpacing: 0.15),
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
        tertiary: Color(0xFF2B2B2B),
        onTertiary: Color(0xFF2B2B2B),
        error: Color(0xFFF00000),
        onError: Color(0xFFF00000),
        background: Color(0xFF0F1A1A),
        onBackground: Color(0xFFFFFFFF),
        surface: Color(0xFF101010),
        onSurface: Color(0xFF101010),
        inversePrimary: Colors.white,
        inverseSurface: Color(0xFF4A578A)),
  );
}
