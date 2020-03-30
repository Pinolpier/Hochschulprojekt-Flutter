import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aiblabswp2020ssunivents/homeFeedScreenUI/feed.dart';

//@author mdarscht
class NavigationBarUI extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff),
          title: Center(child: Text('Univents', ),),
          bottom: TabBar(
              tabs: <Widget>[
                Tab(child: Icon(Icons.event_note)),
                Tab(child: Icon(Icons.map)),
                Tab(child: Icon(Icons.people)),
                Tab(child: Icon(Icons.account_circle)),
                Tab(child: Icon(Icons.settings)),
              ]
          ),
        ),
        body: ListView(
          children: Feed.test(),
        ),
      ),
    );
  }
}