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

  final RxBool _jogoIniciado = RxBool(false);
  bool get jogoIniciado => _jogoIniciado.value;

  final RxBool _jogoFinalizado = RxBool(false);
  bool get jogoFinalizado => _jogoFinalizado.value;

  final RxInt _quantidadeDeErros = RxInt(0);
  int get quantidadeDeErros => _quantidadeDeErros.value;

  final RxBool _gerandoAnotacoes = RxBool(false);
  bool get gerandoAnotacoes => _gerandoAnotacoes.value;

  final RxList<Numero> _numeros = RxList([]);
  List<Numero> get numeros => _numeros.toList();

  iniciarGame(int casasVazias) async {
    _numeros.value = [];
    _numeroEmFoco.value = null;
    _jogoIniciado.value = false;
    _quantidadeDeErros.value = 0;
    _iniciandoJogo.value = true;
    _game.value.inicializar(casasVazias);
    _numeros.value = game.numeros;
    _iniciandoJogo.value = false;
    _jogoIniciado.value = true;
  }

  finalizar() {
    _jogoIniciado.value = false;
    _jogoFinalizado.value = false;
  }

  gerarAnotacoes() {
    if(gerandoAnotacoes){
      return;
    }
    _gerandoAnotacoes.value = true;
    _game.value.gerarAnotacoes();
    _numeros.value = [...game.numeros];
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
    if(gerandoAnotacoes){
      return;
    }
    _numeroEmFoco.value = numero;    
  }

  onInput(int valor) {
    if (!numeroEmFoco!.onInput(valor)) {
      _quantidadeDeErros.value++;
      if (_quantidadeDeErros.value >= 3) {
        _jogoIniciado.value = false;
      }
    } else {
      _numeroEmFoco.refresh();
    }
    _numeros.refresh();
    _jogoFinalizado.value = game.obterIsFinalizado();
  }

  onAnotate(int input) {
    numeroEmFoco!.onAnotate(input);    
    _numeros.refresh();
    _numeroEmFoco.refresh();
  }
}
