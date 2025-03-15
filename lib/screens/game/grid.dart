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
      final numeros = controller.game?.numeros;
      final quadrantes = _obterNumerosPorQuadranteOrdenados(numeros ?? []);
      return Container(
        color: Theme.of(context).colorScheme.primary,
        width: MediaQuery.of(context).size.width - 10,
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
            for (var numerosDoQuadrante in quadrantes)
              Quadrante(numerosDoQuadrante: numerosDoQuadrante)
          ],
        ),
      );
    });
  }

  Iterable<List<Numero>> _obterNumerosPorQuadranteOrdenados(
      List<Numero> numeros) sync* {
    for (int i = 1; i <= 9; i++) {
      List<Numero> numerosDoQuadrante =
          numeros.where((numero) => numero.quadrante == i).toList();
      yield* [numerosDoQuadrante];
    }
  }
}

class Quadrante extends StatelessWidget {
  final List<Numero> numerosDoQuadrante;
  const Quadrante({super.key, required this.numerosDoQuadrante});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: .5,
      mainAxisSpacing: .5,
      crossAxisCount: 3,
      children: numerosDoQuadrante
          .map((numero) => CasaNumero(numero: numero))
          .toList(),
    );
  }
}

class CoresConfig {
  Color corDeFundo;
  Color corDoTexto;

  CoresConfig({required this.corDeFundo, required this.corDoTexto});
}

class CasaNumero extends StatelessWidget {
  final Numero numero;
  const CasaNumero({super.key, required this.numero});

  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.find();

    return Obx(() {
      final numeroEmFoco = controller.numeroEmFoco;

      final coresConfig = _getCoresConfig(context, numeroEmFoco);

      return InkWell(
        onTap: () => controller.onTapNumero(numero),
        child: Container(
          color: coresConfig.corDeFundo,
          child: numero.isRevelado
              ? Center(
                  child: Text(
                    numero.valor.toString(),
                    style:
                        TextStyle(fontSize: 32, color: coresConfig.corDoTexto),
                  ),
                )
              : Anotacoes(numero: numero),
        ),
      );
    });
  }

  CoresConfig _getCoresConfig(BuildContext context, Numero? numeroEmFoco) {
    final colorScheme = Theme.of(context).colorScheme;

    if (numero == numeroEmFoco) {
      // se o número focado é este mesmo
      return CoresConfig(
        corDeFundo: colorScheme.primary,
        corDoTexto: colorScheme.onPrimary,
      );
    }

    if (numeroEmFoco != null) {
      // se um número está sendo focado

      if (numeroEmFoco.valor == numero.valor &&
          numero.areTodosDoMesmoValorRevelados) {
        // se o já foram todos revelados do mesmo número
        return CoresConfig(
          corDeFundo: colorScheme.secondary,
          corDoTexto: colorScheme.onSecondary,
        );
      }

      if (!numeroEmFoco.areTodosDoMesmoValorRevelados &&
          (numero.quadrante == numeroEmFoco.quadrante ||
              numero.linha == numeroEmFoco.linha ||
              numero.coluna == numeroEmFoco.coluna)) {
        // se há um número sendo focado e precisa de um highlight no quadrante linha ou coluna
        return CoresConfig(
          corDeFundo: colorScheme.secondary,
          corDoTexto: colorScheme.onSecondary,
        );
      }

      if (numeroEmFoco.isRevelado &&
          numero.isRevelado &&
          numeroEmFoco.valor == numero.valor &&
          numeroEmFoco.quadrante != numero.quadrante &&
          numero.isRevelado) {
        // se o número focado é do mesmo valor mas de um quadrante diferente
        return CoresConfig(
          corDeFundo: colorScheme.primary,
          corDoTexto: colorScheme.onPrimary,
        );
      }
    }

    if (numero.isReveladoPeloUsuario) {
      // se o número foi revelado pelo usuário
      return CoresConfig(
        corDeFundo: colorScheme.tertiary,
        corDoTexto: colorScheme.onTertiary.withOpacity(.6),
      );
    }

    // default
    return CoresConfig(
      corDeFundo: colorScheme.tertiary,
      corDoTexto: colorScheme.onTertiary,
    );
  }
}

class Anotacoes extends StatelessWidget {
  final Numero numero;
  const Anotacoes({super.key, required this.numero});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      children: [
        for (var n in lista9)
          if (numero.anotacoes.contains(n))
            _numeroAnotadoWidget(n, numero, context)
          else
            const SizedBox.shrink()
      ],
    );
  }

  Widget _numeroAnotadoWidget(int valor, Numero numero, BuildContext context) {
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
}
