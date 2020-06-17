import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/constants.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/dateTimePickerUnivents.dart';
import 'package:univents/service/utils/imagePickerUnivents.dart';
import 'package:univents/service/utils/utils.dart';
import 'package:univents/view/dialogs/friendList_dialog.dart';
import 'package:univents/view/homeFeed_screen/navigationBarUI.dart';

/// @author Jan Oster
/// this class creates an createEventScreen which opens if you want to create a event The screen has following input fields:

class CreateEventScreen extends StatefulWidget {
  /// todo: add documentation of variable
  final List<String> tappedPoint;

  /// todo: missing documentation of constructor
  CreateEventScreen(this.tappedPoint, {Key key}) : super(key: key);

  /// todo: missing documentation
  @override
  State createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  /// todo: add documentation of variables
  /// specified event start date
  DateTime _selectedStartDateTime;

  /// specified event end date
  DateTime _selectedEndDateTime;

  /// placeholder if no event start date is set
  String _selectedStartString = 'not set';

  /// placeholder if no event end date is set
  String _selectedEndString = 'not set';

  /// specified privacy setting of event
  bool _isPrivate = false;

  /// specified tags of the event
  List<dynamic> _tagsList = new List();

  /// specified attendees of the event
  List<dynamic> _attendeeIDs = new List();

  /// used to read the inputted text of the event name
  TextEditingController _eventNameController = new TextEditingController();

  /// used to read the inputted text of the event location
  TextEditingController _eventLocationController = new TextEditingController();

  /// used to read the inputted text of the event description
  TextEditingController _eventDescriptionController =
      new TextEditingController();

  /// used to read the inputted text of the event tags
  TextEditingController _eventTagsController = new TextEditingController();

  /// specified event image
  File _eventImage;

  /// imagePicker for selecting the image from device
  ImagePickerUnivents _ip = new ImagePickerUnivents();

  /// This Widget is a Dialog if a wrong startTime is given
  ///
  ///
  ///
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

  /// This Widget displays a placeholder image if no event image is specified
  ///
  /// returns a [GestureDetector] that opens onTap an imagePickerDialog
  Widget _eventImagePlaceholder() {
    return GestureDetector(
        onTap: () async {
          File eventImageAsync = await _ip.chooseImage(context);
          setState(() {
            print(eventImageAsync);
            _eventImage = eventImageAsync;
          });
        }, // handle your image tap here
        child: Image.asset('assets/eventImagePlaceholder.png', height: 150));
  }

  /// This widget displays the event image if set
  ///
  /// returns a [GestureDetector] that opens onTap an imagePickerDialog
  Widget _eventImageWidget() {
    return GestureDetector(
        onTap: () async {
          File eventImageAsync = await _ip.chooseImage(context);
          setState(() {
            print(eventImageAsync);
            _eventImage = eventImageAsync;
          }); // handle your image tap here
        },
        child: Image.file(_eventImage, height: 150));
  }

  /// This button opens a dateTimePicker to select the event start date
  ///
  /// return a [Container] that wraps a raised button
  Widget _selectStartDateTimeButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          _selectedStartDateTime = await getDateTime(context);
          setState(() {
            print(_selectedStartDateTime);
            _selectedStartString =
                format_date_time(context, _selectedStartDateTime);

            //reset the endDateTime after setting the startDateTime so there is no possibility for it to be earlier
            _selectedEndDateTime = null;
            _selectedEndString = 'not set';
          });
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteBackground,
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

  /// This button opens a dateTimePicker to select the event end date
  ///
  /// return a [Container] that wraps a raisedButton
  Widget _selectEndDateTimeButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          _selectedEndDateTime = await getDateTime(context);
          setState(() {
            if (_selectedStartDateTime == null ||
                _selectedEndDateTime.isBefore(
                    _selectedStartDateTime.add(Duration(minutes: 1)))) {
              errorEndDateTime();
            } else {
              print(_selectedEndDateTime);
              _selectedEndString =
                  format_date_time(context, _selectedEndDateTime);
            }
          });
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteBackground,
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

