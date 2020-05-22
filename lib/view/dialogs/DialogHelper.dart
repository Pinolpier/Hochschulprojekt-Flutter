import 'package:flutter/material.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/utils/errorDialogCreator.dart';

import 'addFriends_dialog.dart';
import 'changeBioOrGroupName_dialog.dart';
import 'friendList_dialog.dart';

/// Helper class that calls the different dialogs when the buttons were pressed and displays them

  showFriendsDialogEvent(context, Event event) => showDialog(context: context, builder: (context) => FriendslistdialogScreen(event));
  showFriendsDialog(context) => showDialog(context: context, builder: (context) => FriendslistdialogScreen.create());
  showAddFriendsDialog(context) => showDialog(context: context, builder: (context) => AddFriendsDialogScreen());
  showChangeBioDialog(context) => showDialog(context: context, builder: (context) => ChangeBioDialog());
  showErrorDialog(context, String title, String body, bool isHighPrio) => showDialog(barrierDismissible: false, context: context, builder: (context) => ErrorDialogCreator(title,body,isHighPrio));
