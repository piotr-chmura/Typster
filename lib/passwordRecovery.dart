import 'package:flutter/material.dart';
import 'package:test_app/passwordRecoveryCode.dart';
import 'backend/buissnesObject.dart';
import 'backend/passwordRecoveryBackend.dart';

class PasswordRecovery extends StatefulWidget {
  const PasswordRecovery({super.key});

  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  TextEditingController emailController = TextEditingController();
  String validate1 = "";
  var dao = PasswordRecDAO();
  bool _buttonEnabled = true;
//alert typu pop-up

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
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
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: const Text(
                "Podaj adres email konta",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "E-mail",
                      errorText: isNullOrEmpty(validate1) ? null : validate1),
                )),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ElevatedButton(
                  onPressed: _buttonEnabled
                    ? () async {
                    _switchButton();
                    String email = emailController.text;
                    setState(() {
                      validate1 = isValidEmail(email);
                    });
                    if (isNullOrEmpty(validate1)) {
                      String result = "";
                      List<String> nameCode = [];
                      try {
                        nameCode = await dao.sendCode(email);
                      } catch (e) {
                        if (e.toString() == 'Brak konta z takim emailem') {
                          result = e.toString();
                        } else {
                          result = "Błąd bazy: $e";
                        }
                      }
                      if (result == "") {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PasswordRecoveryCode(
                                    email: email,
                                    name: nameCode[0],
                                    code: nameCode[1])));
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Błąd'),
                            content: Text(result),
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
          ],
        ),
      ),
    );
  }
}
