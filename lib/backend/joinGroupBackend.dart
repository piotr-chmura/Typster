// ignore: file_names
import 'dataAccesObject.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinGroupDAO extends DAO {
  Future<void> joinGroup(int idGroup) async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql = 'insert into t_groups_users values (?, ?, 0);';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idGroup, idUser]).then((result) {},
          onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
  }

  Future<String> getDescription(int idGroup) async {
    String description = "";
    await db!.getConn().then((conn) async {
      String sql = '''SELECT description FROM t_groups WHERE id_group = ?;''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idGroup]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            description = row.colAt(0)!;
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
    return description;
  }
}
