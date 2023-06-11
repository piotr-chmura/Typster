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

  void showPopup(BuildContext context) {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Czy chcesz się wylogować ?'),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Anuluj'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Zamknięcie okienka
                  },
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  child: const Text('Potwierdź'),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('username');
                    await prefs.remove('date');
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (Route<dynamic> route) => false, // Usunięcie wszystkich poprzednich tras
                    );
                  },
              ),
            )
          ]
          )
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(50, 50, 50, 1.0),  
            ),
            child: Image(
                      width: 120,
                      image: AssetImage(
                          "lib/resources/App Logo/typster-baner2.png")
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
            leading: const Icon(Icons.assignment_ind),
            title: const Text('Historia typowań'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const BetHistory()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Wyloguj'),
            
            onTap: () {
              showPopup(context);
            },
            
            /*
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('username');
              await prefs.remove('date');
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
            */
          ),
        ],
      ),
    );
  }
}
