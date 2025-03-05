import 'package:flutter/material.dart';

class ThemeConfig {
  String description;
  Color darkColor;
  Color lightColor;
  Color mediumColor;
  Color textOnPrimaryColor;

  ThemeConfig({
    required this.description,
    required this.darkColor,
    required this.lightColor,
    required this.mediumColor,
    required this.textOnPrimaryColor,
  });

  ButtonStyle get buttonStyle => ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(textOnPrimaryColor),
        backgroundColor: WidgetStatePropertyAll(darkColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      );

  ThemeData get themeData => ThemeData(
        primaryColor: darkColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: darkColor,
          primary: darkColor,
          onPrimary: textOnPrimaryColor,
          surface: darkColor,
          onSurface: darkColor,
          secondary: mediumColor,
          onSecondary: darkColor,
          tertiary: lightColor,
          onTertiary: darkColor,
          primaryContainer: darkColor,
          surfaceContainer: darkColor,
        ),
        scaffoldBackgroundColor: lightColor,
        textButtonTheme: TextButtonThemeData(
          style: buttonStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle,
        ),
        iconButtonTheme: IconButtonThemeData(
          style:
              ButtonStyle(foregroundColor: WidgetStatePropertyAll(darkColor)),
        ),
      );
}
