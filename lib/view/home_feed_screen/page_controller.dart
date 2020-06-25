import 'package:flutter/material.dart';
import 'package:univents/controller/auth_service.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/view/create_event_screen.dart';
import 'package:univents/view/friend_list_screen.dart';
import 'package:univents/view/homeFeed_screen/feed.dart';
import 'package:univents/view/map_screen.dart';
import 'package:univents/view/profile_screen.dart';
import 'package:univents/view/settings_screen.dart';

import '../../service/app_localizations.dart';
import 'filter_sidebar.dart';

/// @author mathias darscht
/// this class controls witch page should be shown and implements the home
/// of the application
class NavigationBarUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavigationBarUIControl();
}

class NavigationBarUIControl extends State<NavigationBarUI> {
  /// page that is currently shown
  Widget _thisWidget;

  /// list of data that can be filtered
  List<Widget> _data;

  /// state of pages as index for displaying the filter sidebar
  int _state = 0;

  /// dynamic app bar title (changes if screen changes)
  String _appBarTitle = 'Home';

  bool isHomeFeedScreen;
  bool isMapScreen;

  /// initializes [_data] from firebase of feed.dart
  NavigationBarUIControl() {
    _data = new List<Widget>();
  }

  @override
  void initState() {
    _update();
    super.initState();
  }

  ///updates feed with the set filters
  Future<void> _update() async {
    Feed.init().then((val) => setState(() {
          this._data = val;
          _initializeState(_state);
        }));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        floatingActionButton: isHomeFeedScreen == true
            ? Padding(
                padding: isMapScreen == true
                    ? const EdgeInsets.only(left: 340.0, bottom: 50.0)
                    : const EdgeInsets.only(left: 340.0, bottom: 5.0),
                child: FloatingActionButton(
                  mini: isMapScreen == true ? true : false,
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
            onTap: _initializeState,
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
  void _initializeState(int index) {
    setState(() {
      this._state = index;
      switch (index) {
        case 0:
          {
            isHomeFeedScreen = true;
            isMapScreen = false;
            _update();
            this._thisWidget = RefreshIndicator(
              child: ListView(
                children: this._data,
              ),
              onRefresh: _update,
            );
            this._appBarTitle =
                AppLocalizations.of(context).translate('home_screen');
          }
          break;
        case 1:
          {
            isHomeFeedScreen = true;
            isMapScreen = true;
            this._thisWidget = MapScreen();
            this._appBarTitle =
                AppLocalizations.of(context).translate('map_screen');
          }
          break;
        case 2:
          {
            isHomeFeedScreen = false;
            isMapScreen = false;
            this._thisWidget = FriendlistScreen();
            this._appBarTitle =
                AppLocalizations.of(context).translate('friends_screen');
          }
          break;
        case 3:
          {
            isHomeFeedScreen = false;
            isMapScreen = false;
            this._thisWidget = ProfileScreen(getUidOfCurrentlySignedInUser());
            this._appBarTitle =
                AppLocalizations.of(context).translate('profile_screen');
          }
          break;
        case 4:
          {
            isHomeFeedScreen = false;
            isMapScreen = false;
            this._thisWidget = SettingsScreen();
            this._appBarTitle =
                AppLocalizations.of(context).translate('settings_screen');
          }
          break;
      }
    });
  }
}
