import 'package:flutter/material.dart';
import 'package:univents/service/app_localizations.dart';

/// author mathias darscht
/// this class is for selecting the start date and end date inside of
/// a filter
class SliderDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SliderDialogState();
}

class SliderDialogState extends State<SliderDialog> {
  /// list with date values in String and DateTime
  List<String> _sDates = List();
  List<DateTime> _dates = List();

  /// data that will be passed to filter_tile.dart
  List<DateTime> _data;

  /// for managing range values
  var _selectedRange = RangeValues(0, 2);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    // initializing with the upcoming 9 days
    for (int dayRange = 0; dayRange < 10; dayRange++) {
      today.add(Duration(days: dayRange));
      this._dates.add(today);
      //this._sDates.add(getDayAndMonth(context, today));
    }
    String title = AppLocalizations.of(context).translate('start_date_filter');
    return AlertDialog(
        title: //Text('select range'),
            Text(title),
        content: Container(
          child: RangeSlider(
            values: _selectedRange,
            onChanged: (RangeValues newRange) {
              setState(() {
                _selectedRange = newRange;
                this._data = new List();
                this._data.add(_dates[_selectedRange.start.toInt()]);
                this._data.add(_dates[_selectedRange.end.toInt()]);
              });
            },
            min: 0, // min value
            max: 9, // max value
            divisions: 10,
            //labels: RangeLabels(
            //'$_sDates[selectedRage.start]', '$_sDates[selectedRange.end]'),
          ),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('some Text'),
              onPressed: () => Navigator.pop(context, _data)),
        ]);
  }
}
