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
    blackWithBlueThemeConfig,
    blackWithGreenThemeConfig
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
}
