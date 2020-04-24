import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:univents/Controller/authService.dart';
import 'package:univents/Controller/screenManager.dart';
import 'package:univents/View/login_screen.dart';

void main() {
  runApp(new MaterialApp(home: UniventsApp()));
}

class UniventsApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
        value: user,
        child: MaterialApp(home: ScreenManager(),));
  }
}