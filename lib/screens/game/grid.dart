import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:sudoku/models/game.dart';
import 'package:sudoku/screens/game/controller.dart';

class SudokuGrid extends StatelessWidget {
  const SudokuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    GameController controller = Get.find();
    return Obx(() {
      final numeros = controller.game.numeros;
      final quadrantes = obterNumerosPorQuadranteOrdenados(numeros);
      return Container(
        color: Theme.of(context).colorScheme.primary,
        width: MediaQuery.of(context).size.width - 20,
        child: GridView.count(
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          padding: const EdgeInsets.all(3),
          clipBehavior: Clip.none,
          addRepaintBoundaries: false,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          children: [
            for (var quadrante in quadrantes)
              quadranteWidget(quadrante, context)
          ],
        ),
      );
    });
  }

  Widget quadranteWidget(List<Numero> quadrante, BuildContext context) {
    GameController controller = Get.find();
    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: .5,
      mainAxisSpacing: .5,
      crossAxisCount: 3,
      children: [
        for (var numero in quadrante)
          InkWell(
            onTap: () => controller.onTapNumero(numero),
            child:
                containerNumeroWidget(numero, controller.numeroEmFoco, context),
          )
      ],
    );
  }

  Widget anotacoesWidget(Numero numero, BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      children: [
        for (var n in lista9)
          if (numero.anotacoes.contains(n))
            numeroAnotadoWidget(n, numero, context)
          else
            const SizedBox.shrink()
      ],
    );
  }

  Widget numeroAnotadoWidget(int valor, Numero numero, BuildContext context) {
    GameController controller = Get.find();
    return Obx(() {
      final valorNumeroEmFoco = controller.numeroEmFoco?.valor;
      final highlight = (valorNumeroEmFoco == valor &&
              controller.numeroEmFoco?.isRevelado == true) ||
          numero.index == controller.numeroEmFoco?.index;
      final isFundoSecundario = controller.numeroEmFoco != null &&
          !highlight &&
          (controller.numeroEmFoco?.quadrante == numero.quadrante ||
              controller.numeroEmFoco?.linha == numero.linha ||
              controller.numeroEmFoco?.coluna == numero.coluna);

      return Container(
        color: highlight ? Theme.of(context).colorScheme.primary : null,
        child: Center(
          child: Text(
            valor.toString(),
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 0,
              height: 1,
              color: highlight
                  ? Theme.of(context).colorScheme.onPrimary
                  : isFundoSecundario
                      ? Theme.of(context).colorScheme.onSecondary
                      : null,
            ),
          ),
        ),
      );
    });
  }

  Container containerNumeroWidget(
    Numero numero,
    Numero? numeroEmFoco,
    BuildContext context,
  ) {
    Color corDeFundo;
    Color corDoTexto;
    if (numero == numeroEmFoco) {
      // se o número focado é igual a este
      corDeFundo = Theme.of(context).colorScheme.primary;
      corDoTexto = Theme.of(context).colorScheme.onPrimary;
    } else if (numeroEmFoco != null &&
        numeroEmFoco.valor == numero.valor &&
        numero.areTodosDoMesmoValorRevelados) {
      // se o já foram todos revelados do mesmo número
      corDeFundo = Theme.of(context).colorScheme.secondary;
      corDoTexto = Theme.of(context).colorScheme.onSecondary;
    } else if (numeroEmFoco != null &&
        !numeroEmFoco.areTodosDoMesmoValorRevelados &&
        (numero.quadrante == numeroEmFoco.quadrante ||
            numero.linha == numeroEmFoco.linha ||
            numero.coluna == numeroEmFoco.coluna)) {
      // se há um número sendo focado e precisa de um highlight no quadrante linha ou coluna
      corDeFundo = Theme.of(context).colorScheme.secondary;
      corDoTexto = Theme.of(context).colorScheme.onSecondary;
    } else if (numero.isReveladoPeloUsuario) {
      // se o número foi revelado pelo usuário
      corDeFundo = Theme.of(context).colorScheme.tertiary;
      corDoTexto = Theme.of(context).colorScheme.onTertiary.withOpacity(.6);
    } else {
      // default
      corDeFundo = Theme.of(context).colorScheme.tertiary;
      corDoTexto = Theme.of(context).colorScheme.onTertiary;
    }

    return Container(
      color: corDeFundo,
      child: numero.isRevelado
          ? Center(
              child: Text(
                numero.valor.toString(),
                style: TextStyle(fontSize: 32, color: corDoTexto),
              ),
            )
          : anotacoesWidget(numero, context),
    );
  }

  Iterable<List<Numero>> obterNumerosPorQuadranteOrdenados(
      List<Numero> numeros) sync* {
    for (int i = 1; i <= 9; i++) {
      List<Numero> numerosDoQuadrante =
          numeros.where((numero) => numero.quadrante == i).toList();
      yield* [numerosDoQuadrante];
    }
  }
}