  /// This widget displays a textfield to input the event name
  ///
  /// return a [Column] that conatins a textField
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
            controller: _eventNameController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: univentsWhiteText,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.create,
                color: univentsWhiteBackground,
              ),
              hintText: 'Enter the event name',
              hintStyle: textStyleConstant,
            ),
          ),
        ),
      ],
    );
  }

  /// todo: missing documentation
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
            controller: _eventLocationController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: univentsWhiteText,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.add_location,
                color: univentsWhiteBackground,
              ),
              hintText: 'Enter the location of the event',
              hintStyle: textStyleConstant,
            ),
          ),
        ),
      ],
    );
  }

  /// This widget displays a textfield to input the event description
  ///
  /// return a [Column] that conatins a textField
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
            controller: _eventDescriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(
              color: univentsWhiteText,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.comment,
                color: univentsWhiteBackground,
              ),
              hintText: 'Enter the event details',
              hintStyle: textStyleConstant,
            ),
          ),
        ),
      ],
    );
  }

  /// This widget displays a textfield to input the event tags, separated by comma e.g. Tag1, Tag2, Tag3, ...
  ///
  /// return a [Column] that conatins a textField
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
            controller: _eventTagsController,
            keyboardType: TextInputType.text,
            maxLines: null,
            style: TextStyle(
              color: univentsWhiteText,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.add,
                color: univentsWhiteBackground,
              ),
              hintText: 'Tags, seperated by comma',
              hintStyle: textStyleConstant,
            ),
          ),
        ),
      ],
    );
  }

  /// This button opens the select friends dialog
  ///
  /// return a [Container] that wraps a raisedButton
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
                builder: (context) => FriendslistdialogScreen.create(),
              ));
          setState(() {
            for (String s in result) {
              _attendeeIDs.add(s);
              print(s);
            }
          });
          //ID von alles ausgewähleten Freunde-Objekten in anttendeeIDs speichern (als String ind die Liste)
          //Friendslist schließen
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteText,
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

  /// This checkbox specifies if the event is private. Unchecked = open, checked = private
  ///
  /// returns a [Container] that wraps a Checkbox
  Widget _isPrivateCheckbox() {
    return Container(
      child: Checkbox(
        value: _isPrivate,
        onChanged: (value) {
          setState(() {
            _isPrivate = value;
            print(_isPrivate);
          });
        },
      ),
    );
  }

  /// This button creates the event with the specified variables and sends it to the backend
  ///
  /// return a [Container] that wraps a raisedButton
  Widget _createButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          _tagsList = _eventTagsController.text.split(", ");
          print(_tagsList);
          print(_attendeeIDs);

          Event event = new Event(
              _eventNameController.text,
              _selectedStartDateTime,
              _selectedEndDateTime,
              _eventDescriptionController.text,
              _eventLocationController.text,
              _isPrivate,
              _attendeeIDs,
              _tagsList,
              widget.tappedPoint[0],
              widget.tappedPoint[1]);

          try {
            createEvent(_eventImage, event);
          } on PlatformException catch (e) {
            exceptionHandling(e);
            Log().error(
                causingClass: 'createEvent_screen',
                method: '_createButtonWidget',
                action: exceptionHandling(e));
          }
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigationBarUI()),
            (Route<dynamic> route) => false,
          );
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteText,
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
              _eventImage == null
                  ? _eventImagePlaceholder()
                  : _eventImageWidget(),
              SizedBox(height: 40.0),
              new Text(
                'Start Date: ' + _selectedStartString,
                style: labelStyleConstant,
              ),
              _selectStartDateTimeButtonWidget(),
              SizedBox(height: 20.0),
              new Text(
                'End Date: ' + _selectedEndString,
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
}
