import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';

/// this is used as a dialog that opens when you press the "change bio" button on the profile screen while your logged in as the profile owner on your own profile
/// it gives you the option to input a new bio in the textfield and confirm it through the button at the right so your new bio text gets displayed
/// it is also used in the friendList_screen when you create a new group to set a name for that group
class ChangeBioDialog extends StatefulWidget {
  @override
  _ChangeBioDialogState createState() => _ChangeBioDialogState();
}

class _ChangeBioDialogState extends State<ChangeBioDialog> {
  final _textController = TextEditingController();
  String newText =
      ""; //TODO: fill this with the bio text from the database of the user
  bool isBioScreen =
      false; //TODO: set this to true if the user used this dialog to change his profile bio, change to false if he uses it for a new group name in the friendslist

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
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
                backgroundColor: Colors.grey[200],
                onPressed: () {
                  setState(() {
                    newText = _textController.text;
                    //TODO: Save this new biotext/group name in firebase
                  });

                  // Navigator pop twice so user gets send back to group screen
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 2;
                  });
                },
                child: Icon(Icons.check, color: Colors.black45),
              ),
            )
          ],
        ),
      ),
    );
  }
}
