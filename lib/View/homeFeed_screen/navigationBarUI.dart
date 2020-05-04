import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/utils/dateTimePickerUnivents.dart';

import 'feed.dart';

class NavigationBarUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavigationBarUIControl();
}

class NavigationBarUIControl extends State<NavigationBarUI> {
  ///list of data that can be filtered
  List<Widget> _data;

  ///selected filter
  String dropdownValue = 'Standard Filter';

  /// init data from firebase of Feed class
  NavigationBarUIControl() {
    _data = new List<Widget>();
    Feed.init().then((val) => setState(() {
          _data = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff), //TODO: color definition
          title: Center(
            child: Text(
              'Univents',
            ),
          ),
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
        body: Container(
          child: Column(
            children: <Widget>[
              DropdownButton<String>(
                value: dropdownValue,
                underline: Container(
                  height: 2,
                  color: Colors.grey,
                ),
                onChanged: _selectedFilter,
                items: <String>[
                  'Standard Filter',
                  'Date Filter',
                  'Selected Events Filter',
                  'Event of Frieds Filter'
                ].map<DropdownMenuItem<String>>((String dropdownValue) {
                  return DropdownMenuItem<String>(
                    value: dropdownValue,
                    child: Text(dropdownValue),
                  );
                }).toList(),
              ),
              Expanded(
                child: ListView(
                  children: _data, //Feed.feed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///updates feed with the setted filters
  void _update() {
    Feed.init().then((val) => setState(() {
          _data = val;
        }));
  }

  ///controls the filter that are selected
  void _selectedFilter(String selected) async {
    setState(() {
      dropdownValue = selected;
    });
    switch (selected) {
      case "Standard Filter":
        {
          deleteStartFilter();
          deleteEndFilter();
          deleteTagFilter();
          deleteFriendIdFilter();
          myEventFilter = false;
          _update();
        }
        break;
      case "Date Filter":
        {
          DateTime _date = await getDateTime(context);
          if (_date != null) {
            startDateFilter = _date;
            _update();
          }
        }
        break;
      case "Selected Event Filter":
        {
          myEventFilter = true;
          _update();
        }
        break;
      case "Event of Friends Filter":
        {
          //friendIdFilter = ;todo
        }
        break;
    }
  }

  ///navigates through selected pages
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
