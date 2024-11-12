import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  List<DocumentSnapshot>? teams;
  String? gameId;
  bool isGameStarted = false;
  late Stream<DocumentSnapshot> gameStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
      listenForGameState();
    });
  }

  Future<void> loadData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Games')
          .where('Available', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        gameId = querySnapshot.docs.first.id;

        // Set game state to 'waiting'
        await FirebaseFirestore.instance
            .collection('Games')
            .doc(gameId)
            .update({'gameState': 'waiting'});

        // Load teams
        var teamSnapshot = await FirebaseFirestore.instance
            .collection('Games')
            .doc(gameId)
            .collection('Teams')
            .get();

        setState(() {
          teams = teamSnapshot.docs;
        });

        // Introduce a slight delay to ensure the game state is updated
        await Future.delayed(const Duration(milliseconds: 500));

        // Check if each team has 3 players
        checkIfGameCanStart();
      }
    } catch (e) {
      print('Error loading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading game data: $e')),
      );
    }
  }

  void checkIfGameCanStart() async {
    if (teams != null && teams!.isNotEmpty) {
      // Check if both teams have 3 players
      bool canStart = teams!.length == 2 &&
          teams![0]['Players'].length == 3 &&
          teams![1]['Players'].length == 3;

      if (canStart) {
        // Update gameState to 'paused'
        await FirebaseFirestore.instance
            .collection('Games')
            .doc(gameId)
            .update({
          'gameState': 'paused',
          'timerStartTimestamp': Timestamp.fromDate(DateTime.now()),
        });
      }
    }
  }

  void listenForGameState() {
    if (gameId == null) return;

    FirebaseFirestore.instance
        .collection('Games')
        .doc(gameId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final gameState = snapshot.data()!['gameState'];
        if (gameState == 'paused' && !isGameStarted) {
          isGameStarted = true;
          Navigator.pushReplacementNamed(
              context, kIsWeb ? '/score-board' : '/game');
        } else if (gameState == 'started' && !isGameStarted) {
          isGameStarted = true;
          Navigator.pushReplacementNamed(context, '/game');
        }
      }
    });
  }

  @override
  void dispose() {
    // Clean up the stream subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: gameId == null
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Games')
                          .doc(gameId)
                          .collection('Teams')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // Display the list of teams and their players
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot docSnap =
                                snapshot.data!.docs[index];

                            return Column(
                              children: [
                                ListTile(
                                  title: Text(docSnap.id),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ...List.generate(
                                        docSnap['Players'].length,
                                        (playerIndex) => const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Icon(
                                            Icons.person,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          },
                        );
                      },
                    ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Waiting for players to join...',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const Spacer(),
            if (kIsWeb)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      minimumSize: const Size(100, 50),
                      backgroundColor: const Color.fromRGBO(136, 178, 255, 1),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('Games')
                          .doc(gameId)
                          .update({
                        'gameState': 'paused',
                        'timerStartTimestamp':
                            Timestamp.fromDate(DateTime.now())
                      });
                    },
                    child: const Text(
                      'Start',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
