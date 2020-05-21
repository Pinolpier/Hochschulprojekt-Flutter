import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/constants.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/utils/dateTimePickerUnivents.dart';
import 'package:univents/service/utils/imagePickerUnivents.dart';
import 'package:univents/service/utils/utils.dart';
import 'package:univents/view/dialogs/friendList_dialog.dart';

/// this class creates an createEventScreen which opens if you want to create a event The screen has following input fields:
/// -Event Picture (AssetImage with ImagePicker from gallery onPress)
/// -Event Start DateTime (DateTimePicker)
/// -Event End Date (DateTimePicker)
/// -Event Name (input-type: text)
/// -Event Location (input-type: text, maybe convert it to an button which opens the map and where you then can choose the location)
/// -Event Description (input-type: multiline text)
/// -Event Tags (input-type: text, separated by comma)
/// -Event Visibility (input-type: checkbox)
/// -Event addFriends (button)
/// -Event CREATE (button)

class CreateEventScreen extends StatefulWidget {
  @override
  State createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  DateTime selectedStartDateTime;
  DateTime selectedEndDateTime;
  String selectedStartString = 'not set';
  String selectedEndString = 'not set';
  bool isPrivate = false;
  List<dynamic> tagsList = new List();
  List<dynamic> attendeeIDs = new List();
  TextEditingController eventNameController = new TextEditingController();
  TextEditingController eventLocationController = new TextEditingController();
  TextEditingController eventDescriptionController =
      new TextEditingController();
  TextEditingController eventTagsController = new TextEditingController();
  File eventImage;

  var latLongArray = new List.generate(10, (_) => new List(2));
  List<dynamic> latLongList;

  Future<void> errorEndDateTime() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rewind and remember'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('1. please specify first a startDateTime'),
                Text('2. endDateTime can#t be earlier than startDateTime'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget _eventImagePlaceholder() {
    return GestureDetector(
        onTap: () async {
          File eventImageAsync = await chooseImage(context);
          setState(() {
            print(eventImageAsync);
            eventImage = eventImageAsync;
          });
        }, // handle your image tap here
        child: Image.asset('assets/eventImagePlaceholder.png', height: 150));
  }

  Widget _eventImage() {
    return GestureDetector(
        onTap: () async {
          File eventImageAsync = await chooseImage(context);
          setState(() {
            print(eventImageAsync);
            eventImage = eventImageAsync;
          }); // handle your image tap here
        },
        child: Image.file(eventImage, height: 150));
  }

  Widget _selectStartDateTimeButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          selectedStartDateTime = await getDateTime(context);
          setState(() {
            print(selectedStartDateTime);
            selectedStartString =
                format_date_time(context, selectedStartDateTime);

            ///reset the endDateTime after setting the startDateTime so there is no possibility for it to be earlier
            selectedEndDateTime = null;
            selectedEndString = 'not set';
          });
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'select startDateTime',
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _selectEndDateTimeButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          selectedEndDateTime = await getDateTime(context);
          setState(() {
            if (selectedStartDateTime == null ||
                selectedEndDateTime.isBefore(
                    selectedStartDateTime.add(Duration(minutes: 1)))) {
              errorEndDateTime();
            } else {
              print(selectedEndDateTime);
              selectedEndString =
                  format_date_time(context, selectedEndDateTime);
            }
          });
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'select endDateTime',
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _eventNameTextfieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Event Name',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxStyleConstant,
          height: 60.0,
          child: TextField(
            controller: eventNameController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.create,
                color: Colors.white,
              ),
              hintText: 'Enter the event name',
              hintStyle: textStyleConstant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _locationTextfieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Event Location',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxStyleConstant,
          height: 60.0,
          child: TextField(
            controller: eventLocationController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.add_location,
                color: Colors.white,
              ),
              hintText: 'Enter the location of the event',
              hintStyle: textStyleConstant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _eventDescriptionTextfieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Event Description',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.topLeft,
          decoration: boxStyleConstant,
          height: 120.0,
          child: TextField(
            controller: eventDescriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.comment,
                color: Colors.white,
              ),
              hintText: 'Enter the event details',
              hintStyle: textStyleConstant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _eventTagsTextfieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Event Tags',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.topLeft,
          decoration: boxStyleConstant,
          child: TextField(
            controller: eventTagsController,
            keyboardType: TextInputType.text,
            maxLines: null,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              hintText: 'Tags, seperated by comma',
              hintStyle: textStyleConstant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _addFriendsButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          final List<String> result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendslistdialogScreen(),
              ));
          setState(() {
            for (String s in result) {
              attendeeIDs.add(s);
            }
          });
          //ID von alles ausgewähleten Freunde-Objekten in anttendeeIDs speichern (als String ind die Liste)
          //Friendslist schließen
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'addFriends',
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _isPrivateCheckbox() {
    return Container(
      child: Checkbox(
        value: isPrivate,
        onChanged: (value) {
          setState(() {
            isPrivate = value;
            print(isPrivate);
          });
        },
      ),
    );
  }

