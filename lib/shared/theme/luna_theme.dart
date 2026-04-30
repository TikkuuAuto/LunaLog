import 'package:flutter/material.dart';

import 'luna_tokens.dart';

ThemeData buildDarkTheme() {
  const ColorScheme scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: LunaColors.moonViolet,
    onPrimary: Color(0xFF21254A),
    secondary: LunaColors.signalCyan,
    onSecondary: Color(0xFF042531),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    surface: LunaColors.stationDark,
    onSurface: Color(0xFFE8ECF8),
    surfaceContainerHighest: LunaColors.panelDarkHigh,
    onSurfaceVariant: Color(0xFFC1C6DA),
    outline: LunaColors.orbitLine,
    primaryContainer: Color(0xFF2C335A),
    onPrimaryContainer: Color(0xFFE1E0FF),
    secondaryContainer: Color(0xFF1C3945),
    onSecondaryContainer: Color(0xFFD0F4FF),
    tertiary: Color(0xFFFFC1D6),
    onTertiary: Color(0xFF472533),
    tertiaryContainer: Color(0xFF613B49),
    onTertiaryContainer: Color(0xFFFFD9E4),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surfaceDim: Color(0xFF0E1320),
    surfaceBright: Color(0xFF32384F),
    inverseSurface: Color(0xFFE8ECF8),
    onInverseSurface: Color(0xFF1B2031),
    inversePrimary: Color(0xFF535D90),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFFB6B8FF),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: LunaColors.voidBlack,
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: LunaColors.stationDark,
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        shape: LunaButtons.shape,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LunaColors.panelDark,
      border: OutlineInputBorder(
        borderRadius: LunaRadii.panel,
        borderSide: BorderSide.none,
      ),
    ),
  );
}

ThemeData buildLightTheme() {
  const ColorScheme scheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6069A3),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF1F6C85),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    surface: LunaColors.snow,
    onSurface: LunaColors.ink,
    surfaceContainerHighest: Color(0xFFE5E8F2),
    onSurfaceVariant: Color(0xFF444A61),
    outline: Color(0xFF757B93),
    primaryContainer: Color(0xFFDEE0FF),
    onPrimaryContainer: Color(0xFF1A245A),
    secondaryContainer: Color(0xFFD0EEF7),
    onSecondaryContainer: Color(0xFF001F28),
    tertiary: Color(0xFF8C4D67),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD8E5),
    onTertiaryContainer: Color(0xFF3A0A20),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surfaceDim: Color(0xFFDADCE5),
    surfaceBright: Color(0xFFF7F7FB),
    inverseSurface: Color(0xFF303443),
    onInverseSurface: Color(0xFFF1F1F7),
    inversePrimary: Color(0xFFBEC2FF),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFF6069A3),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFF1F4FA),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        shape: LunaButtons.shape,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: LunaRadii.panel,
        borderSide: BorderSide.none,
      ),
    ),
  );
}
