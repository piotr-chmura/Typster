import 'package:flutter/material.dart';
import 'package:test_app/backend/Buissnes%20Object.dart';

class MainMenu extends StatefulWidget{
  const MainMenu({super.key});

  
  @override
  _MainMenu createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {

  String username = "USERNAME";

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Typster')
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(30),
              child: const Text(
                "Witaj użytkowniku",
                style: TextStyle(fontSize: 26),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 150),
              child: Text(
                username,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 20
                  ),
                ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
              child: const Text(
                "Zbliżające się wydarzenie",
                style: TextStyle(
                  fontSize: 20
                  ),
                ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: const Color.fromRGBO(100, 100, 100, 1)
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "Bundesliga",
                            style: TextStyle(
                              color: Colors.green
                            ),
                            ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: const Text("Niedziela 24.02, 16:15"),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                          child: const Text("Miejsce na ikone 1"),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                          child: const Text("Miejsce na ikone 2"),
                        )
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                          child: const Text("Nazwa zespołu 1"),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                          child: const Text("Nazwa zespolu 2"),
                        )
                      ],
                    )
                ],
              )
            )
          ]
        )
      )
    );
  }
}