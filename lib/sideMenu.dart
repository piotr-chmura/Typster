import 'package:flutter/material.dart';
import 'package:test_app/betHistory.dart';
import 'package:test_app/groups.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/login.dart';
import 'package:test_app/matches.dart';
import 'package:test_app/yourGroups.dart';

import 'leaderboards.dart';
import 'mainMenu.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

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
                  MaterialPageRoute(builder: (context) => const MainMenu()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Grupy'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Groups()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Mecze'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Matches()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_work),
            title: const Text('Twoje grupy'),
            onTap: () => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const yourGroupsMatches()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Tablice wyników'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Leaderboard()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Historia typowań'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const BetHistory()))
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
