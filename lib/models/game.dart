import 'dart:math';

import 'package:get/get.dart';

const lista9 = [1, 2, 3, 4, 5, 6, 7, 8, 9];

class Game {
  List<Numero> numeros = [];
  int quantidadeDeErros = 0;
  bool isIniciado = false;
  bool isFinalizado = false;
  Nivel? nivel;

  getQuantidadeCasasVazias() {
    switch (nivel) {
      case Nivel.facil:
        return 45;
      case Nivel.medio:
        return 50;
      default:
        return 55;
    }
  }

  gerarAnotacoes() {
    for (int index = 0; index < 81; index++) {
      numeros[index].gerarAnotacoes();
    }
  }

  bool obterIsFinalizado() {
    return numeros.every((n) => n.isRevelado);
  }

  int obterQuantidadeRevelados() {
    return numeros.where((n) => n.isRevelado).length;
  }

  void inicializar(Nivel nivel) {
    this.nivel = nivel;
    criarNumeros();
    preencherQuadrantesDiagonais();
    resolver();
    removerCasasAleatorias();
    quantidadeDeErros = 0;
    isIniciado = true;
  }

  void criarNumeros() {
    numeros.clear();
    for (int linha = 1; linha <= 9; linha++) {
      for (int coluna = 1; coluna <= 9; coluna++) {
        numeros.add(
          Numero(
              game: this,
              linha: linha,
              coluna: coluna,
              quadrante: calcularNumeroDoQuadrante(linha, coluna),
              valor: 0,
              anotacoes: []),
        );
      }
    }
  }

  void preencherQuadrantesDiagonais() {
    for (int quadrante in [1, 5, 9]) {
      final numerosDoQuadrante = obterNumerosDoQuadrante(quadrante);
      for (final n in numerosDoQuadrante) {
        Random rand = Random();
        int? valor;
        do {
          valor = rand.nextInt(9) + 1;
        } while (!n.isOpcaoValida(valor));
        n.valor = valor;
      }
    }
  }

  Numero? obterPrimeiroVazio() {
    return numeros.firstWhereOrNull((n) => n.valor == 0);
  }

  bool resolver() {
    final vazio = obterPrimeiroVazio();
    if (vazio == null) {
      return true;
    }
    for (int n = 1; n <= 9; n++) {
      if (vazio.isOpcaoValida(n)) {
        vazio.valor = n;
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
        qtdCasasParaRemover--;
      }
    }
  }

  bool podeSerResolvido() {
    final numerosBack = numeros.map((n) => n.obterClone()).toList();
    resolver();
    final vazio = obterPrimeiroVazio();
    numeros = numerosBack;
    return vazio == null;
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

enum Nivel {
  facil("Fácil"),
  medio("Médio"),
  dificil("Difícil");

  final String label;

  const Nivel(this.label);
}

class Numero {
  late Game game;
  late int linha;
  late int coluna;
  late int quadrante;
  int valor = 0;
  List<int> anotacoes = [];
  bool get isRevelado => valor > 0;
  bool get isDiagonal => [1, 3, 5, 7, 9].contains(quadrante);

  Numero({
    required this.game,
    required this.linha,
    required this.coluna,
    required this.quadrante,
    required this.valor,
    required this.anotacoes,
  });

  Numero obterClone() {
    return Numero(
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
      return false;
    }
    valor = input;
    if (!game.podeSerResolvido()) {
      valor = 0;
      return false;
    }
    final numerosParaRemoverAnotacao = game.numeros
        .where((n) =>
            n.linha == linha || n.coluna == coluna || n.quadrante == quadrante)
        .toList();
    for (Numero numero in numerosParaRemoverAnotacao) {
      numero.removerAnotacao(input);
    }
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
    if (numero == null) {
      return false;
    }
    return numero.linha == linha && numero.coluna == coluna;
  }
}
