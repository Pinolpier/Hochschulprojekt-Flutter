import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/constants.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/toast.dart';
import 'package:univents/view/createEvent_screen.dart';
import 'package:univents/view/eventInfo_screen.dart';
import 'package:user_location/user_location.dart';

import 'dialogs/radius_slider_dialog.dart';
import 'homeFeed_screen/feed_filter_values.dart';

class MapScreen extends StatefulWidget {
  @override
  State createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng pos;
  LatLng previousPosition;
  List<Marker> _markerList = new List();
  var _result;
  MapController mapController = new MapController();
  Timer _timer;
  bool _gestureStart = true;

  double _radius = 0;

  Widget _flutterMap(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(49.140530, 9.210270),
        zoom: 8.0,
        plugins: [
          UserLocationPlugin(),
        ],
        onPositionChanged: (position, hasGesture) async {
          if (_gestureStart) {
            if (previousPosition != position.center) {
              final Distance distance = new Distance();
              previousPosition = position.center;
              try {
                if (await loadNewEvents(
                    position,
                    distance.as(LengthUnit.Kilometer, position.center,
                            position.bounds.northEast) +
                        radius_buffer)) {
                  this.setState(() {});
                }
              } on Exception catch (e) {
                show_toast(e.toString());
                Log().error(
                    causingClass: 'map_screen', method: 'onPositionChanged:');
              }
              _restartTimer();
            }
          }
        },
        onLongPress: (LatLng latlng) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    new CreateEventScreen(convertLatLngToString(latlng)),
              ));
        },
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoidW5pdmVudHMiLCJhIjoiY2s4YzJoZzFlMGlmazNtcGVvczZnMW84dyJ9.Pt9uy31wRUAcsijVLBS0vw',
            'id': 'mapbox.streets',
          },
        ),
        MarkerLayerOptions(
          markers: _markerList,
        ),
        UserLocationOptions(
          context: context,
          mapController: mapController,
          markers: _markerList,
          updateMapLocationOnPositionChange: false,
          onLocationUpdate: (LatLng pos) {
            this.pos = pos;
          },
          showMoveToCurrentLocationFloatingActionButton: true,
        ),
      ],
      mapController: mapController,
    );
  }

  /// Gets all Events from the Database, creates a Marker for each and sets an onClickListener to open the eventInfo of the respective Event
  void getMarkerList(List list) {
    _markerList = new List<Marker>();
    for (Event e in list) {
      _markerList.add(new Marker(
        point: LatLng(double.parse(e.latitude), double.parse(e.longitude)),
        builder: (ctx) => Container(
            child: GestureDetector(
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new EventInfo(e),
                ));
          },
          child: Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        )),
      ));
    }
  }

  /// Method to load new events when the card is moved.
  /// The [MapPosition] and the double [radius] are transferred
  Future<bool> loadNewEvents(MapPosition position, double radius) async {
    try {
      getMarkerList(await get_events_near_location_and_filters(
          new GeoPoint(position.center.latitude, position.center.longitude),
          radius));
    } on Exception catch (e) {
      show_toast(exceptionHandling(e));
      Log().error(
          causingClass: 'map_screen',
          method: 'loadNewEvents',
          action: exceptionHandling(e));
    }
    return true;
  }

  Future<bool> loadAsyncData() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      GeoPoint geoPoint = new GeoPoint(position.latitude, position.longitude);
      getMarkerList(await get_events_near_location_and_filters(geoPoint, 100));
    } on Exception catch (e) {
      show_toast(exceptionHandling(e));
      Log().error(
          causingClass: 'map_screen',
          method: 'loadAsyncData',
          action: exceptionHandling(e));
    }
    return true;
  }

  @override
  void initState() {
    // This is the proper place to make the async calls
    // This way they only get called once

    // During development, if you change this code,
    // you will need to do a full restart instead of just a hot reload

    // You can't use async/await here,
    // We can't mark this method as async because of the @override
    loadAsyncData().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        _result = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      // This is what we show while we're loading
      return CircularProgressIndicator();
    } else {
      // Do something with the `_result`s here
      String title = FeedFilterValues.translatedStrings(context)[2];
      String buttonText = FeedFilterValues.translatedStrings(context)[1];
      return Scaffold(
        body: _flutterMap(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.adjust),
          backgroundColor: primaryColor,
          onPressed: () {
            setState(() {
              showDialog(
                      context: context,
                      builder: (context) =>
                          RadiusSliderDialog(title, buttonText))
                  .then((value) => _radius);
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
  }

  ///Converts LatLng to List<String> with index 0 = latitude, index 1 = longitude
  List<String> convertLatLngToString(LatLng latLng) {
    String point = latLng.toString();
    List<String> pointList1 = new List();
    List<String> pointList2 = new List();
    List<String> pointList3 = new List();
    pointList1 = point.split(",");
    pointList2 = pointList1[0].split(":");
    pointList3 = pointList1[1].split(":");
    pointList1 = new List();
    pointList1.add(pointList2[1]);
    pointList1.add(pointList3[1].substring(0, pointList3[1].length - 1));
    return pointList1;
  }

  /// Method to start a timer so that the card does not poll events too often
  void _restartTimer() {
    _gestureStart = false;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 500), () {
      _gestureStart = true;
      // mapGestureInteractionStopped callback here
    });
  }
}
