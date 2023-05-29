// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:test_app/backend/groupsBackend.dart';
import 'package:test_app/backend/database.dart';

import 'yourGroups.dart';

class ExitGroup extends StatefulWidget {
  const ExitGroup({super.key, required this.groupName, required this.groupId});

  final String groupName;
  final int groupId;

  @override
  _ExitGroup createState() => _ExitGroup();
}

class _ExitGroup extends State<ExitGroup> {
  var dao = GroupDAO();
  bool _buttonEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _switchButton() {
    if (_buttonEnabled) {
      setState(() {
        _buttonEnabled = false;
      });
    } else {
      setState(() {
        _buttonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
            child: const Center(child: Text('Typster')
            )
          )
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: Center(
              child: Column(
              children: <Widget>[
                const Text(
                  "Czy chcesz opuścić grupę?",
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
                        onPressed: _buttonEnabled
                        ? () async {
                          _switchButton();
                          try {
                            await dao.leaveGroup(widget.groupId);
                          } catch (e) {
                            print(e);
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const yourGroupsMatches()
                              )
                          );
                          _switchButton();
                        }
                        : null,
                        child: const Text("TAK")
                        )
                      ),
                    Container(
                      height: 60,
                      width: 150,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                            const Color.fromARGB(255, 255, 0, 0)
                        ),
                        onPressed: _buttonEnabled
                        ? () {
                          Navigator.pop(context);
                        }
                        : null,
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
