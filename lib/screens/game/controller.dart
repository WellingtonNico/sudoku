import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:sudoku/models/game.dart';

class GameController extends GetxController {
  final Rx<Game> _game = Rx(Game());
  Game get game => _game.value;

  final Rx<Numero?> _numeroEmFoco = Rx(null);
  Numero? get numeroEmFoco => _numeroEmFoco.value;

  final RxBool _iniciandoJogo = RxBool(false);
  bool get iniciandoJogo => _iniciandoJogo.value;

  final RxBool _jogoFinalizado = RxBool(false);
  bool get jogoFinalizado => _jogoFinalizado.value;

  final RxBool _gerandoAnotacoes = RxBool(false);
  bool get gerandoAnotacoes => _gerandoAnotacoes.value;

  iniciarGame(Nivel nivel) async {
    _numeroEmFoco.value = null;
    _iniciandoJogo.value = true;
    await _game.value.inicializar(nivel);
    _game.refresh();
    _iniciandoJogo.value = false;
  }

  finalizar() {
    _jogoFinalizado.value = false;
    _game.value.isIniciado = false;
  }

  gerarAnotacoes() {
    if (gerandoAnotacoes) {
      return;
    }
    _gerandoAnotacoes.value = true;
    _game.value.gerarAnotacoes();
    _game.refresh();
    _gerandoAnotacoes.value = false;
  }

  Color getCorDoNumero(Numero numero) {
    if (numero.isEqualTo(numeroEmFoco)) {
      return Colors.blueAccent;
    }
    if (numeroEmFoco != null &&
        (numero.quadrante == numeroEmFoco!.quadrante ||
            numero.linha == numeroEmFoco!.linha ||
            numero.coluna == numeroEmFoco!.coluna)) {
      return const Color.fromARGB(255, 82, 82, 82);
    }
    return Colors.grey[600]!;
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
    _jogoFinalizado.value = game.obterIsFinalizado();
  }

  onAnotate(int input) {
    numeroEmFoco!.onAnotate(input);
    _game.refresh();
    _numeroEmFoco.refresh();
  }

  
}
