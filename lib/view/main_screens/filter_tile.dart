import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/friendlist_service.dart';
import 'package:univents/service/utils.dart';
import 'package:univents/view/dialogs/date_slider_dialog.dart';
import 'package:univents/view/dialogs/radius_slider_dialog.dart';

import '../../constants/feed_filter_values.dart';
import '../home_feed_screen/feed_filter.dart';
import '../location_picker_screen.dart';

/// @mathias darscht
/// this class implements the UI for setting filters
class FilterTile extends StatefulWidget {
  /// this filter
  final FeedFilter _filter;

  /// constructor initializes [_filter]
  FilterTile(this._filter);

  @override
  State<StatefulWidget> createState() => FilterTileState(_filter);
}

class FilterTileState extends State<FilterTile> {
  /// this filter
  FeedFilter _filter;

  /// icon for checking if filter is selected
  Icon _icon;

  /// state of selection
  bool _isSelected;

  static GeoPoint point;

  /// constructor initializes
  ///
  /// the var [_filter]
  /// depending on [_isSelected] the [_icon] will be with a check or plus
  FilterTileState(this._filter) {
    _isSelected = _startState();
    _icon = _isSelected
        ? Icon(
            Icons.check,
            color: univentsCheckColor,
          )
        : Icon(
            Icons.add,
          );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        FeedFilterValues(_filter).convertToString(context),
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 1 / 46,
            color: univentsWhiteText),
      ),
      trailing: _icon,
      onTap: () {
        _changeSection(context);
      },
    );
  }

  bool get isSelected => this._isSelected;

  /// depending on [_isSelected] the [_filter] will given a [_startState]
  bool _startState() {
    bool _startState;
    switch (this._filter) {
      case FeedFilter.dateFilter:
        if (startDateFilter != null) {
          _startState = true;
        } else {
          _startState = false;
        }
        break;
      case FeedFilter.tagsFilter:
        if (tagsFilter != null) {
          _startState = true;
        } else {
          _startState = false;
        }
        break;
      case FeedFilter.myEventFilter:
        if (myEventFilter != null && myEventFilter) {
          _startState = true;
        } else {
          _startState = false;
        }
        break;
      case FeedFilter.privateEventFilter:
        if (privateEventFilter != null && privateEventFilter) {
          _startState = true;
        } else {
          _startState = false;
        }
        break;
      case FeedFilter.friendsFilter:
        if (friendIdFilter != null) {
          _startState = true;
        } else {
          _startState = false;
        }
        break;
      case FeedFilter.radiusFilter:
        if (radius != null) {
          _startState = true;
        } else {
          _startState = false;
        }
        break;
    }
    return _startState;
  }

  /// this method checks the filter
  ///
  /// case of date filter we need a (BuildContext)[context]
  /// for setting up a date picker
  void _changeSection(BuildContext context) async {
    switch (this._filter) {
      case FeedFilter.dateFilter:
        if (this._isSelected) {
          deleteStartFilter();
          deleteEndFilter();
          _setIsSelected();
        } else {
          DateTime today = DateTime.now();
          List<String> sDates = List();
          List<DateTime> dates = List();
          for (int dayRange = 0; dayRange < 10; dayRange++) {
            today = today.add(Duration(days: dayRange));
            dates.add(today);
            sDates.add(getDayAndMonth(context, today));
          }
          List<String> strings = FeedFilterValues.translatedStrings(context);
          List<DateTime> data = await showDialog(
              context: context,
              builder: (context) => DateSliderDialog(strings, sDates, dates));
          if (data != null) {
            startDateFilter = data[0];
            endDateFilter = data[1];
            _setIsSelected();
          }
        }
        break;
      case FeedFilter.tagsFilter:
        //todo: implement
        break;
      case FeedFilter.myEventFilter:
        _setIsSelected();
        myEventFilter = _isSelected;
        if (!_isSelected) {
          deleteMyEventFilter();
        }
        break;
      case FeedFilter.privateEventFilter:
        _setIsSelected();
        privateEventFilter = _isSelected;
        if (!_isSelected) {
          deletePrivateEventFilter();
        }
        break;
      case FeedFilter.friendsFilter:
        _setIsSelected();
        Map<String, dynamic> friendMap = await getFriends();
        friendIdFilter = friendMap['friends'];
        if (!_isSelected) {
          deleteFriendIdFilter();
        }
        break;
      case FeedFilter.radiusFilter:
        _setIsSelected();
        if (!_isSelected) {
          deleteRadiusFilter();
          initPoint(null);
        } else {
          String title = FeedFilterValues.translatedStrings(context)[2];
          String buttonText = FeedFilterValues.translatedStrings(context)[1];
          double _radius = await showDialog(
              context: context,
              builder: (context) => RadiusSliderDialog(title, buttonText));
          radius = _radius;

          var interface = InterfaceToReturnPickedLocation();
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LocationPickerScreen(interface)));
          initPoint(GeoPoint(interface.choosenLocationCoords[1],
              interface.choosenLocationCoords[0]));
        }
    }
  }

  /// changes the state of filter
  ///
  /// if this tile is selected
  /// change the icon and the state
  void _setIsSelected() {
    setState(() {
      if (this._isSelected) {
        this._icon = Icon(
          Icons.add,
        );
        this._isSelected = false;
      } else {
        this._icon = Icon(
          Icons.check,
          color: univentsCheckColor,
        );
        this._isSelected = true;
      }
    });
  }
}
