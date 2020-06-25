import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Markus Häring
///
/// handles the actual chosen locale
/// and the related strings for the
/// internationalization
class AppLocalizations {
  /// actual locale
  final Locale locale;

  ///the map with the internationalized strings
  Map<String, String> _localizedStrings;

  /// to create the [AppLocalizations] the actual supported [locale]
  /// is needed
  AppLocalizations(this.locale);

  /// delegate method is needed in flutter to work
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// loads the JSON internationalization file into a map
  ///
  /// loads the internationalization file based on the [locale]
  /// into the Map [_localizedStrings] and returns true, if its done
  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('language/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  /// translate a string by getting the [key]
  /// and returns the resulting [String]
  String translate(String key) {
    return _localizedStrings[key];
  }
}

/// LocalizationsDelegate is a factory for a set of localized resources
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  /// method to proof if the chosen language is supported
  ///
  /// proofs if a language is supported by getting a [locale]
  /// returns true, if it is supported
  @override
  bool isSupported(Locale locale) {
    return ['en', 'de'].contains(locale.languageCode);
  }

  /// Method to loads the actual map with the keys for internationalization
  ///
  /// loads the localized map from [AppLocalizations]
  /// by getting the [locale]
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  /// method needed and have to be false!
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
