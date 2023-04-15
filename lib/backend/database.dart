import 'package:mysql_client/mysql_client.dart';
import 'dart:async';

class Mysql {
  static String host = "217.96.199.27",
      userName = "Host_PCH_API_UPDATE",
      password = "h>k96{U9M8#2Qr8_",
      databaseName = "typster";

  static int port = 3306;

  Mysql();

  Future<MySQLConnection> getConn() async {
    return await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: userName,
        password: password,
        databaseName: databaseName);
  }
}

class User {
  String? username, password, email;
  int id = 0;

  User(this.username, this.password, this.email, this.id);
}

class Group {
  String? name, admin;
  int id;

  Group(this.id, this.name, this.admin);
}

class Match {
  String? name, teamA, teamB, dateString, leagueId;
  DateTime date;
  int id;
  int? scoreA, scoreB, status;

  Match(this.name, this.date, this.teamA, this.teamB, this.id, this.scoreA,
      this.scoreB, this.dateString, this.leagueId) {
    status = _getStatus(scoreA, date);
  }

  //1 do obstawienia, 2 w trakcie, 3 zakończony
  int _getStatus(int? score, DateTime date) {
    if (score == null) {
      if (date.isBefore(DateTime.now())) {
        return 2;
      } else {
        return 1;
      }
    } else {
      return 3;
    }
  }
}
