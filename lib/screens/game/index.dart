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
                    onPressed: ()=>controller.iniciarGame(45),
                    child: const Text('Iniciar jogo fácil'),
                  ),
                  ElevatedButton(
                    onPressed: ()=>controller.iniciarGame(50),
                    child: const Text('Iniciar jogo médio'),
                  ),
                  ElevatedButton(
                    onPressed: ()=>controller.iniciarGame(55),
                    child: const Text('Iniciar jogo difícil'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudoku', style: TextStyle(fontSize: 35)),
                SizedBox(height: 20),
                SudokuInformacoes(),
                SizedBox(height: 10),
                SudokuGrid(),
                SizedBox(height: 20),
                SudokuTeclado()
              ],
            ),
          );
        },
      ),
    );
  }
}
