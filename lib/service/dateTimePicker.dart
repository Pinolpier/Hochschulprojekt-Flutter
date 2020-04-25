import 'package:flutter/material.dart';

class DateTimePicker {
  DateTime selectedDateTime = DateTime.now();

  Future<TimeOfDay> _selectTime(BuildContext context) {
    final now = DateTime.now();

    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }

  Future<DateTime> _selectDateTime(BuildContext context) => showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

  Future<DateTime> getDateTime(BuildContext context) async {
    final selectedDate = await _selectDateTime(context);
    if (selectedDate == null) return null;

    print(selectedDate);

    final selectedTime = await _selectTime(context);
    if (selectedTime == null) return null;
    print(selectedTime);

    selectedDateTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
    return selectedDateTime;
  }
}
