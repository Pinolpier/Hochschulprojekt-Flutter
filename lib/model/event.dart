

import 'package:cloud_firestore/cloud_firestore.dart';

class Event{
  String _eventID;
  String _title;
  Timestamp _eventStartDate;
  Timestamp _eventEndDate;
  var _duration;
  String _details;
  String _city;
  String _lat;
  String _lng;
  bool _privateEvent;
  List<dynamic> _teilnehmerIDs;

  Event(this._title, this._eventStartDate, this._eventEndDate, this._details,
      this._city, this._privateEvent,this._lat,this._lng,this._teilnehmerIDs) {}

  bool get privateEvent => _privateEvent;

  void addTeilnehmer(String teilnehmerID){
    teilnehmerIDs.add(teilnehmerID);
  }
  List<dynamic> get teilnehmerIDs => _teilnehmerIDs;

  set teilnehmerIDs(List<String> value) {
    _teilnehmerIDs = value;
  }

  String get lat => _lat;

  set lat(String value) {
    _lat = value;
  }

  set privateEvent(bool value) {
    _privateEvent = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get details => _details;

  set details(String value) {
    _details = value;
  }

  get duration => _duration;

  set duration(value) {
    _duration = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get lng => _lng;

  set lng(String value) {
    _lng = value;
  }

  Timestamp get eventEndDate => _eventEndDate;

  set eventEndDate(Timestamp value) {
    _eventEndDate = value;
  }

  Timestamp get eventStartDate => _eventStartDate;

  set eventStartDate(Timestamp value) {
    _eventStartDate = value;
  }

  String get eventID => _eventID;

  set eventID(String value) {
    _eventID = value;
  }


}