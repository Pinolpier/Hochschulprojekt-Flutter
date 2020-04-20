import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String _eventID;
  String _title;
  DateTime _eventStartDate;
  DateTime _eventEndDate;
  String _description;
  String _location;
  bool _privateEvent;
  String _latitude, _longitude;
  List<dynamic> _teilnehmerIDs;
  List<dynamic> _tagsList;
  File image;
  String _imageURL;

  /// constructor for creating a event by a user
  Event(
      this._title,
      this._eventStartDate,
      this._eventEndDate,
      this._description,
      this._location,
      this._privateEvent,
      this._teilnehmerIDs,
      this._tagsList,
      this._latitude,
      this._longitude);

  /// constructor for creating a event from the database
  /// from database the event getting a [eventId] and [imageUrl]
  /// additionally
  Event.createFrommDB(
      this._title,
      Timestamp startdate,
      Timestamp enddate,
      this._description,
      this._location,
      this._privateEvent,
      this._teilnehmerIDs,
      this._tagsList,
      this._latitude,
      this._longitude,
      this._imageURL){
    _eventStartDate = startdate.toDate();
    _eventEndDate = enddate.toDate();
  }

  bool get privateEvent => _privateEvent;

  void addTeilnehmer(String teilnehmerID) {
    teilnehmerIDs.add(teilnehmerID);
  }

  List<dynamic> get teilnehmerIDs => _teilnehmerIDs;

  set teilnehmerIDs(List<String> value) {
    _teilnehmerIDs = value;
  }

  set privateEvent(bool value) {
    _privateEvent = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  DateTime get eventEndDate => _eventEndDate;

  set eventEndDate(DateTime value) {
    _eventEndDate = value;
  }

  DateTime get eventStartDate => _eventStartDate;

  set eventStartDate(DateTime value) {
    _eventStartDate = value;
  }

  String get eventID => _eventID;

  set eventID(String value) {
    _eventID = value;
  }

  String get imageURL => _imageURL;

  set imageURL(String value) {
    _imageURL = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }

  List<dynamic> get tagsList => _tagsList;

  set tagsList(List<dynamic> value) {
    _tagsList = value;
  }

  get longitude => _longitude;

  set longitude(value) {
    _longitude = value;
  }

  String get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
  }
}
