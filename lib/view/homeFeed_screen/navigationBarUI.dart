import 'package:flutter/material.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/view/createEvent_screen.dart';
import 'package:univents/view/friendList_screen.dart';
import 'package:univents/view/homeFeed_screen/feed.dart';
import 'package:univents/view/map_screen.dart';
import 'package:univents/view/profile_screen.dart';
import 'package:univents/view/settings_screen.dart';

import '../../service/app_localizations.dart';
import 'feed.dart';
import 'filter_sidebar.dart';

class NavigationBarUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavigationBarUIControl();
}

class NavigationBarUIControl extends State<NavigationBarUI> {
  Widget _thisWidget;

  /// list of data that can be filtered
  List<Widget> _data;

  /// state of pages as index for displaying the filter sidebar
  int _state = 0;

  /// dynamic app bar title (changes if screen changes)
  String _appBarTitle = 'Home';

  bool isHomeFeedOrMapScreen;

  /// init data from firebase of Feed class
  NavigationBarUIControl() {
    _data = new List<Widget>();
    Feed.init().then((val) => setState(() {
          _initState(0);
          this._data = val;
        }));
  }

  ///updates feed with the set filters
  List<Widget> _update() {
    Feed.init().then((val) => setState(() {
          this._data = val;
          _initState(_state);
        }));
    return this._data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        floatingActionButton: isHomeFeedOrMapScreen == true
            ? Padding(
                padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
                child: FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => new CreateEventScreen(null),
                        ));
                  },
                  child: Icon(Icons.add),
                  backgroundColor: primaryColor,
                ),
              )
            : null,
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            this._appBarTitle,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 1 / 35,
            ),
          ),
          leading: this._state == 0 || this._state == 1
              ? Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context)
                    .openAppDrawerTooltip,
              );
            },
          )
              : null,
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
        drawer: this._state == 0 || this._state == 1 ? FilterSidebar() : null,
        body: _thisWidget,
      ),
    );
  }

  /// navigation over screen cards based on
  /// (int) [index]
  void _initState(int index) {
    setState(() {
      this._state = index;
      switch (index) {
        case 0:
          {
            isHomeFeedOrMapScreen = true;
            this._thisWidget = ListView(
              children: _update(),
            );
            this._appBarTitle =
                AppLocalizations.of(context).translate('home_screen');
          }
          break;
        case 1:
          {
            isHomeFeedOrMapScreen = true;
            this._thisWidget = MapScreen();
            this._appBarTitle =
                AppLocalizations.of(context).translate('map_screen');
          }
          break;
        case 2:
          {
            isHomeFeedOrMapScreen = false;
            this._thisWidget = FriendlistScreen();
            this._appBarTitle =
                AppLocalizations.of(context).translate('friends_screen');
          }
          break;
        case 3:
          {
            isHomeFeedOrMapScreen = false;
            this._thisWidget = ProfileScreen(getUidOfCurrentlySignedInUser());
            this._appBarTitle =
                AppLocalizations.of(context).translate('profile_screen');
          }
          break;
        case 4:
          {
            isHomeFeedOrMapScreen = false;
            this._thisWidget = SettingsScreen();
            this._appBarTitle =
                AppLocalizations.of(context).translate('settings_screen');
          }
          break;
      }
    });
  }
}
