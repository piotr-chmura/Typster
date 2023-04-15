import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/sideMenu.dart';
import 'joinGroup.dart';
import 'viewLeadrboard.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  _Leaderboard createState() => _Leaderboard();
}

class _Leaderboard extends State<Leaderboard> {

  String username = "";
  TextEditingController searchBarController= TextEditingController();

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

    @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
  }

  DataRow row(groupName,place,points){
    return DataRow(
      onSelectChanged: (bool? select) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewLeaderboard(groupname: groupName, isTop10: false)),
        );
      },
      cells: [
        DataCell(Text(groupName)),
        DataCell(Text(place.toString())),
        DataCell(Text(points.toString())),
      ]);
  }

  SingleChildScrollView table() {

    return SingleChildScrollView(
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
            ], 
            rows: [
              row("Bundesliga", 12, 213),
              row("Seria A", 1, 1000)
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
                child: TextField(
                  controller: searchBarController,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Wyszukaj grupę",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search), 
                    onPressed: () {  
                      //wyszukaj z bazy dancyh po wartości controlera
                    },
                    )
                  )
                )
              ),
              const SizedBox(height: 20),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: const Color.fromRGBO(100, 100, 100, 1)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: table()
                  )
            ])));
  }
}
