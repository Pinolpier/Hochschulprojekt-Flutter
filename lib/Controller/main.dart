import 'package:aiblabswp2020ssunivents/View/dialogs/friendList_dialog.dart';
import 'package:aiblabswp2020ssunivents/View/foreignProfile_screen.dart';
import 'package:aiblabswp2020ssunivents/View/friendList_screen.dart';
import 'package:aiblabswp2020ssunivents/View/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:aiblabswp2020ssunivents/View/createEvent_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter create event UI',
      home: FriendlistScreen(),
    );
  }
}