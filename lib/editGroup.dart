// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:test_app/backend/createGroupBackend.dart';
import 'package:test_app/backend/database.dart';

import 'backend/BuissnesObject.dart';
import 'deleteGroup.dart';

class EditGroup extends StatefulWidget {
  const EditGroup({super.key, required this.groupId, required this.groupName});

  final int groupId;
  final String groupName;

  @override
  _EditGroup createState() => _EditGroup();
}

class _EditGroup extends State<EditGroup> {

  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  bool validate1 = true;
  bool validate2 = true;
  var dao = CreateGroupDAO();
  List<League> leagues = [];

  List<int> value = [];
  List<S2Choice<int>> leaguesList = [];

  Future<void> getLeagues() async {
    try {
      leagues = await dao.getLeagues();
      for (var league in leagues) {
        leaguesList.add(S2Choice<int>(value: league.id, title: league.name));
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getLeagues();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
    groupDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                child: const Center(child: Text('Typster')))),
        body: ListView(children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Center(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                    child: const Text("Edytuj grupę",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.green)))),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField(
                    controller: groupNameController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Nazwa grupy",
                        errorText:
                            validate1 ? null : 'Nazwa grupy jest wymagana'))),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 12,
                    controller: groupDescriptionController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                        labelText: "Opis grupy",
                        errorText:
                            validate2 ? null : 'Opis grupy jest wymagany'))),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SmartSelect<int>.multiple(
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
                              child: Text("Potwierdz",
                                  style: TextStyle(color: Colors.white))))),
                  modalHeaderStyle: const S2ModalHeaderStyle(
                      textStyle: TextStyle(color: Colors.white),
                      centerTitle: true),
                  selectedValue: value,
                  choiceItems: leaguesList,
                  title: "Wybierz ligi",
                  onChange: (state) => setState(() => value = state.value),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    height: 70,
                    width: 200,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                        onPressed: () {
                          String groupName = groupNameController.text;
                          String groupDescription =
                              groupDescriptionController.text;
                          setState(() {
                            isNullOrEmpty(groupName)
                                ? validate1 = false
                                : validate1 = true;
                            isNullOrEmpty(groupDescription)
                                ? validate2 = false
                                : validate2 = true;
                          });
                          if (validate1 && validate2 && value.isNotEmpty) {
                            Navigator.pop(context, "Edytuj grupę");
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Błąd brak danych'),
                                content: const Text("Nie wybrano żadnej z lig"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text("Edytuj grupę"))),
                Container(
                    height: 70,
                    width: 200,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeleteGroup(groupName: widget.groupName, groupId: widget.groupId))
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Usuń grupę")))
              ],
            )
          ])
        ]));
  }
}
