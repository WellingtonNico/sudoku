import 'dart:math';

const lista9 = [1, 2, 3, 4, 5, 6, 7, 8, 9];

class SudokuGenerator {
  List<List<int>> grid = [];

  void generateSudoku(int numHoles) {
    grid = List.generate(9, (_) => List.filled(9, 0));
    _fillDiagonalSubgrids();
    _solveSudoku();
    _removeNumbers(numHoles);
  }

  void _fillDiagonalSubgrids() {
    for (int i = 0; i < 9; i += 3) {
      _fillSubgrid(i, i);
    }
  }

  void _fillSubgrid(int row, int col) {
    List<int> nums = [...lista9]..shuffle();
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        grid[row + i][col + j] = nums.removeLast();
      }
    }
  }

  bool _canPlace(int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (grid[row][i] == num || grid[i][col] == num) {
        return false;
      }
    }

    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[startRow + i][startCol + j] == num) {
          return false;
        }
      }
    }

    return true;
  }

  bool _solveSudoku() {
    List<int> empty = _findEmpty();
    if (empty.isEmpty) {
      return true;
    }

    int row = empty[0];
    int col = empty[1];
    for (int num = 1; num <= 9; num++) {
      if (_canPlace(row, col, num)) {
        grid[row][col] = num;
        if (_solveSudoku()) {
          return true;
        }
        grid[row][col] = 0;
      }
    }
    return false;
  }

  bool canSolve() {
    final oldGrid = [...grid];
    final canSolve = _solveSudoku();
    grid = oldGrid;
    return canSolve;
  }

  List<int> _findEmpty() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] == 0) {
          return [i, j];
        }
      }
    }
    return [];
  }

  void _removeNumbers(int numHoles) {
    Random rand = Random();
    while (numHoles > 0) {
      int row = rand.nextInt(9);
      int col = rand.nextInt(9);
      if (grid[row][col] != 0) {
        grid[row][col] = 0;
        numHoles--;
      }
    }
  }
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
    final numerosInvalidos = game.numeros
        .where((n) =>
            n.valor > 0 && n.linha == linha ||
            n.coluna == coluna ||
            n.quadrante == quadrante)
        .map((n) => n.valor)
        .toList();
    if (numerosInvalidos.contains(input)) {
      return false;
    }
    return true;
  }

  bool onInput(int input) {
    if (!isOpcaoValida(input)) {
      return false;
    }
    valor = input;
    if (game.generator.canSolve()) {
      final numerosParaRemoverAnotacao = game.numeros
          .where((n) =>
              n.linha == linha ||
              n.coluna == coluna ||
              n.quadrante == quadrante)
          .toList();
      for (int index = 0; index < numerosParaRemoverAnotacao.length; index++) {
        numerosParaRemoverAnotacao[index].removerAnotacao(input);
      }
      return true;
    } else {
      valor = 0;
      return false;
    }
    // if (game.generator._canPlace(linha, coluna, input)) {
    //   valor = input;
    //   return true;
    // } else {
    //   return false;
    // }
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
  SudokuGenerator generator = SudokuGenerator();
  List<Numero> numeros = [];
  int quantidadeDeErros = 0;
  bool isIniciado = false;
  bool isFinalizado = false;

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

  void inicializar(int casasVazias) {
    criarNumeros(casasVazias);
    quantidadeDeErros = 0;
    isIniciado = true;
  }

  void criarNumeros(int casasVazias) {
    numeros.clear();
    generator.generateSudoku(casasVazias);
    for (int linha = 1; linha <= 9; linha++) {
      for (int coluna = 1; coluna <= 9; coluna++) {
        numeros.add(
          Numero(
              game: this,
              linha: linha,
              coluna: coluna,
              quadrante: calcularQuadranteIndex(linha, coluna),
              valor: generator.grid[linha - 1][coluna - 1]),
        );
      }
    }
  }

  int calcularQuadranteIndex(int linha, int coluna) {
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
