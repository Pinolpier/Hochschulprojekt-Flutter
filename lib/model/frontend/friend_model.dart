import 'package:flutter/cupertino.dart';

/// @author Christian Henrich
///
/// friend model class for the friends that get shown in listview in [friendsList_screen], [friendslist_dialog] and [addFriends_dialog]
class FriendModel {
  /// User ID of the friend
  String uid;

  /// name of the friend
  String name;

  /// profile picture of the friend
  Widget profilepic;
  bool isSelected = false;

  FriendModel({this.uid, this.name, this.profilepic});
}
