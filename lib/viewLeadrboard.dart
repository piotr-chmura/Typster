// ignore_for_file: prefer_final_fields
import 'package:awesome_select/awesome_select.dart';
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
  int value = 1;
  List<S2Choice<int>> sezonsList = [S2Choice(value: 1, title: "Aktualny sezon"), S2Choice(value: 2, title: "Sezon 2022")];
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
                child: Text(
                  "Wyniki dla ${widget.groupName}",
                  style: const TextStyle(
                      fontSize: 26,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                child: SmartSelect<int>.single(
                  choiceLayout: S2ChoiceLayout.wrap,
                  choiceStyle: const S2ChoiceStyle(
                      color: Colors.green,
                      titleStyle: TextStyle(color: Colors.green),
                      subtitleStyle: TextStyle(color: Colors.green)),
                  modalType: S2ModalType.popupDialog,
                  modalConfig: S2ModalConfig(
                      useConfirm: true,
                      confirmIcon: null,
                      confirmLabel: Container(
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          width: 100,
                          height: 30,
                          child: const Center(
                              child: Text("Potwierdź",
                                  style: TextStyle(color: Colors.white))))),
                  modalHeaderStyle: const S2ModalHeaderStyle(
                      textStyle: TextStyle(color: Colors.white)
                      ),
                  selectedValue: value,
                  choiceItems: sezonsList,
                  title: "Wybierz sezon",
                  onChange: (state) => setState(() => value = state.value),
                )
                ),
              const SizedBox(height: 20),
              Center(child: table)
            ])));
  }
}
