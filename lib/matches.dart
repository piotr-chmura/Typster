import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/sideMenu.dart';

class Matches extends StatefulWidget {
  const Matches({super.key});

  @override
  _Matches createState() => _Matches();
}

class _Matches extends State<Matches> {


  String username = "";

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('username') ?? "";
    setState(() {
      username = userName;
    });
  }
  
  @override
  void initState() {
    super.initState();
  }

  SingleChildScrollView tablica() {
    //dane udające dane z bazy
    String groupName = "Bundesliga";
    String teamA = "Freiburg";
    String teamB = "Bayern Leverkusen";
    String data = "26.02.2023, 16:15";

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(showCheckboxColumn: false, columns: const [
              DataColumn(
                label: Text('Grupa'),
              ),
              DataColumn(
                label: Text('Drużyna A'),
              ),
              DataColumn(
                label: Text('Drużyna B'),
              ),
              DataColumn(
                label: Text('Data'),
              ),
            ], rows: [
              DataRow(
                  onSelectChanged: (bool? select) {
                    if (kDebugMode) {
                      print("ok");
                    }
                  },
                  cells: [
                    DataCell(Text(groupName)),
                    DataCell(Text(teamA)),
                    DataCell(Text(teamB)),
                    DataCell(Text(data)),
                  ])
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(username: username),
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
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: const Color.fromRGBO(100, 100, 100, 1)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: tablica())
            ])));
  }
}
