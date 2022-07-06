import 'dart:async';
import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/tetris_mino.dart';
import 'package:tetris/tetris_game.dart';
import 'package:tetris/tetromino.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const TetrisApp());
}

class TetrisApp extends StatefulWidget {
  const TetrisApp({Key? key}) : super(key: key);

  @override
  State<TetrisApp> createState() => _TetrisAppState();
}

class _TetrisAppState extends State<TetrisApp> with SingleTickerProviderStateMixin {
  final TetrisGame game = TetrisGame();

  final FocusNode fn = FocusNode();
  late final AnimationController ac;

  @override
  void initState() {
    super.initState();
    FlameAudio.bgm.initialize();
    ac = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    FlameAudio.bgm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KeyboardListener(
        focusNode: fn,
        autofocus: true,
        onKeyEvent: _keyboardControl,
        child: Scaffold(
          body: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: AspectRatio(
                  aspectRatio: 10 / 21,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Color(0xFFb2c7d9),
                      child: CustomPaint(
                        painter: MatrixRectPainter(matrix: game.stage),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Column(
                children: [
                  SizedBox(
                    width: 60,
                    height: 120,
                    child: AspectRatio(
                      aspectRatio: 2 / 4,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          height: double.infinity,
                          color: Color(0xFFb2c7d9),
                          child: CustomPaint(
                            painter: MatrixRectPainter(matrix: game.player.nextMatrix(0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 100, height: 100, color: Colors.blue),
                  Container(width: 100, height: 100, color: Colors.yellow),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (game.isPlaying) {
                game.isPlaying = false;
                FlameAudio.bgm.stop();
                ac.reverse();
              } else {
                game.newGame();
                setState(() {});
                game.isPlaying = true;
                FlameAudio.bgm.play("isitnow.mp3", volume: 0.3);
                ac.forward();
                createTimer();
              }
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: CurvedAnimation(
                curve: Curves.linear,
                parent: ac,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createTimer() {
    Timer.periodic(Duration(milliseconds: 1000), ((Timer timer) {
      game.move(MoveType.down);
      setState(() {});

      if (game.isPlaying == false) {
        timer.cancel();
        FlameAudio.bgm.stop();
        ac.reverse();
      }
    }));
  }

  void _keyboardControl(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;
    if (!game.isPlaying) return;

    var key = event.logicalKey;
    bool isMoved = false;
    if (key == LogicalKeyboardKey.arrowLeft) {
      isMoved = game.move(MoveType.left);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      isMoved = game.move(MoveType.right);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      isMoved = game.move(MoveType.down);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      isMoved = game.move(MoveType.rotation);
    } else if (key == LogicalKeyboardKey.space) {
      isMoved = game.move(MoveType.space);
    }

    // print(isMoved);
    if (isMoved) setState(() {});
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
