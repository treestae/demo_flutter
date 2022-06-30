import 'dart:math';

import 'package:tetris/tetromino.dart';

class TetrisPlayer {
  late Tetromino minoNow;
  late int shapeNow = 0;
  late int left, top;
  late List<Tetromino> minosNext;

  List<List<int>> get intMatrix => minoNow.shape[shapeNow];

  /// 중복되지 않는 Enum 값 7개(BLANK 제외)를 순서에 상관 없이 뽑는다.
  final Random _random = Random();
  List<Tetromino> get _nextSevenMinos {
    Set<Tetromino> s = {};
    while (s.length < 7) {
      s.add(Tetromino.values[_random.nextInt(7)]);
    }
    return s.toList(); // Tetromino.values.shuffle 도 가능한 코드이나 성능이 떨어짐
  }

  TetrisPlayer() {
    minosNext = [..._nextSevenMinos, ..._nextSevenMinos]; // 14개를 미리 뽑아둔다.
    getNewMino();
  }

  TetrisPlayer._simpleClone(TetrisPlayer player) {
    left = player.left;
    top = player.top;
    minoNow = player.minoNow;
    shapeNow = player.shapeNow;
  }

  /// 미리 이동한 객체를 리턴한다.
  TetrisPlayer preMove(MoveType moveType) {
    return TetrisPlayer._simpleClone(this)..move(moveType);
  }

  void getNewMino() {
    minoNow = minosNext.removeAt(0);
    left = 3;
    top = 0;
    shapeNow = 0;

    if (minosNext.length <= 7) {
      minosNext.addAll(_nextSevenMinos);
    }
  }

  void move(MoveType moveType) {
    switch (moveType) {
      case MoveType.left:
        this.left--;
        break;
      case MoveType.right:
        this.left++;
        break;
      case MoveType.down:
        this.top++;
        break;
      case MoveType.rotation:
        shapeNow = (shapeNow + 1) % minoNow.shape.length;
        break;
      case MoveType.space:
        break;
    }
  }
}

enum MoveType { left, right, down, rotation, space }
