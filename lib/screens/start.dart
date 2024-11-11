import 'package:flutter/material.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  TextEditingController name = TextEditingController();
  void joinTeam(String teamName) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => Dialog(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter display name:',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26),
                                    color: const Color.fromRGBO(
                                        235, 235, 235, 0.75),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    controller: name,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context)
                          //     .popUntil((route) => route.isFirst);
                          Navigator.pushReplacementNamed(context, '/game');
                        },
                        style: const ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            minimumSize: WidgetStatePropertyAll(
                                Size(double.maxFinite, 50)),
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromRGBO(17, 12, 49, 1))),
                        child: Text(
                          'Join',
                          style: TextStyle(color: Colors.grey.shade200),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Choose Team'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox.expand(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      joinTeam('Android');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(61, 220, 132, 1),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text(
                          'Android',
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () => joinTeam('iOS'),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 119, 237, 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text(
                        'iOS',
                        style: TextStyle(fontSize: 34, color: Colors.white),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
