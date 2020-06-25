import 'dart:async';

import 'package:flutter/cupertino.dart';

/// @author Christian Henrich

/// this debouncer class makes sure that the user has enough time to put in his full search query into the searchbar before
/// the system starts reading it out
class Debouncer {
  /// time in millis until debouncer should delay the action
  int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer(int milliseconds) {
    this.milliseconds = milliseconds;
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// runs the debouncer
  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
