// ignore_for_file: file_names
import 'dataAccesObject.dart';
import 'database.dart';
import 'emailBackend.dart';
import 'dart:math' show Random;

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
}
