import 'package:flutter/material.dart';

/// author mathias darscht
/// this class is for selecting the start date and end date inside of
/// a filter
class DateSliderDialog extends StatefulWidget {
  final List<String> _strings;
  final List<String> _sDates;
  final List<DateTime> _dates;

  DateSliderDialog(this._strings, this._sDates, this._dates);

  @override
  State<StatefulWidget> createState() =>
      DateSliderDialogState(this._strings, this._sDates, this._dates);
}

class DateSliderDialogState extends State<DateSliderDialog> {
  /// title of the slider dialog
  List<String> _strings;

  /// list with date values in String and DateTime
  List<String> _sDates;
  List<DateTime> _dates;

  /// data that will be passed to filter_tile.dart
  List<DateTime> _data;

  /// for managing range values
  var _selectedRange = RangeValues(0, 2);

  /// for capturing the dates to display
  String _start = "";
  String _end = "";

  DateSliderDialogState(this._strings, this._sDates, this._dates);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    return AlertDialog(
        title: Text(this._strings[0]),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 50,
          child: RangeSlider(
            values: _selectedRange,
            onChanged: (RangeValues newRange) {
              setState(() {
                _selectedRange = newRange;
                this._data = new List();
                this._data.add(_dates[_selectedRange.start.toInt()]);
                _start = this._sDates[_selectedRange.start.toInt()];
                this._data.add(_dates[_selectedRange.end.toInt()]);
                _end = this._sDates[_selectedRange.end.toInt()];
              });
            },
            min: 0, // min value
            max: 9, // max value
            divisions: 10,
            labels: RangeLabels('$_start', '$_end'),
          ),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text(this._strings[1]),
              onPressed: () => Navigator.pop(context, _data)),
        ]);
  }
}
