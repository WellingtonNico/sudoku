import 'package:flutter/material.dart';

class ThemeConfig {
  String name;
  Color primaryColor;
  Color tertiaryColor;
  Color secondaryColor;
  Color onPrimaryColor;

  ThemeConfig({
    required this.name,
    required this.primaryColor,
    required this.tertiaryColor,
    required this.secondaryColor,
    required this.onPrimaryColor,
  });

  ButtonStyle get buttonStyle => ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(onPrimaryColor),
        backgroundColor: WidgetStatePropertyAll(primaryColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      );

  ThemeData get themeData => ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          onPrimary: onPrimaryColor,
          surface: primaryColor,
          onSurface: primaryColor,
          secondary: secondaryColor,
          onSecondary: primaryColor,
          tertiary: tertiaryColor,
          onTertiary: primaryColor,
          primaryContainer: primaryColor,
          surfaceContainer: primaryColor,
        ),
        scaffoldBackgroundColor: tertiaryColor,
        textButtonTheme: TextButtonThemeData(
          style: buttonStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(primaryColor)),
        ),
      );
}
