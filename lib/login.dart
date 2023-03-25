import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/backend/loginBackend.dart';
import 'package:test_app/backend/database.dart';
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
  late List<User> users;
  bool isChecked = false;

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

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Register()),
    );

    if (!mounted) return;
    if(result == null) return;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Center(
            child:Text(
              '$result',
              style: const TextStyle(
              color: Colors.green
              )
            ),
          ),
          duration: const Duration(milliseconds: 3000),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 66, 66, 66)
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Typster"),
        ),
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
                      border: OutlineInputBorder(),
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
                  onPressed: () async {
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
                      User user = User(username, password, "");
                      String res = "";
                      await dao.loginUser(user).then((result) {
                        res = result;
                      }).catchError((error) {
                        res = error;
                      });
                      if (isNullOrEmpty(res)) {
                        if (isChecked) {
                          DateTime now = DateTime.now();
                          //DateTime(now.year, now.month, now.day);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('username', username);
                          await prefs.setStringList('date', [
                            now.day.toString(),
                            now.month.toString(),
                            now.year.toString()
                          ]);
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainMenu(),
                                settings: RouteSettings(arguments: username)));
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Błąd'),
                            content: Text(res),
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
                  child: const Text("Zaloguj")),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const Text("Nie masz konta?"),
              InkWell(
                child: TextButton(
                  onPressed: () {
                    _navigateAndDisplaySelection(context);
                  },
                  child: const Text("Załóż konto"),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
