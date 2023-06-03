// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'backend/database.dart';
import 'backend/BuissnesObject.dart';
import 'backend/passwordRecoveryBackend.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  String validate1 = "";
  String validate2 = "";
  bool validate3 = true;
  bool hidePassword = true;
  var dao = PasswordRecDAO();
  bool _buttonEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
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
              child: const Center(child: Image(
                      width: 120,
                      image: AssetImage(
                          "lib/resources/App Logo/typster-baner.png")
                      )
                    )
          )
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: const Text(
                  "Zmień swoje hasło",
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
              ),
              TextField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                    labelText: 'Stare hasło',
                    suffixIcon: IconButton(
                      icon: Icon(hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    errorText: isNullOrEmpty(validate1) ? null : validate1),
                controller: _controller1,
              ),
              TextField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                    labelText: 'Nowe hasło',
                    errorText: isNullOrEmpty(validate2) ? null : validate2),
                controller: _controller2,
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                    labelText: 'Powtórz hasło',
                    errorText: validate3 ? null : 'Hasła muszą być takie same'),
                controller: _controller3,
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    onPressed: _buttonEnabled
                            ? () async {
                      _switchButton();
                      String oldPassword = _controller1.text;
                      String newPassword = _controller2.text;
                      String newPassword2 = _controller3.text;
                      setState(() {
                        validate1 = isValidPassword(oldPassword);
                        validate2 = isValidPassword(newPassword);
                        isEven(newPassword, newPassword2)
                            ? validate3 = true
                            : validate3 = false;
                      });
                      if (isNullOrEmpty(validate1) &&
                          isNullOrEmpty(validate2) &&
                          validate3) {
                        String res = "Poprawnie zmieniono hasło!";
                        try {
                          await dao.changePassword2(newPassword, oldPassword);
                        } catch (e) {
                          res = e.toString();
                        }
                        if (res == "Poprawnie zmieniono hasło!") {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context, res);
                        } else {
                          // ignore: use_build_context_synchronously
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Błąd'),
                              content: Text(res.substring(11)),
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
                    child: const Text('Zmień hasło')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
