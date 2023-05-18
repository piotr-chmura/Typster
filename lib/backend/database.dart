import 'package:mysql_client/mysql_client.dart';
import 'dart:async';

class Mysql {
  static String host = "217.96.205.29",
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

class GroupCreate {
  String? name, description;
  List<int> leagues = [];

  GroupCreate(this.name, this.description, this.leagues);
}

class League {
  String? name;
  int id;

  League(this.id, this.name);
}

class DescLeagueList {
  String? description;
  List<League> leaguesAll = [];
  List<int> leagues = [];

  DescLeagueList(this.description, this.leagues, this.leaguesAll);
}

class UserPlacement {
  String? username, id, points;

  UserPlacement(this.id, this.username, this.points);
}

class GroupUserPlacement {
  String? name, place, points, id;

  GroupUserPlacement(this.id, this.name, this.place, this.points);
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
    DateTime dateTimeNow = DateTime.now().toUtc().add(const Duration(hours: 2));
    DateTime dateTimeMatch = date.toUtc().add(const Duration(hours: 2));
    if (score == null) {
      if (dateTimeMatch.isBefore(dateTimeNow)) {
        return 2;
      } else {
        return 1;
      }
    } else {
      return 3;
    }
  }
}

class MatchBetHistory {
  String? name, teamA, teamB, dateString, leagueId;
  int? scoreA, scoreB, uScoreA, uScoreB, points = 0;
  MatchBetHistory(this.name, this.teamA, this.teamB, this.scoreA, this.scoreB,
      this.dateString, this.leagueId, this.uScoreA, this.uScoreB) {
    points = _getPoints(scoreA, scoreB, uScoreA, uScoreB);
  }

  int _getPoints(int? scoreA, int? scoreB, int? uScoreA, int? uScoreB) {
    if ((scoreA == uScoreA) && (scoreB == uScoreB)) {
      return 3;
    } else if (scoreA! - scoreB! == uScoreA! - uScoreB!) {
      return 2;
    } else if (((scoreA > scoreB) && (uScoreA > uScoreB)) ||
        ((scoreA < scoreB) && (uScoreA < uScoreB))) {
      return 1;
    } else {
      return 0;
    }
  }
}
