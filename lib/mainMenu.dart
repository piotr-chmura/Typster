import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/backend/matchesBackend.dart';
import 'package:test_app/backend/database.dart';
import 'account.dart';
import 'betMatch.dart';
import 'sideMenu.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenu createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  String username = "";
  Column matchListView = Column();
  var dao = MatchesDAO();
  List<Match> matches = [];
  List<bool> bet = [];

  Future<void> getMatches() async {
    try {
      var temp = await dao.matchesMainList();
      matches = temp[0];
      bet = temp[1];
      matchesView();
      notification();
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
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    getUsername();
    getMatches();
    super.initState();
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

  Future<void> notification() async {
    bool flag = false;
    flag = await AwesomeNotifications().isNotificationAllowed();
    if (flag) {
      AwesomeNotifications().dismiss(10);
      int i = 0;
      for (bool b in bet) {
        if (b) break;
        i++;
      }
      if (i > 2) return;
      String localTimeZone =
          await AwesomeNotifications().getLocalTimeZoneIdentifier();

      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'scheduled',
              title: 'Masz mecz do obstawienia',
              body:
                  'Obstaw mecz ${matches[i].teamA} - ${matches[i].teamB} (mecz rozpocznie się ${matches[i].dateString}).',
              notificationLayout: NotificationLayout.BigPicture,
              bigPicture: 'asset://assets/images/melted-clock.png'),
          schedule: NotificationInterval(
              interval: 3000, timeZone: localTimeZone, repeats: false));
    }
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
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Expanded(child: Center(child: Text('Typster'))),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.account_circle),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Account(userName: username)));
                    },
                  ),
                ])),
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
