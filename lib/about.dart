// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'backend/database.dart';
import 'backend/registerBackend.dart';
import 'backend/BuissnesObject.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  _About createState() => _About();
}

class _About extends State<About> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Text rules(String text){
    return Text(
              text,
              style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400
              ),
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
      body: Column(children: <Widget>[
        const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
        const Center(
          child: Text(
          "Zasady działania",
          style: TextStyle(
            color: Colors.green,
            fontSize: 25,
            fontWeight: FontWeight.w500
            ),
        )
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(children: <Widget>[        
            rules("1. Użytkownicy ograniczeni są do bycia właścicielem maksymalnie 10 grup"),
          ]
          )
        )
      ]
      )
    );
  }
}
