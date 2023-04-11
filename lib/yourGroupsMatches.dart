import 'package:flutter/material.dart';
import 'package:test_app/backend/groupsBackend.dart';
import 'package:test_app/backend/database.dart';
import 'package:test_app/sideMenu.dart';
import 'package:test_app/yourMatches.dart';
import 'joinGroup.dart';

class yourGroupsMatches extends StatefulWidget {
  const yourGroupsMatches({super.key});

  @override
  _yourGroupsMatches createState() => _yourGroupsMatches();
}

class _yourGroupsMatches extends State<yourGroupsMatches> {
  var dao = GroupDAO();
  List<Group> groups = [];
  List<DataRow> rows = [];
  SingleChildScrollView table = SingleChildScrollView(
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
                  label: Text('Właściciel'),
                ),
              ],
              // ignore: prefer_const_literals_to_create_immutables
              rows: [])));
  String username = "";

  Future<void> getGroups() async {
    try {
      groups = await dao.groupList();
      getRows();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _navigateAndDisplaySelection(
      BuildContext context, String groupName, int groupId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              yourMatches(groupId: groupId)),
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
    getGroups();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DataRow row(groupName, ownerNickname, groupId) {
    return DataRow(
        onSelectChanged: (bool? select) {
          _navigateAndDisplaySelection(context, groupName, groupId);
        },
        cells: [
          DataCell(Text(groupName)),
          DataCell(Text(ownerNickname)),
        ]);
  }

  void getRows({String searchString = ""}) {
    List<DataRow> rows = [];
    for (var group in groups) {
      if (group.name!.contains(searchString)) {
        rows.add(row(group.name, group.admin, group.id));
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
                    label: Text('Właściciel'),
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
                child: const Center(child: Text('Typster')))),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: const Text(
                  "Twoje grupy",
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
