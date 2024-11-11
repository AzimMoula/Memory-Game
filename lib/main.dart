import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:memory_game/screens/game.dart';
import 'package:memory_game/screens/home.dart';
import 'package:memory_game/screens/question.dart';
import 'package:memory_game/screens/start.dart';
import 'firebase_options.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
      routes: {
        '/home': (context) => const Home(),
        '/start': (context) => const Start(),
        '/game': (context) => const Game(),
        '/results': (context) => const Home(),
        '/score-board': (context) => const Home(),
      },
    );
  }
}
