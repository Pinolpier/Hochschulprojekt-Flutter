import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:univents/service/storageService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/Model/FriendslistDummies.dart';
import 'package:univents/View/dialogs/Debouncer.dart';
import 'package:univents/View/dialogs/DialogHelper.dart';
import 'package:univents/Controller/backendAPI.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/eventService.dart';

class FriendlistScreen extends StatefulWidget {
  @override
  _FriendlistScreenState createState() => _FriendlistScreenState();
}

/**
 * this class creates a friendslist with a searchbar at the top to filter through the friends (not implemented yet) and a
 * button at the bottom to add new friends
 */
class _FriendlistScreenState extends State<FriendlistScreen> {
  final _debouncer = new Debouncer(500);

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
                  hintText: "search for a friend"),
              onChanged: (string) {
                //debouncer makes sure the user input only gets registered after 500ms to give the user time to input the full search query
                _debouncer.run(() {
                  print(string);
                });
              }),
          Expanded(
            child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 4.0),
                    child: Card(
                      child: ListTile(
                        onTap: () async {
                          print(friends[index].name + " was pressed");
                          print(await signInWithEmailAndPassword(
                              'haringmarkus@yahoo.de', 'password'));
                          String uid = getUidOfCurrentlySignedInUser();
                          List<dynamic> userList = new List();
                          userList.add(uid);
                          DateTime startDate = DateTime(2020, 10, 17);
                          DateTime stopDate = DateTime(2020, 5, 25);
                          Event event = new Event(
                              'neuerTitel',
                              startDate,
                              stopDate,
                              'description',
                              'location',
                              true,
                              userList,
                              ['tags', 'neuerTag'],
                              '20',
                              '47');
                          //await createEvent(null, event);

                          List<Event> eventList = await getEvents();
                          print(eventList.length);
                          print(eventList[0].eventStartDate.toIso8601String());
                        },
                        title: Text(friends[index].name),
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/${friends[index].profilepic}'),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
            child: FloatingActionButton(
              onPressed: () {
                DialogHelper.showaddfriendsdialog(context);
              },
              child: Icon(Icons.group_add),
              backgroundColor: Colors.blueAccent,
            ),
          )
        ],
      ),
    );
  }
}
