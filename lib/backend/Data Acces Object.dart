import 'package:flutter/foundation.dart';
import 'database.dart';

class DAO {
  Mysql db;

  DAO() : db = Mysql();

  Future<List<User>> getUser() async {
    List<User> result = [];
    await db.getConn().then((conn) async {
      String sql = 'select id_user, nickname, e_mail from t_users;';
      await conn.connect();
      await conn.execute(sql).then((results) {
        for (var row in results.rows) {
          // result.add(User(row.colAt(1), row.colAt(2), row.colAt(3),
          //     id: row.typedColAt<int>(0)));
        }
      });
      await conn.close();
    });
    return result;
  }

  Future<void> insertUser(User user) async {
    await db.getConn().then((conn) async {
      String sql = 'insert into t_users values (?, ?, ?, ?);';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment
          .execute([null, user.username, user.password, user.email]).then(
              (result) {
        if (kDebugMode) {
          print("Success");
        }
      }, onError: (details) {
        if (kDebugMode) {
          print("Failed");
        }
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
  }
}
