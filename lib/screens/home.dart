import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/start');
                    },
                    child: const Text(
                      'START',
                      style: TextStyle(color: Colors.black),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
