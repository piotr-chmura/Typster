import 'package:shared_preferences/shared_preferences.dart';
import 'dataAccesObject.dart';
import 'database.dart';

class EditGroupDAO extends DAO {
  Future<void> updateGroup(GroupCreate group, int idGroup) async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql = '''UPDATE t_groups g SET g.name = ?, g.description = ? 
                      WHERE g.id_group = ?;''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment
          .execute([group.name, group.description, idGroup]).then((result) {},
              onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();

      String sql2 = 'DELETE FROM t_groups_leagues WHERE group_id_group = ?;';
      var prepareStatment2 = await conn.prepare(sql2);
      await prepareStatment2.execute([idGroup]).then((result) {},
          onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment2.deallocate();

      String sql3 =
          'insert into t_groups_leagues(group_id_group, league_id_league) values ';
      List<String> groupLeague = [];
      for (int league in group.leagues) {
        String leagueS = league.toString();
        groupLeague.add(idGroup.toString());
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

      await conn.close();
    });
  }

  Future<DescLeagueList> getGroupLeaguesAndDescription(int idGroup) async {
    DescLeagueList descLeagues = DescLeagueList('', [], []);
    String description = "";
    List<int> leagues = [];
    List<League> leaguesAll = [];
    await db!.getConn().then((conn) async {
      String sql = '''SELECT g.description FROM t_groups g WHERE g.id_group = ?
                      UNION
                      SELECT gl.league_id_league FROM t_groups_leagues gl WHERE gl.group_id_group = ?;''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idGroup, idGroup]).then((result) {
        if (result.numOfRows > 0) {
          bool first = true;
          for (var row in result.rows) {
            if (first) {
              description = row.colAt(0)!;
              first = false;
            } else {
              leagues.add(int.parse(row.colAt(0)!));
            }
          }
        } else {
          throw Exception("Błąd bazy danych");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();

      String sql2 = '''SELECT * FROM t_leagues;''';
      var prepareStatment2 = await conn.prepare(sql2);
      await prepareStatment2.execute([]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            leaguesAll.add(League(int.parse(row.colAt(0)!), row.colAt(1)));
          }
        } else {
          throw Exception("Błąd bazy danych");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();

      descLeagues = DescLeagueList(description, leagues, leaguesAll);
      await conn.close();
    });
    return descLeagues;
  }

  Future<void> deleteGroup(int idGroup) async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql = '''DELETE FROM t_groups_users WHERE group_id_group = ?;''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idGroup]).then((result) {},
          onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();

      String sql2 = 'DELETE FROM t_groups_leagues WHERE group_id_group = ?;';
      var prepareStatment2 = await conn.prepare(sql2);
      await prepareStatment2.execute([idGroup]).then((result) {},
          onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment2.deallocate();

      String sql3 = 'DELETE FROM t_groups_matches WHERE group_id_group = ?;';
      var prepareStatment3 = await conn.prepare(sql3);
      await prepareStatment3.execute([idGroup]).then((result) {},
          onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment2.deallocate();

      String sql4 = 'DELETE FROM t_groups WHERE id_group = ?;';
      var prepareStatment4 = await conn.prepare(sql4);
      await prepareStatment4.execute([idGroup]).then((result) {},
          onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment2.deallocate();

      await conn.close();
    });
  }
}
