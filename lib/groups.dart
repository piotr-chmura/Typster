import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_app/sideMenu.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  _Groups createState() => _Groups();
}

class _Groups extends State<Groups> {
  @override
  void initState() {
    super.initState();
  }

  SingleChildScrollView tablica() {
    //dane udające dane z bazy
    int id = 1;
    String groupName = "Bundesliga";
    String ownerNickname = "System";

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(showCheckboxColumn: false, columns: const [
              DataColumn(
                label: Text('ID'),
              ),
              DataColumn(
                label: Text('Nazwa'),
              ),
              DataColumn(
                label: Text('Nickname właściciela'),
              ),
            ], rows: [
              DataRow(
                  onSelectChanged: (bool? select) {
                    if (kDebugMode) {
                      print("$id");
                    }
                  },
                  cells: [
                    DataCell(Text("$id")),
                    DataCell(Text(groupName)),
                    DataCell(Text(ownerNickname)),
                  ])
            ])));
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
                  child: tablica())
            ])));
  }
}
