import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/userProfile.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/service/utils/imagePickerUnivents.dart';
import 'package:univents/service/utils/toast.dart';

import 'dialogs/DialogHelper.dart';

class ProfileScreen extends StatefulWidget  {

  @override
  _ProfileScreenState createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _textControllerUsername = TextEditingController();
  final _textControllerFirstName = TextEditingController();
  final _textControllerLastname = TextEditingController();
  String bioText = "oops seems like firebase doesnt have any text saved for your bio yet";    //TODO: get bio text from firebase and initialize it to the variable name
  String firstName = "First Name";                 //TODO: Fill this with unique username of User from firebase
  String lastName = "Last Name";                 //TODO: Fill this with unique username of User from firebase
  String userName = "univentsuser123";          //TODO: Fill this with unique username of User from firebase
  String emailAddress = "test@email.com";        //TODO: Fill this with email adress of User from firebase
  File profilepic;
  bool isProfileOwner = true;                  //TODO: set this to true if the user is the profile owner and to false if hes not
  bool createProfile = false;                    //TODO: set this to true if the user uses the screen to create his new profile

  Widget _profilePicturePlaceholder() {
    return GestureDetector(
        onTap: () async {
          File profilePicAsync = await chooseImage(context);
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
          File profilePicAsync = await chooseImage(context);
          setState(() {
            print(profilePicAsync);
            profilepic = profilePicAsync;
          }); // handle your image tap here
        },
        child: Image.file(profilepic, height: 150));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: univentsWhiteBackground,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: isProfileOwner == true && createProfile == false ? Text("Your Profile") : isProfileOwner == false && createProfile == false ? Text("Profile of " + userName)
        : Text("Create your Profile"),
        centerTitle: true,
      ),
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
                        child: profilepic == null
                            ? _profilePicturePlaceholder()
                            : _profilePicture(),
                      )),
                  SizedBox(height: 50.0),
                  createProfile == false ? Text(firstName + " " + lastName,
                    style: TextStyle(
                      color: univentsBlackText,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 300.0,
                        child: TextField(
                          controller: _textControllerFirstName,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: AppLocalizations.of(context).translate('first_name'),
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
                            hintText: AppLocalizations.of(context).translate("last_name"),
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
                        hintText: AppLocalizations.of(context).translate('username'),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  createProfile == false ? Text(emailAddress,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'),
                  ) : Text(getEmailOfCurrentlySignedInUser(),
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
                      width: isProfileOwner == true ? 95.0 : isProfileOwner == false ? 150.0 : null,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: univentsGreyBackgorund,
                        color: primaryColor,
                        elevation: 7.0,
                        child: isProfileOwner == true && createProfile == false ? GestureDetector(
                          onTap: () {
                            DialogHelper.showChangeBioDialog(context);
                          },
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate(
                                  'edit_bio'),
                              style: TextStyle(color: univentsWhiteText, fontFamily: 'Montserrat'),
                            ),
                          ),)
                         : isProfileOwner == false && createProfile == false ? GestureDetector(
                          onTap: () {
                            showAlertDialog(context);
                          },
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate(
                                  'send_friends_request'),
                              style: TextStyle(color: univentsWhiteText, fontFamily: 'Montserrat'),
                            ),
                          ),
                        ) : createProfile == true  && isProfileOwner == false ? GestureDetector(
                          onTap: () async {
                            setState(() {
                              userName = _textControllerUsername.text;
                              firstName = _textControllerFirstName.text;
                              lastName = _textControllerLastname.text;
                            });
                            if(userName != null && userName.trim().isNotEmpty) {
                              UserProfile userProfile = new UserProfile(
                                  getUidOfCurrentlySignedInUser(), userName,
                                  getEmailOfCurrentlySignedInUser(), firstName,
                                  lastName, null);
                              await updateProfile(userProfile);
                              await updateImage(profilepic, userProfile);
                            }
                            else {
                              show_toast(AppLocalizations.of(context).translate(
                                  'profile_screen_toast'));
                            }
                          },
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate(
                                  'confirm'),
                              style: TextStyle(color: univentsWhiteText, fontFamily: 'Montserrat'),
                            ),
                          ),) : SizedBox(height: 0.0)
                      )),
                  ],
              ))
        ],
      ),
    );
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