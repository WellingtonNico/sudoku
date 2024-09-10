import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:sudoku/models/game.dart';
import 'package:sudoku/screens/game/controller.dart';

class SudokuTeclado extends StatelessWidget {
  const SudokuTeclado({super.key});

  @override
  Widget build(BuildContext context) {
    GameController controller = Get.find();
    return Obx(() {
      final opacity = controller.numeroEmFoco?.isRevelado == false ? 1.0 : 0.0;
      return Opacity(
        opacity: opacity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            getBotoesNumeros(
                20, opacity == 1 ? controller.onAnotate : null, true),
            const SizedBox(height: 20),
            getBotoesNumeros(
                30, opacity == 1 ? controller.onInput : null, false),
          ],
        ),
      );
    });
  }

  Widget getBotoesNumeros(
      double fontSize, Function(int)? onTap, bool isAnotacao) {
    GameController controller = Get.find();
    return Obx(() {
      final anotacoes = controller.numeroEmFoco?.anotacoes ?? [];
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int n in lista9)
            InkWell(
              onTap: () => onTap?.call(n),
              child: Container(
                width: 35,
                decoration: BoxDecoration(
                  color: isAnotacao && anotacoes.contains(n)
                      ? const Color.fromARGB(255, 75, 91, 110)
                      : const Color.fromARGB(137, 158, 158, 158),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    n.toString(),
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ),
            )
        ],
      );
    });
  }
}
