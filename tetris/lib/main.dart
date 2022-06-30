import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/tetris_player.dart';
import 'package:tetris/tetris_stage.dart';
import 'package:tetris/tetromino.dart';

void main() {
  runApp(const Tetris());
}

class Tetris extends StatefulWidget {
  const Tetris({Key? key}) : super(key: key);

  @override
  State<Tetris> createState() => _TetrisState();
}

class _TetrisState extends State<Tetris> {
  final TetrisStage stage = TetrisStage();
  final TetrisPlayer p1 = TetrisPlayer();

  final FocusNode fn = FocusNode();
  bool isPrinted = false;
  bool shouldRepaint = true;

  @override
  void initState() {
    super.initState();
    // FlameAudio.bgm.initialize();
    stage.addTetromino(p1);
  }

  @override
  void dispose() {
    // FlameAudio.bgm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KeyboardListener(
        focusNode: fn,
        autofocus: true,
        onKeyEvent: _keyboardControll,
        child: Scaffold(
          body: AspectRatio(
            aspectRatio: 10 / 21,
            child: Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Color(0xFFb2c7d9),
                child: CustomPaint(
                  painter: MatrixRectPainter(matrix: stage.matrix),
                  // foregroundPainter: MyForegroundPainter(),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(onPressed: () {
            // if (FlameAudio.bgm.isPlaying)
            //   FlameAudio.bgm.stop();
            // else
            //   FlameAudio.bgm.play("isitnow.mp3", volume: 0.3);
          }),
        ),
      ),
    );
  }

  void _keyboardControll(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;
    var key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      _moveTetromino(MoveType.left);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _moveTetromino(MoveType.right);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      _moveTetromino(MoveType.down);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _moveTetromino(MoveType.rotation);
    } else if (key == LogicalKeyboardKey.space) {
      _moveTetromino(MoveType.space);
    }
  }

  void _moveTetromino(MoveType moveType) {
    stage.deleteTetromino(p1);
    if (moveType == MoveType.space) {
      stage.addBottom(p1);
      p1.getNewMino();
    } else if (stage.canMove(p1.preMove(moveType))) {
      p1.move(moveType);
    } else {
      //print("cannot move");
      // 이동 불가 사운드
    }
    stage.addTetromino(p1);
    setState(() {});
  }
}

class MatrixRectPainter extends CustomPainter {
  final List<List<Tetromino>> matrix;

  MatrixRectPainter({required this.matrix});

  @override
  void paint(Canvas canvas, Size size) {
    final yHeight = max(size.height / matrix.length, size.width / matrix[0].length);
    final xWidth = yHeight;

    double left = 0, top = 0;

    for (var row in matrix) {
      for (var tile in row) {
        canvas.drawRect(Rect.fromLTWH(left, top, xWidth, yHeight), tile.paint);
        // 열 바꿈
        left += xWidth;
      }
      // 행 바꿈
      left = 0;
      top += yHeight;
    }
  }

  @override
  bool shouldRepaint(covariant MatrixRectPainter old) {
    return true;
  }
}
