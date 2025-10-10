import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  // Show simple toast
  static void show(
      String message, {
        ToastGravity gravity = ToastGravity.BOTTOM,
        Color backgroundColor = Colors.black,
        Color textColor = Colors.white,
        double fontSize = 16.0,
        int durationSeconds = 2,
      }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: durationSeconds == 2 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  // Show success toast
  static void success(String message) {
    show(
      message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  // Show error toast
  static void error(String message) {
    show(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  // Show info toast
  static void info(String message) {
    show(
      message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }
}
