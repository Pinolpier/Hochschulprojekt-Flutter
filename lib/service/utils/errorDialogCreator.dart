import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/service/app_localizations.dart';

class ErrorDialogCreator extends StatelessWidget {
  ErrorDialogCreator(String title, String body, bool prio) {
    this.titleText = title;
    this.bodyText = body;
    this.isHighPrio = prio;
  }
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
      ]
    );
  }
}