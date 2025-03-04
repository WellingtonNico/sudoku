import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

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

  bool obterIsFinalizado() {
    return quantidadeDeErros >= 3 || numeros.every((n) => n.isRevelado);
  }

  int obterQuantidadeRevelados() {
    return numeros.where((n) => n.isRevelado).length;
  }

  void inicializar(String nivel) {
    this.nivel = nivel;
    jogadas = [];
    criarNumeros();
    resolver();
    removerCasasAleatorias();
    quantidadeDeErros = 0;
    isIniciado = true;
  }

  void criarNumeros() {
    numeros.clear();
    int index = 0;
    for (int linha = 1; linha <= 9; linha++) {
      for (int coluna = 1; coluna <= 9; coluna++) {
        numeros.add(
          Numero(
            index: index,
            game: this,
            linha: linha,
            coluna: coluna,
            quadrante: calcularNumeroDoQuadrante(linha, coluna),
            valor: 0,
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

  bool resolver() {
    final vazio = obterPrimeiroVazio();
    if (vazio == null) {
      return true;
    }
    final valoresDisponiveis = [...lista9];
    valoresDisponiveis.shuffle();
    for (int n = 0; n < 9; n++) {
      final possivelValor = valoresDisponiveis[n];
      if (vazio.isOpcaoValida(possivelValor)) {
        vazio.valor = possivelValor;
        if (resolver()) {
          return true;
        }
        vazio.valor = 0;
      }
    }
    return false;
  }

  removerCasasAleatorias() {
    var qtdCasasParaRemover = getQuantidadeCasasVazias();
    Random rand = Random();
    while (qtdCasasParaRemover > 0) {
      int index = rand.nextInt(81);
      if (numeros[index].valor > 0) {
        numeros[index].valor = 0;
        numeros[index].isDica = false;
        qtdCasasParaRemover--;
      }
    }
  }

  bool podeSerResolvido() {
    gerarBackup();
    resolver();
    final vazio = obterPrimeiroVazio();
    restaurarBackup();
    return vazio == null;
  }

  restaurarBackup() {
    for (Numero n in numeros) {
      n.valor = backup[n.index];
    }
  }

  gerarBackup() {
    backup = numeros.map((n) => n.valor).toList();
  }

  desfazerJogada() {
    if (jogadas.isNotEmpty) {
      final index = jogadas.removeLast();
      numeros[index].valor = 0;
    }
  }

  int calcularNumeroDoQuadrante(int linha, int coluna) {
    final horizontal = (coluna / 3).ceil();
    final vertical = (linha / 3).ceil();
    return vertical * 3 - (3 - horizontal);
  }

  List<Numero> obterNumerosDoQuadrante(int quadrante) {
    return numeros.where((n) => n.quadrante == quadrante).toList();
  }

  List<int> obterValoresDoQuadrante(int quadrante) {
    return obterNumerosDoQuadrante(quadrante)
        .where((n) => n.valor != 0)
        .map((n) => n.valor)
        .toList();
  }

  List<int> obterValoresDaLinha(int linha) {
    return numeros
        .where((n) => n.valor != 0 && n.linha == linha)
        .map((n) => n.valor)
        .toList();
  }

  List<int> obterValoresDaColuna(int coluna) {
    return numeros
        .where((n) => n.valor != 0 && n.coluna == coluna)
        .map((n) => n.valor)
        .toList();
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
  bool get isRevelado => valor > 0;
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

  Numero obterClone() {
    return Numero(
      index: index,
      coluna: coluna,
      linha: linha,
      valor: valor,
      quadrante: quadrante,
      game: game,
      anotacoes: anotacoes,
    );
  }

  gerarAnotacoes() {
    if (valor > 0) {
      return;
    }
    for (int i = 1; i <= 9; i++) {
      if (isOpcaoValida(i)) {
        if (!anotacoes.contains(i)) {
          anotacoes.add(i);
        }
      }
    }
    valor = 0;
  }

  bool isOpcaoValida(int input) {
    var possiveisDuplicados = game.numeros.where((n) =>
        n.valor == input &&
        (n.linha == linha || n.coluna == coluna || n.quadrante == quadrante));
    return possiveisDuplicados.isEmpty;
  }

  bool onInput(int input) {
    if (!isOpcaoValida(input)) {
      game.quantidadeDeErros++;
      HapticFeedback.vibrate();
      return false;
    }
    game.gerarBackup();
    valor = input;
    if (!game.podeSerResolvido()) {
      game.restaurarBackup();
      valor = 0;
      return false;
    }
    valor = input;
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

  bool isEqualTo(Numero? numero) {
    return numero != null && numero.index == index;
  }
}
