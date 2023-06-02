// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:test_app/backend/createGroupBackend.dart';
import 'package:test_app/backend/database.dart';

import 'backend/BuissnesObject.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  _CreateGroup createState() => _CreateGroup();
}

class _CreateGroup extends State<CreateGroup> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  bool validate1 = true;
  bool validate2 = true;
  bool _buttonEnabled = true;
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

  void _switchButton() {
    if (_buttonEnabled) {
      setState(() {
        _buttonEnabled = false;
      });
    } else {
      setState(() {
        _buttonEnabled = true;
      });
    }
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
                    child: const Text("Stwórz grupę",
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
                              child: Text("Potwierdź",
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
                    width: 300,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                        onPressed: _buttonEnabled
                            ? () async {
                                _switchButton();
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
                                if (validate1 &&
                                    validate2 &&
                                    value.isNotEmpty) {
                                  GroupCreate group = GroupCreate(
                                      groupName, groupDescription, value);
                                  String result = "Uworzono grupę";
                                  try {
                                    await dao.insertGroup(group);
                                  } catch (e) {
                                    if (e
                                        .toString()
                                        .contains("Duplicate entry")) {
                                      result =
                                          "Istnieje już grupa o takiej nazwie";
                                    } else {
                                      result = e.toString().substring(11);
                                    }
                                  }
                                  if (result == "Uworzono grupę") {
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context, result);
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Błąd'),
                                        content: Text(result),
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
                                } else {
                                  String error = "";
                                  if (!validate1) {
                                    error = "Wybierz nazwę grupy";
                                  } else if (!validate2) {
                                    error = "Dodaj opis";
                                  } else {
                                    error = "Nie wybrano żadnej ligi";
                                  }
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Błąd brak danych'),
                                      content: Text(error),
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
                                _switchButton();
                              }
                            : null,
                        child: const Text("Stwórz grupę")))
              ],
            )
          ])
        ]));
  }
}
