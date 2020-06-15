import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';

class LocationPickerScreen extends StatefulWidget {
  final InterfaceToReturnPickedLocation _pickedLocation;

  LocationPickerScreen(this._pickedLocation);

  _LocationPickerScreenState createState() =>
      _LocationPickerScreenState(_pickedLocation);
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  InterfaceToReturnPickedLocation _pickedLocation;

  _LocationPickerScreenState(this._pickedLocation);

  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(child: getLocationWithMapbox(context)),
    );
  }

  Widget getLocationWithMapbox(BuildContext context) {
    return MapBoxLocationPicker(
      apiKey:
          'pk.eyJ1IjoidW5pdmVudHMiLCJhIjoiY2s4YzJoZzFlMGlmazNtcGVvczZnMW84dyJ9.Pt9uy31wRUAcsijVLBS0vw',
      popOnSelect: true,
      language: 'de',
      country: 'de',
      //location: , //TODO Add own location and change country and language to appropriate device settings
      onSelected: (place) {
        setState(() {
          print(
              "Now printing the place\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
          print(place);
          _pickedLocation.choosenLocationName = place.placeName;
          _pickedLocation.choosenLocationCoords = place.geometry.coordinates;
        });
      },
      context: context,
    );
  }
}

class InterfaceToReturnPickedLocation {
  String choosenLocationName;
  List<double> choosenLocationCoords;
}
