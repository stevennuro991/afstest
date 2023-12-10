import 'package:afs_test/utils/constants.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showErrorFlush(String? message) {
  if (message != null && message.isNotEmpty) {
    Flushbar(
      titleColor: kTextRed,
      message: message,
      messageColor: kTextRed,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: const Color(0xFFFFF7F7),
      borderRadius: kBoxRadius(10),
      borderWidth: 1,
      borderColor: kTextRed,
      icon: const Icon(
        Icons.error_outline,
        color: kTextRed,
      ),
      mainButton: InkWell(
        onTap: () => Navigator.pop(navigatorKey.currentState!.context),
        child: const Icon(Icons.close_rounded, color: kTextRed),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 15, right: 20, top: 15, bottom: 15),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 200),
    ).show(navigatorKey.currentState!.context);
  }
}

void showSuccessFlush(String? message) {
  if (message != null) {
    Flushbar(
      message: message,
      messageColor: kGreen,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: const Color(0xFFEFFCF3),
      borderRadius: kBoxRadius(10),
      icon: const Icon(Icons.check_circle_rounded, color: kGreen),
      mainButton: InkWell(
        onTap: () => Navigator.pop(navigatorKey.currentState!.context),
        child: const Icon(Icons.close_rounded, color: kGreen),
      ),
      borderWidth: 1,
      borderColor: kGreen,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 15, right: 20, top: 15, bottom: 15),
      duration: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 200),
    ).show(navigatorKey.currentState!.context);
  }
}

void showFlushBar(String? message) {
  if (message != null) {
    Flushbar(
      message: message,
      messageColor: kPrimaryColor,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: const Color(0xFFA5AEDF),
      borderRadius: kBoxRadius(10),
      icon: const Icon(Icons.info_rounded, color: kPrimaryColor),
      mainButton: InkWell(
        onTap: () => Navigator.pop(navigatorKey.currentState!.context),
        child: const Icon(Icons.close_rounded, color: kPrimaryColor),
      ),
      borderWidth: 1,
      borderColor: kPrimaryColor,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 15, right: 20, top: 15, bottom: 15),
      duration: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 200),
    ).show(navigatorKey.currentState!.context);
  }
}
