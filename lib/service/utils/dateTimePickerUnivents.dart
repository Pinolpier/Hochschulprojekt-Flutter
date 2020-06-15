import 'package:flutter/material.dart';

/// todo: add author
/// todo: CONSIDER writing a library-level doc comment

/// todo: documentation of variables
/// todo: set variables private (provide setter and getter)
DateTime selectedDateTime = DateTime.now();

/// todo: missing documentation
Future<TimeOfDay> _selectTime(BuildContext context) {
  final now = DateTime.now();

  return showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
  );
}

/// todo: missing documentation
Future<DateTime> _selectDateTime(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

/// todo: missing documentation
Future<DateTime> getDateTime(BuildContext context) async {
  final selectedDate = await _selectDateTime(context);
  if (selectedDate == null) return null;

  final selectedTime = await _selectTime(context);
  if (selectedTime == null) return null;

  selectedDateTime = DateTime(selectedDate.year, selectedDate.month,
      selectedDate.day, selectedTime.hour, selectedTime.minute);
  return selectedDateTime;
}
