import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// @author mathias darscht
/// this class saves logs into a .txt file
/// per log a line
/// DateTime: [logType]: causing class, method, action
class Log {
  /// file to save all logs
  var _file;

  /// path to file
  var _pathToFile;

  /// singleton configuration
  static final Log _instance = Log._internal();

  factory Log() => _instance;

  Log._internal();

  /// initializes the file and path to file
  Future<File> _init() async {
    if (_file == null) {
      _pathToFile = await getApplicationDocumentsDirectory();
      _file = File(_pathToFile.path + '/log.txt');
    }
    return _file;
  }

  /// cleans the content of the file
  void cleanFile() async {
    file.writeAsStringSync('-- start --');
  }

  /// info log
  ///
  /// writes and prints an info log with the information from
  /// (String) [causingClass], (String) [method],
  /// (String) [action] (optional)
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

  /// warn log
  ///
  /// writes and prints an warning log with the information from
  /// (String) [causingClass], (String) [method],
  /// (String) [action] (optional)
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

  /// error log
  ///
  /// writes and prints an error log with the information from
  /// (String) [causingClass], (String) [method],
  /// (String) [action] (optional)
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

  /// concat's the data of log to a string
  ///
  /// creates a big String based on (String) [type],
  /// (String) [causingClass], (String) [method]
  /// and (String) [action] (optional)
  /// depending on the action it returns a longer or shorter message
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

  /// saves the data into the log file
  ///
  /// based on (String) [information]
  void _log(String information) async {
    this._file = await _init();
    String previous = '';
    try {
      previous = await this._file.readAsString();
      this._file = await this._file.writeAsString('$information');
      print('$previous\n$information');
    } catch (e) {
      this._file = await this._file.writeAsString('-- start --\n$information');
      print('$information');
    }
  }

  File get file => this._file;

  /// set's up a file if it doesm't exist's
  set file(File file) => this._file;
}
