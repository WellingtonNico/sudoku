import 'package:flutter/material.dart';
import 'package:sudoku/helpers/colors.dart';
import 'package:sudoku/themes/theme_config.dart';

final woodTheme = ThemeConfig(
  description: "Madeira",
  darkColor: convertHexStringToColor("#7d4f23"),
  lightColor: convertHexStringToColor("#e6c690"),
  mediumColor: convertHexStringToColor("#C4975B"),
  textOnPrimaryColor: Colors.white,
).themeData;
