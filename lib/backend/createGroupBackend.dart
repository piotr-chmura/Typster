import 'package:shared_preferences/shared_preferences.dart';
import 'dataAccesObject.dart';
import 'database.dart';

class CreateGroupDAO extends DAO {
  Future<void> insertGroup(GroupCreate group) async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql1 =
          'SELECT COUNT(*) FROM t_groups_users WHERE user_id_user = ?;';
      await conn.connect();
      var prepStatment = await conn.prepare(sql1);
      await prepStatment.execute([idUser]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            if (int.parse(row.colAt(0)!) >= 10) {
              throw Exception(
                  "Użytkownik jest już członkiem maksymalnej ilości grup czyli 10");
            }
          }
        } else {
          throw Exception("Błąd bazy danych");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepStatment.deallocate();

      String sql = 'insert into t_groups values (?, ?, ?, ?);';
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment
          .execute([null, group.name, idUser, group.description]).then(
              (result) {}, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();

      String groupId = "";
      String sql2 =
          '''SELECT MAX(id_group) FROM t_groups WHERE id_admin = ?;''';
      var prepareStatment2 = await conn.prepare(sql2);
      await prepareStatment2.execute([idUser]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            groupId = row.colAt(0)!;
          }
        } else {
          throw Exception("Błąd bazy danych");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment2.deallocate();

      String sql3 =
          'insert into t_groups_leagues(group_id_group, league_id_league) values ';
      List<String> groupLeague = [];
      for (int league in group.leagues) {
        String leagueS = league.toString();
        groupLeague.add(groupId.toString());
        groupLeague.add(leagueS);
        sql3 += "(?, ?),";
      }
      sql3 = "${sql3.substring(0, sql3.length - 1)};";
      var prepareStatment3 = await conn.prepare(sql3);
      await prepareStatment3.execute(groupLeague).then((result) {},
          onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment3.deallocate();

      String sql4 =
          'insert into t_groups_users(group_id_group, user_id_user, points) values (?, ?, ?);';
      var prepareStatment4 = await conn.prepare(sql4);
      await prepareStatment4.execute([groupId, idUser, 0]).then((result) {},
          onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment4.deallocate();

      await conn.close();
    });
  }

  Future<List<League>> getLeagues() async {
    List<League> leagues = [];
    await db!.getConn().then((conn) async {
      String sql = '''SELECT * FROM t_leagues;''';
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
