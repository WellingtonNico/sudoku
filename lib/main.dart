import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku/screens/game/index.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          scaffoldBackgroundColor: const Color.fromARGB(255, 44, 44, 44)),
      themeMode: ThemeMode.dark,
      home: const GameScreen(),
    );
  }
}
