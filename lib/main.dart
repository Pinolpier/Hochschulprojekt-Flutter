import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/view/chat_screen.dart';

void main() {
  runApp(new MaterialApp(home: UniventsApp()));
}

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
          home: ChatScreen(),
        ));
  }
}

/// --> The following code is the original code from Markus Häring, I tried merging above manually, but to keep a copy I also applied his change and commented it out until we can be sure it works!
///// Start of the App where the localization gets initialized
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      // List all of the app's supported locales here
//      supportedLocales: [
//        Locale('en', 'US'),
//        Locale('de', 'DE'),
//      ],
//      localizationsDelegates: [
//        AppLocalizations.delegate,
//        GlobalMaterialLocalizations.delegate,
//        GlobalWidgetsLocalizations.delegate,
//      ],
//      localeResolutionCallback: (locale, supportedLocales) {
//        //ToDo This is just a workaround -> on IOS we don't get the locale at the first millisecond so when the locale is null we first take english as favorite language
//        if (locale == null) {
//          return supportedLocales.first;
//        }
//        for (Locale supportedLocale in supportedLocales) {
//          if (supportedLocale.languageCode == locale.languageCode ||
//              supportedLocale.countryCode == locale.countryCode) {
//            return supportedLocale;
//          }
//        }
//        return supportedLocales.first;
//      },
//      home: LoginScreen(),
//    );
//  }
//}
