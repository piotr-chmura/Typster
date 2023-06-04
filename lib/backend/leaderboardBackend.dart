// ignore_for_file: file_names
import 'dataAccesObject.dart';
import 'database.dart';

class LeaderboardDAO extends DAO {
  Future<List<Leaderboard>> leaderboard(String groupId, bool top10) async {
    List<Leaderboard> leaderBoards = [];
    List<UserPlacement> leaderBoard = [];
    await db!.getConn().then((conn) async {
      String sql = '''SELECT u.nickname, gu.points
                      FROM t_users u
                      INNER JOIN t_groups_users gu ON u.id_user = gu.user_id_user
                      WHERE gu.group_id_group = ?
                      ORDER BY gu.points DESC''';
      if (top10) {
        sql += " LIMIT 10;";
      } else {
        sql += ";";
      }
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([groupId]).then((result) {
        if (result.numOfRows > 0) {
          int i = 1;
          for (var row in result.rows) {
            leaderBoard
                .add(UserPlacement(i.toString(), row.colAt(0), row.colAt(1)));
            i += 1;
          }
        } else {
          throw Exception("Błąd bazy danych (leaderboard)");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();

      leaderBoards.add(Leaderboard('1', leaderBoard));
      leaderBoard = [];

      List<String> tabels = [];
      String sql2 = '''SELECT TABLE_NAME
                        FROM INFORMATION_SCHEMA.TABLES
                        WHERE TABLE_SCHEMA = 'typster'
                        AND TABLE_NAME LIKE 't_groups_users_%';''';
      var prepareStatment2 = await conn.prepare(sql2);
      await prepareStatment2.execute([]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            tabels.add(row.colAt(0)!);
          }
        } else {
          throw Exception("Błąd bazy danych (leaderboard)");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment2.deallocate();

      for (var tabel in tabels) {
        String sql3 = '''SELECT u.nickname, gu.points
                      FROM t_users u
                      INNER JOIN $tabel gu ON u.id_user = gu.user_id_user
                      WHERE gu.group_id_group = ?
                      ORDER BY gu.points DESC LIMIT 10;''';
        var prepareStatment3 = await conn.prepare(sql3);
        await prepareStatment3.execute([groupId]).then((result) {
          if (result.numOfRows > 0) {
            int i = 1;
            for (var row in result.rows) {
              leaderBoard
                  .add(UserPlacement(i.toString(), row.colAt(0), row.colAt(1)));
              i += 1;
            }
          } else {
            throw Exception("Błąd bazy danych (leaderboard)");
          }
        }, onError: (details) {
          throw Exception(details.toString());
        });
        await prepareStatment3.deallocate();
        leaderBoards.add(
            Leaderboard(tabel.replaceAll('t_groups_users_', ''), leaderBoard));
        leaderBoard = [];
      }
      await conn.close();
    });
    return leaderBoards;
  }
}
