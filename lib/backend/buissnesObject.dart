// ignore_for_file: file_names
import 'package:email_validator/email_validator.dart';

bool isNullOrEmpty(String str) {
  if (str.isEmpty) return true;
  return false;
}

bool isEven(String str1, String str2) {
  if (str1 == str2) return true;
  return false;
}

String isValidInt(String INT){
  final regex = RegExp(r'^[0-9]+$');
  if(regex.hasMatch(INT)){
    return "";
  }
  return "Nie podano liczby";
}

String isValidUserName(String str) {
  if (str.isEmpty || str.length < 4 || str.length > 20) {
    return "Nazwa użytkownika musi zawierać od 4 do 20 znaków";
  }

  final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$');
  if (!regex.hasMatch(str)) {
    return "Nazwa użytkownika może zawierać tylko litery i cyfry, ale musi zaczynać się literą";
  }

  return "";
}

String isValidPassword(String str) {
  if (str.isEmpty || str.length < 6 || str.length > 20) {
    return "Hasło musi zawierać od 6 do 20 znaków";
  }

  return "";
}

String isValidEmail(String str) {
  if (str.isEmpty) {
    return "Email jest wymagany";
  }

  if (!EmailValidator.validate(str)) {
    return "Niepoprawny email";
  }

  return "";
}
