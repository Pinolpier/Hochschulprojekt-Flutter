import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/controller/screenManager.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/userProfile.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/service/utils/imagePickerUnivents.dart';
import 'package:univents/service/utils/toast.dart';
import 'package:univents/view/homeFeed_screen/navigationBarUI.dart';

import 'dialogs/DialogHelper.dart';

class ProfileScreen extends StatefulWidget  {
  String UID;
  bool create = false;

  ProfileScreen(String UID) {
    this.UID = UID;
    createState();
  }
  ProfileScreen.create() {
    create = true;
  }

  @override
  _ProfileScreenState createState() => create ? _ProfileScreenState.create() : new _ProfileScreenState(UID);
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileScreenState(String UID) {
    this.UID = UID;
  }
  _ProfileScreenState.create() {
    createProfile = true;
  }

  String UID;
  var _result;
  final _textControllerUsername = TextEditingController();
  final _textControllerFirstName = TextEditingController();
  final _textControllerLastname = TextEditingController();
  String firstName;
  String lastName;
  String userName;
  String emailAddress;
  String bioText = "oops, seems like firebase doesn't have any text saved for your bio yet!";
  Widget profilePicFromDatabase;
  File profilepic;
  bool isProfileOwner;
  bool createProfile = false;

  Widget _profilePicturePlaceholder() {
    return GestureDetector(
        onTap: () async {
          File profilePicAsync = await ip.chooseImage(context);
          setState(() {
            print(profilePicAsync);
            profilepic = profilePicAsync;
          });
        }, // handle your image tap here
        child: Image.asset('assets/blank_profile.png', height: 150));
  }

  Widget _profilePicture() {
    return GestureDetector(
        onTap: () async {
          File profilePicAsync = await ip.chooseImage(context);
          setState(() {
            print(profilePicAsync);
            profilepic = profilePicAsync;
          }); // handle your image tap here
        },
        child: Image.file(profilepic, height: 150));
  }

  Future<bool> loadAsyncData() async {
    if(createProfile == false) {
      try {
        this.isProfileOwner = (UID == getUidOfCurrentlySignedInUser());

        UserProfile userProfile = await getUserProfile(UID);
        this.emailAddress = userProfile.email;
        this.firstName = userProfile.forename;
        this.lastName = userProfile.surname;
        this.userName = userProfile.username;

        this.profilePicFromDatabase = await getProfilePicture(UID);
        if (userProfile.biography != null) {
          this.bioText = userProfile.biography;
        }
        print('got all userdata!');
      } on Exception catch (e) {
        print(e);
      }
      return true;
    }
  }

  @override
  void initState() {
    // This is the proper place to make the async calls
    // This way they only get called once

    // During development, if you change this code,
    // you will need to do a full restart instead of just a hot reload

    // You can't use async/await here,
    // We can't mark this method as async because of the @override
    loadAsyncData().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        _result = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_result == null && createProfile == false) {
      return CircularProgressIndicator();
    }
    else {
      return new Scaffold(
        backgroundColor: Colors.white,
        body: new Stack(
          children: <Widget>[
            Positioned(
                width: 380.0,
                top: MediaQuery
                    .of(context)
                    .size
                    .height / 10,
                left: 20.0,
                child: Column(
                  children: <Widget>[
                    Container(
                        color: Colors.grey,
                        width: 130.0,
                        height: 130.0,
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: _result == null && createProfile == false ? CircularProgressIndicator()
                              : profilePicFromDatabase != null ? profilePicFromDatabase
                              : profilepic == null
                              ? _profilePicturePlaceholder()
                              : _profilePicture(),
                        )),
                    SizedBox(height: 50.0),
                    createProfile == false && firstName != null &&
                        lastName != null ? Text(firstName + " " + lastName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ) : createProfile == false && firstName == null &&
                        lastName == null ? null
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 300.0,
                          child: TextField(
                            controller: _textControllerFirstName,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: AppLocalizations.of(context).translate(
                                  'first_name'),
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
                              hintText: AppLocalizations.of(context).translate(
                                  "last_name"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    createProfile == false ? Text(userName,
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ) : Container(
                      width: 300.0,
                      child: TextField(
                        controller: _textControllerUsername,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: AppLocalizations.of(context).translate(
                              'username'),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    createProfile == false && emailAddress != null ? Text(
                      emailAddress,
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ) : createProfile == false && emailAddress == null ? null
                        : Text(getEmailOfCurrentlySignedInUser(),
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 20.0),
                    createProfile == false ? Text(bioText,
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ) : SizedBox(height: 0.0),
                    SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: isProfileOwner == true ? 95.0 : isProfileOwner ==
                            false ? 150.0 : createProfile == true ? 100.0 : null,
                        child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.grey,
                            color: Colors.black45,
                            elevation: 7.0,
                            child: isProfileOwner == true &&
                                createProfile == false ? GestureDetector(
                              onTap: () {
                                DialogHelper.showChangeBioDialog(context);
                              },
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).translate(
                                      'edit_bio'),
                                  style: TextStyle(color: Colors.white,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),)
                                : isProfileOwner == false &&
                                createProfile == false ? GestureDetector(
                              onTap: () {
                                showAlertDialog(context);
                              },
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).translate(
                                      'send_friends_request'),
                                  style: TextStyle(color: Colors.white,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ) : createProfile == true
                                ? GestureDetector(
                              onTap: () async {
                                setState(() {
                                  userName = _textControllerUsername.text;
                                  firstName = _textControllerFirstName.text;
                                  lastName = _textControllerLastname.text;
                                });
                                if (userName != null && userName
                                    .trim()
                                    .isNotEmpty) {
                                  UserProfile userProfile = new UserProfile(
                                      getUidOfCurrentlySignedInUser(),
                                      userName,
                                      getEmailOfCurrentlySignedInUser(),
                                      firstName,
                                      lastName,
                                      null,
                                      null);
                                  await updateProfile(userProfile);
                                  await updateProfilePicture(profilepic, userProfile);

                                  //Navigator.pop(context); //TODO: Rebuild Screenmanager after pop
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => ScreenManager()),
                                        (Route<dynamic> route) => false,
                                  );
                                }
                                else {
                                  show_toast(
                                      AppLocalizations.of(context).translate(
                                          'profile_screen_toast'));
                                }
                              },
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).translate(
                                      'confirm'),
                                  style: TextStyle(color: Colors.white,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),)
                                : SizedBox(height: 0.0)
                        )),
                  ],
                ))
          ],
        ),
      );
    }
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(AppLocalizations.of(context).translate('cancel')),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = FlatButton(
      child: Text(AppLocalizations.of(context).translate('confirm')),
      onPressed:  () {
        //contact.emails.forEach((item) {
        //print(item.value);
        // });
        // print(contact.displayName);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text(contact.displayName),
      content: Text(
          AppLocalizations.of(context).translate('confirm_friend_request')),
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