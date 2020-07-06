import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:univents/backend/event_service.dart';
import 'package:univents/constants/constants.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/toast.dart';
import 'package:univents/view/create_event_screen.dart';
import 'package:univents/view/event_info_screen.dart';
import 'package:user_location/user_location.dart';

/// @author Jan Oster, Markus Häring
/// This class displays the Map screen
class MapScreen extends StatefulWidget {
  @override
  State createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  /// todo: add documentation of variables need to be done Markus Häring
  /// todo: set variables private Markus Häring
  LatLng pos;
  LatLng previousPosition;
  List<Marker> _markerList = new List();
  var _result;
  MapController _mapController = new MapController();
  Timer _timer;
  bool _gestureStart = true;
  GeoPoint initPosition;

  /// This Widget displays the Map with given parameters ans shows the location of the user
  Widget _flutterMap(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(initPosition.latitude, initPosition.longitude),
        zoom: radius == null ? 11.0 : (log(20000 / radius) / log(2)) - 0.5,
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
          mapController: _mapController,
          markers: _markerList,
          updateMapLocationOnPositionChange: false,
          onLocationUpdate: (LatLng pos) {
            this.pos = pos;
          },
          showMoveToCurrentLocationFloatingActionButton: true,
        ),
      ],
      mapController: _mapController,
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

  /// todo: DO separate the first sentence of a doc comment into its own paragraph.
  /// todo: DO use prose to explain parameters, return values, and exceptions
  /// todo: Markus Häring please correct documentation
  /// Method to load new events when the card is moved.
  /// The [MapPosition] and the double [radius] are transferred
  Future<bool> loadNewEvents(MapPosition position, double radius) async {
    try {
      getMarkerList(await getEventsNearLocationAndFilters(
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
    if (radius != null) {
      initPosition = gPoint;
    } else {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      initPosition = new GeoPoint(position.latitude, position.longitude);
    }
    try {
      getMarkerList(await getEventsNearLocationAndFilters(
          initPosition, radius != null ? radius : 100.0));
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
    loadAsyncData().then((result) {
      setState(() {
        _result = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        body: _flutterMap(context),
      );
    }
  }

  ///Converts LatLng to a readable List
  ///
  /// Returns a [pointList] with index 0 = latitude, index 1 = longitude
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

  /// method to start a timer so that the card does not poll events too often
  void _restartTimer() {
    _gestureStart = false;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 500), () {
      _gestureStart = true;
      // mapGestureInteractionStopped callback here
    });
  }
}
