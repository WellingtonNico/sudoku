import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku/screens/menu/index.dart';
import 'package:sudoku/themes/configs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      theme: woodTheme,
      themeMode: ThemeMode.light,
      home: const MenuScreen(),
    );
  }
}
