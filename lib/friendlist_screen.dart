import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/DialogHelper.dart';
import 'package:univents/FriendslistDummies.dart';
import 'package:univents/backendAPI.dart';

class FriendlistScreen extends StatefulWidget{
  @override
  _FriendlistScreenState createState() => _FriendlistScreenState();
}

/**
 * this debouncer class makes sure that the user has enough time to put in his full search query into the searchbar before
 * the system starts reading it out
 */
class Debouncer{
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action){
    if(_timer != null){
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

/**
 * this class creates a friendslist with a searchbar at the top to filter through the friends (not implemented yet) and a
 * button at the bottom to create a new message
 */
class _FriendlistScreenState extends State<FriendlistScreen>{

  final _debouncer = Debouncer(milliseconds: 500);

  //simple dummie list filled with dummie friend objects to test the list
  List<FriendslistDummies> friends = [
    FriendslistDummies(name: "Markus Link", profilepic: "mango.png"),
    FriendslistDummies(name: "Markus Häring", profilepic: "mango.png"),
    FriendslistDummies(name: "Jan Oster", profilepic: "mango.png"),
    FriendslistDummies(name: "Mathias Darscht", profilepic: "mango.png"),
    FriendslistDummies(name: "Christian Henrich", profilepic: "mango.png")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Your Friendslist"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              hintText: "search for a friend"
            ),
            onChanged: (string) {
              //debouncer makes sure the user input only gets registered after 500ms to give the user time to input the full search query
              _debouncer.run(() {
                print(string);
              });
            }
          ),
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                  child: Card(
                    child: ListTile(
                      onTap: () async {
                        print(friends[index].name + " was pressed");
                        if (friends[index].name.contains("Link")) {
                          print(await appleSignIn());
                        }
                        if (friends[index].name.contains("Häring")) {
                          signOut();
                        }
                        if (friends[index].name.contains("Henrich")) {
                          print(registerWithEmailAndPassword(
                              "MarkusLinkS5@gmail.com", "1Passwört"));
                        }
                        if (friends[index].name.contains("Oster")) {
                          print(signInWithEmailAndPassword(
                              "MarkusLinkS5@gmail.com", "1Passwört"));
                        }
                        if (friends[index].name.contains("Darscht")) {
                          //sendPasswordResetEMail(email: "spam1@markus-link.com");
                          print((getUidOfCurrentlySignedInUser() != null
                              ? getUidOfCurrentlySignedInUser()
                              : "no_uid") + " is " +
                              (getEmailOfCurrentlySignedInUser() != null
                                  ? getEmailOfCurrentlySignedInUser()
                                  : "no_email"));
                        }
                      },
                      title: Text(friends[index].name),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/${friends[index].profilepic}'),
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
            child: FloatingActionButton(
              onPressed: () {
                DialogHelper.showfriendsdialog(context);
              },
              child: Text("+"),
              backgroundColor: Colors.blueAccent,
            ),
          )
        ],
      ),
    );
  }
}