import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/userProfile.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/imagePickerUnivents.dart';
import 'package:univents/service/utils/toast.dart';
import 'package:univents/view/loading_screen.dart';

import 'dialogs/DialogHelper.dart';

/// @author Christian Henrich
///
/// This screen represents the UI for the Profilescreen of a user. the Profilescreen includes the username, profile picture, biotext and also email address of the user.
///
/// The screen is used for 3 different unique cases dependent on 2 booleans:
/// 1. If [_isProfileOwner] is true and [_createProfile] is false -> Shows the profile of the currently signed in user, so your own profile
/// this means you will be able to see everything, even the email address, since we don't need to take care of privacy settings and the user will be able to see a button
/// [edit_bio] where he can put in a new bio text to update his profile
/// 2. If [_isProfileOwner] is false and [_createProfile] is false -> Shows the profile of a foreign user account that the user clicked on
/// this means you will not be able to see everything, only what the user you view the profile off has enabled to be seen for you in his privacy settings and the user will
/// be able to see a button [send_friends_request] where he can send the user a friends request
/// 3. If [_createProfile] is true (it doesn't matter what state [_isProfileOwner] is in) -> Shows the register screen for new users that just started creating their account
/// through the option in the [login_screen] where the user has to put in a name, username and biography text and upload a profile picture to finish the process of creating
/// his very first account

class ProfileScreen extends StatefulWidget {
  /// User ID of the user whose account should appear on the screen
  String UID;

  /// helper bool to distinct between the 2 constructors that get used dependent on where they got called from
  bool create = false;

  /// this constructor gets called whenever you want to show a profile of any user (your own or of any other user)
  ProfileScreen(String UID) {
    this.UID = UID;
    createState();
  }

  /// this constructor only gets called in the registration process when the user creates his very first account from the [login_screen]
  ProfileScreen.create() {
    create = true;
  }

  @override
  _ProfileScreenState createState() =>
      create ? _ProfileScreenState.create() : new _ProfileScreenState(UID);
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// this constructor gets called whenever you want to show a profile of any user (your own or of any other user)
  _ProfileScreenState(String UID) {
    this._UID = UID;
  }

  /// this constructor only gets called in the registration process when the user creates his very first account from the [login_screen]
  _ProfileScreenState.create() {
    _createProfile = true;
  }

  /// result of the async data from [initState()]
  var _result;
  String _UID;
  String _firstName;
  String _lastName;
  String _userName;
  String _emailAddress;

  /// hardcoded bio text: in case the user doesn't have any bio text set for himself yet, this gets shown in his profile
  String _bioText =
      "oops, seems like firebase doesn't have any text saved for your bio yet!";
  Widget profilePicFromDatabase;

  /// profile pic of the current users profile
  File _profilepic;

  /// profile pic that gets retrieved from the backend with an await statement
  File _profilepicasync;

  /// If [_isProfileOwner] is true the currently shown profile belongs to the currently signed in user, if [_isProfileOwner] is false the shown profile belongs to a foreign user
  bool _isProfileOwner;

  /// this bool is always on false by default, it only gets set to true in 1 specific case: when the [ProfileScreen.create()] is called
  bool _createProfile = false;

  /// TextController for username input in createProfile screen: [_createProfile] = true
  final _textControllerUsername = TextEditingController();

  /// TextController for first name input in createProfile screen: [_createProfile] = true
  final _textControllerFirstName = TextEditingController();

  /// TextController for last name input in createProfile screen: [_createProfile] = true
  final _textControllerLastname = TextEditingController();
  ImagePickerUnivents ip = new ImagePickerUnivents();
  UserProfile userProfile;

  /// placeholder widget for profile pic that gets shown while the user doesn't have any picture set for himself
  Widget _profilePicturePlaceholder() {
    return GestureDetector(
        onTap: () async {
          profilePicFromDatabase = null;
          _profilepicasync = await ip.chooseImage(context);
          setState(() {
            print(_profilepicasync);
            _profilepic = _profilepicasync;
            updateProfilePicture(_profilepic, userProfile);
          });
        },
        child: Image.asset(
            'assets/blank_profile.png')); // placeholder picture from assets that shows a grey blank profile symbol
  }

