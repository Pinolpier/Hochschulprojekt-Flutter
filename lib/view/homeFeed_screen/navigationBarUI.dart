import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/view/friendList_screen.dart';
import 'package:univents/view/homeFeed_screen/feed.dart';
import 'package:univents/view/profile_screen.dart';
import 'package:univents/view/settings_screen.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/utils/dateTimePickerUnivents.dart';

import '../../service/app_localizations.dart';
import 'feed.dart';
import 'feed_filter.dart';
import 'feed_filter_values.dart';

class NavigationBarUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavigationBarUIControl();
}

class NavigationBarUIControl extends State<NavigationBarUI> {
  Widget _thisWidget;

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
      _initState(0);
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
            onTap: _initState,
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
        body: _thisWidget,
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
      //todo backend
    }
    setState(() {
      this._dropdownValue = selected;
    });
  }

  void _initState(int index) {
    setState(() {
      switch (index) {
        case 0:
          {
            _thisWidget = Container(
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
            );
            print(index);
          }
          break;
        case 1:
          {
            //TODO: Map einbinden wenn joster fertig ist
            print(index);
          }
          break;
        case 2:
          {
            _thisWidget = FriendlistScreen();
            print(index);
          }
          break;
        case 3:
          {
            _thisWidget = ProfileScreen();
            print(index);
          }
          break;
        case 4:
          {
            _thisWidget = SettingsScreen();
            print(index);
          }
          break;
      }
    });
  }
}