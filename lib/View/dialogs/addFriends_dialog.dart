import 'package:aiblabswp2020ssunivents/Model/FriendslistDummies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aiblabswp2020ssunivents/View/dialogs/Debouncer.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:univents/Model/FriendslistDummies.dart';
import 'package:univents/View/dialogs/Debouncer.dart';

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
 * button at the bottom to add a friend through name search or through importing contacts
 */
class _AddFriendsDialogScreenState extends State<AddFriendsDialogScreen>{

  final _debouncer = new Debouncer(500);
  List<Contact> _contacts;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  //simple dummie list filled with dummie friend objects to test the list
  List<FriendslistDummies> friends = [
    FriendslistDummies(name: "Markus Link", profilepic: "mango.png"),
  ];

  /**
   * request permissions to use contacts from phone
   */
  Future<void> requestPermission(Permission permission) async {
    final status = await Permission.contacts.request();
      setState(() {
        print(status);
        _permissionStatus = status;
        print(_permissionStatus);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Text("Add new Friends"),
            centerTitle: true,
          ),
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
                  itemCount: _contacts == null ? 0 : _contacts.length,
                  itemBuilder: (context, index) => Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            //print(friends[index].name + " was pressed");
                            showAlertDialog(context,_contacts.elementAt(index));
                          },
                          title: Text(_contacts == null ? 'no contacts selected yet' : _contacts.elementAt(index).displayName),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('assets/mango.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.only(left: 260, bottom: 10.0),
              child: FloatingActionButton(
                onPressed: ()  async {
                  requestPermission(Permission.contacts);
                  if (await Permission.contacts.request().isGranted) {
                    showContactsImportDialog(context);
                  }
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

  showAlertDialog(BuildContext context, Contact contact) {

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
        contact.emails.forEach((item) {
          print(item.value);
        });
        print(contact.displayName);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(contact.displayName),
      content: Text("Do you really want to send " + contact.displayName + " a friends request?"),
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

  showContactsImportDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = FlatButton(
      child: Text("Confirm"),
      onPressed: () async {
        var contacts = (await ContactsService.getContacts()).toList();
        setState(() {
        _contacts = contacts;
        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Import Contacts from phone'),
      content: Text("Do you want to import contacts from your local phone?"),
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