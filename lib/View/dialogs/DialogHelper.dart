import 'package:flutter/material.dart';

import 'addFriends_dialog.dart';
import 'changeBio_dialog.dart';
import 'friendList_dialog.dart';

class DialogHelper {

  static showfriendsdialog(context) => showDialog(context: context, builder: (context) => FriendslistdialogScreen());
  static showaddfriendsdialog(context) => showDialog(context: context, builder: (context) => AddFriendsDialogScreen());
  static showchangebiodialog(context) => showDialog(context: context, builder: (context) => ChangeBioDialog());
}