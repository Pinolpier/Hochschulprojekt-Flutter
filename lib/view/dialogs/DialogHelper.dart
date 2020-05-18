import 'package:flutter/material.dart';
import 'package:univents/service/utils/errorDialogCreator.dart';

import 'addFriends_dialog.dart';
import 'changeBioOrGroupName_dialog.dart';
import 'friendList_dialog.dart';

/// Helper class that calls the different dialogs when the buttons were pressed and displays them
class DialogHelper {

  static showFriendsDialog(context) => showDialog(context: context, builder: (context) => FriendslistdialogScreen());
  static showAddFriendsDialog(context) => showDialog(context: context, builder: (context) => AddFriendsDialogScreen());
  static showChangeBioDialog(context) => showDialog(context: context, builder: (context) => ChangeBioDialog());
  static showErrorDialog(context, String title, String body, bool isHighPrio) => showDialog(barrierDismissible: false, context: context, builder: (context) => ErrorDialogCreator(title,body,isHighPrio));
}