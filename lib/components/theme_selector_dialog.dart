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
            (theme) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: InkWell(
                  onTap: () {
                    onSelectTheme(theme);
                    Get.back();
                  },
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            color: theme.primaryColor,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            color: theme.secondaryColor,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            color: theme.tertiaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
}
