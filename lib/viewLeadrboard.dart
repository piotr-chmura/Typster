// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class ViewLeaderboard extends StatefulWidget {
  const ViewLeaderboard({super.key, required this.groupname, required this.isTop10});

  final String groupname;
  final bool isTop10; // Jeżeli Top10 jest true to przeszliśmy z liderów, jeżeli nie do z tablicy wyników
  //Jeżeli true to ograniczamy do 10 pierwszych miejsc, jeżeli false to wyświetlamy wszytsko

  @override
  _ViewLeaderboard createState() => _ViewLeaderboard();
}

class _ViewLeaderboard extends State<ViewLeaderboard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DataRow row(nickName,place,points){
    String Crown = "lib/resources/Crowns/$place.png";
    if(place > 3){
      return DataRow(
        cells: [
          DataCell(Center(child: Text(place.toString()))),
          DataCell(Text(nickName)),
          DataCell(Text(points.toString())),
        ]);
    }else{
      return DataRow(
        cells: [
          DataCell(Image 
          (
            image: AssetImage(Crown),
            width: 50,
            height: 50,
            )
          ),
          DataCell(Text(nickName)),
          DataCell(Text(points.toString())),
        ]);
    }
  }

  SingleChildScrollView table() {

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child:DataTable(showCheckboxColumn: false, 
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
                rows: [
                  row("Adam12", 1, 2132),
                  row("Wuja4", 2, 1000),
                  row("Piter3", 3, 800),
                  row("Przegryw8", 4, 2),
                ]
            )
        )
      )
    );
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
                "Tablica wyników dla ${widget.groupname}",
                style: const TextStyle(
                    fontSize: 26,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Center(child: table())
          ])));
  }
}
