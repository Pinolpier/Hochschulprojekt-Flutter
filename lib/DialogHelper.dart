import 'package:aiblabswp2020ssunivents/addfriends_dialog.dart';
import 'package:aiblabswp2020ssunivents/friendslistdialog_screen.dart';
import 'package:flutter/material.dart';

class DialogHelper {

  static showfriendsdialog(context) => showDialog(context: context, builder: (context) => FriendslistdialogScreen());
  static showaddfriendsdialog(context) => showDialog(context: context, builder: (context) => AddFriendsDialogScreen());
}