  ///gets displaced if profilepicture gets changed
  Widget _profilePicture() {
    return GestureDetector(
        onTap: () async {
          profilePicFromDatabase = null;
          _profilepicasync = await ip.chooseImage(context);
          setState(() {
            print(_profilepicasync);
            _profilepic = _profilepicasync;
            updateProfilePicture(_profilepic, userProfile);
          });
        },
        child: Image.file(_profilepic));
  }

  ///gets displayed if user has an profilepicture in Database
  Widget _profilePicFromDatabase() {
    return GestureDetector(
        onTap: () async {
          profilePicFromDatabase = null;
          _profilepicasync = await ip.chooseImage(context);
          setState(() {
            print(_profilepicasync);
            _profilepic = _profilepicasync;
            updateProfilePicture(_profilepic, userProfile);
          });
        },
        child: profilePicFromDatabase != null
            ? profilePicFromDatabase
            : _profilepic == null
                ? Image.asset('assets/blank_profile.png')
                : Image.file(_profilepic));
  }

  /// async method that retrieves all needed data from the backend before Widget Build runs and shows the screen to the user
  Future<bool> loadAsyncData() async {
    if (_createProfile == false) {
      try {
        this._isProfileOwner = (_UID == getUidOfCurrentlySignedInUser());

        userProfile = await getUserProfile(_UID);
        userProfile.email == null
            ? this._emailAddress = ''
            : this._emailAddress = userProfile.email;
        userProfile.forename == null
            ? this._firstName = ''
            : this._firstName = userProfile.forename;
        userProfile.surname == null
            ? this._lastName = ''
            : this._lastName = userProfile.surname;
        this._userName = userProfile.username;

        this.profilePicFromDatabase = await getProfilePicture(_UID);
        print(profilePicFromDatabase);
        if (userProfile.biography != null) {
          this._bioText = userProfile.biography;
        }
        print('got all userdata!');
      } on Exception catch (e) {
        Log().error(
            causingClass: 'profile_screen',
            method: 'loadAsyncData',
            action: e.toString());
      }
    } else {
      profilePicFromDatabase = null;
    }
    return true;
  }

