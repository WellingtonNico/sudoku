import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:sudoku/screens/game/controller.dart';

class SudokuInformacoes extends StatelessWidget {
  const SudokuInformacoes({super.key});

  @override
  Widget build(BuildContext context) {
    GameController controller = Get.find();
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${controller.game.obterQuantidadeRevelados()}/81'),
            Text('Nível ${controller.game.nivel}'),
            Text('Erros ${controller.game.quantidadeDeErros}/3'),
          ],
        ),
      );
    });
  }
}