  Widget _createButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          tagsList = eventTagsController.text.split(", ");
          print(tagsList);

          print(attendeeIDs);

          getLatLong();
          print(latLongList[0]);
          print(latLongList[1]);

          Event event = new Event(
              eventNameController.text,
              selectedStartDateTime,
              selectedEndDateTime,
              eventDescriptionController.text,
              eventLocationController.text,
              isPrivate,
              attendeeIDs,
              tagsList,
              latLongList[0],
              latLongList[1]);

          //TODO -> Auskommentiert wegen Errormessages: createEvent(eventImage, event);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'CREATE',
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: new Container(
        height: double.infinity,
        child: SingleChildScrollView(
          //fixes pixel overflow error when keyboard is used
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 120.0,
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              eventImage == null ? _eventImagePlaceholder() : _eventImage(),
              SizedBox(height: 40.0),
              new Text(
                'Start Date: ' + selectedStartString,
                style: labelStyleConstant,
              ),
              _selectStartDateTimeButtonWidget(),
              SizedBox(height: 20.0),
              new Text(
                'End Date: ' + selectedEndString,
                style: labelStyleConstant,
              ),
              _selectEndDateTimeButtonWidget(),
              SizedBox(height: 20.0),
              _eventNameTextfieldWidget(),
              SizedBox(height: 20.0),
              _locationTextfieldWidget(),
              SizedBox(height: 20.0),
              _eventDescriptionTextfieldWidget(),
              SizedBox(height: 20.0),
              _eventTagsTextfieldWidget(),
              SizedBox(height: 20.0),
              new Text(
                'isPrivate: ',
                style: labelStyleConstant,
              ),
              _isPrivateCheckbox(),
              _addFriendsButtonWidget(),
              _createButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void getLatLong() {
    latLongArray[0] = ['49.142413', '9.219539'];
    latLongArray[1] = ['49.139957', '9.246418'];
    latLongArray[2] = ['49.133698', '9.268036'];
    latLongArray[3] = ['49.160640', '9.221719'];
    latLongArray[4] = ['49.163503', '9.201642'];
    latLongArray[5] = ['49.159195', '9.196814'];
    latLongArray[6] = ['49.151414', '9.190218'];
    latLongArray[7] = ['49.145704', '9.188501']; //Friedhof
    latLongArray[8] = ['49.140341', '9.185237'];
    latLongArray[9] = ['49.132612', '9.179011'];

    Random rnd = new Random();
    int i = rnd.nextInt(10);
    latLongList = new List();

    switch (i) {
      case 0:
        {
          latLongList.add(latLongArray[i][0]);
          latLongList.add(latLongArray[i][1]);
          break;
        }
      case 1:
        {
          latLongList.add(latLongArray[i][0]);
          latLongList.add(latLongArray[i][1]);
          break;
        }
      case 2:
        {
          latLongList.add(latLongArray[i][0]);
          latLongList.add(latLongArray[i][1]);
          break;
        }
      case 3:
        {
          latLongList.add(latLongArray[i][0]);
          latLongList.add(latLongArray[i][1]);
          break;
        }
      case 4:
        {
          latLongList.add(latLongArray[i][0]);
          latLongList.add(latLongArray[i][1]);
          break;
        }
      case 5:
        {
          latLongList.add(latLongArray[i][0]);
          latLongList.add(latLongArray[i][1]);
          break;
        }
      case 6:
        {
          latLongList.add(latLongArray[i][0]);
          latLongList.add(latLongArray[i][1]);
          break;
        }
      case 7:
        {
          latLongList.add(latLongArray[i][0]);
          latLongList.add(latLongArray[i][1]);
          break;
        }
      case 8:
        {
          latLongList.add(latLongArray[i][0]);
          latLongList.add(latLongArray[i][1]);
          break;
        }
      case 9:
        {
          latLongList.add(latLongArray[i][0]);
          latLongList.add(latLongArray[i][1]);
          break;
        }
    }
  }
}
