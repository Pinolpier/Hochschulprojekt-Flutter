import 'package:flutter/material.dart';

class Log {
  static void INFO(
      {@required String causingClass, @required String method, String action}) {
    String information = _concat(
        type: 'INFO',
        causingClass: causingClass,
        method: method,
        action: action);
  }

  static void WARN(
      {@required String causingClass, @required String method, String action}) {
    String information = _concat(
        type: 'INFO',
        causingClass: causingClass,
        method: method,
        action: action);
  }

  static void ERROR(
      {@required String causingClass, @required String method, String action}) {
    String information = _concat(
        type: 'INFO',
        causingClass: causingClass,
        method: method,
        action: action);
  }

  static String _concat(
      {@required String type,
      @required String causingClass,
      @required String method,
      String action}) {
    return action != null
        ? DateTime.now().toString() +
            ' : [$type]: class: $causingClass, method: $method, action: $action'
        : DateTime.now().toString() +
            ' : [$type]: class: $causingClass, method: $method';
  }
}
