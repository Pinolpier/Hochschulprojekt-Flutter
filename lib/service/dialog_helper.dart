import 'package:flutter/material.dart';
import 'package:univents/model/event.dart';
import 'package:univents/model/user_profile.dart';
import 'package:univents/view/main_screens/profile_screen.dart';

import '../view/dialogs/add_friends_dialog.dart';
import '../view/dialogs/change_bio_dialog.dart';
import '../view/dialogs/friend_list_dialog.dart';
import 'error_dialog_creator.dart';

/// @author Christian Henrich
///
/// Helper script construct that calls the different dialogs when the buttons were pressed and displays them

/// shows the [friendsList_dialog] with the matching event where it got called from
showFriendsDialogEvent(context, Event event) => showDialog(
    context: context, builder: (context) => FriendslistdialogScreen(event));

/// shows the [friendsList_dialog] in the context of creating a new group from [friendsList_screen]
showFriendsDialog(context) => showDialog(
    context: context, builder: (context) => FriendslistdialogScreen.create());

/// shows the [addFriends_dialog] when it got called from [friendsList_screen] in the context of adding a new user as a friend
showAddFriendsDialog(context) => showDialog(
    context: context, builder: (context) => AddFriendsDialogScreen());

/// shows the [changeBioOrGroupName_dialog] when the user wants to set a new bio in his [profile_screen]
showChangeBioDialog(context, UserProfile userProfile) => showDialog(
    context: context, builder: (context) => ChangeBioDialog(userProfile));

/// shows the errordialog from the [errorDialogCreator] API where you can set a custom title and body with this method
showErrorDialog(context, String title, String body, bool isHighPrio) =>
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ErrorDialogCreator(title, body, isHighPrio));

/// shows the [profile_screen] of the user with the matching [uid]
showProfileScreen(context, String uid) =>
    showDialog(context: context, builder: (context) => ProfileScreen(uid));
