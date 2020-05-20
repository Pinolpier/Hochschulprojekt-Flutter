import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// shows a short toast based on a String [message]
void show_long_toast(String message){
Fluttertoast.showToast(msg: message,
toastLength: Toast.LENGTH_LONG,
backgroundColor: Colors.blueAccent,
textColor: Colors.black);
}

/// shows a short toast based on a String [message]
void show_short_toast(String message){
  Fluttertoast.showToast(msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.black);
}