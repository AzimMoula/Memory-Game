import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Memory\n\t\t\t\t\t\t\t\tGame',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                    style: const ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                        minimumSize: WidgetStatePropertyAll(Size(180, 50)),
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(136, 178, 255, 1))),
                    onPressed: () async {
                      if (kIsWeb) {
                        var temp1 = DateTime.now();
                        final querySnapshot = await FirebaseFirestore.instance
                            .collection('Games')
                            .where('Available', isEqualTo: true)
                            .limit(1)
                            .get();
                        if (querySnapshot.docs.isEmpty) {
                          var temp2 = await FirebaseFirestore.instance
                              .collection('Games')
                              .doc(
                                  '${temp1.day}${temp1.month}${temp1.hour}${temp1.minute}');
                          temp2
                              .set({'Available': true, 'gameState': 'waiting'});
                          temp2
                              .collection('Teams')
                              .doc('Android')
                              .set({'Players': []});
                          temp2
                              .collection('Teams')
                              .doc('iOS')
                              .set({'Players': []});
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Game already created')));
                          }
                        }
                        Navigator.pushNamed(context, '/waiting');
                      } else {
                        Navigator.pushNamed(context, '/start');
                      }
                    },
                    child: const Text(
                      kIsWeb ? 'Create Game' : 'START',
                      style: TextStyle(color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
