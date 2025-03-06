import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sudoku/screens/menu/index.dart';
import 'package:sudoku/themes/controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ThemeController themeController = ThemeController();
  await themeController.loadSavedTheme();
  Get.put(themeController);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final ThemeController controller = Get.find();
    return Obx(
      () => GetMaterialApp(
        theme: controller.themeConfig.themeData,
        themeMode: ThemeMode.light,
        home: const MenuScreen(),
      ),
    );
  }
}
