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
        color: Colors.white60,
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
            for (var quadrante in quadrantes) quadranteWidget(quadrante)
          ],
        ),
      );
    });
  }

  Widget quadranteWidget(List<Numero> quadrante) {
    GameController controller = Get.find();
    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: .5,
      mainAxisSpacing: .5,
      crossAxisCount: 3,
      children: [
        for (var numero in quadrante)
          Obx(
            () {
              final color = controller.getCorDoNumero(numero);
              return InkWell(
                onTap: () => controller.onTapNumero(numero),
                child: containerNumeroWidget(color, numero),
              );
            },
          ),
      ],
    );
  }

  Widget anotacoesWidget(Numero numero) {
    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      children: [
        for (var n in lista9)
          if (numero.anotacoes.contains(n))
            numeroAnotadoWidget(n)
          else
            const SizedBox.shrink()
      ],
    );
  }

  Widget numeroAnotadoWidget(int n) {
    GameController controller = Get.find();
    return Obx(() {
      final valorNumeroEmFoco = controller.numeroEmFoco?.valor;
      final highlight =
          valorNumeroEmFoco == n && controller.numeroEmFoco?.isRevelado == true;
      return Container(
        color: highlight ? Colors.blueAccent : null,
        child: Center(
          child: Text(
            n.toString(),
            style: const TextStyle(
              fontSize: 13,
              letterSpacing: 0,
              height: 1,
            ),
          ),
        ),
      );
    });
  }

  Container containerNumeroWidget(Color color, Numero numero) {
    return Container(
      color: color,
      child: numero.isRevelado
          ? Center(
              child: Text(
                numero.valor.toString(),
                style: const TextStyle(fontSize: 32),
              ),
            )
          : anotacoesWidget(numero),
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
