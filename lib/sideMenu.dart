import 'package:flutter/material.dart';
import 'package:test_app/groups.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/login.dart';
import 'package:test_app/matches.dart';

import 'leaderboards.dart';
import 'mainMenu.dart';

class NavDrawer extends StatelessWidget {

  const NavDrawer({super.key, required this.username});
  final String username;
  

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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(
                    builder: (context) => const MainMenu(),
                    settings: RouteSettings(arguments: username)))
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Grupy'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Groups(),
                  settings: RouteSettings(arguments: username)))
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Mecze'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Matches(),
                  settings: RouteSettings(arguments: username)))
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Tablice wyników'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Leaderboard(),
                  settings: RouteSettings(arguments: username)))
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Wyloguj'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('username');
              await prefs.remove('date');
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
          ),
        ],
      ),
    );
  }
}
