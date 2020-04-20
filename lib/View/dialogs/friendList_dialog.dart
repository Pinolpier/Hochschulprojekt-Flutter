import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/Model/FriendslistDummies.dart';
import 'package:univents/View/dialogs/Debouncer.dart';

/**
 * this is a custom version of the friendslistscreen widget that should be used as a dialog for the eventinfocreate screen later to add
 * an option to directly invite friends to events
 */
class FriendslistdialogScreen extends StatefulWidget{
  @override
  _FriendlistdialogScreenState createState() => _FriendlistdialogScreenState();
}

/**
 * this class creates a friendslist with a searchbar at the top to filter through the friends (not implemented yet) and a
 * button at the bottom to create a new message
 */
class _FriendlistdialogScreenState extends State<FriendslistdialogScreen>{

  final _debouncer = new Debouncer(500);
  bool longPressFlag = false;
  int selectedCount = 0;

  //simple dummie list filled with dummie friend objects to test the list
  List<FriendslistDummies> friends = [
    FriendslistDummies(name: "Markus Link", profilepic: "mango.png"),
    FriendslistDummies(name: "Markus Häring", profilepic: "mango.png"),
    FriendslistDummies(name: "Jan Oster", profilepic: "mango.png"),
    FriendslistDummies(name: "Mathias Darscht", profilepic: "mango.png"),
    FriendslistDummies(name: "Christian Henrich", profilepic: "mango.png")
  ];

  void longPress() {
    setState(() {
      if (friends.isEmpty) {
        longPressFlag = false;
      } else {
        longPressFlag = true;
      }
    });
  }

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
                        onLongPress: () {
                          setState(() {
                            friends[index].isSelected = !friends[index].isSelected;
                          });
                        },
                        selected: friends[index].isSelected,
                        onTap: () {
                          print(friends[index].name + " was pressed");
                        },
                        title: Text(friends[index].name),
                        trailing: (friends[index].isSelected) ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                        leading: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {

                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/${friends[index].profilepic}'),
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}