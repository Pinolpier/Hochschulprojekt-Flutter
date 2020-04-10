import 'package:aiblabswp2020ssunivents/Model/FriendslistDummies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aiblabswp2020ssunivents/View/dialogs/Debouncer.dart';
import 'package:contact_picker/contact_picker.dart';

/**
 * this is a custom version of the friendslistscreen widget that should be used as a dialog for the eventinfocreate screen later to add
 * an option to directly invite friends to events
 */
class AddFriendsDialogScreen extends StatefulWidget{
  @override
  _AddFriendsDialogScreenState createState() => _AddFriendsDialogScreenState();
}

/**
 * this class creates a friendslist with a searchbar at the top to filter through the friends (not implemented yet) and a
 * button at the bottom to create a new message
 */
class _AddFriendsDialogScreenState extends State<AddFriendsDialogScreen>{

  final _debouncer = new Debouncer(500);

  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;

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
              ),
            new Text(
              _contact == null ? 'no contact selected' : _contact.toString(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 260, bottom: 10.0),
              child: FloatingActionButton(
                onPressed: () async {
                  Contact contact = await _contactPicker.selectContact();
                  setState(() {
                    _contact = contact;
                  });
                },
                child: Icon(Icons.contacts),
                backgroundColor: Colors.blueAccent,
              ),
             ),
            ],
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