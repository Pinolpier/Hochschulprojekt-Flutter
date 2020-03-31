import 'package:flutter/material.dart';
import 'package:aiblabswp2020ssunivents/homeFeedScreenUI/navigationBarUI.dart';

//@author mdarscht
class HomeFeedScreenUI extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App',
        theme: ThemeData(fontFamily: 'Open Sans'),
        debugShowCheckedModeBanner: false,
        home: NavigationBarUI(),
    );
  }
}
