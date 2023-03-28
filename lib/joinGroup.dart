// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key, required this.groupname});

  final String groupname;

  @override
  _JoinGroup createState() => _JoinGroup();
}

class _JoinGroup extends State<JoinGroup> {

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
      appBar: AppBar(title: const Center(child: Text('Dołącz do grupy          '))),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
        child: Center(
          child: Column(
            children: <Widget>[
              const Text(
                "Czy chcesz dołączyć do grupy:",
                style: TextStyle(fontSize: 20),
                ),
              const Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 20)),
              Text(
                widget.groupname,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18
                  ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 200,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context, "Dołączono do grupy");
                      }, 
                      child: const Text("TAK")
                      )
                    ),
                  Container(
                    height: 60,
                    width: 200,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 0, 0)
                        ),
                        onPressed: (){
                          Navigator.pop(context, "Wycofano dołączanie");
                        }, 
                        child: const Text("NIE")
                        )
                    ),
                ],
              )
            ],
          )
        )
      )
    );
  }
}
