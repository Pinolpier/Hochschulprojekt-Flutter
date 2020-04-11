import 'package:aiblabswp2020ssunivents/View/dialogs/addFriends_dialog.dart';
import 'package:aiblabswp2020ssunivents/View/dialogs/friendList_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {

  static showfriendsdialog(context) => showDialog(context: context, builder: (context) => FriendslistdialogScreen());
  static showaddfriendsdialog(context) => showDialog(context: context, builder: (context) => AddFriendsDialogScreen());
}