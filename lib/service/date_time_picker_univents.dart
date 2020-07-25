import 'package:flutter/material.dart';

/// @author Jan Oster
/// This class opens a DateTimePicker dialog
///
/// To use the DateTimePicker just call the function [getDateTime] in a Widget

/// selected DateTime, if not set it's the current time
DateTime _selectedDateTime = DateTime.now();

/// This function is used to pick a time
/// Returns selected [TimeOfDay] asynchronous
Future<TimeOfDay> _selectTime(BuildContext context) {
  final now = DateTime.now();

  return showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
  );
}

/// This function is used to pick a date
/// Returns selected [DateTime] asynchronous
Future<DateTime> _selectDateTime(BuildContext context,
    {DateTime initialDateTime, DateTime firstDateTime, DateTime lastDateTime}) {
  initialDateTime ??= DateTime.now().add(Duration(seconds: 1));
  firstDateTime ??= DateTime.now();
  lastDateTime ??= DateTime(2100);
  return showDatePicker(
    context: context,
    initialDate: initialDateTime,
    firstDate: firstDateTime,
    lastDate: lastDateTime,
  );
}

/// This function displays firstly the date picker and the the time picker so that you
/// have both pickers as one function
///
/// Returns selected [DateTime] asynchronous
Future<DateTime> getDateTime(BuildContext context,
    [DateTime minDateTime]) async {
  final selectedDate = await _selectDateTime(context,
      firstDateTime: minDateTime, initialDateTime: minDateTime);
  if (selectedDate == null) return null;

  final selectedTime = await _selectTime(context);
  if (selectedTime == null) return null;

  _selectedDateTime = DateTime(selectedDate.year, selectedDate.month,
      selectedDate.day, selectedTime.hour, selectedTime.minute);
  return _selectedDateTime;
}
