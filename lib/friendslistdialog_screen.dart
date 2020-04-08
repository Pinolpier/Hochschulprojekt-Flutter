import 'dart:async';

import 'package:aiblabswp2020ssunivents/FriendslistDummies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * this is a custom version of the friendslistscreen widget that should be used as a dialog for the eventinfocreate screen later to add
 * an option to directly invite friends to events
 */
class FriendslistdialogScreen extends StatefulWidget{
  @override
  _FriendlistdialogScreenState createState() => _FriendlistdialogScreenState();
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
class _FriendlistdialogScreenState extends State<FriendslistdialogScreen>{

  final _debouncer = Debouncer(milliseconds: 500);

  //simple dummie list filled with dummie friend objects to test the list
  List<FriendslistDummies> friends = [
    FriendslistDummies(name: "Markus Link", profilepic: "mango.png"),
    FriendslistDummies(name: "Markus Häring", profilepic: "mango.png"),
    FriendslistDummies(name: "Jan Oster", profilepic: "mango.png"),
    FriendslistDummies(name: "Mathias Darscht", profilepic: "mango.png"),
    FriendslistDummies(name: "Christian Henrich", profilepic: "mango.png")
  ];

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
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
                  itemBuilder: (context, index) => Container(color: _selectedIndex != null && _selectedIndex == index
                                  ? Colors.blueAccent: Colors.white,
                     child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            print(friends[index].name + " was pressed");
                            _onSelected(index);
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
}