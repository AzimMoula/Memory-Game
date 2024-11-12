import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:memory_game/screens/game.dart';
import 'package:memory_game/screens/home.dart';
import 'package:memory_game/screens/results.dart';
import 'package:memory_game/screens/score_board.dart';
import 'package:memory_game/screens/start.dart';
import 'package:memory_game/screens/waiting.dart';
import 'firebase_options.dart';

bool team = false;
String? userName;
int? userIndex;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
      routes: {
        '/home': (context) => const Home(),
        '/start': (context) => const Start(),
        '/waiting': (context) => const Waiting(),
        '/game': (context) => const Game(),
        '/results': (context) => const Results(),
        '/score-board': (context) => const ScoreBoard(),
      },
    );
  }
}
