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
      final quantidadeRevelados = controller.game.obterQuantidadeRevelados();
      final quantidadeDeErros = controller.game.quantidadeDeErros;
      final nivelLabel = controller.game.nivel?.label ?? '';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$quantidadeRevelados/81'),
            Text("Nível $nivelLabel"),
            Text('Erros $quantidadeDeErros/3'),
          ],
        ),
      );
    });
  }
}
