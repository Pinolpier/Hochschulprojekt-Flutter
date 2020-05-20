import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// shows a short toast based on a String [message]
void show_long_toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.black,
      fontSize: 16);
}

/// shows a short toast based on a String [message]
void show_short_toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.black,
      fontSize: 16);
}
