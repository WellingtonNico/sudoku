import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:sudoku/screens/game/controller.dart';

class SudokuInformacoes extends StatelessWidget {
  const SudokuInformacoes({super.key});

  @override
  Widget build(BuildContext context) {
    GameController controller = Get.find();
    final containerWidth = (MediaQuery.of(context).size.width - 40) * 0.333;
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: containerWidth,
              child: Text('${controller.game!.obterQuantidadeRevelados()}/81'),
            ),
            SizedBox(
              width: containerWidth,
              child: Text(
                'Nível ${controller.game!.nivel}',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: containerWidth,
              child: Text(
                'Erros ${controller.game!.quantidadeDeErros}/3',
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      );
    });
  }
}
