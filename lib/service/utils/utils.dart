import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../app_localizations.dart';

String format_date_time(BuildContext context, DateTime date) {
  return DateFormat.yMEd(AppLocalizations.of(context).translate('localization'))
      .add_jm()
      .format(date);
}
