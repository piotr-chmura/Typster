// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'backend/database.dart';
import 'backend/groupsBackend.dart';
import 'changePassword.dart';

class Account extends StatefulWidget {
  const Account({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  _Account createState() => _Account();
}

class _Account extends State<Account> {
  List<String> groups = [];
  List<String> groups2 = [];
  var dao = GroupDAO();

  Future<void> getGroups() async {
    try {
      groups = await dao.userGroupListProfile();
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  Future<void> getOwnedGroups() async {
    try {
      groups2 = await dao.userOwnedGroupListProfile();
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  void initState() {
    getGroups();
    getOwnedGroups();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePassword()),
    );

    if (!mounted) return;
    if (result == null) return;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Center(
            child: Text('$result', style: const TextStyle(color: Colors.green)),
          ),
          duration: const Duration(milliseconds: 3000),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 66, 66, 66)));
  }

  ListTile wiersz(String text) {
    return ListTile(title: Text(text));
  }

  ExpansionTile exp(List<String> list, title) {
    return ExpansionTile(
      title: Text(title),
      children: list.map<ListTile>((String text) {
        return wiersz(text);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
              child: const Center(child: Image(
                      width: 120,
                      image: AssetImage(
                          "lib/resources/App Logo/typster-baner.png")
                      )
                    )
          )
      ),
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
            child: const Text(
              "Dane konta",
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            child: Text(
              widget.userName,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          exp(groups, "Grupy do których należysz (${groups.length})"),
          exp(groups2, "Grupy których jesteś właścicielem (${groups2.length})"),
          const Padding(padding: EdgeInsets.all(20)),
          InkWell(
            child: TextButton(
              onPressed: () {
                _navigateAndDisplaySelection(context);
              },
              child: const Text(
                "Zmień hasło",
                textAlign: TextAlign.left,
              ),
            ),
          )
        ],
      ),
    );
  }
}
