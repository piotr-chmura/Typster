import 'package:mysql_client/mysql_client.dart';
import 'dart:async';

Future<void> main2() async {
  // Open a connection (testdb should already exist)

  final conn = await MySQLConnection.createConnection(
    host: "217.96.203.20",
    port: 3306,
    userName: "Host_PCH_API_UPDATE",
    password: "h>k96{U9M8#2Qr8_",
    databaseName: "test", // optional
  );
  await conn.connect();
  // Create a table
  await conn.execute('INSERT INTO testowa values (2, "Kowalskis")');

  // Finally, close the connection
  await conn.close();
}
