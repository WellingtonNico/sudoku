import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku/themes/controller.dart';
import 'package:sudoku/themes/theme_config.dart';

class ThemeSelectorDialog extends StatelessWidget {
  const ThemeSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return AlertDialog(
      title: const Text(
        'Selecione o tema',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Obx(() {
          return ListBody(
            children: [
              ...themeOptionsButtons(
                themeController.themeOptions,
                themeController.themeConfig,
                themeController.setTheme,
              ),
              const SizedBox(height: 20),
              cancelButton()
            ],
          );
        }),
      ),
    );
  }

  TextButton cancelButton() {
    return TextButton(
      onPressed: Navigator.of(Get.context!).pop,
      child: const Text(
        "Cancelar",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Iterable<Widget> themeOptionsButtons(
    List<ThemeConfig> themeOptions,
    ThemeConfig currentConfig,
    Function(ThemeConfig) onSelectTheme,
  ) =>
      themeOptions.where((t) => t.name != currentConfig.name).map(
            (theme) => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.tertiaryColor,
                  foregroundColor: theme.primaryColor,
                ),
                onPressed: () {
                  onSelectTheme(theme);
                  Navigator.of(Get.context!).pop();
                },
                child: Text(theme.name),
              ),
            ),
          );
}
