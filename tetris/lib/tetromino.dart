import 'package:flutter/material.dart';

enum Tetromino {
  I(
    next: [
      [0, 0, 0, 0],
      [1, 1, 1, 1],
    ],
    shape: [
      [
        [1, 1, 1, 1],
      ],
      [
        [0, 0, 0, 1],
        [0, 0, 0, 1],
        [0, 0, 0, 1],
        [0, 0, 0, 1],
      ],
    ],
    color: Color(0xFF00f0f0),
  ),
  J(
    next: [
      [1, 0, 0, 0],
      [1, 1, 1, 0],
    ],
    shape: [
      [
        [1, 0, 0],
        [1, 1, 1],
      ],
      [
        [0, 1, 1],
        [0, 1, 0],
        [0, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [0, 0, 1],
      ],
      [
        [0, 1],
        [0, 1],
        [1, 1],
      ],
    ],
    color: Color(0xFF0000f0),
  ),
  L(
    next: [
      [0, 0, 1, 0],
      [1, 1, 1, 0],
    ],
    shape: [
      [
        [0, 0, 1],
        [1, 1, 1],
      ],
      [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 1],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [1, 0, 0],
      ],
      [
        [1, 1],
        [0, 1],
        [0, 1],
      ],
    ],
    color: Color(0xFFf0a000),
  ),
  O(
    next: [
      [0, 1, 1, 0],
      [0, 1, 1, 0],
    ],
    shape: [
      [
        [0, 1, 1],
        [0, 1, 1],
      ],
    ],
    color: Color(0xFFf0f000),
  ),
  T(
    next: [
      [0, 1, 0, 0],
      [1, 1, 1, 0],
    ],
    shape: [
      [
        [0, 1, 0],
        [1, 1, 1],
      ],
      [
        [0, 1, 0],
        [0, 1, 1],
        [0, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [0, 1, 0],
      ],
      [
        [0, 1, 0],
        [1, 1, 0],
        [0, 1, 0],
      ],
    ],
    color: Color(0xFFa000f0),
  ),
  S(
    next: [
      [0, 1, 1, 0],
      [1, 1, 0, 0],
    ],
    shape: [
      [
        [0, 1, 1],
        [1, 1, 0],
      ],
      [
        [1, 0, 0],
        [1, 1, 0],
        [0, 1, 0],
      ],
    ],
    color: Color(0xFF00f000),
  ),
  Z(
    next: [
      [1, 1, 0, 0],
      [0, 1, 1, 0],
    ],
    shape: [
      [
        [1, 1, 0],
        [0, 1, 1],
      ],
      [
        [0, 0, 1],
        [0, 1, 1],
        [0, 1, 0],
      ],
    ],
    color: Color(0xFFf00000),
  ),
  BLANK(
    next: [
      [1]
    ],
    shape: [
      [
        [1]
      ]
    ],
    color: Colors.black45,
  ),
  STEEL(
    next: [
      [1]
    ],
    shape: [
      [
        [1]
      ]
    ],
    color: Colors.grey,
  );

  const Tetromino({required this.next, required this.shape, required this.color});

  final List<List<int>> next;
  final List<List<List<int>>> shape;
  final Color color;

  /// enum에 일반 객체를 담을 수 없기 때문에 객체 생성 비용을 낮추고자
  /// static으로 만들어 둔 Paint 객체의 값만 변경하여 리턴한다.
  get paint => _paint..color = color;

  static final Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;
}
