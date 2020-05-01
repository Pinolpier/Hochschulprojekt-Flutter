import 'package:flutter/material.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/utils/dateTimePickerUnivents.dart';

class DropDownMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DropDownMenuState();
}

class DropDownMenuState extends State {
  String dropdownValue = 'Standard Filter';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: _selectedFilter,
      items: <String>['Standard Filter', 'Date Filter', 'Selected Event Filter']
          .map<DropdownMenuItem<String>>((String dropdownValue) {
        return DropdownMenuItem<String>(
          value: dropdownValue,
          child: Text(dropdownValue),
        );
      }).toList(),
    );
  }

  ///controls the filter that are selected
  void _selectedFilter(String selected) async {
    setState(() {
      dropdownValue = selected;
    });
    switch (selected) {
      case "Standard Filter":
        {
          deleteStartFilter();
          deleteEndFilter();
          deleteTagFilter();
          deleteFriendIdFilter();
          myEventFilter = false;
        }
        break;
      case "Date Filter":
        {
          DateTime _date = await getDateTime(context);
          startDateFilter = _date;
        }
        break;
      case "Selected Event Filter":
        {
          myEventFilter = true;
        }
        break;
    }
  }
}
