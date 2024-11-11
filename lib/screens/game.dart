import 'package:flutter/material.dart';
import 'package:memory_game/screens/answer.dart';
import 'package:memory_game/screens/question.dart';
import 'package:memory_game/services/flipper.dart';

class Game extends StatefulWidget {
  Game({super.key});
  final GlobalKey<FlipperState> flipperKey = GlobalKey<FlipperState>();
  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Memory Game'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flipper(
                key: widget.flipperKey,
                front: const Question(),
                back: const Answer(),
                flippable: false,
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       Game.flipperKey.currentState?.flipCard();
              //     },
              //     child: const Text('Turn')),
            ],
          ),
        ),
      ),
    );
  }
}
