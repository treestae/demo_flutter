import 'package:flutter/foundation.dart';

class Snake {
  static const int minDelay = 20; // 뱀의 최고 속도
  static const int maxDelay = 300; // 뱀의 최저 속도

  late List<List<int>> _position; // 뱀의 머리 + 몸통 배열

  List<int> get head => _position[0]; // 머리
  List<List<int>> get bodys => _position.sublist(1); // 몸통
  int get length => _position.length; // 뱀의 길이

  List<int>? _lastTail; // 잘린 꼬리

  SnakeDirection _curDirection = SnakeDirection.up; // 현재 뱀의 방향
  SnakeDirection _nextDirection = SnakeDirection.up; // 다음 뱀의 방향

  int _delay = 300; // 현재 지연속도(타이머의 Duration)
  get delay => _delay;

  // 20씩 뱀의 속도를 올린다.
  void speedUp() {
    _addDelay(-20);
  }

  // 20씩 뱀의 속도를 낮춘다.
  void speedDown() {
    _addDelay(20);
  }

  // 딜레이 값을 value만큼 더한다
  void _addDelay(int value) {
    var delay = _delay + value;

    if (minDelay <= delay && delay <= maxDelay) {
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

  // 이동 -> 마지막 꼬리를 자르고 새로운 머리를 넣는다.
  void move({bool grow = false}) {
    _lastTail = _position.removeLast();
    _position = [_nextHeadPosition(), ..._position];
    _curDirection = _nextDirection;
  }

  // 뱀의 길이를 1칸 성장 -> 이동시 잘린 꼬리를 복구한다.
  void grow() {
    if (_lastTail != null) {
      _position.add(_lastTail!);
    }
  }

  // 1칸 이동하기 전 다음 머리의 위치를 계산한다.
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

  // 자기 몸에 충돌 확인
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
