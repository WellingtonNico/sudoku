import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

const lista9 = [1, 2, 3, 4, 5, 6, 7, 8, 9];

class Game {
  static const niveis = {
    "Fácil": 45,
    "Médio": 50,
    "Difícil": 55,
    "Extremo": 60,
    "Especialista": 64,
  };

  List<Numero> numeros = [];
  int quantidadeDeErros = 0;
  bool isIniciado = false;
  bool isFinalizado = false;
  late String nivel;
  List<int> backup = [];
  List<int> jogadas = [];

  getQuantidadeCasasVazias() {
    return niveis[nivel];
  }

  gerarAnotacoes() {
    for (int index = 0; index < 81; index++) {
      numeros[index].gerarAnotacoes();
    }
  }

  List<int> getPuzzle() =>
      numeros.map((n) => n.isRevelado ? n.valor : -1).toList();

  bool obterIsFinalizado() {
    return quantidadeDeErros >= 3 || numeros.every((n) => n.isRevelado);
  }

  int obterQuantidadeRevelados() {
    return numeros.where((n) => n.isRevelado).length;
  }

  Game.fromNivel(this.nivel) {
    jogadas = [];
    criarNumeros();
    removerCasasAleatorias();
    quantidadeDeErros = 0;
    isIniciado = true;
  }

  void criarNumeros() {
    numeros.clear();
    final sudoku = Sudoku.generate(Level.expert);
    int index = 0;
    for (int linha = 1; linha <= 9; linha++) {
      for (int coluna = 1; coluna <= 9; coluna++) {
        final valor = sudoku.solution[index];
        numeros.add(
          Numero(
            index: index,
            game: this,
            linha: linha,
            coluna: coluna,
            quadrante: calcularNumeroDoQuadrante(linha, coluna),
            valor: valor,
            anotacoes: [],
          ),
        );
        index++;
      }
    }
  }

  void preencherQuadrantesDiagonaisComNumerosAleatorios() {}

  Numero? obterPrimeiroVazio() {
    final numeroDiagonal = numeros.firstWhereOrNull(
        (n) => [1, 5, 9].contains(n.quadrante) && n.valor == 0);
    if (numeroDiagonal != null) {
      return numeroDiagonal;
    }
    final numeroDasQuinasRestantes = numeros
        .firstWhereOrNull((n) => [3, 7].contains(n.quadrante) && n.valor == 0);
    if (numeroDasQuinasRestantes != null) {
      return numeroDasQuinasRestantes;
    }
    return numeros.firstWhereOrNull((n) => n.valor == 0);
  }

  bool isSolucaoUnica() {
    final puzzle = getPuzzle();
    try {
      Sudoku(puzzle, strict: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  void removerCasasAleatorias() {
    var qtdCasasParaRemover = getQuantidadeCasasVazias();
    Random rand = Random();

    final quantidadeRestantePorValor = {
      1: 9,
      2: 9,
      3: 9,
      4: 9,
      5: 9,
      6: 9,
      7: 9,
      8: 9,
      9: 9
    };

    int tentativas = 600;

    while (qtdCasasParaRemover > 0 && tentativas > 0) {
      tentativas--;
      int index = rand.nextInt(81);
      final numeroASerRemovido = numeros[index];

      final restaSomenteUmDoMesmoValor =
          quantidadeRestantePorValor[numeroASerRemovido.valor] == 1;

      final jaTemUmValorComTodosRemovidos =
          quantidadeRestantePorValor.values.any((v) => v == 0);

      final vaiTerSomenteUmValorTotalmenteRemovido =
          !(restaSomenteUmDoMesmoValor && jaTemUmValorComTodosRemovidos);

      final quadranteTemPeloMenosDoisRestantes = numeros
              .where((n) =>
                  n.quadrante == numeroASerRemovido.quadrante && n.isRevelado)
              .length >=
          2;

      final podeSerRemovido = numeroASerRemovido.isRevelado &&
          quadranteTemPeloMenosDoisRestantes &&
          vaiTerSomenteUmValorTotalmenteRemovido;

      if (podeSerRemovido) {
        numeroASerRemovido.isRevelado = false;
        if (isSolucaoUnica()) {
          quantidadeRestantePorValor[numeroASerRemovido.valor] =
              quantidadeRestantePorValor[numeroASerRemovido.valor]! - 1;
          numeroASerRemovido.isDica = false;
          qtdCasasParaRemover--;
        } else {
          numeroASerRemovido.isRevelado = true;
        }
      }
    }
  }

  desfazerJogada() {
    if (jogadas.isNotEmpty) {
      final index = jogadas.removeLast();
      numeros[index].isRevelado = false;
    }
  }

  int calcularNumeroDoQuadrante(int linha, int coluna) {
    final horizontal = (coluna / 3).ceil();
    final vertical = (linha / 3).ceil();
    return vertical * 3 - (3 - horizontal);
  }

  limparAnotacoes() {
    for (var numero in numeros) {
      numero.anotacoes.clear();
    }
  }
}

class Numero {
  final int index;
  final Game game;
  final int linha;
  final int coluna;
  final int quadrante;
  int valor = 0;
  final List<int> anotacoes;
  bool isRevelado = true;
  bool get isReveladoPeloUsuario => isRevelado && !isDica;
  bool areTodosDoMesmoValorRevelados = false;
  bool get isDiagonal => [1, 3, 5, 7, 9].contains(quadrante);
  bool isDica = true;

  Numero({
    required this.index,
    required this.game,
    required this.linha,
    required this.coluna,
    required this.quadrante,
    required this.valor,
    required this.anotacoes,
  });

  gerarAnotacoes() {
    if (isRevelado) {
      return;
    }
    for (int i = 1; i <= 9; i++) {
      if (isOpcaoValida(i)) {
        if (!anotacoes.contains(i)) {
          anotacoes.add(i);
        }
      }
    }
  }

  bool isOpcaoValida(int input) {
    var possiveisDuplicados = game.numeros.where((n) =>
        n.valor == input &&
        n.isRevelado &&
        n.index != index &&
        (n.linha == linha || n.coluna == coluna || n.quadrante == quadrante));
    return possiveisDuplicados.isEmpty;
  }

  bool onInput(int input) {
    if (input != valor) {
      game.quantidadeDeErros++;
      HapticFeedback.vibrate();
      return false;
    }
    isRevelado = true;

    bool areTodosDoMesmoValorRevelados =
        game.numeros.where((n) => n.valor == valor && n.isRevelado).length == 9;

    if (areTodosDoMesmoValorRevelados) {
      for (Numero numero in game.numeros.where((n) => n.valor == valor)) {
        numero.areTodosDoMesmoValorRevelados = true;
      }
    }

    final numerosParaRemoverAnotacao = game.numeros
        .where((n) =>
            n.linha == linha || n.coluna == coluna || n.quadrante == quadrante)
        .toList();
    for (Numero numero in numerosParaRemoverAnotacao) {
      numero.removerAnotacao(input);
    }
    game.jogadas.add(index);
    return true;
  }

  onAnotate(int input) {
    if (anotacoes.contains(input)) {
      anotacoes.remove(input);
    } else {
      anotacoes.add(input);
    }
  }

  removerAnotacao(int input) {
    if (anotacoes.contains(input)) {
      anotacoes.remove(input);
    }
  }

  limpar() {
    if (isRevelado) {
      isRevelado = false;
    } else {
      anotacoes.clear();
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Numero && other.index == index;
  }

  @override
  int get hashCode => index;
}
