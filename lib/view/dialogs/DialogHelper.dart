import 'package:flutter/material.dart';
import 'package:univents/model/event.dart';
import 'package:univents/model/userProfile.dart';
import 'package:univents/service/utils/errorDialogCreator.dart';
import 'package:univents/view/profile_screen.dart';

import 'addFriends_dialog.dart';
import 'changeBioOrGroupName_dialog.dart';
import 'friendList_dialog.dart';

/// todo: add author
/// todo: this is no class
/// Helper class that calls the different dialogs when the buttons were pressed and displays them

/// todo: missing documentation
showFriendsDialogEvent(context, Event event) => showDialog(
    context: context, builder: (context) => FriendslistdialogScreen(event));
showFriendsDialog(context) => showDialog(
    context: context, builder: (context) => FriendslistdialogScreen.create());
showAddFriendsDialog(context) => showDialog(
    context: context, builder: (context) => AddFriendsDialogScreen());
showChangeBioDialog(context, UserProfile userProfile) => showDialog(
    context: context, builder: (context) => ChangeBioDialog(userProfile));
showChangeGroup(context) => showDialog(
    context: context, builder: (context) => ChangeBioDialog.create());
showErrorDialog(context, String title, String body, bool isHighPrio) =>
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ErrorDialogCreator(title, body, isHighPrio));
showProfileScreen(context, String uid) =>
    showDialog(context: context, builder: (context) => ProfileScreen(uid));
