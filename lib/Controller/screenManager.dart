import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:univents/Controller/userProfileService.dart';
import 'package:univents/View/friendList_screen.dart';
import 'package:univents/View/login_screen.dart';
import 'package:univents/View/settings_screen.dart';

class ScreenManager extends StatelessWidget {
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context);
    return (user == null) ? LoginScreen() : FutureBuilder<bool>(
      future: existsUserProfile(user.uid),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data
              ? FriendlistScreen()
              : SettingsScreen(); //TODO change FriendlistScreen with HomeScreenHandler when exists and SettingsScreen() with createProfileScreen()
        } else if (snapshot.hasError) {
          //TODO error handling here in case async function fails somehow
          return Container(
            width: 0.0,
            height: 0.0,
          );
        } else {
          //TODO Maybe return a loading animation?
          return Container(
            width: 0.0,
            height: 0.0,
          );
        }
      },
    );
  }
}
