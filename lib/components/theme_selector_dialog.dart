import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku/themes/controller.dart';
import 'package:sudoku/themes/theme_config.dart';

class ThemeSelectorDialog extends StatelessWidget {
  const ThemeSelectorDialog({super.key});

  static void show() => showDialog(
        context: Get.context!,
        builder: (_) => const ThemeSelectorDialog(),
      );

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return AlertDialog(
      title: const Text(
        'Selecione o tema',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text(
            "Cancelar",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        )
      ],
      content: SingleChildScrollView(
        child: Obx(() {
          return ListBody(
            children: themeOptionsButtons(
              themeController.themeOptions,
              themeController.themeConfig,
              themeController.setTheme,
            ).toList(),
          );
        }),
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
                  Get.back();
                },
                child: Text(theme.name),
              ),
            ),
          );
}
