import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/Model/FriendslistDummies.dart';
import 'package:univents/Model/GroupDummies.dart';
import 'package:univents/View/dialogs/Debouncer.dart';
import 'package:univents/View/dialogs/DialogHelper.dart';

class FriendlistScreen extends StatefulWidget{
  @override
  _FriendlistScreenState createState() => _FriendlistScreenState();
}

/**
 * this class creates a friendslist with a searchbar at the top to filter through the friends (not implemented yet) and a
 * button at the bottom to add new friends, also used to display groups depending on the bool [isFriendsScreen] to avoid code duplication!
 */
class _FriendlistScreenState extends State<FriendlistScreen>{

  final _debouncer = new Debouncer(500);
  bool isFriendsScreen = true;

  //simple dummie list filled with dummie friend objects to test the list
  List<FriendslistDummies> friends = [
    FriendslistDummies(name: "Markus Link", profilepic: "mango.png"),
    FriendslistDummies(name: "Markus Häring", profilepic: "mango.png"),
    FriendslistDummies(name: "Jan Oster", profilepic: "mango.png"),
    FriendslistDummies(name: "Mathias Darscht", profilepic: "mango.png"),
    FriendslistDummies(name: "Christian Henrich", profilepic: "mango.png"),
  ];

  List<GroupDummies> groups = [
    GroupDummies(name: "GROUP1", profilepic: "mango.png")
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: isFriendsScreen == true ? Text("Your Friendslist") :  Text("Your Groups"),
        leading: isFriendsScreen == true ? null : new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                isFriendsScreen = true;
              });
            },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              hintText: isFriendsScreen == true ? "search for a friend" :  "search for a group",
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
              itemCount: isFriendsScreen == true ? friends.length : groups.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 6.0),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          isFriendsScreen == true ? print(friends[index].name + " was pressed"): isFriendsScreen = true; //Beim Auswählen einer Gruppe öffnet sich der eigene FriendsList_Screen (wir noch geändert sobald Backend steht)
                        });
                      },
                      title: isFriendsScreen == true ? Text(friends[index].name) : Text(groups[index].name),
                      leading: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                        },
                        child: CircleAvatar(
                          backgroundImage: isFriendsScreen == true ? AssetImage('assets/${friends[index].profilepic}') : AssetImage('assets/${groups[index].profilepic}'),  //Gruppenvorschaubild ändern können ? Rücksprache mit PO Markus Link
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
          isFriendsScreen == true ? Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isFriendsScreen = false;
                    });
                  },
                  child: Icon(Icons.group),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
                child: FloatingActionButton(
                  onPressed: () {
                    DialogHelper.showAddFriendsDialog(context);
                  },
                  child: Icon(Icons.group_add),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          )
          : Padding(
            padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
            child: FloatingActionButton(
              onPressed: () {
                DialogHelper.showFriendsDialog(context);
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}