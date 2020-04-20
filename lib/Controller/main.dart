import 'package:univents/View/dialogs/friendList_dialog.dart';
import 'package:univents/View/eventInfo_screen.dart';
import 'package:univents/View/friendList_screen.dart';
import 'package:flutter/material.dart';
import 'package:univents/View/profile_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter create event UI',
      home: EventInfo(),
    );
  }
}