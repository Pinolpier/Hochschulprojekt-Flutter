import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:univents/Model/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Model/constants.dart';

class AboutScreen extends StatefulWidget {
  @override
  State createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Map<dynamic, dynamic> _loadedStrings;
  var _result;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
    await rootBundle.loadString('assets/res/strings.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _loadedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  void share(BuildContext context, String text) {
    final RenderBox box = context.findRenderObject();   //fix for iPad

    Share.share(
      text,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  Widget _feedbackButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _launchURL();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'feedback',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'mailto:feedback@univents.app?subject=Feedback&body=What could be better: ';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Widget _shareButtonWidget(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => Share.share(text),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'share',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // This is the proper place to make the async calls
    // This way they only get called once

    // During development, if you change this code,
    // you will need to do a full restart instead of just a hot reload

    // You can't use async/await here,
    // We can't mark this method as async because of the @override
    load().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        _result = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      return new Container();
    } else {
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
                      style: labelStyleConstant,
                    ),
                    Text(
                      _loadedStrings["privacy"],
                      style: textStyleConstant,
                    ),
                    SizedBox(height: 20.0),
                    Text('impressum',
                      style: labelStyleConstant,
                    ),
                    Text(
                      'load impressum text',
                      style: textStyleConstant,
                    ),
                    SizedBox(height: 20.0),
                    _feedbackButtonWidget(),
                    _shareButtonWidget('load shareMessage text'),
                  ],
                ),
              )
          )
      );
    }
  }
}