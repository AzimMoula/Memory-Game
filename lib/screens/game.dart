import 'package:flutter/material.dart';
import 'package:memory_game/screens/answer.dart';
import 'package:memory_game/screens/question.dart';
import 'package:memory_game/services/flipper.dart';

class Game extends StatefulWidget {
  const Game({super.key});
  static final GlobalKey<FlipperState> flipperKey = GlobalKey<FlipperState>();
  @override
  State<Game> createState() => GameState();
}

class GameState extends State<Game> {
  final List<int> questionNumbers = [
    1,
    2,
    3
  ]; // List of num values for questions and answers
  int currentIndex = 0; // To track the current question/answer pair
  bool showAnswer = false; // To toggle between showing question and answer
  void nextQuestion() {
    if (currentIndex < questionNumbers.length - 1) {
      setState(() {
        currentIndex++; // Move to the next question/answer
        showAnswer = false; // Reset to show question
      });
      Game.flipperKey.currentState?.flipCard(); // Flip back to the question
    } else {
      // Handle game over logic here if needed
      print('Game Over! No more questions.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Memory Game'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flipper(
                  key: Game.flipperKey,
                  front: Question(num: questionNumbers[currentIndex]),
                  back: Answer(
                    num: questionNumbers[currentIndex],
                    onNext: nextQuestion,
                  ),
                  flippable: false,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showAnswer =
                          !showAnswer; // Toggle between question and answer
                    });
                    // Flip the card when toggling
                    if (showAnswer) {
                      Game.flipperKey.currentState?.flipCard();
                    } else {
                      Game.flipperKey.currentState?.flipCard();
                    }
                  },
                  child: Text(showAnswer ? 'Show Question' : 'Show Answer'),
                ),
                const SizedBox(height: 20),
                if (showAnswer && currentIndex < questionNumbers.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      nextQuestion();
                    },
                    child: const Text('Next Question'),
                  ),
                if (currentIndex == questionNumbers.length - 1 && showAnswer)
                  const Text('Game Over!'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
