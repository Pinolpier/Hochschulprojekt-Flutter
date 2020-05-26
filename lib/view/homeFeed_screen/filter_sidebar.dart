import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/view/homeFeed_screen/feed_filter.dart';

import 'filter_tile.dart';

class FilterSidebar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FilterSidebarState();
}

class FilterSidebarState extends State<FilterSidebar> {
  List<Widget> _filters = [];

  FilterSidebarState() {
    this._filters = [
      FilterTile(FeedFilter.noFilter),
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
            height: 30,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate('feed_filter'),
              style: TextStyle(
                fontSize: 20,
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
