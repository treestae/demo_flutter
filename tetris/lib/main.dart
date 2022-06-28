import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Tetris());
}

class Tetris extends StatefulWidget {
  const Tetris({Key? key}) : super(key: key);

  @override
  State<Tetris> createState() => _TetrisState();
}

class _TetrisState extends State<Tetris> {
  @override
  void initState() {
    super.initState();
    FlameAudio.bgm.initialize();
  }

  @override
  void dispose() {
    FlameAudio.bgm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(),
        floatingActionButton: FloatingActionButton(onPressed: () {
          if (FlameAudio.bgm.isPlaying)
            FlameAudio.bgm.stop();
          else
            FlameAudio.bgm.play("isitnow.mp3", volume: 0.3);
        }),
      ),
    );
  }
}
