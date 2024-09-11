import 'dart:math';

import 'package:get/get.dart';

const lista9 = [1, 2, 3, 4, 5, 6, 7, 8, 9];

enum Nivel {
  facil('Fácil'),
  medio('Médio'),
  dificil('Difícil');

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
  bool isDica = false;
  bool get isRevelado => valor > 0;
  bool get isDiagonal => [1, 3, 5, 7, 9].contains(quadrante);

  Numero({
    required this.game,
    required this.linha,
    required this.coluna,
    required this.quadrante,
    required this.valor,
  }) {
    isDica = valor > 0;
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
    final grid = game.toGrid();
    for (int i = 0; i < 9; i++) {
      if (grid[linha][i] == input || grid[i][coluna] == input) {
        return false;
      }
    }
    int startRow = linha - linha % 3;
    int startCol = coluna - coluna % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[startRow + i][startCol + j] == input) {
          return false;
        }
      }
    }
    return true;
  }

  bool onInput(int input) {
    if (!isOpcaoValida(input)) {
      game.quantidadeDeErros++;
      return false;
    }
    valor = input;
    if (game.podeSerResolvido()) {
      return true;
    } else {
      valor = 0;
      game.quantidadeDeErros++;
      return false;
    }
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

class Game {
  List<Numero> numeros = [];
  int quantidadeDeErros = 0;
  bool isIniciado = false;
  bool isFinalizado = false;
  Nivel? nivel;

  List<List<int>> toGrid() {
    List<List<int>> lista = [];
    for (int linha = 0; linha < 9; linha++) {
      lista.add(
        numeros.where((n) => n.linha == linha).map((n) => n.valor).toList(),
      );
    }

    return lista;
  }

  int obterQuantidadeCasasVazias() {
    switch (nivel) {
      case Nivel.facil:
        return 45;
      case Nivel.medio:
        return 55;
      default:

        /// nível difícil
        return 55;
    }
  }

  inicializar(Nivel nivel) async {
    this.nivel = nivel;
    criarNumeros();
    preencherQuadrantesDiagonais();
    resolverSudoku();
    removerNumerosAleatorios();
    quantidadeDeErros = 0;
    isIniciado = true;
    isFinalizado = false;
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

  void criarNumeros() {
    numeros.clear();
    for (int linha = 0; linha < 9; linha++) {
      for (int coluna = 0; coluna < 9; coluna++) {
        numeros.add(
          Numero(
            game: this,
            linha: linha,
            coluna: coluna,
            quadrante: calcularQuadranteIndex(linha, coluna),
            valor: 0,
          ),
        );
      }
    }
  }

  void preencherQuadrantesDiagonais() {
    final diagonais = [1, 5, 9, 3, 7];
    for (int diagonal in diagonais) {
      final numerosDoQuadrante = obterNumerosDoQuadrante(diagonal);
      if ([1, 5, 9].contains(diagonal)) {
        final nums = List.from(lista9);
        nums.shuffle();
        for (int index = 0; index < numerosDoQuadrante.length; index++) {
          numerosDoQuadrante[index].valor = nums[index];
        }
      } else {
        Random rand = Random();
        for (final numero in numerosDoQuadrante) {
          int? valor;
          do {
            valor = rand.nextInt(9) + 1;
          } while (!numero.isOpcaoValida(valor));
          numero.valor = valor;
        }
      }
    }
  }

  Numero? obterPrimeiroVazio() {
    return numeros.firstWhereOrNull((numero) => numero.valor == 0);
  }

  bool resolverSudoku() {
    final vazio = obterPrimeiroVazio();
    if (vazio == null) {
      return true;
    }
    for (int valor = 1; valor <= 9; valor++) {
      if (!vazio.isOpcaoValida(valor)) {
        print('negando valor $valor');
        continue;
      }
      ;
      vazio.valor = valor;
      if (resolverSudoku()) return true;
    }
    return false;
  }

  bool podeSerResolvido() {
    final numerosOriginais = List<Numero>.from(numeros);
    final pode = resolverSudoku();
    numeros = numerosOriginais;
    return pode;
  }

  removerNumerosAleatorios() {
    var casasVazias = obterQuantidadeCasasVazias();
    casasVazias = 0;
    Random rand = Random();
    while (casasVazias > 0) {
      int linha = rand.nextInt(9);
      int coluna = rand.nextInt(9);
      final numero =
          numeros.firstWhere((n) => n.linha == linha && n.coluna == coluna);
      if (numero.valor > 0) {
        numero.valor = 0;
        casasVazias--;
      }
    }
  }

  int calcularQuadranteIndex(int linha, int coluna) {
    final horizontal = ((coluna + 1) / 3).ceil();
    final vertical = ((linha + 1) / 3).ceil();
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
