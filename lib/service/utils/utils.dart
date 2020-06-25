import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../app_localizations.dart';

/// Markus Häring
///
/// utils for the project
/// until now there is the possibility to
/// format a DateTime object

/// Formats a Date with internationalization to a String including the Year,
/// month and day.
///
/// returns a [String] with formatted [DateTime] and [BuildContext]
/// dateTime is formatted based on the supported locales
String formatDateTime(BuildContext context, DateTime date) {
  return DateFormat.yMEd(AppLocalizations.of(context).translate('localization'))
      .add_jm()
      .format(date);
}

/// Formats a DateTime with internationalization to a String for the Feed
/// with only month and day
///
/// returns a [String] with formatted [DateTime] without year and [BuildContext]
/// dateTime is formatted based on the supported locales
String feedFormatDateTime(BuildContext context, DateTime date) {
  return DateFormat.MEd(AppLocalizations.of(context).translate('localization'))
      .add_jm()
      .format(date);
}

String getDayAndMonth(BuildContext context, DateTime date) {
  return DateFormat.Md(AppLocalizations.of(context).translate('localization'))
      .format(date);
}
