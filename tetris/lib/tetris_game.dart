import 'package:tetris/tetris_mino.dart';
import 'package:tetris/tetromino.dart';

class TetrisGame {
  static const yCount = 21;
  static const xCount = 10;

  late int score;
  late int clearLines;

  late List<List<Tetromino>> stage;
  late TetrisMino player;
  late bool isPlaying = false;

  TetrisGame() {
    newGame();
  }

  void newGame() {
    score = 0;
    clearLines = 0;

    stage = List.generate(
      yCount,
      (_) => List.filled(xCount, Tetromino.BLANK, growable: false),
    );

    player = TetrisMino();

    _addTetromino(player);
  }

  /// 스테이지에 미노를 추가하고 꽉찬 줄이 있다면 제거하며 새로운 미노를 생성한다..
  void putOnStage(TetrisMino mino) {
    _clearFulfilledLines();
    player.newMino();
    if (canAdd(player)) {
      _addTetromino(mino);
    } else {
      // Game Over
      isPlaying = false;
    }
  }

  /// 미노를 이동시킨다.
  bool move(MoveType moveType) {
    _deleteTetromino(player);
    if (canAdd(player.preMove(moveType))) {
      switch (moveType) {
        case MoveType.space:
          toBottom(player);
          _addTetromino(player);
          putOnStage(player);
          break;
        case MoveType.down:
        case MoveType.left:
        case MoveType.right:
        case MoveType.rotation:
          player.move(moveType);
          _addTetromino(player);
          break;
      }
      return true;
    } else {
      _addTetromino(player);
      if (moveType == MoveType.down) {
        putOnStage(player);
      }
      return false;
    }
  }

  /// 스테이지에 추가할 수 있는지 체크
  bool canAdd(TetrisMino mino) {
    for (var y = 0; y < mino.shapeNow.length; y++) {
      for (var x = 0; x < mino.shapeNow[y].length; x++) {
        if (mino.shapeNow[y][x] == 1) {
          // 게임판 범위 밖인지 체크
          if ((mino.top + y) < 0 || yCount <= (mino.top + y) || (mino.left + x) < 0 || xCount <= (mino.left + x)) {
            return false;
          } else if (_isNotBlankTile(mino.left + x, mino.top + y)) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// 다른 타일이 존재하는가
  bool _isNotBlankTile(int x, int y) => stage[y][x] != Tetromino.BLANK;

  /// 미노를 가능한 최하단으로 보낸다.
  void toBottom(TetrisMino mino) {
    do {
      if (!canAdd(mino)) {
        mino.top--;
        break;
      }
      mino.top++;
    } while (true);
  }

  /// 미노를 스테이지에 추가한다.
  void _addTetromino(TetrisMino mino) {
    for (var y = 0; y < mino.shapeNow.length; y++) {
      for (var x = 0; x < mino.shapeNow[y].length; x++) {
        if (mino.shapeNow[y][x] == 1) stage[mino.top + y][mino.left + x] = mino.now;
      }
    }
  }

  /// 미노를 스테이지에서 제거한다.
  void _deleteTetromino(TetrisMino mino) {
    for (var y = 0; y < mino.shapeNow.length; y++) {
      for (var x = 0; x < mino.shapeNow[y].length; x++) {
        if (mino.shapeNow[y][x] == 1) stage[mino.top + y][mino.left + x] = Tetromino.BLANK;
      }
    }
  }

  /// 가득찬 줄을 제거하고 점수를 계산한다.
  void _clearFulfilledLines() {
    int clearLinesAtOnce = 0;

    for (var i = 0; i < stage.length; i++) {
      if (stage[i].where((e) => e == Tetromino.BLANK).isEmpty) {
        stage[i].fillRange(0, xCount, Tetromino.BLANK); // 해당 줄을 BLANK로 만든다.
        stage.insert(0, stage.removeAt(i)); // 해당 줄을 최상단으로 올린다.
        clearLinesAtOnce++;
      }
    }
    __getScore(clearLinesAtOnce);
  }

  /// 제거한 줄 수에 따라 점수와 제거한 줄 수를 계산한다.
  void __getScore(int clearLinesAtOnce) {
    score += 100 * (clearLinesAtOnce * clearLinesAtOnce); // 동시에 제거한 줄이 많을수록 제곱수로 점수가 높아진다.
    clearLines += clearLinesAtOnce;
  }
}
