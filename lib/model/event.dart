import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String _eventID;
  String _title;
  DateTime _eventStartDate;
  DateTime _eventEndDate;
  String _description;
  dynamic _location;
  bool _privateEvent;
  String _latitude, _longitude;
  List<dynamic> _attendeesIds = new List();
  List<dynamic> _tagsList = new List();
  List<dynamic> _ownerIds = new List();
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
      this._attendeesIds,
      this._tagsList,
      this._latitude,
      this._longitude);

  /// constructor for creating a event from the database
  /// from database the event getting a [eventId] and [imageUrl]
  /// additionally
  Event.createFrommDB(
      this._title,
      Timestamp startDate,
      Timestamp endDate,
      this._description,
      this._location,
      this._privateEvent,
      this._attendeesIds,
      this._tagsList,
      this._latitude,
      this._longitude,
      this._imageURL,
      this._ownerIds) {
    _eventStartDate = startDate.toDate();
    _eventEndDate = endDate.toDate();
  }

  bool get privateEvent => _privateEvent;

  void addAttendeesIds(String attendeesIds) {
    _attendeesIds.add(attendeesIds);
  }

  List<dynamic> get attendeesIds => _attendeesIds;

  set attendeesIds(List<String> value) {
    _attendeesIds = value;
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

  dynamic get location => _location;

  set location(String value) {
    _location = value;
  }

  set location_to_geopoint(GeoPoint value){
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

  get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
  }

  List<dynamic> get ownerIds => _ownerIds;

  set ownerIds(List<dynamic> value) {
    _ownerIds = value;
  }
}
