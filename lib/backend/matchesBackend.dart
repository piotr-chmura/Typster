// ignore_for_file: file_names
import 'dataAccesObject.dart';
import 'database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchesDAO extends DAO {
  //Sprint 3
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

  Future<List<Match>> matchesList(bool main) async {
    List<Match> matches = [];
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql =
          '''SELECT l.name, m.data, m.team_a, m.team_b, m.id_match, m.score_a, m.score_b, DATE_FORMAT(m.data, '%d.%m %H-%i'), l.id_league
              FROM t_matches m 
              INNER JOIN t_leagues l ON m.league_id_league = l.id_league
              WHERE m.data BETWEEN DATE(NOW() - INTERVAL 2 DAY) AND DATE(NOW() + INTERVAL 7 DAY) 
              AND m.id_match IN
                (
                  SELECT DISTINCT gm.match_id_match
                  FROM t_groups_matches gm
                  WHERE gm.group_id_group IN (
                    SELECT gu.group_id_group
                    FROM t_groups_users gu
                    WHERE gu.user_id_user = ?
                  )
                )
              ORDER BY m.data
              ;''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idUser]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            matches.add(Match(
                row.colAt(0),
                DateTime.parse(row.colAt(1) ?? ""),
                row.colAt(2),
                row.colAt(3),
                int.parse(row.colAt(4)!),
                row.colAt(5)?.isEmpty ?? true ? null : int.parse(row.colAt(5)!),
                row.colAt(6)?.isEmpty ?? true ? null : int.parse(row.colAt(6)!),
                row.colAt(7),
                row.colAt(8)));
          }
        } else {
          throw Exception("Błąd bazy danych: Brak meczy do wyświetlenia");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    return matches;
  }
}
