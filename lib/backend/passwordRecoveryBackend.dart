// ignore_for_file: file_names
import 'buissnesObject.dart';
import 'dataAccesObject.dart';
import 'database.dart';
import 'emailBackend.dart';
import 'dart:math' show Random;
import 'package:shared_preferences/shared_preferences.dart';

class PasswordRecDAO extends DAO {
  Future<List<String>> sendCode(String email) async {
    EmailSender sender = EmailSender();
    String resp = "";
    await db!.getConn().then((conn) async {
      String sql = 'select nickname from t_users where e_mail = ? limit 1;';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([email]).then((result) {
        if (result.numOfRows == 1) {
          for (var row in result.rows) {
            resp = row.colAt(0).toString();
          }
        } else {
          throw Exception("Brak konta z takim emailem");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
    String message = 'Kod odzyskania hasła: \'';
    Random random = Random();
    String code = "";
    const possibleChars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    for (var i = 0; i < 5; i++) {
      code += possibleChars[random.nextInt(possibleChars.length)];
    }
    message += '$code\'';

    sender.sendEmail(name: resp, email: email, message: message);
    return [resp, code];
  }

  Future<String> sendCode2(String email, String name) async {
    EmailSender sender = EmailSender();
    String message = 'Kod odzyskania hasła: \'';
    Random random = Random();
    String code = "";
    const possibleChars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    for (var i = 0; i < 5; i++) {
      code += possibleChars[random.nextInt(possibleChars.length)];
    }
    message += '$code\'';

    sender.sendEmail(name: name, email: email, message: message);
    return code;
  }

  Future<void> changePassword(String email, String password) async {
    final encryptedPass =
        encrypter?.encrypt(password.toString(), iv: iv).base64.toString();
    String error = "";
    await db!.getConn().then((conn) async {
      String sql = '''UPDATE t_users
                      SET password = ?
                      WHERE e_mail = ?; ''';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([encryptedPass, email]).then((result) {},
          onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();
      await conn.close();
    });
  }

  Future<void> changePassword2(String newPassword, String oldPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('id');
    final encryptedPass =
        encrypter?.encrypt(newPassword.toString(), iv: iv).base64.toString();
    final encryptedPass2 =
        encrypter?.encrypt(oldPassword.toString(), iv: iv).base64.toString();
    await db!.getConn().then((conn) async {
      String sql = 'select password from t_users where id_user = ? limit 1;';
      await conn.connect();
      var prepareStatment = await conn.prepare(sql);
      await prepareStatment.execute([idUser]).then((result) {
        if (result.numOfRows == 1) {
          for (var row in result.rows) {
            if (!isEven(encryptedPass2!, row.colAt(0).toString())) {
              throw Exception("Stare hasło jest niepoprawne");
            }
          }
        } else {
          throw Exception("Błąd bazy danych");
        }
      }, onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment.deallocate();

      String sql2 = '''UPDATE t_users
                      SET password = ?
                      WHERE id_user = ?;''';
      var prepareStatment2 = await conn.prepare(sql2);
      await prepareStatment2.execute([encryptedPass, idUser]).then((result) {},
          onError: (details) {
        throw Exception(details.toString());
      });
      await prepareStatment2.deallocate();
      await conn.close();
    });
  }
}
