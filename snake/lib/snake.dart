import 'package:flutter/foundation.dart';

class Snake {
  static const int minSpeed = 20;
  static const int maxSpeed = 300;

  late List<List<int>> _position;
  List<List<int>> get position => _position;
  List<int> get head => _position[0];
  List<List<int>> get bodys => _position.sublist(1);
  int get length => _position.length;

  List<int>? lastTail;

  SnakeDirection _curDirection = SnakeDirection.up;
  SnakeDirection _nextDirection = SnakeDirection.up;

  int _delay = 300;
  get delay => _delay;
  void speedUp() {
    _addDelay(-20);
  }

  void speedDown() {
    _addDelay(20);
  }

  void _addDelay(int value) {
    var delay = _delay + value;

    if (minSpeed <= delay && delay <= maxSpeed) {
      _delay = delay;
    }
  }

  Snake() {
    init();
  }
  void init() {
    _position = [
      [10, 20],
      [10, 21]
    ];
  }

  void move({bool grow = false}) {
    lastTail = _position.removeLast();
    _position = [_nextHeadPosition(), ..._position];
    _curDirection = _nextDirection;
  }

  void grow() {
    if (lastTail != null) {
      _position.add(lastTail!);
    }
  }

  List<int> _nextHeadPosition() {
    var headX = head[0];
    var headY = head[1];

    switch (_nextDirection) {
      case SnakeDirection.up:
        headY--;
        break;
      case SnakeDirection.down:
        headY++;
        break;
      case SnakeDirection.left:
        headX--;
        break;
      case SnakeDirection.right:
        headX++;
        break;
    }

    return [headX, headY];
  }

  void setNextDirection(SnakeDirection dir) {
    if (_curDirection == dir || _curDirection == dir.opposite()) return;

    _nextDirection = dir;
  }

  bool isCrushed() {
    for (var body in bodys) {
      if (listEquals(head, body)) return true;
    }
    return false;
  }

  bool isHead(int x, int y) {
    return listEquals(head, [x, y]);
  }

  bool isBody(int x, int y) {
    for (var body in bodys) {
      if (listEquals(body, [x, y])) return true;
    }

    return false;
  }
}

enum SnakeDirection {
  up,
  down,
  left,
  right;
}

extension SnakeDirectionOpposite on SnakeDirection {
  // 반대 방향값을 리턴한다.
  SnakeDirection opposite() {
    switch (this) {
      case SnakeDirection.up:
        return SnakeDirection.down;
      case SnakeDirection.down:
        return SnakeDirection.up;
      case SnakeDirection.left:
        return SnakeDirection.right;
      case SnakeDirection.right:
        return SnakeDirection.left;
    }
  }
}
