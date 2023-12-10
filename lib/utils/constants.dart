import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Duration requestDuration = const Duration(seconds: 120);


//Colors
const Color kPrimaryColor = Color(0xFF66328E);
const Color kPrimaryWhite = Color(0xFFFFFFFF);
const Color kGreyLight = Color(0xFFD8DCE2);
const Color kTextRed = Color(0xFFEF4444);
const Color kTransparent = Colors.transparent;
const Color kTextGreyMedium = Color(0xFF534E50);
const Color kTextGreyLight = Color(0xFF847D81);
const Color kInactiveColor = Color(0xFFC3DEFF);
const Color kTextGreyDark = Color(0xFF2F3133);
const Color kGreyMedium = Color(0xFFB5BAC2);
const Color kGreen = Color(0xFF22C55E);




List<String> countrySelectFilter = const ["+233"];

RegExp numberValues = RegExp(r'[0-9!\$%&\*\(\)_\+\|%\{\}\\=[\]:;<>\?,@#\/"]+$');
extension StringValidators on String {
  bool get containsUppercase => contains(RegExp(r'[A-Z]'));

  bool get containsLowercase => contains(RegExp(r'[a-z]'));
}

RegExp phoneNumberValues = RegExp(r'[0-9\-]');
var chars = r'''[0-9]^$*.[]{}()?-"'!@#%&/\,><:;_~`+=''';
var passwordAllowSet = {...chars.codeUnits};


bool isEmail(String? email) {
  if (email == null || email.isEmpty) {
    return false;
  } else {
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = RegExp(p);

    return regExp.hasMatch(email);
  }
}
String? isPasswordValid(String? password) {
  if (password == null || password.isEmpty) return "Input a password";
  if (password.length < 8) return "Password is too short";
  if (!password.containsUppercase) return "Password must contain uppercase";
  if (!password.containsLowercase) return "Password must contain lowercase";
  if (!phoneNumberValues.hasMatch(password)) {
    return "Password must contain number";
  }
  if (!password.codeUnits.any(passwordAllowSet.contains)) {
    return "Password must contain number and symbols";
  }
  return null;
}
BorderRadius kBoxRadius(double size) => BorderRadius.all(Radius.circular(size));


class LocalStorageKeys {
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
}
