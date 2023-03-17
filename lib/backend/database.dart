import 'package:mysql_client/mysql_client.dart';
import 'dart:async';

class Mysql {
  static String host = "217.96.203.130",
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

  User(this.username, this.password, this.email);
}
