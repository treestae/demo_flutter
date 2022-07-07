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

  Duration? prevVerticalDrag = Duration();
  Duration? prevHorizontalDrag = Duration();

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
      debugShowCheckedModeBanner: false,
      home: KeyboardListener(
        focusNode: fn,
        autofocus: true,
        onKeyEvent: _keyboardControl,
        child: _dragControl(
          child: Scaffold(
            body: Builder(builder: (context) {
              final size = MediaQuery.of(context).size;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: size.width >= 600 ? const EdgeInsets.all(12.0) : EdgeInsets.symmetric(vertical: size.height * 0.2),
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
                  SizedBox(width: 12),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Text("N E X T"),
                      _nextTetromino(0),
                      _nextTetromino(1),
                      _nextTetromino(2),
                      _nextTetromino(3),
                      _nextTetromino(4),
                      _nextTetromino(5),
                      Text("S C O R E"),
                      Text("${game.score}"),
                      SizedBox(height: 50),
                      Text("Arrow keys"),
                      Text("or"),
                      Text("Drag"),
                      SizedBox(height: 10),
                      Text("Space"),
                      Text("or"),
                      Text("DoubleTap"),
                    ],
                  ),
                ],
              );
            }),
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
      ),
    );
  }

  Widget _nextTetromino(int index) {
    return Builder(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          width: size.height / 10,
          height: size.height / 20,
          child: AspectRatio(
            aspectRatio: 2 / 4,
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: MatrixRectPainter(matrix: game.player.nextMatrix(index)),
                ),
              ),
            ),
          ),
        ),
      );
    });
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

    if (isMoved) setState(() {});
  }

  Widget _dragControl({required Widget child}) {
    return GestureDetector(
        child: child,

        /// 회전 및 아래로 이동
        onVerticalDragUpdate: (details) {
          if (!game.isPlaying) return;
          // 연속 입력 시간 체크
          if (Duration(milliseconds: 130).compareTo(details.sourceTimeStamp! - prevVerticalDrag!) == -1) {
            prevVerticalDrag = details.sourceTimeStamp;
          } else {
            return;
          }
          int sense = 1;
          if (details.delta.dy.abs() < sense) return;

          bool isMoved = false;
          if (details.delta.dy < 0) {
            isMoved = game.move(MoveType.rotation);
          } else if (details.delta.dy > 0) {
            isMoved = game.move(MoveType.down);
          }
          if (isMoved) setState(() {});
        },

        /// 좌우 이동
        onHorizontalDragUpdate: (details) {
          if (!game.isPlaying) return;

          if (Duration(milliseconds: 80).compareTo(details.sourceTimeStamp! - prevHorizontalDrag!) == -1) {
            prevHorizontalDrag = details.sourceTimeStamp;
          } else {
            return;
          }
          int sense = 2;
          if (details.delta.dx.abs() < sense) return;

          bool isMoved = false;

          if (details.delta.dx < 0) {
            isMoved = game.move(MoveType.left);
          } else if (details.delta.dx > 0) {
            isMoved = game.move(MoveType.right);
          }
          if (isMoved) setState(() {});
        },

        /// 바닥으로 이동
        onDoubleTap: () {
          if (!game.isPlaying) return;
          bool isMoved = false;
          isMoved = game.move(MoveType.space);
          if (isMoved) setState(() {});
        });
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
