import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';

/// author mathias darscht
/// this class is for selecting the radius of events
/// is an event not inside of the radius
/// it will not be displayed
class RadiusSliderDialog extends StatefulWidget {
  /// variables to pass to RadiusSliderDialogState
  String _title;
  String _buttonText;

  RadiusSliderDialog(this._title, this._buttonText);

  @override
  State<StatefulWidget> createState() =>
      RadiusSliderDialogState(this._title, this._buttonText);
}

class RadiusSliderDialogState extends State<RadiusSliderDialog> {
  String _title;
  String _buttonText;

  /// selector for the distance
  double _radius = 1;

  /// constructor with [_title] of alert dialog and [_buttonText] of confirm button
  RadiusSliderDialogState(this._title, this._buttonText);

  @override
  Widget build(BuildContext context) {
    int distance = _radius.toInt();
    return AlertDialog(
        title: Text(_title),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 50,
          child: Slider(
            value: _radius,
            onChanged: (newRadius) {
              setState(() {
                _radius = newRadius;
                distance = _radius.toInt();
              });
            },
            min: 1, // min value
            max: 10, // max value
            divisions: 10,
            label: '$distance',
          ),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text(_buttonText),
              color: primaryColor,
              onPressed: () {
                Navigator.pop(context, _radius);
              }),
        ]);
  }
}
