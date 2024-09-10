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
            for (var quadrante in quadrantes) getQuadranteGrid(quadrante)
          ],
        ),
      );
    });
  }

  Widget getQuadranteGrid(List<Numero> quadrante) {
    GameController controller = Get.find();
    return GridView.count(
      padding: EdgeInsets.zero,
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
                child: getContainerNumero(color, numero),
              );
            },
          ),
      ],
    );
  }

  Widget getGridAnotacoes(Numero numero) {
    return GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        children: [
          for (var n in lista9)
            if (numero.anotacoes.contains(n))
              Center(
                child: Text(
                  n.toString(),
                  style: const TextStyle(fontSize: 11, letterSpacing: 0),
                ),
              )
            else
              const SizedBox.shrink()
        ]);
  }

  Container getContainerNumero(Color color, Numero numero) {
    return Container(
      color: color,
      child: numero.valor > 0
          ? Center(
              child: Text(
                numero.valor > 0 ? numero.valor.toString() : '',
                style: TextStyle(fontSize: numero.valor == 0 ? 15 : 28),
              ),
            )
          : getGridAnotacoes(numero),
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
