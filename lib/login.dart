import 'package:flutter/material.dart';
import 'package:test_app/backend/Data%20Acces%20Object.dart';
import 'package:test_app/backend/database.dart';
import 'package:test_app/register.dart';
import 'package:test_app/mainMenu.dart';

class Login extends StatefulWidget{
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
  var dao = DAO();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  late List<User> users;

//alert typu pop-up
  void openDialog(BuildContext context, String dialogTitle, String dialogContent){
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogContent),
          actions: <Widget>[
              TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: const Text('Back'))
          ],
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Username"),
                )
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                child: TextField(
                  obscureText: hidePassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(), 
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(hidePassword? Icons.visibility_off : Icons.visibility), 
                      onPressed: () {  
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      )
                    ),
                )
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ElevatedButton(
                  onPressed: () { 
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainMenu())
                      );
                  },
                  child: const Text("Zaloguj")

                  ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Nie masz konta?"),
                  InkWell(
                    child: TextButton(
                    onPressed: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register())
                      );
                    },
                    child: const Text("Załóż konto"),
                    ),
                  )
                ]
              )
            ],
          ),
        ),
    );
  }
}