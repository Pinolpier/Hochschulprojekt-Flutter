import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/View/homeFeed_screen/feed.dart';

//@author mdarscht
class NavigationBarUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavigationBarUIControl();
}

class NavigationBarUIControl extends State<NavigationBarUI> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff), //TODO: color definition
          title: Center(child: Text('Univents',),),
          bottom: TabBar(
            onTap: _navigate,
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
          children: Feed.test(),//Feed.feed,
        ),
      ),
    );
  }

  void _navigate(int index) {
    switch (index) {
      case 0:
        {
          //_toHome(); TODO
          print(index);
        }
        break;
      case 1:
        {
          //_toMap(); TODO
          print(index);
        }
        break;
      case 2:
        {
          //_toFiends(); TODO
          print(index);
        }
        break;
      case 3:
        {
          //_toProfile(); TODO
          print(index);
        }
        break;
      case 4:
        {
          //_toSettings();
          print(index);
        }
        break;
    }
  }

/*
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
*/
}
