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
                  const Text('Sudoku', style: TextStyle(fontSize: 35)),
                  const SizedBox(height: 20),
                  const Text(
                    'Selecione o nível do jogo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  for (var entry in controller.game.niveis.entries)
                    ElevatedButton(
                      onPressed: () => controller.iniciarGame(entry.key),
                      child: Text(entry.key),
                    ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [       
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: controller.gerarAnotacoes,
                        icon: gerandoAnotacoes
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.format_list_numbered),
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
                      onPressed: controller.reiniciar,
                      child: const Text('Reiniciar'),
                    )
                  else
                    const SudokuTeclado(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
