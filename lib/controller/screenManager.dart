import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/view/homeFeed_screen/navigationBarUI.dart';
import 'package:univents/view/login_screen.dart';
import 'package:univents/view/profile_screen.dart';

/// This class is used to handle to show the correct screen depending on whether a user is logged in or not.
/// The shown screen changes automatically as a user signs in or out.
/// If no user is signed In the Login Screen is shown, if one is signed in the HomeScreen is shown except
/// the logged in user doesn't have a profile yet (e.g. newly registered), then another screen is shown to
/// make sure that relevant information is added and a consistent database state is kept.
class ScreenManager extends StatelessWidget {
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context);
    //TODO read the comments, for some reason not all TODOs are detected correctly, keep this one until all others are done in this ticket.
    return (user == null)
        ? LoginScreen()
        : FutureBuilder<bool>(
            future: existsUserProfile(user.uid),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data
                    ? NavigationBarUI() //TODO HomeScreenHandler here, because existsUserProfile returned true
                    : ProfileScreen
                        .create(); // TODO change FriendlistScreen with HomeScreenHandler when exists and this line with createProfileScreen()
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
