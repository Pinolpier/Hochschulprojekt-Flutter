import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:univents/View/friendList_screen.dart';
import 'package:univents/View/login_screen.dart';

class ScreenManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context);
    // TODO: implement build
    return (user == null) ? LoginScreen() : FriendlistScreen();
  }
}
