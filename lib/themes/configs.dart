import 'package:flutter/material.dart';
import 'package:sudoku/themes/theme_config.dart';

final brownThemeConfig = ThemeConfig(
  name: "Marrom",
  primaryColor: const Color.fromARGB(255, 100, 61, 25),
  secondaryColor: const Color.fromARGB(255, 219, 179, 127),
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
  primaryColor: const Color.fromARGB(255, 15, 67, 113),
  secondaryColor: const Color.fromARGB(255, 209, 233, 251),
  tertiaryColor: const Color.fromARGB(255, 255, 255, 255),
  onPrimaryColor: Colors.white,
);
