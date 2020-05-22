import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/FriendslistDummies.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/userProfile.dart';
import 'package:univents/service/friendlist_service.dart';
import 'package:univents/view/dialogs/Debouncer.dart';

/// this is used as a dialog that opens when you press the button to add new friends on the friendslist_screen
/// here you have the option to search for new friends through username or import local friends from your phone contacts
//TODO: implement backend so the user gets users to choose from when searching for them via name/through import, only dummies implemented yet
class AddFriendsDialogScreen extends StatefulWidget {
  @override
  _AddFriendsDialogScreenState createState() => _AddFriendsDialogScreenState();
}

class _AddFriendsDialogScreenState extends State<AddFriendsDialogScreen> {
  final _debouncer = new Debouncer(500);
  List<Contact> _contacts;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  //simple dummie list filled with dummie friend objects to test the list
  List<FriendslistDummies> friends = new List();
  String query;

  /// request permissions to use contacts from phone
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
        backgroundColor: univentsLightGreyBackground,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Add new Friends"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: "Enter name of the friend you want to add"),
                onChanged: (string) {
                  //debouncer makes sure the user input only gets registered after 500ms to give the user time to input the full search query
                  _debouncer.run(() {
                    query = string;
                  });
                }),
            Expanded(
              child: ListView.builder(
                itemCount: _contacts == null ? 0 : _contacts.length,
                itemBuilder: (context, index) => Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 4.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          //print(friends[index].name + " was pressed");
                          showAlertDialog(context, _contacts.elementAt(index));
                        },
                        title: Text(_contacts == null
                            ? 'no contacts selected yet'
                            : _contacts.elementAt(index).displayName),
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
                onPressed: () async {
                  requestPermission(Permission.contacts);
                  if (await Permission.contacts.request().isGranted) {
                    showContactsImportDialog(context);
                  }
                },
                child: Icon(Icons.contacts),
                backgroundColor: primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 260, bottom: 10.0),
              child: FloatingActionButton(
                onPressed: () async {
                  addFriendByUsername(query);
                },
                child: Icon(Icons.check_box),
                backgroundColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Alertdialog to cancel or confirm the action of sending a marked user a friends request
  showAlertDialog(BuildContext context, Contact contact) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = FlatButton(
      child: Text("Confirm"),
      onPressed: () {
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
      content: Text("Do you really want to send " +
          contact.displayName +
          " a friends request?"),
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

  /// Alertdialog to cancel or confirm the action of importing friends through the local contacts from your phone
  showContactsImportDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
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
