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
  String _description = "";
  bool _buttonEnabled = true;

  Future<void> getDescription() async {
    try {
      _description = await dao.getDescription(widget.groupId);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getDescription();
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
                  "Czy chcesz dołączyć do grupy:",
                  style: TextStyle(fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 20)
                ),
                Text(
                  widget.groupName,
                  style: const TextStyle(color: Colors.green, fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 20)
                ),
                Container(
                  height: 200,
                  width: 300,
                  padding: const EdgeInsets.all(5),
                  child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Opis grupy',
                        labelStyle: const TextStyle(color: Colors.green),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                      ),
                      child: ListView(children: <Widget>[
                        Text(
                          _description,
                        ),
                        ]
                      )
                  )
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 20)
                ),
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
                            await dao.joinGroup(widget.groupId);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, "Dołączono do grupy");
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
                          Navigator.pop(context, "Wycofano dołączanie");
                        }
                        : null,
                        child: const Text("NIE")
                      )
                    ),
                  ],
                )
              ],
            ))));
  }
}
