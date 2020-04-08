import 'dart:async';

import 'package:aiblabswp2020ssunivents/FriendslistDummies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * this is a custom version of the friendslistscreen widget that should be used as a dialog for the eventinfocreate screen later to add
 * an option to directly invite friends to events
 */
class AddFriendsDialogScreen extends StatefulWidget{
  @override
  _AddFriendsDialogScreenState createState() => _AddFriendsDialogScreenState();
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
class _AddFriendsDialogScreenState extends State<AddFriendsDialogScreen>{

  final _debouncer = Debouncer(milliseconds: 500);

  //simple dummie list filled with dummie friend objects to test the list
  List<FriendslistDummies> friends = [
    FriendslistDummies(name: "Markus Link", profilepic: "mango.png"),
  ];


  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: Column(
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: "Enter name of the friend you want to add"
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
                  itemBuilder: (context, index) => Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            //print(friends[index].name + " was pressed");
                            showAlertDialog(context,friends[index].name);
                          },
                          title: Text(friends[index].name),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('assets/${friends[index].profilepic}'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ), ],
          ),
        ),
    );
  }

  showAlertDialog(BuildContext context, String name) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = FlatButton(
      child: Text("Confirm"),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(name),
      content: Text("Do you really want to send " + name + " a friends request?"),
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