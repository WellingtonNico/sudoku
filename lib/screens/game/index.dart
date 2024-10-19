import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:sudoku/screens/game/controller.dart';
import 'package:sudoku/screens/game/grid.dart';
import 'package:sudoku/screens/game/informacoes.dart';
import 'package:sudoku/screens/game/teclado.dart';

class GameScreen extends StatelessWidget {
  final String nivel;
  const GameScreen({super.key, required this.nivel});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GameController(nivel));
    return PopScope(
      onPopInvoked: (_) => Get.delete<GameController>(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Obx(
            () => AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: controller.gerarAnotacoes,
                  icon: controller.gerandoAnotacoes
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.mode_edit_outlined),
                ),
                const SizedBox(width: 20)
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Obx(
            () {
              final isFinalizado = controller.jogoFinalizado;
              if (controller.iniciandoJogo) {
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
                    if (isFinalizado)
                      ElevatedButton(
                        onPressed: controller.reiniciar,
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
