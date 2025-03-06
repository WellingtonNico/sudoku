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
      child: Scaffold(
        appBar: const DefaultAppBar(),
        body: SafeArea(
          child: Obx(
            () {
              if (gameController.iniciandoJogo) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
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
    );
  }
}
