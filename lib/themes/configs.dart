import 'package:flutter/material.dart';
import 'package:sudoku/themes/theme_config.dart';

final brownThemeConfig = ThemeConfig(
  name: "Marrom",
  primaryColor: const Color.fromARGB(255, 100, 61, 25),
  secondaryColor: const Color.fromARGB(255, 219, 179, 127),
  tertiaryColor: const Color.fromARGB(255, 234, 209, 166),
  onPrimaryColor: Colors.white,
);

final brownReverseThemeConfig = ThemeConfig(
  name: "Marrom invertido",
  primaryColor: const Color.fromARGB(255, 247, 199, 116),
  secondaryColor: const Color.fromARGB(255, 83, 48, 17),
  tertiaryColor: const Color.fromARGB(255, 52, 30, 7),
  onPrimaryColor: Colors.white,
);

final darkBlueThemeConfig = ThemeConfig(
  name: "Azul escuro",
  primaryColor: const Color.fromARGB(255, 96, 177, 242),
  secondaryColor: const Color.fromARGB(255, 9, 28, 56),
  tertiaryColor: const Color.fromARGB(255, 5, 15, 31),
  onPrimaryColor: Colors.white,
);

final waterGreenThemeConfig = ThemeConfig(
  name: "Verde água",
  primaryColor: const Color.fromARGB(255, 16, 109, 80),
  secondaryColor: const Color.fromARGB(255, 191, 245, 236),
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

final blackWithBlueThemeConfig = ThemeConfig(
  name: "Preto e azul",
  primaryColor: const Color.fromARGB(255, 57, 118, 170),
  secondaryColor: const Color.fromARGB(255, 23, 45, 62),
  tertiaryColor: Colors.black,
  onPrimaryColor: Colors.white,
);

final blackWithGreenThemeConfig = ThemeConfig(
  name: "Preto e verde",
  primaryColor: const Color.fromARGB(255, 67, 202, 69),
  secondaryColor: const Color.fromARGB(255, 15, 37, 12),
  tertiaryColor: Colors.black,
  onPrimaryColor: Colors.white,
);
