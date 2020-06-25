import 'package:flutter/material.dart';

/// author mathias darscht
/// this class is for selecting the radius of events
/// is an event not inside of the radius
/// it will not be displayed
class RadiusSliderDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RadiusSliderDialogState();
}

class RadiusSliderDialogState extends State<RadiusSliderDialog> {
  double _radius = 0;

  @override
  Widget build(BuildContext context) {
    //String title = AppLocalizations.of(context).translate('start_date_filter');
    return AlertDialog(
        title: Text("title"),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 50,
          child: Slider(
            value: _radius,
            onChanged: (newRadius) {
              setState(() {
                _radius = newRadius;
              });
            },
            min: 1, // min value
            max: 10, // max value
            divisions: 10,
            //labels: RangeLabels('$_sDates', '$_sDates'),
          ),
        ),
        actions: <Widget>[
          FlatButton(child: Text('SET'), onPressed: () {}),
        ]);
  }
}
