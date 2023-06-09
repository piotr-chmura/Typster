// ignore_for_file: prefer_final_fields

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'backend/database.dart';
import 'backend/registerBackend.dart';
import 'backend/BuissnesObject.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  _About createState() => _About();
}

class _About extends State<About> {
  bool textColor = false;
  Column RULES = Column();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Text rule(String text) {
    if (text.trim() == "ZIELONY") {
      textColor = true;
      text = "";
    }
    if (text.trim() == "BIAŁY") {
      textColor = false;
      text = "";
    }
    if (textColor) {
      return Text(
        text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.green),
      );
    } else {
      return Text(
        text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      );
    }
  }

  Future<String> readTextFile() async {
    final String data = await rootBundle.loadString('lib/resources/ZasadyAplikacjiTypster.txt');
    return data;
  }

  Future<void> rules() async{
    var contents = await readTextFile();
    List<String> parts = contents.split('\n');
    Column Y = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: parts.map((item) {
          return rule(item);
        }).toList());

    setState(() {
    RULES = Y;
  });
  }

  @override
  Widget build(BuildContext context){
    rules();
    return Scaffold(
        appBar: AppBar(
            title: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                child: const Center(
                    child: Image(
                        width: 120,
                        image: AssetImage(
                            "lib/resources/App Logo/typster-baner.png"))))),
        body: ListView(children: <Widget>[
          const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
          const Center(
              child: Text(
            "Zasady działania",
            style: TextStyle(
                color: Colors.green, fontSize: 25, fontWeight: FontWeight.w500),
          )),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: RULES,
          )
        ]));
  }
}
