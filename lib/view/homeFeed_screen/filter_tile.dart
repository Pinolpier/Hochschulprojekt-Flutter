import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/utils/dateTimePickerUnivents.dart';
import 'package:univents/view/homeFeed_screen/feed_filter_values.dart';

import 'feed_filter.dart';

class FilterTile extends StatefulWidget {
  final FeedFilter _filter;

  FilterTile(this._filter);

  @override
  State<StatefulWidget> createState() => FilterTileState(_filter);
}

class FilterTileState extends State<FilterTile> {
  FeedFilter _filter;
  Icon _icon;
  bool _isSelected;

  FilterTileState(this._filter) {
    this._icon = _filter != FeedFilter.noFilter
        ? Icon(
            Icons.add,
          )
        : null;
    _isSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        FeedFilterValues(_filter).convertToString(context),
        style: TextStyle(fontSize: 15, color: univentsWhiteText),
      ),
      trailing: _icon,
      onTap: () {
        _changeSection(context);
      },
    );
  }

  bool get isSelected => this._isSelected;

  void _changeSection(BuildContext context) async {
    switch (this._filter) {
      case FeedFilter.noFilter:
        deleteStartFilter();
        deleteEndFilter();
        deleteTagFilter();
        myEventFilter = false;
        deleteTagFilter();
        deleteFriendIdFilter();
        deletePrivateEventFilter();
        deleteMyEventFilter();
        _setIsSelected();
        break;
      case FeedFilter.startDateFilter:
        if (isSelected) {
          deleteStartFilter();
          _setIsSelected();
        } else {
          DateTime _date = await getDateTime(context);
          if (_date != null) {
            startDateFilter = _date;
            _setIsSelected();
          }
        }
        break;
      case FeedFilter.endDateFilter:
        if (isSelected) {
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
        break;
    }
  }

  void _setIsSelected() {
    setState(() {
      if (this._isSelected) {
        this._icon = _filter != FeedFilter.noFilter
            ? Icon(
                Icons.add,
              )
            : null;
        this._isSelected = false;
      } else {
        this._icon = _filter != FeedFilter.noFilter
            ? Icon(
                Icons.check,
                color: univentsCheckColor,
              )
            : null;
        this._isSelected = true;
      }
    });
  }
}
