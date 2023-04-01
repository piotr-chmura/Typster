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
}
