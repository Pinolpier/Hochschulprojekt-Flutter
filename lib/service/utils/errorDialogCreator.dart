import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// todo: add author
/// todo: CONSIDER writing a library-level doc comment
/// todo: fix typos
/// todo: reorganize: attributes -> constructor -> methods

class ErrorDialogCreator extends StatelessWidget {
  /// todo: missing documentation
  ErrorDialogCreator(String title, String body, bool prio) {
    this.titleText = title;
    this.bodyText = body;
    this.isHighPrio = prio;
  }

  /// todo: set variables private
  /// todo: add documentation to variables
  String titleText;
  String bodyText;
  bool isHighPrio;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(titleText),
        content: Text(bodyText),
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
