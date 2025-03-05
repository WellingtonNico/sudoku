import 'package:flutter/material.dart';
import 'package:sudoku/helpers/colors.dart';
import 'package:sudoku/themes/theme_config.dart';

final woodTheme = ThemeConfig(
  description: "Madeira",
  primaryColor: convertHexStringToColor("#7d4f23"),
  secondaryColor: convertHexStringToColor("#C4975B"),
  tertiaryColor: convertHexStringToColor("#e6c690"),
  onPrimaryColor: Colors.white,
).themeData;

final darkBlueTheme = ThemeConfig(
  description: "Azul escuro",
  primaryColor: convertHexStringToColor("#3a80ba"),
  secondaryColor: convertHexStringToColor("#103752"),
  tertiaryColor: convertHexStringToColor("#061224"),
  onPrimaryColor: Colors.white,
).themeData;
