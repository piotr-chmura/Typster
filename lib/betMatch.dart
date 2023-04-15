// ignore_for_file: prefer_final_fields, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'backend/buissnesObject.dart';
import 'package:test_app/backend/matchesBackend.dart';
import 'package:test_app/backend/database.dart';

class BetMatch extends StatefulWidget {
  const BetMatch(
      {super.key,
      required this.matchId,
      required this.leagueName,
      required this.teamA,
      required this.teamB,
      required this.date,
      required this.leagueId});

  final int matchId;
  final String leagueName, teamA, teamB, date, leagueId;

  @override
  _BetMatch createState() => _BetMatch();
}

class _BetMatch extends State<BetMatch> {
  TextEditingController teamA_bet = TextEditingController();
  TextEditingController teamB_bet = TextEditingController();
  String validate1 = "";
  String validate2 = "";
  var dao = MatchesDAO();

  Future<void> getBet() async {
    try {
      List<String> score = await dao.getBet(widget.matchId.toString());
      teamA_bet.text = score[0];
      teamB_bet.text = score[1];
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getBet();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    teamA_bet.dispose();
    teamB_bet.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Center(child: Text('Obstaw mecz          '))),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: Center(
                child: ListView(
              children: <Widget>[
                const Center(
                    child: Text(
                  "Obstaw wynik meczu",
                  style: TextStyle(fontSize: 20),
                )),
                const Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 20)),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 5,
                            color: const Color.fromRGBO(100, 100, 100, 1)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                              child: Text(
                                widget.leagueName,
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
                              child: Text(widget.date),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 20, 5, 20),
                              child: Image(
                                  image: AssetImage(
                                      "lib/resources/Team logos/" +
                                          widget.leagueId +
                                          "/" +
                                          widget.teamA +
                                          ".png")),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.fromLTRB(5, 20, 10, 20),
                              child: Image(
                                  image: AssetImage(
                                      "lib/resources/Team logos/" +
                                          widget.leagueId +
                                          "/" +
                                          widget.teamB +
                                          ".png")),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 5, 0),
                              child: Text(widget.teamA,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.fromLTRB(5, 10, 20, 0),
                              child: Text(
                                widget.teamB,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 150,
                          height: 100,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextField(
                              controller: teamA_bet,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Wynik drużyny A",
                                  errorText: isNullOrEmpty(validate1)
                                      ? null
                                      : validate1))),
                      Container(
                          width: 150,
                          height: 100,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextField(
                              controller: teamB_bet,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Wynik drużyny B",
                                  errorText: isNullOrEmpty(validate2)
                                      ? null
                                      : validate2)))
                    ]),
                const Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        height: 60,
                        width: 150,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: ElevatedButton(
                            onPressed: () async {
                              var teamABet = teamA_bet.text;
                              var teamBBet = teamB_bet.text;
                              String result = "Obstawiono mecz!";
                              setState(() {
                                validate1 = isValidInt(teamABet);
                                validate2 = isValidInt(teamBBet);
                              });
                              if (isNullOrEmpty(validate1) &&
                                  isNullOrEmpty(validate2)) {
                                try {
                                  await dao.placeBet(widget.matchId.toString(),
                                      teamABet, teamBBet);
                                } catch (e) {
                                  result = e.toString();
                                }
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, result);
                              }
                            },
                            child: const Text("OBSTAW"))),
                    Container(
                        height: 60,
                        width: 150,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 0, 0)),
                            onPressed: () {
                              Navigator.pop(context, "Wycofano obstawianie");
                            },
                            child: const Text("WYCOFAJ"))),
                  ],
                )
              ],
            ))));
  }
}
