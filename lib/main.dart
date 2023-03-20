import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application. test
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Typster',
      theme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.green),
      home: const Login(),
    );
  }
}
