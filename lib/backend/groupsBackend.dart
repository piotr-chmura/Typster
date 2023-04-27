// ignore_for_file: file_names
import 'dataAccesObject.dart';
import 'database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupDAO extends DAO {
  Future<List<Group>> groupList() async {
    List<Group> groups = [];
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql = '''SELECT g.id_group, g.name, u.nickname
                      FROM t_groups g
                      INNER JOIN t_groups_users gu
                      ON g.id_group = gu.group_id_group
                      INNER JOIN t_users u
                      ON g.id_admin = u.id_user 
                      WHERE g.id_group NOT IN
                        (
                          SELECT group_id_group
                          FROM t_groups_users
                          WHERE user_id_user = ?
                          )
                      GROUP BY g.id_group, g.name, u.nickname, g.id_admin, u.id_user
                      HAVING g.id_admin = u.id_user;''';
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

  Future<List<Group>> userGroupList() async {
    //sprint 3
    List<Group> groups = [];
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql = '''SELECT g.id_group, g.name, u.nickname
                      FROM t_groups g
                      INNER JOIN t_users u ON g.id_admin =u.id_user
                      WHERE g.id_group IN (
                        SELECT gu.group_id_group
                          FROM t_groups_users gu
                          WHERE gu.user_id_user = ?);''';
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
              "Błąd bazy danych: Użytkownik nie należy do żadnej grupy");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    return groups;
  }

  Future<List<GroupUserPlacement>> userGroupLeaderboardList() async {
    //sprint 3
    List<GroupUserPlacement> groups = [];
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql = '''SELECT g.id_group, g.name, gu.user_id_user, gu.points
                      FROM t_groups g
                      INNER JOIN t_groups_users gu ON g.id_group = gu.group_id_group
                      WHERE g.id_group IN (
                        SELECT gu.group_id_group
                          FROM t_groups_users gu
                          WHERE gu.user_id_user = ?)
                    ORDER BY g.id_group ASC, gu.points DESC;''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idUser]).then((result) {
        if (result.numOfRows > 0) {
          var it = result.rows.iterator;
          bool flag = true; //czy jeszcze nie znaleziono usera w grupie
          it.moveNext();
          String idGroup = it.current.colAt(0)!;
          int i = 1;
          if (it.current.colAt(2) == idUser) {
            groups.add(GroupUserPlacement(it.current.colAt(0),
                it.current.colAt(1), "1", it.current.colAt(3)));
            flag = false;
          } else {
            i += 1;
          }
          while (it.moveNext()) {
            if (flag == false) {
              if (it.current.colAt(0) != idGroup) {
                if (it.current.colAt(2) == idUser) {
                  groups.add(GroupUserPlacement(it.current.colAt(0),
                      it.current.colAt(1), "1", it.current.colAt(3)));
                } else {
                  i += 1;
                  flag = true;
                }
                idGroup = it.current.colAt(0)!;
              }
            } else {
              if (it.current.colAt(2) == idUser) {
                groups.add(GroupUserPlacement(it.current.colAt(0),
                    it.current.colAt(1), i.toString(), it.current.colAt(3)));
                flag = false;
                i = 1;
              } else {
                i += 1;
              }
            }
          }
        } else {
          throw Exception(
              "Błąd bazy danych: Użytkownik nie należy do żadnej grupy");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    return groups;
  }

//check
  Future<void> leaveGroup(int idGroup) async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    await db!.getConn().then((conn) async {
      String sql =
          '''DELETE FROM t_groups_users WHERE group_id_group = ? AND user_id_user = ?;''';
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
}
