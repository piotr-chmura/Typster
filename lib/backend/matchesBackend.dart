// ignore_for_file: file_names
import 'dataAccesObject.dart';
import 'database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchesDAO extends DAO {
  //Sprint 3
  Future<List<Match>> groupMatchesList(String groupId) async {
    List<Match> matches = [];
    await db!.getConn().then((conn) async {
      String sql =
          '''SELECT l.name, m.data, m.team_a, m.team_b, m.id_match, m.score_a, m.score_b, DATE_FORMAT(m.data, '%d.%m %H:%i'), l.id_league
              FROM t_matches m 
              INNER JOIN t_leagues l ON m.league_id_league = l.id_league
              WHERE m.data BETWEEN DATE(NOW() - INTERVAL 1 DAY) AND DATE(NOW() + INTERVAL 7 DAY) 
              AND m.id_match IN
                (
                  SELECT gm.match_id_match
                  FROM t_groups_matches gm
                  WHERE gm.group_id_group = ?
                )
              ORDER BY m.data
              ;''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([groupId]).then((result) {
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

  Future<List<Match>> matchesList() async {
    List<Match> matches = [];
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql =
          '''SELECT l.name, m.data, m.team_a, m.team_b, m.id_match, m.score_a, m.score_b, DATE_FORMAT(m.data, '%d.%m %H:%i'), l.id_league
              FROM t_matches m 
              INNER JOIN t_leagues l ON m.league_id_league = l.id_league
              WHERE m.data BETWEEN DATE(NOW() - INTERVAL 1 DAY) AND DATE(NOW() + INTERVAL 7 DAY) 
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

  Future<List<Match>> matchesMainList() async {
    List<Match> matches = [];
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql =
          '''SELECT l.name, m.data, m.team_a, m.team_b, m.id_match, m.score_a, m.score_b, DATE_FORMAT(m.data, '%d.%m %H:%i'), l.id_league
              FROM t_matches m 
              INNER JOIN t_leagues l ON m.league_id_league = l.id_league
              WHERE m.data BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 24 DAY) 
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
              LIMIT 3;''';
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

  Future<void> placeBet(String idMatch, String scoreA, String scoreB) async {
    bool flag = true;
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      //Czy mecz się rozpoczął
      String sql1 =
          '''SELECT IF((SELECT m.data FROM t_matches m WHERE id_match = ?) > NOW(), 'true', 'false') AS result;''';
      await conn.connect();
      var prepareStatment1 = await conn.prepare(sql1);
      await prepareStatment1.execute([idMatch]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            if (row.colAt(0) == "false") {
              flag = false;
              throw Exception(
                  "Błąd: Mecz już się rozpoczął, nie możesz obstawić");
            }
          }
        } else {
          flag = false;
          throw Exception("Błąd bazy danych");
        }
      }, onError: (details) {
        flag = false;
        throw Exception(details.toString());
      });
      await prepareStatment1.deallocate();

      String sql2 =
          '''INSERT INTO t_matches_users (user_id_user, match_id_match, score_a, score_b) 
                      VALUES (?, ?, ?, ?) AS newdata
                      ON DUPLICATE KEY UPDATE
                        score_a = newdata.score_a,
                        score_b = newdata.score_b;''';
      var prepareStatment2 = await conn.prepare(sql2);
      await prepareStatment2.execute([idUser, idMatch, scoreA, scoreB]).then(
          (result) {}, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment2.deallocate();
      await conn.close();
    });
  }

  Future<List<String>> getBet(String idMatch) async {
    List<String> bets = ["", ""];
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql =
          '''SELECT score_a, score_b FROM t_matches_users WHERE user_id_user = ? AND match_id_match = ?;''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idUser, idMatch]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            bets = [row.colAt(0)!, row.colAt(1)!];
          }
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    return bets;
  }

  Future<List<MatchBetHistory>> matchesUserList() async {
    List<MatchBetHistory> matches = [];
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql =
          '''SELECT l.name, m.data, m.team_a, m.team_b, m.score_a, m.score_b, DATE_FORMAT(m.data, '%d.%m %H:%i'), l.id_league, mu.score_a, mu.score_b
              FROM t_matches m 
              INNER JOIN t_leagues l ON m.league_id_league = l.id_league
              INNER JOIN t_matches_users mu ON m.id_match = mu.match_id_match
              WHERE (m.score_a IS NOT NULL) AND (mu.user_id_user = ?)
              ORDER BY m.data
              ;''';
      //dokończ
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idUser]).then((result) {
        if (result.numOfRows > 0) {
          for (var row in result.rows) {
            matches.add(MatchBetHistory(
                row.colAt(0),
                row.colAt(2),
                row.colAt(3),
                int.parse(row.colAt(4)!),
                int.parse(row.colAt(5)!),
                row.colAt(6),
                row.colAt(7),
                int.parse(row.colAt(8)!),
                int.parse(row.colAt(9)!)));
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
