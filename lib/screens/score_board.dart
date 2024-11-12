import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Memory Game Scoreboard',
          style: GoogleFonts.lobster(fontSize: 36, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Team iOS
              const Expanded(
                  child: TeamScores(teamName: 'Team iOS', scores: [
                [11, 13, 14],
                [14, 12, 16],
                [13, 14, 17]
              ])),

              const SizedBox(width: 20),

              // Circular Countdown Timer
              CircularCountDownTimer(
                duration: 5,
                width: 100,
                height: 100,
                ringColor: Colors.blue,
                fillColor: Colors.red,
                backgroundColor: Colors.amber,
                strokeWidth: 10.0,
                textStyle: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
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
                        DateTime.now().add(const Duration(seconds: 5))
                  });
                  Navigator.pushReplacementNamed(context, '/game');
                },
              ),

              const SizedBox(width: 20),

              // Right side: Team Android
              const Expanded(
                  child: TeamScores(teamName: 'Team Android', scores: [
                [10, 12, 15],
                [14, 15, 18],
                [12, 13, 16]
              ])),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamScores extends StatelessWidget {
  final String teamName;
  final List<List<int>> scores;

  const TeamScores({super.key, required this.teamName, required this.scores});

  @override
  Widget build(BuildContext context) {
    int totalScore = scores.fold(
        0, (sum, playerScores) => sum + playerScores.reduce((a, b) => a + b));

    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: teamName == 'Team Android' ? Colors.green[700] : Colors.blue[700],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              teamName,
              style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            Column(
              children: List.generate(3, (index) {
                return PlayerScoresRow(
                  playerName: 'Player ${index + 1}',
                  roundScores: scores[index],
                );
              }),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.4)),
            Text(
              'Total Score: $totalScore',
              style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerScoresRow extends StatelessWidget {
  final String playerName;
  final List<int> roundScores;

  const PlayerScoresRow(
      {super.key, required this.playerName, required this.roundScores});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            playerName,
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    roundScores[index].toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
