import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memory_game/screens/game.dart';

class Question extends StatefulWidget {
  Question({super.key, this.num = 1});
  int num;
  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final CountDownController controller = CountDownController();
  bool showImage = false;
  int duration = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await syncTimerWithFirestore();
    });
  }

  Future<void> syncTimerWithFirestore() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Games')
        .where('Available', isEqualTo: true)
        .limit(1)
        .get();
    final gameDoc = FirebaseFirestore.instance
        .collection('Games')
        .doc(querySnapshot.docs.first.id);

    gameDoc.snapshots().listen((snapshot) async {
      if (snapshot.exists && snapshot.data() != null) {
        final timerStartTimestamp = snapshot.data()!['timerStartTimestamp'];
        final gameState = snapshot.data()!['gameState'];
        if (timerStartTimestamp != null && timerStartTimestamp is Timestamp) {
          DateTime targetTime = timerStartTimestamp.toDate();
          DateTime currentTime = DateTime.now().toUtc();
          int remainingSeconds = targetTime.difference(currentTime).inSeconds;

          print('Timer Start Timestamp: $timerStartTimestamp');
          print('Current Time: $currentTime');
          print('Remaining Seconds: $remainingSeconds');

          // Wait for an additional 5 seconds before starting the timer
          // if (!kIsWeb) {
          //   print('it was me');
          //   await Future.delayed(const Duration(seconds: 5));
          // }

          if (remainingSeconds > 0) {
            // Set the remaining time and restart after the delay
            setState(() {
              duration = remainingSeconds;
              showImage = true;
            });
            Future.delayed(const Duration(seconds: kIsWeb ? 0 : 5), () {
              setState(() {
                showImage = true;
              });
              if (!controller.isStarted.value) controller.start();
            });
            // if (gameState == 'paused') {
            //   // Introduce a 5-second delay when game is paused
            //   Future.delayed(const Duration(seconds: 5), () {
            //     controller.restart(duration: remainingSeconds);
            //   });
            // } else {
            //   controller.restart(duration: remainingSeconds);
            // }
          } else {
            Future.delayed(const Duration(seconds: kIsWeb ? 0 : 5), () {
              setState(() {
                showImage = true;
              });
              if (!controller.isStarted.value) controller.start();
            });
            // controller.start();
          }
        } else {
          print('timerStartTimestamp is null or not a Timestamp type.');
        }
      } else {
        print('Game document does not exist or data is null.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      child: Column(
        children: [
          const SizedBox(height: 25),
          ListTile(
            leading: Text(
              '${widget.num} Remember this image',
              style: TextStyle(fontSize: 18),
            ),
            trailing: CircularCountDownTimer(
              controller: controller,
              autoStart: false,
              isReverseAnimation: true,
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
              duration: duration,
              isReverse: true,
              onComplete: () async {
                final querySnapshot = await FirebaseFirestore.instance
                    .collection('Games')
                    .where('Available', isEqualTo: true)
                    .limit(1)
                    .get();
                await FirebaseFirestore.instance
                    .collection('Games')
                    .doc(querySnapshot.docs.first.id)
                    .update({
                  'gameState': 'started',
                  'timerStartTimestamp':
                      DateTime.now().add(const Duration(seconds: 12))
                });
                Game.flipperKey.currentState?.flipCard();
              },
              fillColor: Colors.amber,
              ringColor: Colors.black,
            ),
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
                  image: NetworkImage('https://picsum.photos/200'),
                ),
              ),
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
