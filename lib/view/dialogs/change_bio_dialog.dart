import 'package:flutter/material.dart';
import 'package:univents/backend/user_profile_service.dart';
import 'package:univents/constants/colors.dart';
import 'package:univents/model/user_profile.dart';

/// @author Christian Henrich
///
/// this is used as a dialog that opens when you press the "change bio" button on the profile screen while your logged in as the profile owner on your own profile
/// it gives you the option to input a new bio in the textfield and confirm it through the button at the right so your new bio text gets displayed
class ChangeBioDialog extends StatefulWidget {
  /// userprofile of the currently signed in user
  UserProfile _userProfile;

  /// this constructor gets called when the user chose the option to change his current biography text in [profile_screen]
  ChangeBioDialog(UserProfile userProfile) {
    this._userProfile = userProfile;
  }

  @override
  _ChangeBioDialogState createState() => _ChangeBioDialogState(_userProfile);
}

class _ChangeBioDialogState extends State<ChangeBioDialog> {
  /// textcontrolle for the textfield where the user can input his new bio
  final _textController = TextEditingController();
  String _newBioText = "";

  /// userprofile of the currently signed in user
  UserProfile _userProfile;

  /// this constructor gets called when the user chose the option to change his current biography text in [profile_screen]
  _ChangeBioDialogState(UserProfile userProfile) {
    this._userProfile = userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        backgroundColor: univentsLightGreyBackground,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Change your Bio"),
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
                    hintText: "input new bio here"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 265, top: 10),
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(),
                backgroundColor: univentsLightGreyBackground,
                onPressed: () {
                  setState(() {
                    _newBioText = _textController.text;
                    _userProfile.biography = _newBioText;
                    updateProfile(_userProfile);
                  });
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
