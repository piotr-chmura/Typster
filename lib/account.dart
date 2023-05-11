// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:test_app/login.dart';
import 'backend/database.dart';
import 'backend/BuissnesObject.dart';
import 'changePassword.dart';

class Account extends StatefulWidget {
  const Account({super.key, required this.userName,});

   final String userName;

  @override
  _Account createState() => _Account();
}

class _Account extends State<Account> {

  List<String> listaTestowa = ['1','2','xd'];
  List<String> listaTestowa2 = ['tak','2354','xd2','nie'];

  @override
  void initState() {
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

 ListTile wiersz(String text){
  return ListTile(title: Text(text));
 }

 ExpansionTile exp(List<String> list, title){
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
          child: const Center(child: Text('Typster'))
          )
        ),
      body: Column(
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
          exp(listaTestowa, "Grupy do których należysz"),
          exp(listaTestowa2, "Grupy których jesteś właścicielem"),
          const Padding(padding: EdgeInsets.all(20)),
          InkWell(
            child: TextButton(
              onPressed: () {
                _navigateAndDisplaySelection(context);
              },
              child: const Text("Zmień hasło", textAlign: TextAlign.left,),
            ),
          )
        ],
      ),
    );
  }
}
