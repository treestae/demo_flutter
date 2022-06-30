import 'package:tetris/tetris_player.dart';
import 'package:tetris/tetromino.dart';

class TetrisStage {
  static const yCount = 21;
  static const xCount = 10;

  int score = 0;

  final List<List<Tetromino>> matrix = List.generate(
    yCount,
    (i) => List.filled(
      growable: false,
      xCount,
      Tetromino.BLANK,
    ),
  );

  bool canMove(TetrisPlayer tp) {
    for (var y = 0; y < tp.intMatrix.length; y++) {
      for (var x = 0; x < tp.intMatrix[y].length; x++) {
        if (tp.intMatrix[y][x] == 1) {
          // 게임판 범위 밖인지 체크
          if ((tp.top + y) < 0 || yCount <= (tp.top + y) || (tp.left + x) < 0 || xCount <= (tp.left + x)) {
            return false;

            // 이미 다른 타일이 존재하는지 체크
          } else if (matrix[tp.top + y][tp.left + x] != Tetromino.BLANK) {
            return false;
          }
        }
      }
    }

    return true;
  }

  //
  void addBottom(TetrisPlayer tp) {
    do {
      if (!canMove(tp)) {
        tp.top--;
        break;
      }
      tp.top++;
    } while (true);
    addTetromino(tp);
    deleteFilledLine();
  }

  void addTetromino(TetrisPlayer tp) {
    for (var y = 0; y < tp.intMatrix.length; y++) {
      for (var x = 0; x < tp.intMatrix[y].length; x++) {
        if (tp.intMatrix[y][x] == 1) matrix[tp.top + y][tp.left + x] = tp.minoNow;
      }
    }
  }

  void deleteTetromino(TetrisPlayer tp) {
    for (var y = 0; y < tp.intMatrix.length; y++) {
      for (var x = 0; x < tp.intMatrix[y].length; x++) {
        if (tp.intMatrix[y][x] == 1) matrix[tp.top + y][tp.left + x] = Tetromino.BLANK;
      }
    }
  }

  void deleteFilledLine() {
    for (var i = 0; i < matrix.length; i++) {
      if (matrix[i].where((e) => e == Tetromino.BLANK).isEmpty) {
        _clearLine(i);
      }
    }
  }

  void _clearLine(int lineNum) {
    for (var i = 0; i < matrix[lineNum].length; i++) {
      matrix[lineNum][i] = Tetromino.BLANK;
    }
    var temp = matrix.removeAt(lineNum);
    matrix.insert(0, temp);
  }
}
