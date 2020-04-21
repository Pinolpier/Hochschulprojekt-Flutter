import 'package:flutter/material.dart';
import 'package:univents/View/profile_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter create event UI',
      home: ProfileScreen(),
    );
  }
}