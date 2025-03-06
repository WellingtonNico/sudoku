import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku/models/game.dart';
import 'package:sudoku/screens/game/index.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Center(
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
              for (var entry in Game.niveis.entries)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => GameScreen(nivel: entry.key)),
                    child: Text(entry.key),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
