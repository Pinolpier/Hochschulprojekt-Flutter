import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/view/homeFeed_screen/feed_filter.dart';

import 'filter_tile.dart';

/// todo: add author
/// this class helps to set filters for events with a sidebar
class FilterSidebar extends StatefulWidget {
  /// todo: misisng documentation
  @override
  State<StatefulWidget> createState() => FilterSidebarState();
}

/// todo: missing documentation
class FilterSidebarState extends State<FilterSidebar> {
  /// list with all filters
  List<Widget> _filters = [];

  /// todo: missing documentation of constructor
  FilterSidebarState() {
    this._filters = [
      FilterTile(FeedFilter.startDateFilter),
      FilterTile(FeedFilter.endDateFilter),
      FilterTile(FeedFilter.tagsFilter),
      FilterTile(FeedFilter.myEventFilter),
      FilterTile(FeedFilter.privateEventFilter),
      FilterTile(FeedFilter.friendsFilter),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 2 / 3,
      color: primaryColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 1 / 10,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate('feed_filter'),
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 1 / 28,
                color: univentsWhiteText,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: _filters,
            ),
          ),
        ],
      ),
    );
  }
}
