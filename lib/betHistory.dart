import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/backend/matchesBackend.dart';
import 'package:test_app/backend/database.dart';
import 'betMatch.dart';
import 'sideMenu.dart';

class BetHistory extends StatefulWidget {
  const BetHistory({super.key});

  @override
  _BetHistory createState() => _BetHistory();
}

class _BetHistory extends State<BetHistory> {
  String username = "";
  Column matchListView = Column();
  var dao = MatchesDAO();
  List<Match> matches = [];

  Future<void> getMatches() async {
    try {
      matches = await dao.matchesList();
      matchesView();
    } catch (e) {
      List<Widget> matchWidgetError = [
        const Text(
          "Brak meczy do wyświetlenia",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.green),
        )
      ];
      matchListView = Column(children: matchWidgetError);
      setState(() {});
    }
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('username') ?? "";
    setState(() {
      username = userName;
    });
  }

  @override
  void initState() {
    getUsername();
    getMatches();
    super.initState();
  }

  void matchesView() {
    List<Widget> matchWidgets = [];
    for (var match in matches) {
      matchWidgets.add(matchWidget(
          match.name,
          match.dateString,
          match.teamA,
          match.teamB,
          match.id,
          match.status,
          match.scoreA,
          match.scoreB,
          match.leagueId));
    }
    matchListView = Column(children: matchWidgets);
    setState(() {});
  }

  Container matchWidget(leagueName, date, teamA, teamB, matchId, status,
      scoreA, scoreB, leagueId) {
    return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
                border: Border.all(width: 5, color: const Color.fromRGBO(140, 15, 15, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                      child: Text(
                        "$leagueName",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
                      child: Text("$date"),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 20, 5, 20),
                      child: Image(
                        width: 150,
                        image: AssetImage(
                            "lib/resources/Team logos/$leagueId/$teamA.png")),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 20, 10, 20),
                      child: Image(
                        width: 150,
                        image: AssetImage(
                            "lib/resources/Team logos/$leagueId/$teamB.png")),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                      child: Text("$teamA",
                          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.green)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
                      child: Text(
                        "$teamB",
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: const Text("Wynik faktyczny",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 10)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(00, 10, 0, 0),
                      child: const Text("Wynik obstawiony",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 10)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text("$scoreA"" - ""$scoreB",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 30)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text("21 - 37",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 30)),
                    ),
                  ],
                )
              ],
            ));
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
                  "Witaj użytkowniku",
                  style: TextStyle(fontSize: 26),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 150),
                child: Text(
                  username,
                  style: const TextStyle(color: Colors.green, fontSize: 20),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                child: const Text(
                  "Zbliżające się wydarzenie",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              matchListView
            ])));
  }
}
