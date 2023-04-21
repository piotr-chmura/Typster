// ignore_for_file: file_names
import 'dataAccesObject.dart';
import 'database.dart';

class LeaderboardDAO extends DAO {
  Future<List<UserPlacement>> leaderboard(String groupId, bool top10) async {
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
      await conn.close();
    });
    return leaderBoard;
  }
}
