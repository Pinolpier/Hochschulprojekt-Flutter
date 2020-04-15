import 'package:flutter/material.dart';
import 'package:univents/friendslistdialog_screen.dart';

class DialogHelper {

  static showfriendsdialog(context) => showDialog(context: context, builder: (context) => FriendslistdialogScreen());
}