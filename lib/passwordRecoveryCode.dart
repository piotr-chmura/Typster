import 'package:flutter/material.dart';
import 'package:test_app/changePasswordByEmail.dart';
import 'backend/buissnesObject.dart';
import 'backend/passwordRecoveryBackend.dart';

class PasswordRecoveryCode extends StatefulWidget {
  PasswordRecoveryCode(
      {super.key, required this.email, required this.name, required this.code});

  final String email;
  String code;
  final String name;
  @override
  _PasswordRecoveryCode createState() => _PasswordRecoveryCode();
}

class _PasswordRecoveryCode extends State<PasswordRecoveryCode> {
  List<TextEditingController> code =
      List.generate(5, (_) => TextEditingController());
  List<bool> validate = List.generate(5, (_) => true);
  var dao = PasswordRecDAO();
  bool _buttonEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    code[0].dispose();
    code[1].dispose();
    code[2].dispose();
    code[3].dispose();
    code[4].dispose();
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

  Expanded CodeGen(TextEditingController code, validate) {
    return Expanded(
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
            child: TextField(
              maxLength: 1,
              controller: code,
              textAlign: TextAlign.center,
              onChanged: (value) {
                if(code.value.text.isNotEmpty){
                FocusScope.of(context).nextFocus();
                }else{
                FocusScope.of(context).previousFocus();
                }
              },
              decoration: InputDecoration(
                  counterText: '',
                  border: const OutlineInputBorder(),
                  errorText: validate ? null : ''),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
            child: const Center(child: Text('Typster'))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              child: const Text(
                "Odzyskiwanie hasła",
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: const Text(
                "Podaj kod przysłany na adres e-mail",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(children: <Widget>[
              CodeGen(code[0], validate[0]),
              CodeGen(code[1], validate[1]),
              CodeGen(code[2], validate[2]),
              CodeGen(code[3], validate[3]),
              CodeGen(code[4], validate[4])
            ]),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ElevatedButton(
                  onPressed: _buttonEnabled
                    ? () async {
                    _switchButton();
                    String fullCode = code[0].text +
                        code[1].text +
                        code[2].text +
                        code[3].text +
                        code[4].text;
                    setState(() {
                      isNullOrEmpty(code[0].text)
                          ? validate[0] = false
                          : validate[0] = true;
                      isNullOrEmpty(code[1].text)
                          ? validate[1] = false
                          : validate[1] = true;
                      isNullOrEmpty(code[2].text)
                          ? validate[2] = false
                          : validate[2] = true;
                      isNullOrEmpty(code[3].text)
                          ? validate[3] = false
                          : validate[3] = true;
                      isNullOrEmpty(code[4].text)
                          ? validate[4] = false
                          : validate[4] = true;
                    });
                    if (validate[0] &&
                        validate[1] &&
                        validate[2] &&
                        validate[3] &&
                        validate[4]) {
                      if (fullCode == widget.code) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordByEmail(
                                    email: widget.email)));
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Błąd'),
                            content: const Text('Błędny kod'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    _switchButton();
                  }
                  : null,
                  child: const Text("Odzyskaj hasło")),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const Text("Kod nie przyszedł?"),
              InkWell(
                child: TextButton(
                  onPressed: _buttonEnabled
                    ? () async {
                    _switchButton();
                    try {
                      widget.code =
                          await dao.sendCode2(widget.email, widget.name);
                    } catch (e) {
                      print(e.toString());
                    }
                    _switchButton();
                  }
                  : null,
                  child: const Text("Wyślij ponownie"),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
