import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../app_localizations.dart';

/// returns a [String] with formatted [DateTime] and [BuildContext]
/// dateTime is formatted based on the supported locales
String format_date_time(BuildContext context, DateTime date) {
  return DateFormat.yMEd(AppLocalizations.of(context).translate('localization'))
      .add_jm()
      .format(date);
}

String feed_format_date_time(BuildContext context, DateTime date) {
  return DateFormat.MEd(AppLocalizations.of(context).translate('localization'))
      .add_jm()
      .format(date);
}
