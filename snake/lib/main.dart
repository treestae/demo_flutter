import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/snake.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SnakeGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final FocusNode _focusNode = FocusNode();
  final int squaresPerRow = 20;
  final int squaresPerCol = 40;
  final fontStyle = const TextStyle(color: Colors.white, fontSize: 20);
  final randomGen = Random();

  Snake snake = Snake();
  late List<int> food;
  var isPlaying = false;
  var isSpeedChanged = false;

  @override
  void initState() {
    super.initState();
    _creatFood();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: KeyboardListener(
                focusNode: _focusNode,
                autofocus: true,
                onKeyEvent: _keyDownEvent,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy < 0) {
                      snake.setNextDirection(SnakeDirection.up);
                    } else if (details.delta.dy > 0) {
                      snake.setNextDirection(SnakeDirection.down);
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx < 0) {
                      snake.setNextDirection(SnakeDirection.left);
                    } else if (details.delta.dx > 0) {
                      snake.setNextDirection(SnakeDirection.right);
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: squaresPerRow / (squaresPerCol),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: squaresPerRow,
                      ),
                      itemCount: squaresPerRow * squaresPerCol,
                      itemBuilder: (context, index) {
                        var color = Colors.grey[800];
                        var x = index % squaresPerRow;
                        var y = index ~/ squaresPerRow;

                        if (snake.isHead(x, y)) {
                          color = Colors.green;
                        } else if (snake.isBody(x, y)) {
                          color = Colors.green[200];
                        } else if (listEquals(food, [x, y])) {
                          color = Colors.red;
                        }

                        return Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text("Move: Arrows OR Drag\n\nSpeed: + OR -", style: fontStyle.copyWith(fontSize: 14)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  _speedDown();
                },
                icon: const Icon(Icons.remove, color: Colors.white70),
              ),
              Text(
                "Speed: ${((snake.delay - 320) / 20).abs()}",
                style: fontStyle,
              ),
              IconButton(
                onPressed: () {
                  _speedUp();
                },
                icon: const Icon(Icons.add, color: Colors.white70),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (isPlaying) {
                        isPlaying = false;
                      } else {
                        isPlaying = true;
                        FocusScope.of(context).requestFocus(_focusNode);
                        startGame();
                      }
                    });
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                  child: Text(
                    isPlaying ? "End" : "Start",
                    style: fontStyle,
                  ),
                ),
                Text("Score: ${max<int>(snake.length - 2, 0)}", style: fontStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void startGame() {
    snake.init();
    isPlaying = true;

    _createTimer();
  }

  /// 주기적인 타이머를 동작시켜 뱀을 움직이고 음식을 만든다.
  /// 또한 속도가 변경되면 주기가 변경된 타이머를 새로 만든다.
  void _createTimer() {
    isSpeedChanged = false;
    Timer.periodic(Duration(milliseconds: snake.delay), ((Timer timer) {
      setState(() {
        snake.move();
      });

      if (snake.head[0] == food[0] && snake.head[1] == food[1]) {
        snake.grow();
        _creatFood();
      }

      if (_isGameOver()) {
        timer.cancel();
        endGame();
      }

      if (isSpeedChanged) {
        timer.cancel();
        _createTimer();
        return;
      }
    }));
  }

  void _creatFood() {
    food = [randomGen.nextInt(squaresPerRow), randomGen.nextInt(squaresPerCol)];
  }

  bool _isGameOver() {
    if (snake.isCrushed() || !isPlaying || snake.head[1] < 0 || snake.head[1] >= squaresPerCol || snake.head[0] < 0 || snake.head[0] >= squaresPerRow) {
      return true;
    }

    return false;
  }

  void endGame() {
    isPlaying = false;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Game Over"),
            content: Text("Score: ${snake.length - 2}"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"))
            ],
          );
        });
  }

  void _speedUp() {
    snake.speedUp();
    isSpeedChanged = true;
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _speedDown() {
    snake.speedDown();
    isSpeedChanged = true;
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _keyDownEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    var key = event.logicalKey;

    setState(() {
      if (key == LogicalKeyboardKey.arrowUp) {
        snake.setNextDirection(SnakeDirection.up);
      } else if (key == LogicalKeyboardKey.arrowDown) {
        snake.setNextDirection(SnakeDirection.down);
      } else if (key == LogicalKeyboardKey.arrowLeft) {
        snake.setNextDirection(SnakeDirection.left);
      } else if (key == LogicalKeyboardKey.arrowRight) {
        snake.setNextDirection(SnakeDirection.right);
      } else if (key == LogicalKeyboardKey.numpadAdd || key == LogicalKeyboardKey.equal) {
        _speedUp();
      } else if (key == LogicalKeyboardKey.numpadSubtract || key == LogicalKeyboardKey.minus) {
        _speedDown();
      }
    });
  }
}
