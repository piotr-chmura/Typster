import 'package:shared_preferences/shared_preferences.dart';
import 'dataAccesObject.dart';
import 'database.dart';

class CreateGroupDAO extends DAO {
  Future<String> insertGroup(User user) async {
    final encryptedPass =
        encrypter?.encrypt(user.password.toString(), iv: iv).base64.toString();
    String error = "";
    await db!.getConn().then((conn) async {
      String sql = 'insert into t_users values (?, ?, ?, ?);';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment
          .execute([null, user.username, encryptedPass, user.email]).then(
              (result) {}, onError: (details) {
        error = details.toString();
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    return (error);
  }

  Future<List<League>> getLeagues() async {
    List<League> leagues = [];
    await db!.getConn().then((conn) async {
      String sql = '''SELECT * FROM typster.t_leagues;''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            leagues.add(League(int.parse(row.colAt(0)!), row.colAt(1)));
          }
        } else {
          throw Exception("Błąd bazy danych");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    return leagues;
  }
}
