import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';

/// used to choose an address on a map and get the geo coordinates back for this place.
class LocationPickerScreen extends StatefulWidget {
  final InterfaceToReturnPickedLocation _pickedLocation;

  /// the argument [InterfaceToReturnPickedLocation] is used to keep a reference on where to return the picked location to.
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

  /// widget responsible for the main functionality of this class. Is provided by the nominatim location picker plugin
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
          _pickedLocation.choosenLocationName = place.placeName;
          _pickedLocation.choosenLocationCoords = place.geometry.coordinates;
        });
      },
      context: context,
    );
  }
}

/// this is used as reference on where to return the location that was picked by the user
class InterfaceToReturnPickedLocation {
  String choosenLocationName;
  List<double> choosenLocationCoords;
}
