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
              controller.numeroEmFoco?.isRevelado == true ||
          (controller.numeroEmFoco?.isRevelado == false &&
              controller.numeroEmFoco?.anotacoes.isEmpty == false);
      final possuiJogadas = controller.game!.jogadas.isNotEmpty;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (exibirNumeros) ...[
            getBotoesNumeros(20, controller.onAnotate, true, context),
            const SizedBox(height: 20),
            getBotoesNumeros(30, controller.onInput, false, context),
          ],
          const SizedBox(height: 20),
          acoesWidget(possuiJogadas, controller, exibirBotaoLimpar)
        ],
      );
    });
  }

  Row acoesWidget(
      bool possuiJogadas, GameController controller, bool exibirBotaoLimpar) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              const Text('Desfazer\njogada', textAlign: TextAlign.center)
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
              const Text('Limpar\nnúmero', textAlign: TextAlign.center)
            ],
          ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: controller.gerarAnotacoes,
              icon: const Icon(Icons.flash_auto),
            ),
            const Text('Gerar\nanotações', textAlign: TextAlign.center)
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: controller.limparAnotacoes,
              icon: const Icon(Icons.clear_all_rounded),
            ),
            const Text('Limpar\nAnotações', textAlign: TextAlign.center)
          ],
        )
      ],
    );
  }

  Widget getBotoesNumeros(double fontSize, Function(int)? onTap,
      bool isAnotacao, BuildContext context) {
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
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    n.toString(),
                    style: TextStyle(
                      fontSize: fontSize,
                      color: isAnotacao && anotacoes.contains(n)
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            )
        ],
      );
    });
  }
}
