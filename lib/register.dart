import 'package:flutter/material.dart';
import 'package:test_app/backend/Buissnes%20Object.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  bool validate1 = true;
  bool validate2 = true;
  bool validate3 = true;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Center(child: Text('Rejestracja           '))),
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
                    labelText: 'Username',
                    errorText: validate1 ? null : 'Pole nie może być puste'),
                controller: _controller1,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: validate2 ? null : 'Pole nie może być puste'),
                controller: _controller2,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: validate3 ? null : 'Pole nie może być puste'),
                controller: _controller3,
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    onPressed: () {
                      String username = _controller1.text;
                      String password = _controller2.text;
                      String email = _controller3.text;
                      setState(() {
                        isNullOrEmpty(username)
                            ? validate1 = false
                            : validate1 = true;
                        isNullOrEmpty(password)
                            ? validate2 = false
                            : validate2 = true;
                        isNullOrEmpty(email)
                            ? validate3 = false
                            : validate3 = true;
                      });
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