  @override
  void initState() {
    loadAsyncData().then((result) {
      setState(() {
        _result = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // while the needed data to fill the screen gets retrieved from the backend by [loadAsyncData()] show a CircularProgressIndicator loading circle
    if (_result == null) {
      return CircularProgressIndicator();
    } else {
      // when all the data was collected (_result != null) show the screen
      return new Scaffold(
        backgroundColor: univentsWhiteBackground,
        appBar: isProfileOwner == false
            ? AppBar(
                title: Text("Profile of: " + userName),
                backgroundColor: primaryColor,
              )
            : null,
        body: new Stack(
          children: <Widget>[
            Positioned(
                width: 380.0,
                top: MediaQuery.of(context).size.height / 10,
                left: 20.0,
                child: Column(
                  children: <Widget>[
                    Container(
                        color: univentsLightGreyBackground,
                        width: 130.0,
                        height: 130.0,
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: _result == null
                              ? CircularProgressIndicator()
                              : _profilePicFromDatabase() != null
                                  ? _profilePicFromDatabase()
                              : _profilepic == null
                                      ? _profilePicturePlaceholder()
                                      : _profilePicture(),
                        )),
                    SizedBox(height: 50.0),
                    _createProfile == false &&
                        _firstName != null &&
                        _lastName != null
                        ? Text(
                      _firstName + " " + _lastName,
                            style: TextStyle(
                                color: univentsBlackText,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          )
                        : _createProfile == false &&
                        _firstName == null &&
                        _lastName == null
                            ? null
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 300.0,
                                    child: TextField(
                                      controller: _textControllerFirstName,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        hintText:
                                        "First Name", //TODO: Add Internationalization
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    width: 300.0,
                                    child: TextField(
                                      controller: _textControllerLastname,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        hintText: "Last Name", //TODO: Add Internationalization
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                    SizedBox(height: 10.0),
                    _createProfile == false
                        ? Text(
                      _userName,
                            style: TextStyle(
                                fontSize: 17.0,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Montserrat'),
                          )
                        : Container(
                            width: 300.0,
                            child: TextField(
                              controller: _textControllerUsername,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: "username", //TODO: Add Internationalization
                              ),
                            ),
                          ),
                    SizedBox(height: 10.0),
                    _createProfile == false && _emailAddress != null
                        ? Text(
                      _emailAddress,
                            style: TextStyle(
                                fontSize: 17.0,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Montserrat'),
                          )
                        : _createProfile == false && _emailAddress == null
                            ? null
                            : Text(
                                getEmailOfCurrentlySignedInUser(),
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Montserrat'),
                              ),
                    SizedBox(height: 20.0),
                    _createProfile == false
                        ? Text(
                      _bioText,
                            style: TextStyle(
                                fontSize: 17.0,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Montserrat'),
                          )
                        : SizedBox(height: 0.0),
                    SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: _isProfileOwner == true
                            ? 95.0
                            : isProfileOwner == false
                            ? 0.0
                                : createProfile == true ? 100.0 : null,
                        child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: univentsGreyBackgorund,
                            color: primaryColor,
                            elevation: 7.0,
                            child: _isProfileOwner == true &&
                                _createProfile == false
                                ? GestureDetector(
                                    onTap: () {
                                      showChangeBioDialog(context, userProfile);
                                    },
                                    child: Center(
                                      child: Text(
                                        "Edit Bio",
                                        //TODO: Add Internationalization
                                        style: TextStyle(
                                            color: univentsWhiteText,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                            )
                                    : createProfile == true
                                        ? GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                _userName =
                                                    _textControllerUsername
                                                        .text;
                                                _firstName =
                                                    _textControllerFirstName
                                                        .text;
                                                _lastName =
                                                    _textControllerLastname
                                                        .text;
                                              });
                                              if (_userName != null &&
                                                  _userName
                                                      .trim()
                                                      .isNotEmpty) {
                                                UserProfile userProfile =
                                                    new UserProfile(
                                                        getUidOfCurrentlySignedInUser(),
                                                        _userName,
                                                        getEmailOfCurrentlySignedInUser(),
                                                        _firstName,
                                                        _lastName,
                                                        null,
                                                        null);
                                                try {
                                                  await updateProfile(
                                                      userProfile);
                                                  await updateProfilePicture(
                                                      _profilepic, userProfile);
                                                } on Exception catch (e) {
                                                  show_toast(e.toString());
                                                  Log().error(
                                                      causingClass:
                                                          'profile_screen',
                                                      method: 'updateProfil',
                                                      action: e.toString());
                                                }

                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoadingScreen()),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              } else {
                                                show_toast(
                                                    "username cant be empty!"); //TODO: Add Internationalization
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                "confirm",
                                                //TODO: Add Internationalization
                                                style: TextStyle(
                                                    color: univentsWhiteText,
                                                    fontFamily: 'Montserrat'),
                                              ),
                                            ),
                                          )
                                        : SizedBox(height: 0.0))),
                  ],
                ))
          ],
        ),
      );
    }
  }

  /// this method shows a dialog screen when you try to send someone a friends request. you have to manually confirm sending the user the friends request
  /// or also have the option to cancel it if you changed your mind
  showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("cancel"), //TODO: Add Internationalization
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = FlatButton(
      child: Text("confirm"), //TODO: Add Internationalization
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
          "Do you really want to send a Friend Request to:"),
      //TODO: Add Internationalization
      //contact.displayname
      actions: [
        cancelButton,
        confirmButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
