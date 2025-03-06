import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/themes/configs.dart';
import 'package:sudoku/themes/theme_config.dart';

class ThemeController extends GetxController {
  final Rx<ThemeConfig> _themeData = Rx(brownThemeConfig);

  ThemeConfig get themeConfig => _themeData.value;

  late SharedPreferences _prefs;

  List<ThemeConfig> themeOptions = [
    whiteThemeConfig,
    brownThemeConfig,
    brownReverseThemeConfig,
    darkBlueThemeConfig,
    waterGreenThemeConfig,
  ];

  void setTheme(ThemeConfig themeConfig) {
    _prefs.setString("theme", themeConfig.name);
    _themeData.value = themeConfig;
    update();
  }

  Future<void> loadSavedTheme() async {
    _prefs = await SharedPreferences.getInstance();
    String? themeName = _prefs.getString('theme');
    if (themeName != null) {
      ThemeConfig theme = themeOptions.firstWhere(
        (t) => t.name == themeName,
        orElse: () => brownThemeConfig,
      );
      setTheme(theme);
    }
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
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ...themeOptions
                    .where((t) => t.name != themeConfig.name)
                    .map((theme) {
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
                      child: Text(theme.name),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
