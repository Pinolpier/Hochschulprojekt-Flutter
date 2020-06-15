import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// todo: add author
/// todo: CONSIDER writing a library-level doc comment
/// todo: reorganize: class -> attributes -> contructor -> methods

class AppLocalizations {
  /// todo: add documentation to variables
  final Locale locale;

  /// todo: missing documentation of constructor
  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, String> _localizedStrings;

  /// todo: missing documentation
  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('language/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  /// todo: missing documentation
  String translate(String key) {
    return _localizedStrings[key];
  }
}

/// todo: missing documentation
// LocalizationsDelegate is a factory for a set of localized resources
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  /// todo: missing documentation
  @override
  bool isSupported(Locale locale) {
    return ['en', 'de'].contains(locale.languageCode);
  }

  /// todo: missing documentation
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  /// todo: missing documentation
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
