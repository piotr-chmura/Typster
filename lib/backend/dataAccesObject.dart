// ignore_for_file: file_names

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
}
