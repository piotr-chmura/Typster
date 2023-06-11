import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/backend/loginBackend.dart';
import 'package:test_app/backend/database.dart';
import 'package:test_app/passwordRecovery.dart';
import 'package:test_app/passwordRecoveryCode.dart';
import 'backend/buissnesObject.dart';
import 'package:test_app/register.dart';
import 'package:test_app/mainMenu.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var dao = LoginDAO();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool validate1 = true;
  bool validate2 = true;
  bool hidePassword = true;
  bool isChecked = false;
  bool _buttonEnabled = true;
  String usernameGlobal = "";
  int counter = 0;

//alert typu pop-up

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
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

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Register()),
    );

    if (!mounted) return;
    if (result == null) return;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Center(
            child: Text('$result', style: const TextStyle(color: Colors.green)),
          ),
          duration: const Duration(milliseconds: 3000),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 66, 66, 66)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Image(
              width: 120,
              image: AssetImage(
                  "lib/resources/App Logo/typster-baner.png")
              )
            )
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              child: const Text(
                "Logowanie",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Nazwa użytkownika",
                      errorText:
                          validate1 ? null : 'Nazwa użytkownika jest wymagana'),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                child: TextField(
                  obscureText: hidePassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Hasło",
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
                      errorText: validate2 ? null : 'Hasło jest wymagane'),
                )),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const Text("Zapamiętaj dane logowania"),
              Checkbox(
                  value: isChecked,
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.green),
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  })
            ]),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ElevatedButton(
                  onPressed: _buttonEnabled
                      ? () async {
                          _switchButton();
                          var time = await SharedPreferences.getInstance();
                          var dateList = time.getStringList('timeFailLogin');
                          int minutesDiff;
                          if(dateList != null){
                            var dateSaved = DateTime(int.parse(dateList[4]), int.parse(dateList[3]),
                            int.parse(dateList[2]), int.parse(dateList[1]), int.parse(dateList[0]));
                            var dateNow = DateTime.now();
                            Duration difference = dateNow.difference(dateSaved);
                            minutesDiff = difference.inMinutes;
                          }else{
                            minutesDiff = 2;
                          }
                          if(minutesDiff >= 1){

                          String username = usernameController.text;
                          String password = passwordController.text;
                          setState(() {
                            isNullOrEmpty(username)
                                ? validate1 = false
                                : validate1 = true;
                            isNullOrEmpty(password)
                                ? validate2 = false
                                : validate2 = true;
                          });
                          if (validate1 && validate2) {
                            User user = User(username, password, "", 0);
                            String res = "";
                            await dao.loginUser(user).then((result) {
                              res = result;
                            }).catchError((error) {
                              res = error;
                            });
                            if (int.tryParse(res) != null) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('username', username);
                              await prefs.setString('id', res);
                              if (isChecked) {
                                DateTime now = DateTime.now();
                                //DateTime(now.year, now.month, now.day);
                                await prefs.setStringList('date', [
                                  now.day.toString(),
                                  now.month.toString(),
                                  now.year.toString()
                                ]);
                              }
                              counter = 0; //przywrócenie licznika
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainMenu()));
                            } else {
                              if(usernameGlobal == usernameController.text)
                              {
                                counter++;
                              }else
                              {
                                usernameGlobal = usernameController.text;
                              }
                              //Ustawienie blokady jeżeli próbowano zalogować sie 5 razy na to samo konto
                              if(counter >= 5)
                              {
                              final prefs = await SharedPreferences.getInstance();
                                DateTime now = DateTime.now();
                                //DateTime(now.year, now.month, now.day);
                                await prefs.setStringList('timeFailLogin', [
                                  now.minute.toString(),
                                  now.hour.toString(),
                                  now.day.toString(),
                                  now.month.toString(),
                                  now.year.toString()
                                ]);
                                counter = 0;
                                // ignore: use_build_context_synchronously
                                await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Błąd logowania'),
                                  content: const Text("Następuje blokada logowania spróbuj ponownie za minute"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              //Jeżeli nie przekroczono limitu prób
                              }else{
                              // ignore: use_build_context_synchronously
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Błąd'),
                                  content: Text(res),
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
                            }
                          }
                          }else{
                            //różnica czasu mniejsza niż 1 minut czyli nie upłynoł czas blokady
                            // ignore: use_build_context_synchronously
                           showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Błąd logowania'),
                                  content: const Text("Nastąpiła blokada logowania spróbuj ponownie za minute"),
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
                  child: const Text("Zaloguj")),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const Text("Nie masz konta?"),
              InkWell(
                child: TextButton(
                  onPressed: _buttonEnabled
                      ? () {
                          _navigateAndDisplaySelection(context);
                        }
                      : null,
                  child: const Text("Załóż konto"),
                ),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const Text("Zapomniałeś hasła?"),
              InkWell(
                child: TextButton(
                  onPressed: _buttonEnabled
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PasswordRecovery()));
                        }
                      : null,
                  child: const Text("Odzyskaj hasło"),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
