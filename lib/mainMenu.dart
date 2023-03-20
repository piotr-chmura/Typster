import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_app/side_menu.dart';

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

  Widget matches() {
    return Expanded(
      child: Column(
        children: <Widget>[
          mecz("Bundesliga","26.02.2023, 16:15","Freiburg","Bayern Leverkusen"),
          mecz("Ekstraklasa","27.02.2023, 20:10","Legia Warszawa","Pogoń Szczecin")
        ]
      )
    );
  }

  GestureDetector mecz(groupName,data,teamA,teamB){
    return GestureDetector(
      onTap: (){
        if (kDebugMode) {
          print("xD");
        }
      },
      child:Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                    child: Text(
                      "$groupName",
                      style: const TextStyle(
                        color: Colors.green
                      ),
                      ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Text("$data"),
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
                    child: Text("$teamA"),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                    child: Text("$teamB"),
                  )
                ],
              )
          ],
        )
      )
    );
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.green,
          size: 30,
          ),
        title: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
          child:const Center(
            child:Text('Typster')
            )
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
            matches()
          ]
        )
      )
    );
  }
}