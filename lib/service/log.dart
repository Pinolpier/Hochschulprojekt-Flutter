import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Log {
  var _file;

  static final Log _instance = Log._internal();
  factory Log() => _instance;

  Log._internal();

  void info(
      {@required String causingClass,
      @required String method,
      String action}) async {
    String information = _concat(
        type: 'INFO',
        causingClass: causingClass,
        method: method,
        action: action);
    this._file = await _init();
    this._file.writeAsString('$information\n');
    try {
      String logs = await _file.readAsString();
      print(logs);
    } catch (e) {
      print('error');
    }
  }

  void warn(
      {@required String causingClass,
      @required String method,
      String action}) async {
    String information = _concat(
        type: 'WARN',
        causingClass: causingClass,
        method: method,
        action: action);
    this._file = await _init();
    this._file.writeAsString(information);
    try {
      String logs = await _file.readAsString();
      print(logs);
    } catch (e) {
      print('error');
    }
  }

  void error(
      {@required String causingClass,
      @required String method,
      String action}) async {
    String information = _concat(
        type: 'ERROR',
        causingClass: causingClass,
        method: method,
        action: action);
    this._file = await _init();
    this._file.writeAsString(information);
    try {
      String logs = await _file.readAsString();
      print(logs);
    } catch (e) {
      print('error');
    }
  }

  String _concat(
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

  Future<File> _init() async {
    if (_file == null) {
      final dir = await getApplicationDocumentsDirectory();
      _file = File(dir.path + '/log.txt');
    }
    return _file;
  }
}
