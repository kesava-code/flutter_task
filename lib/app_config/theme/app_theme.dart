// File: lib/app_config/theme/app_theme.dart
import 'package:flutter/material.dart';

const _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff31628d),
  surfaceTint: Color(0xff31628d),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffcfe5ff),
  onPrimaryContainer: Color(0xff124a73),
  secondary: Color(0xff526070),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffd5e4f7),
  onSecondaryContainer: Color(0xff3a4857),
  tertiary: Color(0xff695779),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xfff0dbff),
  onTertiaryContainer: Color(0xff514060),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff93000a),
  surface: Color(0xfff7f9ff),
  onSurface: Color(0xff181c20),
  onSurfaceVariant: Color(0xff42474e),
  outline: Color(0xff72777f),
  outlineVariant: Color(0xffc2c7cf),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff2d3135),
  inversePrimary: Color(0xff9dcbfb),
  primaryFixed: Color(0xffcfe5ff),
  onPrimaryFixed: Color(0xff001d34),
  primaryFixedDim: Color(0xff9dcbfb),
  onPrimaryFixedVariant: Color(0xff124a73),
  secondaryFixed: Color(0xffd5e4f7),
  onSecondaryFixed: Color(0xff0f1d2a),
  secondaryFixedDim: Color(0xffbac8da),
  onSecondaryFixedVariant: Color(0xff3a4857),
  tertiaryFixed: Color(0xfff0dbff),
  onTertiaryFixed: Color(0xff241532),
  tertiaryFixedDim: Color(0xffd4bee6),
  onTertiaryFixedVariant: Color(0xff514060),
  surfaceDim: Color(0xffd8dae0),
  surfaceBright: Color(0xfff7f9ff),
  surfaceContainerLowest: Color(0xffffffff),
  surfaceContainerLow: Color(0xfff2f3f9),
  surfaceContainer: Color(0xffeceef4),
  surfaceContainerHigh: Color(0xffe6e8ee),
  surfaceContainerHighest: Color(0xffe0e2e8),
);

const _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff9dcbfb),
  surfaceTint: Color(0xff9dcbfb),
  onPrimary: Color(0xff003355),
  primaryContainer: Color(0xff124a73),
  onPrimaryContainer: Color(0xffcfe5ff),
  secondary: Color(0xffbac8da),
  onSecondary: Color(0xff243240),
  secondaryContainer: Color(0xff3a4857),
  onSecondaryContainer: Color(0xffd5e4f7),
  tertiary: Color(0xffd4bee6),
  onTertiary: Color(0xff392a49),
  tertiaryContainer: Color(0xff514060),
  onTertiaryContainer: Color(0xfff0dbff),
  error: Color(0xffffb4ab),
  onError: Color(0xff690005),
  errorContainer: Color(0xff93000a),
  onErrorContainer: Color(0xffffdad6),
  surface: Color(0xff101418),
  onSurface: Color(0xffe0e2e8),
  onSurfaceVariant: Color(0xffc2c7cf),
  outline: Color(0xff8c9199),
  outlineVariant: Color(0xff42474e),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffe0e2e8),
  inversePrimary: Color(0xff31628d),
  primaryFixed: Color(0xffcfe5ff),
  onPrimaryFixed: Color(0xff001d34),
  primaryFixedDim: Color(0xff9dcbfb),
  onPrimaryFixedVariant: Color(0xff124a73),
  secondaryFixed: Color(0xffd5e4f7),
  onSecondaryFixed: Color(0xff0f1d2a),
  secondaryFixedDim: Color(0xffbac8da),
  onSecondaryFixedVariant: Color(0xff3a4857),
  tertiaryFixed: Color(0xfff0dbff),
  onTertiaryFixed: Color(0xff241532),
  tertiaryFixedDim: Color(0xffd4bee6),
  onTertiaryFixedVariant: Color(0xff514060),
  surfaceDim: Color(0xff101418),
  surfaceBright: Color(0xff36393e),
  surfaceContainerLowest: Color(0xff0b0e12),
  surfaceContainerLow: Color(0xff181c20),
  surfaceContainer: Color(0xff1d2024),
  surfaceContainerHigh: Color(0xff272a2f),
  surfaceContainerHighest: Color(0xff32353a),
);

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: _lightColorScheme.surface,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
       elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightColorScheme.primary,
          foregroundColor: _lightColorScheme.onPrimary,
          disabledBackgroundColor: _lightColorScheme.outline,
          disabledForegroundColor: _lightColorScheme.outlineVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _lightColorScheme.primary),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: _darkColorScheme.surface,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkColorScheme.primary,
          foregroundColor: _darkColorScheme.onPrimary,
          disabledBackgroundColor: _darkColorScheme.outline,
          disabledForegroundColor: _darkColorScheme.outlineVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _darkColorScheme.primary),
      ),
    );
  }
}
