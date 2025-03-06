import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku/screens/game/controller.dart';
import 'package:sudoku/screens/game/grid.dart';
import 'package:sudoku/screens/game/informacoes.dart';
import 'package:sudoku/screens/game/teclado.dart';
import 'package:sudoku/themes/controller.dart';

class GameScreen extends StatelessWidget {
  final String nivel;
  const GameScreen({super.key, required this.nivel});

  @override
  Widget build(BuildContext context) {
    final GameController gameController = Get.put(GameController(nivel: nivel));
    final ThemeController themeController = Get.find();

    return PopScope(
      onPopInvokedWithResult: (_, __) => Get.delete<GameController>(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: themeController.openThemeSelector,
                icon: const Icon(Icons.palette),
              ),
              const SizedBox(width: 20)
            ],
          ),
        ),
        body: SafeArea(
          child: Obx(
            () {
              if (gameController.iniciandoJogo) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Sudoku', style: TextStyle(fontSize: 35)),
                    const SizedBox(height: 20),
                    const SudokuInformacoes(),
                    const SizedBox(height: 10),
                    const SudokuGrid(),
                    const SizedBox(height: 20),
                    if (gameController.jogoFinalizado)
                      ElevatedButton(
                        onPressed: gameController.reiniciar,
                        child: const Text('Reiniciar'),
                      )
                    else
                      const SudokuTeclado(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
