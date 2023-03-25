// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'backend/database.dart';
import 'backend/registerBackend.dart';
import 'backend/BuissnesObject.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var dao = RegisterDAO();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  String validate1 = "";
  String validate2 = "";
  bool validate3 = true;
  String validate4 = "";
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Rejestracja          '))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    labelText: 'Nazwa użytkownika',
                    errorText: isNullOrEmpty(validate1) ? null : validate1),
                controller: _controller1,
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: isNullOrEmpty(validate4) ? null : validate4),
                controller: _controller4,
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    onPressed: () async {
                      String username = _controller1.text;
                      String password = _controller2.text;
                      String password2 = _controller3.text;
                      String email = _controller4.text;
                      setState(() {
                        validate1 = isValidUserName(username);
                        validate2 = isValidPassword(password);
                        isEven(password2, password)
                            ? validate3 = true
                            : validate3 = false;
                        validate4 = isValidEmail(email);
                      });
                      if (isNullOrEmpty(validate1) &&
                          isNullOrEmpty(validate2) &&
                          validate3 &&
                          isNullOrEmpty(validate4)) {
                        User user = User(username, password, email);
                        String res = "";
                        await dao.insertUser(user).then((result) {
                          res = result;
                        }).catchError((error) {
                          res = error;
                        });
                        if (isNullOrEmpty(res)) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context, "Zarejestrowano poprawnie");
                        } else {
                          int error = res.indexOf("nickname");
                          String errorElement = "";
                          if (error != -1) {
                            error = res.indexOf("e_mail");
                            if (error != -1) {
                              errorElement = "Błąd serwera.";
                            } else {
                              errorElement =
                                  "Nazwa użytkownika jest już zajęta.";
                            }
                          } else {
                            errorElement =
                                "E-mail jest już przypisany do innego użytkownika.";
                          }
                          // ignore: use_build_context_synchronously
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Błąd'),
                              content: Text(errorElement),
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
                    },
                    child: const Text('Załóż konto')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
