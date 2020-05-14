import 'package:flutter/cupertino.dart';
import 'package:univents/service/app_localizations.dart';

import 'feed_filter.dart';

class FeedFilterValues {
  ///value to translate
  final FeedFilter _filterValue;

  const FeedFilterValues(this._filterValue);

  FeedFilter get filterValue => _filterValue;

  ///translates the value into the right language
  String convertToString(BuildContext context) {
    String _filter;
    switch (this._filterValue) {
      case FeedFilter.standardFilter:
        {
          _filter = AppLocalizations.of(context).translate("standard_filter");
        }
        break;
      case FeedFilter.dateFilter:
        {
          _filter = AppLocalizations.of(context).translate("date_filter");
        }
        break;
      case FeedFilter.selectedEventsFilter:
        {
          _filter =
              AppLocalizations.of(context).translate("selected_events_filter");
        }
        break;
      case FeedFilter.eventsOfFriendsFilter:
        {
          _filter = AppLocalizations.of(context)
              .translate("events_of_friends_filter");
        }
        break;
    }
    return _filter;
  }
}
