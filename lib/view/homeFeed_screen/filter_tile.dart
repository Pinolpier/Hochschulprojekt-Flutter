import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/friendlist_service.dart';
import 'package:univents/service/utils/dateTimePickerUnivents.dart';
import 'package:univents/view/homeFeed_screen/feed_filter_values.dart';

import 'feed_filter.dart';

/// this class implements the UI for setting filters
class FilterTile extends StatefulWidget {
  /// this filter
  final FeedFilter _filter;

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

  /// for setting up the start state of the icons for each filter
  bool _startState() {
    bool _startState;
    switch (this._filter) {
      case FeedFilter.startDateFilter:
        print(startDateFilter);
        if (startDateFilter != null) {
          _startState = true;
        } else {
          _startState = false;
        }
        break;
      case FeedFilter.endDateFilter:
        if (endDateFilter != null) {
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
    }
    return _startState;
  }

  /// this method checks the filter
  /// case of date filter we need a (BuildContext)[context]
  /// for setting up a date picker
  void _changeSection(BuildContext context) async {
    switch (this._filter) {
      case FeedFilter.startDateFilter:
        if (this._isSelected) {
          deleteStartFilter();
          _setIsSelected();
        } else {
          DateTime _date = await getDateTime(context);
          if (_date != null) {
            startDateFilter = _date;
            print(_date);
            _setIsSelected();
          }
        }
        break;
      case FeedFilter.endDateFilter:
        if (this._isSelected) {
          deleteEndFilter();
          _setIsSelected();
        } else {
          DateTime _date = await getDateTime(context);
          if (_date != null) {
            endDateFilter = _date;
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
        Map<String, dynamic> friendMap = await getFriends();
        friendIdFilter = friendMap['friends'];
        break;
    }
  }

  /// changes the state of this class
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
