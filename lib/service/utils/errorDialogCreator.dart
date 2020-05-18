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
    // TODO: implement build
    return AlertDialog(
      title: Text(titleText),
      content: Text(bodyText),
      backgroundColor: Colors.white,
      actions: <Widget>[
        isHighPrio == false ? FlatButton(
          child: Text("cancel"),      //TODO: Add Internationalization
          onPressed: () {
            Navigator.pop(context);
          },
        ) : null,
        FlatButton(
          child: Text("accept"),     //TODO: Add Internationalization
          onPressed: () {
            //TODO: Was genau soll nach dem Akzeptieren passieren?
          },
        )
      ]
    );
  }
}