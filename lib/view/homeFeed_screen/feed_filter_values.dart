import 'package:flutter/material.dart';
import 'package:univents/service/app_localizations.dart';

import 'feed_filter.dart';

/// todo: add author
/// todo: CONSIDER writing a library-level doc comment

class FeedFilterValues {
  /// value to translate
  final FeedFilter _filterValue;

  /// todo: missing documenation of constructor
  const FeedFilterValues(this._filterValue);

  /// todo: missing documentation
  FeedFilter get filterValue => _filterValue;

  /// todo: DO separate the first sentence of a doc comment into its own paragraph.
  /// translates the value into the right language
  /// (BuildContext)[context] for setting the translation
  String convertToString(BuildContext context) {
    String _filter;
    switch (this._filterValue) {
      case FeedFilter.startDateFilter:
        _filter = AppLocalizations.of(context).translate('start_date_filter');
        break;
      case FeedFilter.endDateFilter:
        _filter = AppLocalizations.of(context).translate('end_date_filter');
        break;
      case FeedFilter.tagsFilter:
        _filter = AppLocalizations.of(context).translate('tags_filter');
        break;
      case FeedFilter.myEventFilter:
        _filter = AppLocalizations.of(context).translate('my_event_filter');
        break;
      case FeedFilter.privateEventFilter:
        _filter =
            AppLocalizations.of(context).translate('private_event_filter');
        break;
      case FeedFilter.friendsFilter:
        _filter = AppLocalizations.of(context).translate('friends_filter');
        break;
    }
    return _filter;
  }
}
