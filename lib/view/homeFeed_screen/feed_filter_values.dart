import 'package:flutter/material.dart';
import 'package:univents/service/app_localizations.dart';

import 'feed_filter.dart';

class FeedFilterValues {
  /// value to translate
  final FeedFilter _filterValue;

  const FeedFilterValues(this._filterValue);

  FeedFilter get filterValue => _filterValue;

  /// translates the value into the right language
  /// (BuildContext)[context] for setting the translation
  String convertToString(BuildContext context) {
    String _filter;
    switch (this._filterValue) {
      case FeedFilter.dateFilter:
        _filter = AppLocalizations.of(context).translate('date_filter');
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

  /// translates title on [context] of use
  List<String> translatedStrings(BuildContext context) {
    List<String> stringsToTranslate = List();
    stringsToTranslate
        .add(AppLocalizations.of(context).translate('select_range_values'));
    stringsToTranslate.add(AppLocalizations.of(context).translate('confirm'));
    return stringsToTranslate;
  }
}
