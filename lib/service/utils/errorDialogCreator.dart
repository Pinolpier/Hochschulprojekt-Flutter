import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @author Christian Henrich
///
/// This class is the API to create a uniformly ErrorDialog where you can only change the title and body text, the rest is always the same (visually)
class ErrorDialogCreator extends StatelessWidget {
  String _titleText;
  String _bodyText;
  bool _isHighPrio;

  /// constructor where title, body and prio get passed to create the desired dialog
  ErrorDialogCreator(String title, String body, bool prio) {
    this._titleText = title;
    this._bodyText = body;
    this._isHighPrio = prio;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(_titleText),
        content: Text(_bodyText),
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]);
  }
}
