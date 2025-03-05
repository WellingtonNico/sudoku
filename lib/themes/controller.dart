import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku/themes/configs.dart';
import 'package:sudoku/themes/theme_config.dart';

class ThemeController extends GetxController {
  final Rx<ThemeConfig> _themeData = Rx(waterGreenThemeConfig);

  ThemeConfig get themeConfig => _themeData.value;

  List<ThemeConfig> themeOptions = [
    whiteThemeConfig,
    woodThemeConfig,
    darkBlueThemeConfig,
    waterGreenThemeConfig,
  ];

  void setTheme(ThemeConfig themeConfig) {
    _themeData.value = themeConfig;
    update();
  }

  void openThemeSelector() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Selecione o tema',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(Get.context!).colorScheme.tertiary,
          content: SingleChildScrollView(
            child: ListBody(
              children: themeOptions.map((theme) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.tertiaryColor,
                      foregroundColor: theme.primaryColor,
                    ),
                    onPressed: () {
                      setTheme(theme);
                      Navigator.of(context).pop();
                    },
                    child: Text(theme.description),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
