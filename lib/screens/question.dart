import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:memory_game/screens/game.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  CountDownController controller = CountDownController();
  bool showImage = false;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      controller.start();
      setState(() {
        showImage = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 25),
          ListTile(
            leading: const Text(
              'Remember this image',
              style: TextStyle(fontSize: 18),
            ),
            trailing: CircularCountDownTimer(
                controller: controller,
                autoStart: false,
                // isReverseAnimation: true,
                ringGradient: const SweepGradient(colors: [
                  Colors.amber,
                  Colors.orange,
                  Colors.orange,
                  Colors.amber
                ]),
                fillGradient: const SweepGradient(
                    colors: [Colors.black, Colors.grey, Colors.black]),
                width: 50,
                height: 50,
                duration: 10,
                isReverse: true,
                onComplete: () {
                  Game.flipperKey.currentState?.flipCard();
                },
                fillColor: Colors.amber,
                ringColor: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80.0),
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('https://picsum.photos/200'))),
              child: showImage
                  ? null
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 250,
                      height: 250,
                    ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
