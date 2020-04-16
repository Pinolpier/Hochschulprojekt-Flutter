import 'package:flutter/material.dart';
import 'package:univents/View/dialogs/addFriends_dialog.dart';
import 'package:univents/View/dialogs/friendList_dialog.dart';

class DialogHelper {

  static showfriendsdialog(context) => showDialog(context: context, builder: (context) => FriendslistdialogScreen());
  static showaddfriendsdialog(context) => showDialog(context: context, builder: (context) => AddFriendsDialogScreen());
}