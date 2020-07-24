import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univents/backend/event_service.dart';
import 'package:univents/constants/colors.dart';
import 'package:univents/constants/constants.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/date_time_picker_univents.dart';
import 'package:univents/service/image_picker_univents.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/page_controller.dart';
import 'package:univents/service/toast.dart';
import 'package:univents/service/utils.dart';
import 'package:univents/view/dialogs/friend_list_dialog.dart';
import 'package:univents/view/location_picker_screen.dart';

/// @author Jan Oster, Markus Häring
/// this class creates an createEventScreen which opens if you want to create a event

class CreateEventScreen extends StatefulWidget {
  /// latitude and longitude of the location you clicked on the map where you want to create your event
  final List<String> tappedPoint;

  /// constructor gets the tappedPoint from the map
  CreateEventScreen(this.tappedPoint, {Key key}) : super(key: key);

  /// todo: missing documentation
  @override
  State createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
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
  InterfaceToReturnPickedLocation _returnPickedLocation =
      new InterfaceToReturnPickedLocation();

  /// This Widget displays a Dialog if a wrong startTime is given
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
                formatDateTime(context, _selectedStartDateTime);

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
          'select start date',
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
                  formatDateTime(context, _selectedEndDateTime);
            }
          });
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteBackground,
        child: Text(
          'select end date',
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

  /// This widget displays a textfield to input the event description
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
                builder: (context) => FriendslistdialogScreen(null),
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
          'add friends',
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

  /// this button is used to open a location picker screen.
  Widget _eventlocationPickerButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        new LocationPickerScreen(_returnPickedLocation)));
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: univentsWhiteBackground,
          child: Text(
            'Choose Location',
            style: TextStyle(
              color: textButtonDarkBlue,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ));
  }

  /// This button creates the event with the specified variables and sends it to the backend
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
              _returnPickedLocation.choosenLocationName,
              _isPrivate,
              _attendeeIDs,
              _tagsList,
              _returnPickedLocation.choosenLocationCoords[1].toString(),
              _returnPickedLocation.choosenLocationCoords[0].toString());
          if (event.eventStartDate == null || event.eventEndDate == null) {
            show_toast(
                'Sowohl Start als auch Endzeitpunkt muss ausgewählt sein');
          } else if (event.eventStartDate.isAfter(event.eventEndDate)) {
            show_toast('Startdatum muss vor Enddatum liegen!');
          }
          if (event.title == null) {
            show_toast('Event Name darf nicht leer sein');
          } else if (event.description == null) {
            show_toast('Eventbeschreibung darf nicht leer sein');
          } else if (event.location == null) {
            show_toast('location darf nicht fehlen');
          } else {
            try {
              createEvent(_eventImage, event);
            } on PlatformException catch (e) {
              show_toast(exceptionHandling(e));
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
          }
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
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Create Your Event"),
        centerTitle: true,
      ),
      backgroundColor: primaryColor,
      body: new Container(
        height: double.infinity,
        child: SingleChildScrollView(
          //fixes pixel overflow error when keyboard is used
          physics: AlwaysScrollableScrollPhysics(),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  _eventImage != null
                      ? Stack(
                          children: <Widget>[
                            SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: FittedBox(
                                child: _eventImageWidget(),
                                fit: BoxFit.fill,
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned.fill(
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 15.0,
                                      sigmaY: 0,
                                    ),
                                    child: Container(
                                      color: Colors.black.withOpacity(0),
                                    ))),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: _eventImage == null
                        ? _eventImagePlaceholder()
                        : _eventImageWidget(),
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      _eventNameTextfieldWidget(),
                      SizedBox(height: 20.0),
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
                      _eventlocationPickerButton(context),
                      SizedBox(height: 20.0),
                      _eventDescriptionTextfieldWidget(),
                      SizedBox(height: 20.0),
                      _eventTagsTextfieldWidget(),
                      SizedBox(height: 20.0),
                      new Text(
                        'Should the event be private?',
                        //TODO: Add Internationalization
                        style: labelStyleConstant,
                      ),
                      _isPrivateCheckbox(),
                      _addFriendsButtonWidget(),
                      _createButtonWidget(),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
