import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/Model/FriendslistDummies.dart';
import 'package:univents/Model/GroupDummies.dart';
import 'package:univents/View/dialogs/Debouncer.dart';
import 'package:univents/View/dialogs/DialogHelper.dart';

class FriendlistGroupScreen extends StatefulWidget{
  @override
  _FriendlistGroupScreenState createState() => _FriendlistGroupScreenState();
}

/**
 * this class creates a friendslist with a searchbar at the top to filter through the friends (not implemented yet) and a
 * button at the bottom to add new friends
 */
class _FriendlistGroupScreenState extends State<FriendlistGroupScreen>{

  final _debouncer = new Debouncer(500);

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
        title: Text("Your Groups"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: "search for a group"
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
                itemCount: groups.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          print(groups[index].name + " was pressed");
                        },
                        title: Text(groups[index].name),
                        leading: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/${groups[index].profilepic}'),
                          ),
                        ),
                      ),
                    ),
                  ); }
            ),
          ),
          Padding(
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