import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku/components/default_appbar.dart';
import 'package:sudoku/screens/game/controller.dart';
import 'package:sudoku/screens/game/grid.dart';
import 'package:sudoku/screens/game/informacoes.dart';
import 'package:sudoku/screens/game/teclado.dart';

class GameScreen extends StatelessWidget {
  final String nivel;
  const GameScreen({super.key, required this.nivel});

  @override
  Widget build(BuildContext context) {
    final GameController gameController = Get.put(GameController(nivel: nivel));

    return PopScope(
      onPopInvokedWithResult: (_, __) => Get.delete<GameController>(),
      child: GestureDetector(
        onTap: gameController.removerFoco,
        child: Scaffold(
          appBar: const DefaultAppBar(),
          body: SafeArea(
            child: Obx(
              () {
                if (gameController.iniciandoJogo) {
                  return _loadingFeedback();
                }
                return Column(
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Center _loadingFeedback() {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sudoku', style: TextStyle(fontSize: 35)),
          SizedBox(height: 20),
          Text(
            "Gerando um jogo maneiro,\naguarde...",
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            "Isso pode demorar um pouco.",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
