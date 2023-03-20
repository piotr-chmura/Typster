// ignore_for_file: file_names
import 'package:test_app/backend/buissnesObject.dart';
import 'dataAccesObject.dart';
import 'database.dart';

class LoginDAO extends DAO {
  Future<String> loginUser(User user) async {
    String error = "";
    await db!.getConn().then((conn) async {
      String sql = 'select password from t_users where nickname = ? limit 1;';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([user.username]).then((result) {
        if (result.numOfRows == 1) {
          for (var row in result.rows) {
            String? dbPassword = encrypter
                ?.decrypt64(row.colAt(0).toString(), iv: iv)
                .toString();
            String dbPasswordValidate = dbPassword ?? "";
            String passwordValidate = user.password ?? "";
            if (isEven(dbPasswordValidate, passwordValidate)) {
              error = "Nie poprawna nazwa użytkownika lub hasło";
            }
          }
        } else {
          error = "Nie poprawna nazwa użytkownika lub hasło";
        }
      }, onError: (details) {
        error = details.toString();
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    return error;
  }
}
