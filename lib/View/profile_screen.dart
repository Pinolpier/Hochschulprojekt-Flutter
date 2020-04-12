import 'package:aiblabswp2020ssunivents/View/dialogs/DialogHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget  {
  @override
  _ProfileScreenState createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String bioText = "oops seems like firebase doesnt have any text saved for your bio yet";    //TODO: get bio text from firebase and initialize it to the variable name
  String fullName = "First Name Last Name";                                                   //TODO: Fill this with actual name of User from firebase
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
                  SizedBox(height: 90.0),
                  Text(fullName,
                    style: TextStyle(
                      color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 15.0),
                  Text(bioText,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 25.0),
                  Container(
                      height: 30.0,
                      width: 95.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.grey,
                        color: Colors.black45,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            DialogHelper.showchangebiodialog(context);
                          },
                          child: Center(
                            child: Text(
                              'Edit Bio',
                              style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),
                ],
              ))
        ],
      ),
    );
  }
}