import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Markus Häring

// limit of words for decision between short and long toast
final int _wordCount = 10;

/// todo: DO start doc comments with a single-sentence summary
/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// shows a toast based on a String [message].
/// The number of words is used
/// to decide whether a short or a long toast should be displayed
/// Whether a toast is displayed long or short is decided
/// by the fixed variable wordCount
show_toast(String message) {
  if (message.split(' ').length >= _wordCount)
    _show_long_toast(message);
  else
    _show_short_toast(message);
}

/// shows a short toast based on a String [message]
void _show_long_toast(String message) {
  print("langer Toast");
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.black,
      fontSize: 16);
}

/// shows a short toast based on a String [message]
void _show_short_toast(String message) {
  print("kurzer Toast");
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.black,
      fontSize: 16);
}
