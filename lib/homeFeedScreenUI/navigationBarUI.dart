import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aiblabswp2020ssunivents/homeFeedScreenUI/feed.dart';

//@author mdarscht
class NavigationBarUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavigationBarUIControl();
}

class NavigationBarUIControl extends State<NavigationBarUI> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff), //TODO: color definition
          title: Center(child: Text('Univents', ),),
          bottom: TabBar(
            onTap: _something,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.map),
              ),
              Tab(
                icon: Icon(Icons.group),
              ),
              Tab(
                icon: Icon(Icons.account_circle),
              ),
              Tab(
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
        body: ListView(
          children: Feed.feed,
        ),
      ),
    );
  }

  void _something(int index) {
    switch (index) {
      case 0: {
        _toHome();
      }
      break;
      case 1: {
        _toMap();
      }
      break;
      case 2: {
        _toFiends();
      }
      break;
      case 3: {
        _toProfile();
      }
      break;
      case 4: {
        _toSettings();
      }
      break;
    }
  }

  Route _toHome() {
    print('navigate to home');
  }

  Route _toMap() {
    print('navigate to map');
  }

  Route _toFiends() {
    print('navigate to friends');
  }

  Route _toProfile() {
    print('navigate to profile');
  }

  Route _toSettings() {
    print('navigate to settings');
  }
}
