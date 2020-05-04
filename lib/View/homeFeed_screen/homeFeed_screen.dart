import 'package:flutter/material.dart';
import 'package:univents/Controller/authService.dart';

import 'navigationBarUI.dart';

class HomeFeedScreenUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    signInWithEmailAndPassword("j.oster@gmx.net", "pass1234");
    return MaterialApp(
      title: 'App',
      theme: ThemeData(fontFamily: 'Open Sans'),
      debugShowCheckedModeBanner: false,
      home: NavigationBarUI(),
    );
  }
}
