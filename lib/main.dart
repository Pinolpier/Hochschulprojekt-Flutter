import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/view/loading_screen.dart';

import 'backend/auth_service.dart';

/// Markus Häring
///
/// the main method is the entry point for the app
/// and starts a new MaterialApp
void main() {
  runApp(new MaterialApp(home: UniventsApp()));
}

/// the class UniventsApp represents the start of the app and loads all important data
///
/// When you start the app, all important data is loaded and which locales
/// are supported and should be loaded. It is also checked which locale is
/// active on the device and this is set for the app. If the set locale
/// is not supported, it will automatically be set to English.
class UniventsApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
        value: user,
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // List all of the app's supported locales here
          supportedLocales: [
            Locale('en', 'US'),
            Locale('de', 'DE'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            //ToDo This is just a workaround -> on IOS we don't get the locale at the first millisecond so when the locale is null we first take english as favorite languages
            if (locale == null) {
              return supportedLocales.first;
            }
            for (Locale supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode ||
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          home: LoadingScreen(),
        ));
  }
}
