import 'package:flutter/material.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/view/friendList_screen.dart';
import 'package:univents/view/homeFeed_screen/feed.dart';
import 'package:univents/view/map_screen.dart';
import 'package:univents/view/profile_screen.dart';
import 'package:univents/view/settings_screen.dart';

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
  String _appBarTitle;

  /// init data from firebase of Feed class
  NavigationBarUIControl() {
    _data = new List<Widget>();
    Feed.init().then((val) => setState(() {
          _data = val;
          _initState(0);
        }));
  }

  ///updates feed with the setted filters
  List<Widget> _update() {
    Feed.init().then((val) => setState(() {
          this._data = val;
          _initState(0);
        }));
    return this._data;
  }

  @override
  Widget build(BuildContext context) {
    this._appBarTitle = AppLocalizations.of(context).translate('home_screen');
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            _appBarTitle,
          ),
          leading: this._state == 0
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
        drawer: this._state == 0 ? FilterSidebar() : null,
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
            this._thisWidget = ListView(
              children: _update(),
            );
            this._appBarTitle =
                AppLocalizations.of(context).translate('home_screen');
          }
          break;
        case 1:
          {
            this._thisWidget = MapScreen();
            this._appBarTitle =
                AppLocalizations.of(context).translate('map_screen');
          }
          break;
        case 2:
          {
            this._thisWidget = FriendlistScreen();
            this._appBarTitle =
                AppLocalizations.of(context).translate('friends_screen');
          }
          break;
        case 3:
          {
            this._thisWidget = ProfileScreen(getUidOfCurrentlySignedInUser());
            this._appBarTitle =
                AppLocalizations.of(context).translate('profile_screen');
          }
          break;
        case 4:
          {
            this._thisWidget = SettingsScreen();
            this._appBarTitle =
                AppLocalizations.of(context).translate('settings_screen');
          }
          break;
      }
    });
  }
}
