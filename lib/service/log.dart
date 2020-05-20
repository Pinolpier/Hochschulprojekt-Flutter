import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Log {
  var _file;
  var _pathToFile;

  static final Log _instance = Log._internal();
  factory Log() => _instance;

  Log._internal();

  Future<File> _init() async {
    if (_file == null) {
      _pathToFile = await getApplicationDocumentsDirectory();
      _file = File(_pathToFile.path + '/log.txt');
    }
    return _file;
  }

  void cleanFile() async {
    file.writeAsStringSync('-- start --');
  }

  void info(
      {@required String causingClass,
      @required String method,
      String action}) async {
    String information = _concat(
        type: 'INFO',
        causingClass: causingClass,
        method: method,
        action: action);
    _log(information);
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
    _log(information);
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
    _log(information);
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

  void _log(String information) async {
    this._file = await _init();
    String previous = '';
    try {
      previous = await _file.readAsString();
      print(previous);
      this._file.writeAsString('$previous\n$information');
    } catch (e) {
      print('file is empty');
    }
  }

  File get file => this._file;

  set file(File file) => this._file;
}
