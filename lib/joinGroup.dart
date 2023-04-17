// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:test_app/backend/joinGroupBackend.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key, required this.groupName, required this.groupId});

  final String groupName;
  final int groupId;

  @override
  _JoinGroup createState() => _JoinGroup();
}

class _JoinGroup extends State<JoinGroup> {
  var dao = JoinGroupDAO();

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
                  "Czy chcesz dołączyć do grupy:",
                  style: TextStyle(fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 20)),
                Text(
                  widget.groupName,
                  style: const TextStyle(color: Colors.green, fontSize: 18),
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
                            onPressed: () async {
                              await dao.joinGroup(widget.groupId);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context, "Dołączono do grupy");
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
                              Navigator.pop(context, "Wycofano dołączanie");
                            },
                            child: const Text("NIE"))),
                  ],
                )
              ],
            ))));
  }
}
