import 'package:flutter/material.dart';
import 'package:sudoku/themes/theme_config.dart';

final brownThemeConfig = ThemeConfig(
  name: "Marrom",
  primaryColor: const Color.fromRGBO(125, 79, 35, 1),
  secondaryColor: const Color.fromRGBO(196, 151, 91, 1),
  tertiaryColor: const Color.fromARGB(255, 234, 209, 166),
  onPrimaryColor: Colors.white,
);

final darkBlueThemeConfig = ThemeConfig(
  name: "Azul escuro",
  primaryColor: const Color.fromRGBO(58, 128, 186, 1),
  secondaryColor: const Color.fromRGBO(16, 55, 82, 1),
  tertiaryColor: const Color.fromRGBO(6, 18, 36, 1),
  onPrimaryColor: Colors.white,
);

final waterGreenThemeConfig = ThemeConfig(
  name: "Verde água",
  primaryColor: const Color.fromARGB(255, 16, 109, 80),
  secondaryColor: const Color.fromARGB(255, 141, 218, 205),
  tertiaryColor: const Color.fromARGB(255, 210, 253, 233),
  onPrimaryColor: Colors.white,
);

final whiteThemeConfig = ThemeConfig(
  name: "Branco",
  primaryColor: const Color.fromARGB(255, 39, 91, 137),
  secondaryColor: const Color.fromARGB(255, 141, 199, 218),
  tertiaryColor: const Color.fromARGB(255, 255, 255, 255),
  onPrimaryColor: Colors.white,
);
