import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_app/sideMenu.dart';
import 'package:test_app/backend/groupsBackend.dart';
import 'package:test_app/backend/database.dart';
import 'viewLeadrboard.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  _Leaderboard createState() => _Leaderboard();
}

class _Leaderboard extends State<Leaderboard> {
  TextEditingController searchBarController = TextEditingController();
  var dao = GroupDAO();
  List<GroupUserPlacement> groups = [];
  List<DataRow> rows = [];
  SingleChildScrollView table = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(showCheckboxColumn: false, columns: const [
            DataColumn(
              label: Text('Nazwa'),
            ),
            DataColumn(
              label: Text('Miejsce'),
            ),
            DataColumn(
              label: Text('Ilość punktów'),
            ),
            // ignore: prefer_const_literals_to_create_immutables
          ], rows: [])));

  Future<void> getGroups() async {
    try {
      groups = await dao.userGroupLeaderboardList();
      getRows();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getGroups();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
  }

  DataRow row(groupName, place, points, groupId) {
    return DataRow(
        onSelectChanged: (bool? select) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewLeaderboard(
                    groupName: groupName, groupId: groupId, isTop10: false)),
          );
        },
        cells: [
          DataCell(Text(groupName)),
          DataCell(Text(place)),
          DataCell(Text(points)),
        ]);
  }

  void getRows({String searchString = ""}) {
    List<DataRow> rows = [];
    for (var group in groups) {
      if (group.name!.contains(searchString)) {
        rows.add(row(group.name, group.place, group.points, group.id));
      }
    }
    this.rows = rows;
    createTable();
  }

  void createTable() {
    table = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(
                    label: Text('Nazwa'),
                  ),
                  DataColumn(
                    label: Text('Miejsce'),
                  ),
                  DataColumn(
                    label: Text('Ilość punktów'),
                  ),
                ],
                rows: rows)));
    setState(() {});
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
                child: const Center(child: Image(
                      width: 120,
                      image: AssetImage(
                          "lib/resources/App Logo/typster-baner.png")
                      )
                    )
            )
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: const Text(
                  "Grupy",
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
                  child: table)
            ])));
  }
}
