import 'package:flutter/material.dart';

import 'navigationBarUI.dart';

class HomeFeedScreenUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //googleSignIn();
    return MaterialApp(
      title: 'App',
      theme: ThemeData(fontFamily: 'Open Sans'),
      debugShowCheckedModeBanner: false,
      home: NavigationBarUI(),
    );
  }
}
