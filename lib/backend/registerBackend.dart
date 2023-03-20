// ignore_for_file: file_names
import 'dataAccesObject.dart';
import 'database.dart';

class RegisterDAO extends DAO {
  Future<String> insertUser(User user) async {
    final encryptedPass =
        encrypter?.encrypt(user.password.toString(), iv: iv).base64.toString();
    String error = "";
    await db!.getConn().then((conn) async {
      String sql = 'insert into t_users values (?, ?, ?, ?);';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment
          .execute([null, user.username, encryptedPass, user.email]).then(
              (result) {}, onError: (details) {
        error = details.toString();
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    return (error);
  }
}
