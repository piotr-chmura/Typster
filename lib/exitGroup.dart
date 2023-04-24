// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';

import 'mainMenu.dart';

class ExitGroup extends StatefulWidget {
  const ExitGroup({super.key, required this.groupName, required this.groupId});

  final String groupName;
  final int groupId;

  @override
  _ExitGroup createState() => _ExitGroup();
}

class _ExitGroup extends State<ExitGroup> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
            child: const Center(child: Text('Typster'))
          )
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: Center(
                child: Column(
              children: <Widget>[
                const Text(
                  "Czy chcesz opuścić grupe:",
                  style: TextStyle(fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 20)),
                Text(
                  widget.groupName,
                  style: const TextStyle(color: Colors.green, fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        height: 60,
                        width: 150,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: ElevatedButton(
                            onPressed: () {
                               Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const MainMenu()));
                            },
                            child: const Text("TAK"))),
                    Container(
                        height: 60,
                        width: 150,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 0, 0)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("NIE"))),
                  ],
                )
              ],
            ))));
  }
}
