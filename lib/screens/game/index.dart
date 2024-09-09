import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:sudoku/screens/game/controller.dart';
import 'package:sudoku/screens/game/grid.dart';
import 'package:sudoku/screens/game/informacoes.dart';
import 'package:sudoku/screens/game/teclado.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GameController());
    return Scaffold(
      body: Obx(
        () {
          final isFinalizado = controller.jogoFinalizado;
          final gerandoAnotacoes = controller.gerandoAnotacoes;
          if (controller.iniciandoJogo) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!controller.jogoIniciado) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => controller.iniciarGame(45),
                    child: const Text('Iniciar jogo fácil'),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.iniciarGame(50),
                    child: const Text('Iniciar jogo médio'),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.iniciarGame(55),
                    child: const Text('Iniciar jogo difícil'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: controller.gerarAnotacoes,
                      icon: gerandoAnotacoes
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.edit_calendar_outlined),
                    ),
                    const SizedBox(width: 20)
                  ],
                ),
                const Text('Sudoku', style: TextStyle(fontSize: 35)),
                const SizedBox(height: 20),
                const SudokuInformacoes(),
                const SizedBox(height: 10),
                const SudokuGrid(),
                const SizedBox(height: 20),
                if (isFinalizado)
                  ElevatedButton(
                    onPressed: controller.finalizar,
                    child: const Text('Finalizar'),
                  )
                else
                  const SudokuTeclado(),
              ],
            ),
          );
        },
      ),
    );
  }
}
