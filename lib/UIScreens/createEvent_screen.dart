import 'package:aiblabswp2020ssunivents/UIScreens/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// this class creates an createEventScreen which opens if you want to create a event The screen has following input fields:
/// -Event Picture (at this point only a placeholder)
/// -Event Start Date (input-type: datetime)
/// -Event Start Time (input-type: datetime)
/// -Event End Date (input-type: datetime)
/// -Event End Time (input-type: datetime)
/// -Event Name (input-type: text)
/// -Event Location (input-type: text, maybe convert it to an button which opens the map and where you then can choose the location)
/// -Event Description (input-type: multiline text)

class CreateEventScreen extends StatefulWidget {
  @override
  State createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(3000),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _time
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
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

  Widget _createButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => print('Create Button Pressed'),
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
        child: SingleChildScrollView(     //fixes pixel overflow error when keyboard is used
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 120.0,
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Event Picture Placeholder',
                style: labelStyleConstant,
              ),
              SizedBox(height: 20),
              Placeholder(
                fallbackHeight: 150,
              ),
              SizedBox(height: 20.0),
              new RaisedButton(
                  child: new Text("Select Date"),
                  onPressed: (){_selectDate(context);
                  }
              ),
              SizedBox(height: 20.0),
              new RaisedButton(
                  child: new Text("Select Time"),
                  onPressed: (){_selectTime(context);
                  }
              ),
              SizedBox(height: 20),
              _eventNameTextfieldWidget(),
              SizedBox(height: 20.0),
              _locationTextfieldWidget(),
              SizedBox(height: 20.0),
              _eventDescriptionTextfieldWidget(),
              _createButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
