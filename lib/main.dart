import 'package:flutter/material.dart';
import 'package:aiblabswp2020ssunivents/UIScreens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      home: LoginScreen(),
    );
  }
}

