import 'dart:isolate';

import 'package:get/state_manager.dart';
import 'package:sudoku/models/game.dart';

class GameController extends GetxController {
  final Rx<Game?> _game = Rx(null);
  Game? get game => _game.value;

  late final String nivel;

  final Rx<Numero?> _numeroEmFoco = Rx(null);
  Numero? get numeroEmFoco => _numeroEmFoco.value;

  final RxBool _iniciandoJogo = RxBool(true);
  bool get iniciandoJogo => _iniciandoJogo.value;

  final RxBool _jogoFinalizado = RxBool(false);
  bool get jogoFinalizado => _jogoFinalizado.value;

  final RxBool _gerandoAnotacoes = RxBool(false);
  bool get gerandoAnotacoes => _gerandoAnotacoes.value;

  GameController({required this.nivel}) {
    iniciarGame();
  }

  iniciarGame() async {
    _iniciandoJogo.value = true;
    _game.value = await Isolate.run(() => Game.fromNivel(nivel));
    _numeroEmFoco.value = null;
    _iniciandoJogo.value = false;
    _jogoFinalizado.value = false;
  }

  reiniciar() {
    iniciarGame();
  }

  gerarAnotacoes() {
    if (gerandoAnotacoes) {
      return;
    }
    _gerandoAnotacoes.value = true;
    _game.value!.gerarAnotacoes();
    _game.refresh();
    _gerandoAnotacoes.value = false;
  }

  onTapNumero(Numero numero) {
    if (gerandoAnotacoes) {
      return;
    }
    _numeroEmFoco.value = numero;
  }

  onInput(int valor) {
    numeroEmFoco!.onInput(valor);
    _numeroEmFoco.refresh();
    _game.refresh();
    _jogoFinalizado.value = game!.obterIsFinalizado();
  }

  onAnotate(int input) {
    numeroEmFoco!.onAnotate(input);
    _game.refresh();
    _numeroEmFoco.refresh();
  }

  limparNumeroEmFoco() {
    if (numeroEmFoco != null) {
      game!.numeros[numeroEmFoco!.index].limpar();
      _numeroEmFoco.refresh();
      _game.refresh();
    }
  }

  desfazerJogada() {
    game!.desfazerJogada();
    _game.refresh();
  }

  limparAnotacoes() {
    game!.limparAnotacoes();
    _game.refresh();
  }
}
