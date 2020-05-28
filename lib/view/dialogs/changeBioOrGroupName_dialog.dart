import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/userProfile.dart';

//TODO: change to only Bio bc Groupname moved to another screen
/// this is used as a dialog that opens when you press the "change bio" button on the profile screen while your logged in as the profile owner on your own profile
/// it gives you the option to input a new bio in the textfield and confirm it through the button at the right so your new bio text gets displayed
/// it is also used in the friendList_screen when you create a new group to set a name for that group
class ChangeBioDialog extends StatefulWidget {
  UserProfile userProfile;
  bool create = false;

  ChangeBioDialog(UserProfile userProfile) {this.userProfile = userProfile;}

  ChangeBioDialog.create() {create = true;}

  @override
  _ChangeBioDialogState createState() => create == true ? _ChangeBioDialogState.create() : _ChangeBioDialogState(userProfile);
}

class _ChangeBioDialogState extends State<ChangeBioDialog> {
  final _textController = TextEditingController();
  String newText =
      ""; //TODO: fill this with the bio text from the database of the user
  bool isBioScreen =
      false; //TODO: set this to true if the user used this dialog to change his profile bio, change to false if he uses it for a new group name in the friendslist
  UserProfile userProfile;

  _ChangeBioDialogState.create() {}

  _ChangeBioDialogState(UserProfile userProfile) {
    isBioScreen = true;
    this.userProfile = userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        backgroundColor: univentsLightGreyBackground,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: isBioScreen == true
              ? Text("Change your Bio")
              : Text("Creating a new Group"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: isBioScreen == true
                      ? "input new bio here"
                      : "enter group name here",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 265, top: 10),
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(),
                backgroundColor: univentsLightGreyBackground,
                onPressed: () {
                  setState(() {
                    newText = _textController.text;
                    if (isBioScreen == true) {
                      userProfile.biography = newText;
                      updateProfile(userProfile);
                    }
                  });

                  // Navigator pop twice so user gets send back to group screen
                  int count = 0;
                  isBioScreen == false ? Navigator.popUntil(context, (route) {return count++ == 2;}) : Navigator.pop(context);
                },
                child: Icon(Icons.check, color: univentsBlackText2),
              ),
            )
          ],
        ),
      ),
    );
  }
}
