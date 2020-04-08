import 'package:aiblabswp2020ssunivents/friendlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:aiblabswp2020ssunivents/UIScreens/createEvent_screen.dart';

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