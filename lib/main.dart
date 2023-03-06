import 'package:flutter/material.dart';

import 'backend/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  var db = Mysql();
  var name = '';

  //baza
  Future<String> getName() async {
    String name2 = "";
    await db.getConn().then((conn) async {
      String sql = 'select nazwisko from test.testowa where id_testowa = 1;';
      await conn.connect();
      await conn.execute(sql).then((results) {
        for (var row in results.rows) {
          name2 = row.colAt(0)!;
        }
      });
    });
    return name2;
  }

  void _setName() {
    getName().then((results) {
      setState(() {
        name = results;
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
              '$name'
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: _setName,
              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Text('bottom'),
        elevation: 0,
      ),
    );
  }
}
