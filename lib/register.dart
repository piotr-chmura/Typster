import 'package:flutter/material.dart';
import 'package:test_app/backend/Buissnes%20Object.dart';

class Register extends StatefulWidget{
  const Register({super.key});

  
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  bool validate1 = true;
  bool validate2 = true;
  bool validate3 = true;
  bool validate4 = true;
  bool hidePassword = true;

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
  }


  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Rejestracja')
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
            TextField(
              decoration: InputDecoration(
              labelText: 'Nazwa użytkownika',
              errorText: validate1? null : 'Pole nie może być puste'
              ),
            controller: _controller1,
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: hidePassword,
              decoration: InputDecoration(
              labelText: 'Hasło',
              suffixIcon: IconButton(
                icon: Icon(hidePassword? Icons.visibility_off : Icons.visibility), 
                onPressed: () {  
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
              ),
              errorText: validate2? null : 'Pole nie może być puste',
              ),
            controller: _controller2,
            ),
            TextField(
              obscureText: hidePassword,
              decoration: InputDecoration(
              labelText: 'Powtórz hasło',
              errorText: validate3? null : 'Podane hasła nie są takie same'
              ),
            controller: _controller3,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
              labelText: 'Email',
              errorText: validate4? null : 'Pole nie może być puste'
              ),
            controller: _controller4,
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
              onPressed: () {  
                String username = _controller1.text;
                String password = _controller2.text;
                String password2 = _controller3.text;
                String email = _controller4.text;
                setState(() {
                  isNullOrEmpty(username) ? validate1 = false : validate1 = true;
                  isNullOrEmpty(password) ? validate2 = false : validate2 = true;
                  isEven(password, password2) ? validate3 = false : validate3 = true;
                  isNullOrEmpty(email) ? validate4 = false : validate4 = true;
                });
              },
              child: const Text('Załóż konto')
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}