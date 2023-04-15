import 'package:flutter/material.dart';
import 'package:test_app/sideMenu.dart';
import 'package:test_app/backend/matchesBackend.dart';
import 'package:test_app/backend/database.dart';
import 'betMatch.dart';
import 'package:flutter/foundation.dart';

class Matches extends StatefulWidget {
  const Matches({super.key});

  @override
  _Matches createState() => _Matches();
}

class _Matches extends State<Matches> {
  String username = "";
  Column matchListView = Column();
  var dao = MatchesDAO();
  List<Match> matches = [];

  Future<void> getMatches() async {
    try {
      matches = await dao.matchesList(true);
      matchesView();
    } catch (e) {
      print("xd");
      print(e);
    }
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context, int matchId,
      String leagueName, teamA, teamB, date, leagueId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BetMatch(
              matchId: matchId,
              leagueName: leagueName,
              teamA: teamA,
              teamB: teamB,
              date: date,
              leagueId: leagueId)),
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

  GestureDetector matchWidget(leagueName, date, teamA, teamB, matchId, status,
      scoreA, scoreB, leagueId) {
    Color T_color = const Color.fromRGBO(20, 150, 37, 1);
    if (status == 3) {
      T_color = const Color.fromRGBO(140, 15, 15, 1);
    } else if (status == 2) {
      T_color = const Color.fromRGBO(100, 100, 100, 1);
    }
    scoreA ??= 0;
    scoreB ??= 0;
    return GestureDetector(
        onTap: () {
          if (status == 1) {
            _navigateAndDisplaySelection(
                context, matchId, leagueName, teamA, teamB, date, leagueId);
          } else {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Center(
                    child: Text(
                        "Brak możliwości typowania meczu w trakcie lub zakończonego",
                        style: TextStyle(color: Colors.green)),
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
                border: Border.all(width: 5, color: T_color),
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
                          image: AssetImage(
                              "lib/resources/Team logos/$leagueId/$teamA.png")
                              ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 20, 10, 20),
                      child: Image(
                          image: AssetImage(
                              "lib/resources/Team logos/$leagueId/$teamB.png")
                              ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(40, 20, 0, 0),
                      child: Text("$scoreA",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 30
                            )
                          ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: const Text("-",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 30
                            )
                          ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 40, 0),
                      child: Text(
                        "$scoreB",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30
                          ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 5, 0),
                      child: Text("$teamA",
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 20, 20, 0),
                      child: Text(
                        "$teamB",
                        style: const TextStyle(fontWeight: FontWeight.w500),
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
              matchListView
            ])));
  }
}
