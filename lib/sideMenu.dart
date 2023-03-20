import 'package:flutter/material.dart';
import 'package:test_app/groups.dart';
import 'package:test_app/login.dart';
import 'package:test_app/matches.dart';

import 'mainMenu.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.green,
                /*
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))
                    */
            ),
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Strona główna'),
            onTap: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainMenu()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Grupy'),
            onTap: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Groups()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Mecze'),
            onTap: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Matches()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Wyloguj'),
            onTap: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login()))
            },
          ),
        ],
      ),
    );
  }
}