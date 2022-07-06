import 'package:tetris/tetromino.dart';

class TetrisMino {
  late int _shapeIndex;

  late int left, top; // 좌표 x, y
  late Tetromino now;
  List<Tetromino> nexts = [];

  List<List<int>> get shapeNow => now.shape[_shapeIndex];

  /// 중복되지 않는 Enum 값 7개(BLANK 제외)를 순서에 상관 없이 뽑는다.
  List<Tetromino> get _nextSevenMinos => Tetromino.values.sublist(0, 7)..shuffle();
  // 성능이 더 좋은 코드
  // final Random _random = Random();
  // List<Tetromino> get _nextSevenMinos {
  //   Set<Tetromino> s = {};
  //   while (s.length < 7) {
  //     s.add(Tetromino.values[_random.nextInt(7)]);
  //   }
  //   return s.toList();
  // }

  TetrisMino() {
    newMino();
  }

  void newMino() {
    if (nexts.length <= 7) {
      nexts.addAll(_nextSevenMinos);
    }

    now = nexts.removeAt(0);
    left = 3;
    top = 0;
    _shapeIndex = 0;
  }

  TetrisMino._simpleClone(TetrisMino player) {
    left = player.left;
    top = player.top;
    now = player.now;
    _shapeIndex = player._shapeIndex;
  }

  /// 미리 이동한 객체를 리턴한다.
  TetrisMino preMove(MoveType moveType) {
    return TetrisMino._simpleClone(this)..move(moveType);
  }

  List<List<Tetromino>> nextMatrix(int index) {
    return nexts[index].next.map((e) => e.map((e) => e == 0 ? Tetromino.BLANK : nexts[index]).toList()).toList();
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
        _shapeIndex = (_shapeIndex + 1) % now.shape.length;
        break;
      case MoveType.space:
        break;
    }
  }
}

enum MoveType { left, right, down, rotation, space }
