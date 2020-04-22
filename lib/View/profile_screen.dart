import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialogs/DialogHelper.dart';

class ProfileScreen extends StatefulWidget  {
  final String UID;

  const ProfileScreen (
      {
        Key key, this.UID
      }
      )
      : super(key: key);

  @override
  _ProfileScreenState createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String bioText = "oops seems like firebase doesnt have any text saved for your bio yet";    //TODO: get bio text from firebase and initialize it to the variable name
  String fullName = "First Name Last Name";  //TODO: Fill this with actual name of User from firebase
  String userName = "univentsuser123";       //TODO: Fill this with unique username of User from firebase
  String emailAdress = "test@email.com";     //TODO: Fill this with email adress of User from firebase
  bool isProfileOwner = true;                  //TODO: set this to true if the user is the profile owner and to false if hes not
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white30,
      body: new Stack(
        children: <Widget>[
          Positioned(
              width: 380.0,
              top: MediaQuery.of(context).size.height / 5,
              left: 20.0,
              child: Column(
                children: <Widget>[
                  Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          boxShadow: [
                            BoxShadow(blurRadius: 7.0, color: Colors.black)
                          ])),
                  SizedBox(height: 70.0),
                  Text(fullName,
                    style: TextStyle(
                      color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 10.0),
                  Text(userName,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 10.0),
                  Text(emailAdress,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 20.0),
                  Text(bioText,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 25.0),
                  Container(
                      height: 30.0,
                      width: isProfileOwner == true ? 95.0 : isProfileOwner == false ? 150.0 : null,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.grey,
                        color: Colors.black45,
                        elevation: 7.0,
                        child: isProfileOwner == true ? GestureDetector(
                          onTap: () {
                            DialogHelper.showChangeBioDialog(context);
                          },
                          child: Center(
                            child: Text(
                              'Edit Bio',
                              style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                            ),
                          ),)
                         : isProfileOwner == false ? GestureDetector(
                          onTap: () {
                            showAlertDialog(context);
                          },
                          child: Center(
                            child: Text(
                              'Send Friends Request',
                              style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                            ),
                          ),
                        ) : null
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
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = FlatButton(
      child: Text("Confirm"),
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
      content: Text("Do you really want to send "  " a friends request?"), //contact.displayname
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