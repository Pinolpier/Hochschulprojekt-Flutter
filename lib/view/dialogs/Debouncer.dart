import 'dart:async';

import 'package:flutter/cupertino.dart';

/// todo: add author

/// this debouncer class makes sure that the user has enough time to put in his full search query into the searchbar before
/// the system starts reading it out
class Debouncer {
  /// todo: add documentation of variables
  int milliseconds;
  VoidCallback action;
  Timer _timer;

  /// todo: missing documentation
  Debouncer(int milliseconds) {
    this.milliseconds = milliseconds;
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// todo: missing documentation
  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
