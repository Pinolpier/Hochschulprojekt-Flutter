import 'package:flutter/material.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/utils/dateTimePickerUnivents.dart';
import 'package:univents/view/homeFeed_screen/feed_filter.dart';
import 'package:univents/view/homeFeed_screen/feed_filter_values.dart';

import 'file:///D:/eoao_backup_unsorted_backup/eoao/eoao_study/study_ai/4.SE/AI_10_Labor_fuer_SW_Projekte_und_Project_Skills/aib_labswp_2020_ss_univents/lib/service/log.dart';

import 'feed.dart';

class NavigationBarUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavigationBarUIControl();
}

class NavigationBarUIControl extends State<NavigationBarUI> {
  ///list of data that can be filtered
  List<Widget> _data;

  ///selected filter
  String _dropdownValue;

  ///for language support
  BuildContext _context;

  /// init data from firebase of Feed class
  NavigationBarUIControl() {
    _data = new List<Widget>();
    Feed.init().then((val) => setState(() {
          _data = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
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
                hint: Text(AppLocalizations.of(context).translate("filter")),
                value: _dropdownValue,
                underline: Container(
                  height: 2,
                  color: Colors.grey,
                ),
                onChanged: _selectedFilter,
                items: <String>[
                  FeedFilterValues(FeedFilter.standardFilter)
                      .convertToString(context),
                  FeedFilterValues(FeedFilter.dateFilter)
                      .convertToString(context),
                  FeedFilterValues(FeedFilter.selectedEventsFilter)
                      .convertToString(context),
                  FeedFilterValues(FeedFilter.eventsOfFriendsFilter)
                      .convertToString(context),
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
    if (selected ==
        FeedFilterValues(FeedFilter.standardFilter).convertToString(_context)) {
      deleteStartFilter();
      deleteEndFilter();
      deleteTagFilter();
      deleteFriendIdFilter();
      myEventFilter = false;
      _update();
    } else if (selected ==
        FeedFilterValues(FeedFilter.dateFilter).convertToString(context)) {
      DateTime _date = await getDateTime(context);
      if (_date != null) {
        startDateFilter = _date;
        _update();
      }
    } else if (selected ==
        FeedFilterValues(FeedFilter.selectedEventsFilter)
            .convertToString(context)) {
      myEventFilter = true;
      _update();
    } else if (selected ==
        FeedFilterValues(FeedFilter.eventsOfFriendsFilter)
            .convertToString(context)) {
      Log().info(causingClass: 'someClass', method: "someMethod");
      //todo backend
    }
    setState(() {
      this._dropdownValue = selected;
    });
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
