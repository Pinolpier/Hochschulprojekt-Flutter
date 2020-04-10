import 'dart:async';

import 'package:flutter/cupertino.dart';

/**
 * this debouncer class makes sure that the user has enough time to put in his full search query into the searchbar before
 * the system starts reading it out
 */

class Debouncer{

  int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer(int milliseconds)
  {
    this.milliseconds = milliseconds;
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }


  run(VoidCallback action){
    if(_timer != null){
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}