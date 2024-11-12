import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memory_game/main.dart';
import 'package:memory_game/screens/game.dart';

class Answer extends StatefulWidget {
  Answer({super.key, this.num = 1, this.onNext});
  int num;
  final VoidCallback? onNext;
  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  final CountDownController controller = CountDownController();
  int duration = 10;
  List<String> options = ['A', 'B', 'C', 'D'];
  String? selected;
  String? gameId;
  bool isGameStarted = false;

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
          // await Future.delayed(const Duration(seconds: 5));
          // }

          if (remainingSeconds > 0) {
            // Set the remaining time
            setState(() {
              duration = remainingSeconds;
            });
            controller.restart(duration: duration);
          } else {
            controller.start();
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
            leading: const Text(
              kIsWeb
                  ? 'Select the image that resembles the previous image'
                  : 'Select the image that resembles\nthe previous image',
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
                Colors.amber,
              ]),
              fillGradient: const SweepGradient(
                colors: [Colors.black, Colors.grey, Colors.black],
              ),
              width: 50,
              height: 50,
              duration: duration,
              isReverse: true,
              onComplete: () async {
                // Update game state to paused
                final querySnapshot = await FirebaseFirestore.instance
                    .collection('Games')
                    .where('Available', isEqualTo: true)
                    .limit(1)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('Games')
                      .doc(querySnapshot.docs.first.id)
                      .update({
                    'gameState': 'paused'
                  }); // Change game state to paused

                  // Update the player's score
                  await FirebaseFirestore.instance
                      .collection('Games')
                      .doc(querySnapshot.docs.first.id)
                      .collection('Teams')
                      .doc(!team ? 'Android' : 'iOS')
                      .update({
                    'Players': FieldValue.arrayUnion([
                      {'Name': userName, 'Score${widget.num}': 5}
                    ])
                  });
                  await FirebaseFirestore.instance
                      .collection('Games')
                      .doc(querySnapshot.docs.first.id)
                      .update({
                    'gameState': 'paused',
                    'timerStartTimestamp': Timestamp.fromDate(DateTime.now())
                  });
                  Navigator.pushReplacementNamed(
                      context, kIsWeb ? '/score-board' : '/game');
                  // widget.onNext!();
                }
              },
              fillColor: Colors.amber,
              ringColor: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kIsWeb ? 4 : 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: options.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = options[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('https://picsum.photos/200'),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            options[index],
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = options[index];
                        });
                      },
                      child: CustomPaint(
                        painter: InnerShadowPainter(selected == options[index]),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class InnerShadowPainter extends CustomPainter {
  final bool isSelected;

  InnerShadowPainter(this.isSelected);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color =
          isSelected ? Colors.amber[200]!.withOpacity(0.7) : Colors.transparent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect outerRRect =
        RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final RRect innerRRect = outerRRect.deflate(10);

    final Path outerPath = Path()..addRRect(outerRRect);
    final Path innerPath = Path()..addRRect(innerRRect);

    final Path combinedPath =
        Path.combine(PathOperation.difference, outerPath, innerPath);

    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
