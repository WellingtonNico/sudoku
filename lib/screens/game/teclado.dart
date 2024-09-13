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
      final exibirNumeros = controller.numeroEmFoco?.isRevelado == false;
      final exibirBotaoLimpar = controller.numeroEmFoco?.isDica == false &&
          controller.numeroEmFoco?.isRevelado == true;
      final possuiJogadas = controller.game.jogadas.isNotEmpty;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (exibirNumeros) ...[
            getBotoesNumeros(
              20,
              controller.onAnotate,
              true,
            ),
            const SizedBox(height: 20),
            getBotoesNumeros(
              30,
              controller.onInput,
              false,
            ),
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (possuiJogadas)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: controller.desfazerJogada,
                      icon: const Icon(Icons.undo_outlined),
                    ),
                    const Text('Desfazer')
                  ],
                ),
              if (exibirBotaoLimpar)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: controller.limparNumeroEmFoco,
                      icon: const Icon(Icons.cleaning_services_outlined),
                    ),
                    const Text('Limpar')
                  ],
                )
            ],
          )
        ],
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
                      ? Colors.blueAccent
                      : const Color.fromARGB(135, 210, 210, 210),
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
