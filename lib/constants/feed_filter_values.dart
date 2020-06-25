import 'package:flutter/material.dart';
import 'package:univents/service/app_localizations.dart';

import 'feed_filter.dart';

/// @author mathias darscht
/// this class translates the filter values of all filters
class FeedFilterValues {
  /// value to translate
  final FeedFilter _filterValue;

  /// constructor initializez [_filterValue]
  const FeedFilterValues(this._filterValue);

  FeedFilter get filterValue => _filterValue;

  /// translates the value into the right language
  ///
  /// (BuildContext)[context] for setting the translation and returns the translated [_filter]
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
      case FeedFilter.radiusFilter:
        _filter = AppLocalizations.of(context).translate('radius_filter');
    }
    return _filter;
  }

  /// translates strings on [context] of use
  static List<String> translatedStrings(BuildContext context) {
    List<String> stringsToTranslate = List();
    stringsToTranslate.add(
        AppLocalizations.of(context).translate('select_range_values_date'));
    stringsToTranslate.add(AppLocalizations.of(context).translate('confirm'));
    stringsToTranslate.add(
        AppLocalizations.of(context).translate('select_range_value_radius'));
    return stringsToTranslate;
  }
}
