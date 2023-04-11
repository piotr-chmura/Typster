import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/sideMenu.dart';
import 'betMatch.dart';

class Matches extends StatefulWidget {
  const Matches({super.key});

  @override
  _Matches createState() => _Matches();
}

class _Matches extends State<Matches> {
  String username = "";

  Future<void> _navigateAndDisplaySelection(BuildContext context, int match_id,
      String groupName, teamA, teamB, data) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BetMatch(
              match_id: match_id,
              groupName: groupName,
              teamA: teamA,
              teamB: teamB,
              data: data)),
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

  @override
  void initState() {
    super.initState();
  }

  Widget matches() {
      return Column(children: <Widget>[
      mecz("Bundesliga", "26.02.2023, 16:15", "Borussia Dortmund",
          "Bayer Leverkusen", 1,"Zakonczony"),
      mecz("Seria A", "27.02.2023, 20:10", "Inter", "Juventus", 2,"Dostepny")
    ]);
  }

  GestureDetector mecz(groupName, data, teamA, teamB, match_id, status) {
    Color T_color =  Color.fromRGBO(20, 150, 37, 1);
    if(status == "Zakonczony"){
      T_color = Color.fromRGBO(140, 15, 15, 1);
    }else if(status == "W trakcie"){
      T_color =Color.fromRGBO(100, 100, 100, 1);
    }
    return GestureDetector(
        onTap: () {
          if(status == "Dostepny"){
          _navigateAndDisplaySelection(
              context, match_id, groupName, teamA, teamB, data);
          }
          else{
            ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(
            content: Center(
              child: Text("Brak możliwości typowania meczu w trakcie lub zakończonego", style: TextStyle(color: Colors.green)),
            ),
            duration: Duration(milliseconds: 3000),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color.fromARGB(255, 66, 66, 66)));
          }
        },
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 5, color: T_color),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                      child: Text(
                        "$groupName",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
                      child: Text("$data"),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 20, 5, 20),
                      child: Image(
                          image: AssetImage(
                              "lib/resources/Team logos/2/" + teamA + ".png")),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 20, 10, 20),
                      child: Image(
                          image: AssetImage(
                              "lib/resources/Team logos/2/" + teamB + ".png")),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 5, 0),
                      child: Text("$teamA",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 20, 20, 0),
                      child: Text(
                        "$teamB",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.green,
              size: 30,
            ),
            title: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                child: const Center(child: Text('Typster')))),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: const Text(
                  "Mecze",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ),
              matches()
            ])));
  }
}
