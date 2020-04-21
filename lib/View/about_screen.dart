import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/Model/constants.dart';

class AboutScreen extends StatefulWidget {
  @override
  State createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: new Container(
            height: double.infinity,
            child: SingleChildScrollView(
              //fixes pixel overflow error when keyboard is used
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Privacy',
                  style: textStyleConstant,
                  ),
                  //TODO code here
                ],
              ),
            )
        )
    );
  }
}