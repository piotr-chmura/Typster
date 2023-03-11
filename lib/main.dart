import 'package:flutter/material.dart';
import 'backend/database.dart';
import 'backend/Data Acces Object.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Typster',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green
      ),
      home: const Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dao = DAO();
  var name = '';

  //baza
  void _readUser() {
    dao.getUser().then((results) {
      setState(() {
        name = results[0].username!;
      });
    });
  }
/*
  void _Insert() {
    User user = User("user", "word", "whatever@gmail.com");
    dao.insertUser(user);
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text(widget.title),
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$name',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: _readUser,
              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        elevation: 0,
        child: Text('bottom'),
      ),
    );
  }
}
