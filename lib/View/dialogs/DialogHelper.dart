import 'package:flutter/material.dart';
import 'package:univents/View/friendsGroups_screen.dart';

import 'addFriends_dialog.dart';
import 'changeBio_dialog.dart';
import 'friendList_dialog.dart';

/// Helper class that calls the different dialogs when the buttons were pressed and displays them
class DialogHelper {

  static showFriendsDialog(context) => showDialog(context: context, builder: (context) => FriendslistdialogScreen());
  static showAddFriendsDialog(context) => showDialog(context: context, builder: (context) => AddFriendsDialogScreen());
  static showChangeBioDialog(context) => showDialog(context: context, builder: (context) => ChangeBioDialog());
  static showFriendsGroupDialog(context) => showDialog(context: context, builder: (context) => FriendlistGroupScreen());
}