// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:test_app/login.dart';
import 'backend/database.dart';
import 'backend/BuissnesObject.dart';
import 'backend/passwordRecoveryBackend.dart';

class ChangePasswordByEmail extends StatefulWidget {
  const ChangePasswordByEmail({super.key, required this.email});

  final String email;
  @override
  _ChangePasswordByEmail createState() => _ChangePasswordByEmail();
}

class _ChangePasswordByEmail extends State<ChangePasswordByEmail> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  String validate1 = "";
  bool validate2 = true;
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
              child: const Center(child: Text('Typster')))),
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
                  "Podaj nowe hasło",
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
              ),
              TextField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                    labelText: 'Hasło',
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
              const SizedBox(height: 10),
              TextField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                    labelText: 'Powtórz hasło',
                    errorText: validate2 ? null : 'Hasła muszą być takie same'),
                controller: _controller2,
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    onPressed: _buttonEnabled
                            ? () async {
                      _switchButton();
                      String password = _controller1.text;
                      String password2 = _controller2.text;
                      setState(() {
                        validate1 = isValidPassword(password);
                        isEven(password2, password)
                            ? validate2 = true
                            : validate2 = false;
                      });
                      if (isNullOrEmpty(validate1) && validate2) {
                        try {
                          await dao.changePassword(widget.email, password);
                        } catch (e) {
                          print(e.toString());
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
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
