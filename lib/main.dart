import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'mainMenu.dart';

void main() async {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'scheduled',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests')
      ],
      debug: true);
  WidgetsFlutterBinding.ensureInitialized();
  bool flag = false;
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username') ?? "";
  final dateList = prefs.getStringList('date');
  if (username != "" && dateList != null) {
    final dateSaved = DateTime(
        int.parse(dateList[2]), int.parse(dateList[1]), int.parse(dateList[0]));
    final dateNow = DateTime.now();
    Duration difference = dateNow.difference(dateSaved);
    int days = difference.inDays;
    if (days > 30) {
      await prefs.remove('username');
      await prefs.remove('date');
    } else {
      flag = true;
    }
  }
  runApp(MyApp(flag: flag));
}

class MyApp extends StatelessWidget {
  final bool flag;
  const MyApp({Key? key, required this.flag}) : super(key: key);

  // This widget is the root of your application. test
  @override
  Widget build(BuildContext context) {
    Widget homeWidget;
    if (flag) {
      homeWidget = const MainMenu();
    } else {
      homeWidget = const Login();
    }
    return MaterialApp(
      title: 'Typster',
      routes: {
        '/login': (context) => Login(), // Ekran logowania jako ścieżka '/login'
        // Dodaj inne ścieżki do innych ekranów
      },
      theme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.green),
      home: homeWidget,
    );
  }
}
