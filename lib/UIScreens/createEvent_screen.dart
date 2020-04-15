import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/UIScreens/constants.dart';
import 'package:univents/model/event.dart';

/// this class creates an createEventScreen which opens if you want to create a event The screen has following input fields:
/// -Event Picture (AssetImage)
/// -Event Start DateTime (DateTimePicker)
/// -Event End Date (DateTimePicker)
/// -Event Name (input-type: text)
/// -Event Location (input-type: text, maybe convert it to an button which opens the map and where you then can choose the location)
/// -Event Description (input-type: multiline text)

class CreateEventScreen extends StatefulWidget {
  @override
  State createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  DateTime selectedStartDateTime;
  DateTime selectedEndDateTime;
  String selectedStartString = "not set";
  String selectedEndString = "not set";
  bool isPrivate = false;
  TextEditingController eventNameController = new TextEditingController();
  TextEditingController eventLocationController = new TextEditingController();
  TextEditingController eventDescriptionController =
      new TextEditingController();

  Widget _eventImage() {
    return GestureDetector(
      onTap: () {
        print('image pressed');
      }, // handle your image tap here
      child: Image.asset(
        'assets/eventPlaceholder.png',
        height: 150.0,
      ),
    );
  }

  Future<TimeOfDay> _selectTime(BuildContext context) {
    final now = DateTime.now();

    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) => showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

  Widget _selectStartDateTimeButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          final selectedDate = await _selectDate(context);
          if (selectedDate == null) return;

          final selectedTime = await _selectTime(context);
          if (selectedTime == null) return;

          setState(() {
            selectedStartDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            if (selectedStartDateTime.isBefore(new DateTime.now())) {
              //TODO errormessage
              print("failed startdate");
            } else {
              print(selectedStartDateTime);
              selectedStartString = selectedStartDateTime.toIso8601String();
            }
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
            color: Color(0xFF527DAA),
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
          final selectedDate = await _selectDate(context);
          if (selectedDate == null) return;

          final selectedTime = await _selectTime(context);
          if (selectedTime == null) return;

          setState(() {
            selectedEndDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            if (selectedStartDateTime == null ||
                selectedEndDateTime.isBefore(selectedStartDateTime)) {
              //TODO errormessage
              print("failed enddate");
            } else {
              print(selectedEndDateTime);
              selectedEndString = selectedEndDateTime.toIso8601String();
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
            color: Color(0xFF527DAA),
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

  Widget _addFriendsButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => print('addFriends Button Pressed'),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'addFriends',
          style: TextStyle(
            color: Color(0xFF527DAA),
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
        onPressed: () {/*
          Event event = new Event.createEvent(
              eventNameController.text,
              selectedStartDateTime.millisecondsSinceEpoch,
              selectedEndDateTime.millisecondsSinceEpoch,
              eventDescriptionController.text,
              eventLocationController.text,
              isPrivate,
              _tagsList,
              _teilnehmerIDs); */
          //TODO Event erstellen -> Rücksprache mit @Markus Haering
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'CREATE',
          style: TextStyle(
            color: Color(0xFF527DAA),
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
      backgroundColor: Colors.blueAccent,
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
              _eventImage(),
              SizedBox(height: 40.0),
              new Text(
                "Start Date: " + selectedStartString,
                style: labelStyleConstant,
              ),
              _selectStartDateTimeButtonWidget(),
              SizedBox(height: 20.0),
              new Text(
                "End Date: " + selectedEndString,
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
              new Text(
                "isPrivate:",
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
