// ignore_for_file: prefer_final_fields
import 'package:test_app/backend/leaderboardBackend.dart';
import 'package:test_app/backend/database.dart';
import 'package:flutter/material.dart';

class ViewLeaderboard extends StatefulWidget {
  const ViewLeaderboard(
      {super.key,
      required this.groupName,
      required this.groupId,
      required this.isTop10});

  final String groupName, groupId;
  final bool
      isTop10; // Jeżeli Top10 jest true to przeszliśmy z liderów, jeżeli nie do z tablicy wyników
  //Jeżeli true to ograniczamy do 10 pierwszych miejsc, jeżeli false to wyświetlamy wszytsko

  @override
  _ViewLeaderboard createState() => _ViewLeaderboard();
}

class _ViewLeaderboard extends State<ViewLeaderboard> {
  var dao = LeaderboardDAO();
  List<UserPlacement> users = [];
  List<DataRow> rows = [];
  SingleChildScrollView table = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(
                  label: Text('Miejsce'),
                ),
                DataColumn(
                  label: Text('Nickname'),
                ),
                DataColumn(
                  label: Text('Ilość punktów'),
                ),
              ],
              // ignore: prefer_const_literals_to_create_immutables
              rows: [])));

  Future<void> getUsers() async {
    try {
      users = await dao.leaderboard(widget.groupId, widget.isTop10);
      getRows();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DataRow row(nickName, place, points) {
    if (int.parse(place) > 3) {
      return DataRow(cells: [
        DataCell(Center(child: Text(place))),
        DataCell(Center(
          child: Text(nickName),
        )),
        DataCell(Center(
          child: Text(points),
        )),
      ]);
    } else {
      String crown = "lib/resources/Crowns/$place.png";
      return DataRow(cells: [
        DataCell(Image(
          image: AssetImage(crown),
          width: 50,
          height: 50,
        )),
        DataCell(Center(
          child: Text(nickName),
        )),
        DataCell(Center(
          child: Text(points),
        )),
      ]);
    }
  }

  void getRows() {
    List<DataRow> rows = [];
    for (var user in users) {
      rows.add(row(user.username, user.id, user.points));
    }
    this.rows = rows;
    createTable();
  }

  void createTable() {
    table = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(
                        label: Text('Miejsce'),
                      ),
                      DataColumn(
                        label: Text('Nickname'),
                      ),
                      DataColumn(
                        label: Text('Ilość punktów'),
                      ),
                    ],
                    rows: rows))));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text(
                  "Tablica wyników dla ${widget.groupName}",
                  style: const TextStyle(
                      fontSize: 26,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Center(child: table)
            ])));
  }
}
