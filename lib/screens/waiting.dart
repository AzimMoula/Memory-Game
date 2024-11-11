import 'package:flutter/material.dart';

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  void initState() {
    //TODO if 3 members in each team
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/game');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
            child: Text(
          'Waiting for players to join...',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
