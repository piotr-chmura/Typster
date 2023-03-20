import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'database.dart';

class DAO {
  Mysql? db;
  final Key key =
      Key(Uint8List.fromList("o25rDa!ZN@F=US=E@n{1D(mfZ*H+T4S<".codeUnits));
  final iv = IV(Uint8List.fromList("Q}Y2!,};P/tcs?l0".codeUnits));
  Encrypter? encrypter;

  DAO() {
    db = Mysql();
    encrypter = Encrypter(AES(key));
  }

  // Future<List<User>> getUser() async {
  //   List<User> result = [];
  //   await db.getConn().then((conn) async {
  //     String sql = 'select id_user, nickname, e_mail from t_users;';
  //     await conn.connect();
  //     await conn.execute(sql).then((results) {
  //       for (var row in results.rows) {
  //         // result.add(User(row.colAt(1), row.colAt(2), row.colAt(3),
  //         //     id: row.typedColAt<int>(0)));
  //       }
  //     });
  //     await conn.close();
  //   });
  //   return result;
  // }
}
