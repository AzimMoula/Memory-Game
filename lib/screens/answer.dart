import 'package:flutter/material.dart';

class Answer extends StatefulWidget {
  const Answer({super.key});

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2.5,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12)),
                  width: 50,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12)),
                  width: 50,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'B',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12)),
                  width: 50,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'C',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12)),
                  width: 50,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'D',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
