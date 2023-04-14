// ignore_for_file: file_names
import 'dataAccesObject.dart';
import 'database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchesDAO extends DAO {
  Future<List<Group>> groupMatchesList() async {
    List<Group> groups = [];
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql = '''SELECT g.id_group, g.name, u.nickname
                      FROM t_groups g
                      INNER JOIN t_groups_users gu
                      ON g.id_group = gu.group_id_group
                      INNER JOIN t_users u
                      ON gu.user_id_user = u.id_user
                      WHERE g.id_group NOT IN
                        (
                          SELECT group_id_group
                          FROM t_groups_users
                          WHERE user_id_user = ?
                          );''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idUser]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            groups.add(Group(int.parse(row.colAt(0) ?? "error"), row.colAt(1),
                row.colAt(2)));
          }
        } else {
          throw Exception(
              "Błąd bazy danych: Użytkownik należy do wszystkich grup");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    return groups;
  }

  Future<List<Group>> MatchesList() async {
    List<Group> groups = [];
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql = '''SELECT g.id_group, g.name, u.nickname
                      FROM t_groups g
                      INNER JOIN t_groups_users gu
                      ON g.id_group = gu.group_id_group
                      INNER JOIN t_users u
                      ON gu.user_id_user = u.id_user
                      WHERE g.id_group NOT IN
                        (
                          SELECT group_id_group
                          FROM t_groups_users
                          WHERE user_id_user = ?
                          );''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idUser]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            groups.add(Group(int.parse(row.colAt(0) ?? "error"), row.colAt(1),
                row.colAt(2)));
          }
        } else {
          throw Exception(
              "Błąd bazy danych: Użytkownik należy do wszystkich grup");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    return groups;
  }
}
